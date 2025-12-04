variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
}

# VPC Configuration
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
}

# EKS Configuration
variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
}

variable "cluster_security_group_ids" {
  description = "Additional security group IDs to attach to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "cluster_log_types" {
  description = "List of control plane logging types to enable"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
}

variable "max_unavailable" {
  description = "Maximum number of nodes unavailable during a version update"
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Helm Chart Configuration
variable "install_mend_chart" {
  description = "Whether to install the Mend Helm chart"
  type        = bool
  default     = false
}

variable "oci_chart_url" {
  description = "OCI URL for the Mend Helm chart"
  type        = string
  default     = ""
}

variable "chart_version" {
  description = "Version of the Mend Helm chart"
  type        = string
  default     = ""
}

variable "helm_release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = ""
}

variable "helm_namespace" {
  description = "Kubernetes namespace for the Helm release"
  type        = string
  default     = ""
}

# Ingress Controller Configuration
variable "install_ingress_controller" {
  description = "Whether to install nginx ingress controller"
  type        = bool
  default     = false
}

variable "ingress_controller_version" {
  description = "Version of nginx ingress controller Helm chart"
  type        = string
  default     = "4.8.3"
}

# DNS Configuration
variable "create_dns_record" {
  description = "Whether to create DNS record for ingress"
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "Route53 hosted zone name (e.g., example.com)"
  type        = string
  default     = ""
}

variable "dns_record_name" {
  description = "DNS record name (e.g., app.example.com or example.com for apex)"
  type        = string
  default     = ""
}
