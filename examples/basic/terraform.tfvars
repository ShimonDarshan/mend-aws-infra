# Example values - replace with your actual values
cluster_name       = "my-eks-cluster"
kubernetes_version = "1.34"

# VPC Configuration
vpc_name           = "my-eks-vpc"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Subnet CIDR blocks - must be within VPC CIDR
public_subnet_cidrs = [
  "10.0.1.0/24", # us-east-1a
  "10.0.2.0/24", # us-east-1b
  "10.0.3.0/24"  # us-east-1c
]

private_subnet_cidrs = [
  "10.0.101.0/24", # us-east-1a
  "10.0.102.0/24", # us-east-1b
  "10.0.103.0/24"  # us-east-1c
]

# Enable NAT Gateway for private subnet internet access
enable_nat_gateway = true

# Network configuration
endpoint_private_access = true
endpoint_public_access  = true

# CIDR blocks allowed to access the public endpoint
# IMPORTANT: Replace with your actual public IP address
# To get your current IP: curl ifconfig.me
# Format: "YOUR.IP.ADDRESS.HERE/32" for a single IP
public_access_cidrs = [
  "0.0.0.0/0"  # WARNING: This allows access from anywhere - replace with your actual IP/32
]

# Control plane logging
cluster_log_types = [
  "api",
  "audit",
  "authenticator",
  "controllerManager",
  "scheduler"
]

# Node group configuration
desired_capacity = 2
max_capacity     = 4
min_capacity     = 1

instance_types = ["t3.medium"]
capacity_type  = "ON_DEMAND"
disk_size      = 20

max_unavailable = 1

# Tags
tags = {
  Environment = "development"
  ManagedBy   = "terraform"
  Project     = "my-project"
}

# Helm Chart Configuration
install_mend_chart = true
oci_chart_url      = "oci://ghcr.io/shimondarshan/mendchart/mend"
chart_version      = "0.1.0"
helm_release_name  = "mend"
helm_namespace     = "mend"

# Ingress Controller Configuration
install_ingress_controller = true
ingress_controller_version = "4.8.3"

# DNS Configuration
create_dns_record = true
dns_zone_name     = "shimondarshan-aws-mend.com"
dns_record_name   = "shimondarshan-aws-mend.com" # Use zone name for apex domain
