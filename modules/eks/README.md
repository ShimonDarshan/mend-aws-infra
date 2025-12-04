# EKS Terraform Module

Creates an AWS EKS cluster with VPC, managed node groups, and security configurations.

## Usage

```hcl
module "eks" {
  source = "./modules/eks"

  # Cluster
  cluster_name       = "my-cluster"
  kubernetes_version = "1.28"

  # VPC
  vpc_name             = "my-vpc"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = true

  # Security
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]  # Restrict in production
  cluster_log_types       = ["api", "audit"]

  # Nodes
  desired_capacity = 2
  max_capacity     = 4
  min_capacity     = 1
  instance_types   = ["t3.medium"]
  capacity_type    = "ON_DEMAND"
  disk_size        = 20
  max_unavailable  = 1

  tags = {
    Environment = "dev"
  }
}
```

## What Gets Created

- VPC with public and private subnets
- Internet Gateway and NAT Gateways
- EKS cluster control plane
- Managed node group in private subnets
- Security groups (cluster, nodes, pods)
- IAM roles and policies

## Security Features

✅ Dedicated security groups with least privilege
✅ Nodes in private subnets only
✅ No SSH access to nodes
✅ Control plane logging enabled
✅ Network isolation between cluster/nodes/pods

## Variables

### Required

| Name | Description | Type |
|------|-------------|------|
| cluster_name | EKS cluster name | string |
| kubernetes_version | Kubernetes version | string |
| vpc_name | VPC name | string |
| vpc_cidr | VPC CIDR block | string |
| availability_zones | List of AZs | list(string) |
| public_subnet_cidrs | Public subnet CIDRs | list(string) |
| private_subnet_cidrs | Private subnet CIDRs | list(string) |
| enable_nat_gateway | Enable NAT gateway | bool |
| endpoint_private_access | Enable private endpoint | bool |
| endpoint_public_access | Enable public endpoint | bool |
| public_access_cidrs | CIDRs for public access | list(string) |
| cluster_log_types | Control plane logs to enable | list(string) |
| desired_capacity | Desired node count | number |
| max_capacity | Max node count | number |
| min_capacity | Min node count | number |
| instance_types | Node instance types | list(string) |
| capacity_type | ON_DEMAND or SPOT | string |
| disk_size | Node disk size (GiB) | number |
| max_unavailable | Max unavailable during updates | number |

### Optional

| Name | Default | Description |
|------|---------|-------------|
| tags | {} | Tags for all resources |
| cluster_security_group_ids | [] | Additional cluster SGs |
| install_ingress_controller | false | Install nginx ingress |
| install_mend_chart | false | Install Mend chart |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_endpoint | API server endpoint |
| vpc_id | VPC ID |

## Connect to Cluster

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
