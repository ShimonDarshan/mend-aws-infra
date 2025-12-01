# ========================================
# Core Cluster Configuration
# ========================================

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster (e.g., 1.28, 1.29, 1.30)"
  type        = string

  validation {
    condition     = can(regex("^1\\.(2[8-9]|3[0-9])$", var.kubernetes_version))
    error_message = "Kubernetes version must be 1.28 or higher."
  }
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster control plane"
  type        = list(string)
}

# ========================================
# Cluster Access Configuration
# ========================================

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint. Set to true only if needed and restrict public_access_cidrs"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint. Restrict to your IP/VPN for security"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_access_cidrs) > 0 || var.endpoint_public_access == false
    error_message = "public_access_cidrs must be specified when endpoint_public_access is true. Do not use 0.0.0.0/0 in production."
  }
}

# ========================================
# Logging Configuration
# ========================================

# ========================================
# Fargate Configuration
# ========================================

variable "fargate_subnet_ids" {
  description = "List of subnet IDs for Fargate profiles (must be private subnets)"
  type        = list(string)
}

# ========================================
# Security Group Configuration
# ========================================

variable "cluster_security_group_additional_rules" {
  description = "Additional security group rules to add to the cluster security group"
  type = list(object({
    description = string
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

# ========================================
# Tags
# ========================================

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

# ========================================
# EKS Add-ons Configuration
# ========================================

variable "vpc_cni_addon_version" {
  description = "Version of the VPC CNI addon. Leave null for latest"
  type        = string
  default     = null
}

variable "kube_proxy_addon_version" {
  description = "Version of the kube-proxy addon. Leave null for latest"
  type        = string
  default     = null
}

variable "coredns_addon_version" {
  description = "Version of the CoreDNS addon. Leave null for latest"
  type        = string
  default     = null
}
