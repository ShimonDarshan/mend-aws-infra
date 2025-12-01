# Default Fargate Profile for default namespace
resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
  subnet_ids             = var.fargate_subnet_ids

  selector {
    namespace = "default"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-default"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_policy
  ]
}

# CoreDNS Fargate Profile - Required for DNS to work on Fargate
resource "aws_eks_fargate_profile" "coredns" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "coredns"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
  subnet_ids             = var.fargate_subnet_ids

  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-coredns"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_policy
  ]
}

# Patch CoreDNS to remove ec2 annotations after Fargate profile is created
resource "null_resource" "patch_coredns" {
  depends_on = [
    aws_eks_fargate_profile.coredns,
    aws_eks_addon.coredns
  ]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${aws_eks_cluster.main.name}
      kubectl patch deployment coredns \
        -n kube-system \
        --type json \
        -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
      kubectl rollout restart -n kube-system deployment/coredns
    EOT
  }

  triggers = {
    fargate_profile_id = aws_eks_fargate_profile.coredns.id
    addon_version      = aws_eks_addon.coredns.addon_version
  }
}
