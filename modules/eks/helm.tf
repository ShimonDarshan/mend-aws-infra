# Ingress Controller (nginx)
resource "helm_release" "ingress_nginx" {
  count = var.install_ingress_controller ? 1 : 0

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_controller_version
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
          }
        }
      }
    })
  ]

  wait    = true
  timeout = 600

  lifecycle {
    ignore_changes = [
      repository_password,
      repository_username,
    ]
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main
  ]
}

# Helm Chart Installation
resource "helm_release" "mend" {
  count = var.install_mend_chart ? 1 : 0

  name             = var.helm_release_name
  chart            = var.oci_chart_url
  version          = var.chart_version
  namespace        = var.helm_namespace
  create_namespace = true

  values = [
    yamlencode({
      ingress = {
        enabled   = true
        className = "nginx"
        annotations = {
          "nginx.ingress.kubernetes.io/backend-protocol"      = "HTTP"
          "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
          "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "30"
          "nginx.ingress.kubernetes.io/proxy-send-timeout"    = "30"
          "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "30"
          "nginx.ingress.kubernetes.io/proxy-body-size"       = "0"
        }
        hosts = [
          {
            host = ""
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
              }
            ]
          }
        ]
      }
    })
  ]

  # Wait for nodes to be ready
  wait    = true
  timeout = 600

  lifecycle {
    ignore_changes = [
      repository_password,
      repository_username,
    ]
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    helm_release.ingress_nginx
  ]
}
