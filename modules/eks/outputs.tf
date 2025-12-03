output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

# output "cluster_arn" {
#   description = "The Amazon Resource Name (ARN) of the cluster"
#   value       = aws_eks_cluster.main.arn
# }

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = aws_eks_cluster.main.endpoint
# }

# output "cluster_security_group_id" {
#   description = "Security group ID attached to the EKS cluster"
#   value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
# }

# output "cluster_certificate_authority_data" {
#   description = "Base64 encoded certificate data required to communicate with the cluster"
#   value       = aws_eks_cluster.main.certificate_authority[0].data
# }

# output "cluster_version" {
#   description = "The Kubernetes server version for the cluster"
#   value       = aws_eks_cluster.main.version
# }

# output "node_group_id" {
#   description = "EKS node group ID"
#   value       = aws_eks_node_group.main.id
# }

# output "node_group_arn" {
#   description = "Amazon Resource Name (ARN) of the EKS Node Group"
#   value       = aws_eks_node_group.main.arn
# }

# output "node_group_status" {
#   description = "Status of the EKS node group"
#   value       = aws_eks_node_group.main.status
# }

# output "cluster_iam_role_arn" {
#   description = "IAM role ARN of the EKS cluster"
#   value       = aws_iam_role.cluster.arn
# }

# output "node_iam_role_arn" {
#   description = "IAM role ARN of the EKS node group"
#   value       = aws_iam_role.node.arn
# }

# VPC Outputs
# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = aws_vpc.main.id
# }

# output "vpc_cidr" {
#   description = "CIDR block of the VPC"
#   value       = aws_vpc.main.cidr_block
# }

# output "public_subnet_ids" {
#   description = "IDs of public subnets"
#   value       = aws_subnet.public[*].id
# }

# output "private_subnet_ids" {
#   description = "IDs of private subnets"
#   value       = aws_subnet.private[*].id
# }

# output "nat_gateway_ids" {
#   description = "IDs of NAT Gateways"
#   value       = aws_nat_gateway.main[*].id
# }

# Helm Outputs
# output "mend_chart_status" {
#   description = "Status of the Mend Helm chart deployment"
#   value       = var.install_mend_chart ? helm_release.mend[0].status : "not_installed"
# }

# output "mend_chart_namespace" {
#   description = "Namespace where Mend chart is installed"
#   value       = var.install_mend_chart ? helm_release.mend[0].namespace : null
# }

# output "ingress_controller_status" {
#   description = "Status of nginx ingress controller deployment"
#   value       = var.install_ingress_controller ? helm_release.ingress_nginx[0].status : "not_installed"
# }

output "ingress_load_balancer_hostname" {
  description = "Hostname of the ingress controller load balancer"
  value       = var.install_ingress_controller && var.create_dns_record ? try(data.kubernetes_service.ingress_nginx[0].status[0].load_balancer[0].ingress[0].hostname, null) : null
}

# output "dns_record_name" {
#   description = "DNS record name created for ingress"
#   value       = var.create_dns_record ? aws_route53_record.ingress[0].fqdn : null
# }

