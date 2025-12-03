terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources to get cluster info for providers
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source = "../../modules/eks"

  # Cluster configuration
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version

  # VPC configuration
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway

  # Network access control
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access
  public_access_cidrs     = var.public_access_cidrs

  # Logging
  cluster_log_types = var.cluster_log_types

  # Node group configuration
  desired_capacity = var.desired_capacity
  max_capacity     = var.max_capacity
  min_capacity     = var.min_capacity
  instance_types   = var.instance_types
  capacity_type    = var.capacity_type
  disk_size        = var.disk_size
  max_unavailable  = var.max_unavailable

  # Helm chart configuration
  install_mend_chart = var.install_mend_chart
  oci_chart_url      = var.oci_chart_url
  chart_version      = var.chart_version
  helm_release_name  = var.helm_release_name
  helm_namespace     = var.helm_namespace

  # Ingress controller configuration
  install_ingress_controller = var.install_ingress_controller
  ingress_controller_version = var.ingress_controller_version

  # DNS configuration
  create_dns_record = var.create_dns_record
  dns_zone_name     = var.dns_zone_name
  dns_record_name   = var.dns_record_name

  tags = var.tags
}
