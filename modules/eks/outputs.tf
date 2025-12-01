# ========================================
# Cluster Outputs
# ========================================

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_platform_version" {
  description = "The platform version for the cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED"
  value       = aws_eks_cluster.main.status
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster control plane"
  value       = aws_security_group.eks_cluster.id
}

output "fargate_pod_security_group_id" {
  description = "Security group ID attached to Fargate pods"
  value       = aws_security_group.eks_fargate_pods.id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = aws_iam_role.eks_cluster.name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = try(aws_eks_cluster.main.identity[0].oidc[0].issuer, null)
}

# ========================================
# Fargate Outputs
# ========================================

output "fargate_profile_ids" {
  description = "IDs of the Fargate profiles"
  value       = { for k, v in aws_eks_fargate_profile.main : k => v.id }
}

output "fargate_profile_arns" {
  description = "ARNs of the Fargate profiles"
  value       = { for k, v in aws_eks_fargate_profile.main : k => v.arn }
}

output "fargate_profile_statuses" {
  description = "Status of the Fargate profiles"
  value       = { for k, v in aws_eks_fargate_profile.main : k => v.status }
}

output "fargate_pod_execution_role_arn" {
  description = "IAM role ARN for Fargate pod execution"
  value       = aws_iam_role.fargate_pod_execution.arn
}

output "fargate_pod_execution_role_name" {
  description = "IAM role name for Fargate pod execution"
  value       = aws_iam_role.fargate_pod_execution.name
}

# ========================================
# Add-on Outputs
# ========================================

output "vpc_cni_addon_version" {
  description = "Version of VPC CNI addon"
  value       = aws_eks_addon.vpc_cni.addon_version
}

output "kube_proxy_addon_version" {
  description = "Version of kube-proxy addon"
  value       = aws_eks_addon.kube_proxy.addon_version
}

output "coredns_addon_version" {
  description = "Version of CoreDNS addon"
  value       = aws_eks_addon.coredns.addon_version
}
