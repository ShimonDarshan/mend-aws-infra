# Get the ingress controller load balancer hostname
data "kubernetes_service" "ingress_nginx" {
  count = var.install_ingress_controller && var.create_dns_record ? 1 : 0

  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.ingress_nginx]
}

# Get the hosted zone
data "aws_route53_zone" "main" {
  count = var.create_dns_record ? 1 : 0

  name         = "${var.dns_zone_name}."
  private_zone = false
}

# Create DNS record pointing to the ingress load balancer
resource "aws_route53_record" "ingress" {
  count = var.install_ingress_controller && var.create_dns_record ? 1 : 0

  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = var.dns_record_name
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_nginx[0].status[0].load_balancer[0].ingress[0].hostname
    zone_id               = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }

  depends_on = [helm_release.ingress_nginx]
}

# Get ELB hosted zone ID for the region
data "aws_elb_hosted_zone_id" "main" {}
