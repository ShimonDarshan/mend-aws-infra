# output "cluster_id" {
#   description = "The name/id of the EKS cluster"
#   value       = module.eks.cluster_id
# }

# output "cluster_arn" {
#   description = "The Amazon Resource Name (ARN) of the cluster"
#   value       = module.eks.cluster_arn
# }

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   description = "Security group ID attached to the EKS cluster"
#   value       = module.eks.cluster_security_group_id
# }

# output "cluster_version" {
#   description = "The Kubernetes server version for the cluster"
#   value       = module.eks.cluster_version
# }

# output "node_group_id" {
#   description = "EKS node group ID"
#   value       = module.eks.node_group_id
# }

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.eks.vpc_id
# }

# output "public_subnet_ids" {
#   description = "IDs of public subnets"
#   value       = module.eks.public_subnet_ids
# }

# output "private_subnet_ids" {
#   description = "IDs of private subnets"
#   value       = module.eks.private_subnet_ids
# }

# output "mend_chart_status" {
#   description = "Status of Mend Helm chart installation"
#   value       = module.eks.mend_chart_status
# }

# output "ingress_controller_status" {
#   description = "Status of nginx ingress controller"
#   value       = module.eks.ingress_controller_status
# }

output "ingress_load_balancer_hostname" {
  description = "Load balancer hostname for ingress"
  value       = module.eks.ingress_load_balancer_hostname
}

# output "dns_record_name" {
#   description = "DNS record created for ingress"
#   value       = module.eks.dns_record_name
# }

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}
