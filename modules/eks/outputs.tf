output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "ingress_load_balancer_hostname" {
  description = "Hostname of the ingress controller load balancer"
  value       = var.install_ingress_controller && var.create_dns_record ? try(data.kubernetes_service.ingress_nginx[0].status[0].load_balancer[0].ingress[0].hostname, null) : null
}
