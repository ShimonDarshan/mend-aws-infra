# Security Group for EKS Cluster Control Plane
resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-sg"
    }
  )
}

# Egress rule for cluster - allow all outbound traffic
resource "aws_security_group_rule" "cluster_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "Allow all outbound traffic"
}

# Ingress rule - allow nodes to communicate with cluster API
resource "aws_security_group_rule" "cluster_ingress_node_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.cluster.id
  description              = "Allow nodes to communicate with cluster API Server"
}

# Security Group for EKS Worker Nodes
resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name                                        = "${var.cluster_name}-node-sg"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

# Egress rule for nodes - allow all outbound traffic
resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node.id
  description       = "Allow all outbound traffic"
}

# Ingress rule - allow nodes to communicate with each other
resource "aws_security_group_rule" "node_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.node.id
  description       = "Allow nodes to communicate with each other"
}

# Ingress rule - allow pods to communicate with cluster API
resource "aws_security_group_rule" "node_ingress_cluster_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster API to communicate with nodes"
}

# Ingress rule - allow cluster control plane to communicate with nodes (kubelet)
resource "aws_security_group_rule" "node_ingress_cluster_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster control plane to communicate with kubelet"
}

# Ingress rule - allow cluster control plane to communicate with CoreDNS
resource "aws_security_group_rule" "node_ingress_cluster_dns_tcp" {
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster control plane to communicate with CoreDNS (TCP)"
}

resource "aws_security_group_rule" "node_ingress_cluster_dns_udp" {
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster control plane to communicate with CoreDNS (UDP)"
}

# Ingress rule - allow cluster control plane to communicate with node ephemeral ports
resource "aws_security_group_rule" "node_ingress_cluster_ephemeral" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster control plane to communicate with pods on ephemeral ports"
}

# Security Group for Pod-to-Pod communication (CNI)
resource "aws_security_group" "pod" {
  name        = "${var.cluster_name}-pod-sg"
  description = "Security group for pod-to-pod communication"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name                                        = "${var.cluster_name}-pod-sg"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

# Allow all traffic within pod security group
resource "aws_security_group_rule" "pod_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.pod.id
  description       = "Allow pods to communicate with each other"
}

# Allow all outbound traffic from pods
resource "aws_security_group_rule" "pod_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pod.id
  description       = "Allow all outbound traffic from pods"
}

# Allow nodes to communicate with pods
resource "aws_security_group_rule" "pod_ingress_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.pod.id
  description              = "Allow nodes to communicate with pods"
}

# Allow cluster control plane to communicate with pods
resource "aws_security_group_rule" "pod_ingress_cluster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.pod.id
  description              = "Allow cluster control plane to communicate with pods"
}
