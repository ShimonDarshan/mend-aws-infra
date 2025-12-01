# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name_prefix = "${var.cluster_name}-eks-cluster-sg-"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-eks-cluster-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cluster_egress_fargate" {
  description       = "Allow cluster egress to Fargate pods"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = aws_security_group.eks_fargate_pods.id
  security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "cluster_ingress_fargate" {
  description              = "Allow Fargate pods to communicate with cluster API Server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_fargate_pods.id
  security_group_id        = aws_security_group.eks_cluster.id
}

# EKS Fargate Pod Security Group
resource "aws_security_group" "eks_fargate_pods" {
  name_prefix = "${var.cluster_name}-eks-fargate-pods-sg-"
  description = "Security group for EKS Fargate pods"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name                                        = "${var.cluster_name}-eks-fargate-pods-sg"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "fargate_pods_egress_internet" {
  description       = "Allow Fargate pods all egress (required for pulling images, communicating with AWS APIs)"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_fargate_pods.id
}

resource "aws_security_group_rule" "fargate_pods_ingress_self" {
  description              = "Allow Fargate pods to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_fargate_pods.id
  security_group_id        = aws_security_group.eks_fargate_pods.id
}

resource "aws_security_group_rule" "fargate_pods_ingress_cluster_https" {
  description              = "Allow cluster API Server to communicate with Fargate pods"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_fargate_pods.id
}
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "nodes_ingress_cluster_coredns_tcp" {
  description              = "Allow cluster control plane to communicate with pods running CoreDNS (TCP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_fargate_pods.id
}

resource "aws_security_group_rule" "fargate_pods_ingress_cluster_coredns_udp" {
  description              = "Allow cluster control plane to communicate with CoreDNS pods (UDP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_fargate_pods.id
}

resource "aws_security_group_rule" "fargate_pods_ingress_cluster_coredns_tcp" {
  description              = "Allow cluster control plane to communicate with CoreDNS pods (TCP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_fargate_pods.id
}

# Additional security group rules for specific CIDRs
resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  count             = length(var.cluster_security_group_additional_rules) > 0 ? length(var.cluster_security_group_additional_rules) : 0
  description       = var.cluster_security_group_additional_rules[count.index].description
  type              = var.cluster_security_group_additional_rules[count.index].type
  from_port         = var.cluster_security_group_additional_rules[count.index].from_port
  to_port           = var.cluster_security_group_additional_rules[count.index].to_port
  protocol          = var.cluster_security_group_additional_rules[count.index].protocol
  cidr_blocks       = var.cluster_security_group_additional_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.eks_cluster.id
}
