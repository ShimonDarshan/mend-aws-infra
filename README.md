# AWS Infrastructure Terraform Modules

Terraform modules for AWS infrastructure.

## EKS Module

Creates an AWS EKS cluster with managed node groups and network security.

### Usage

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

  # Node Group
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

### Features

- VPC with public/private subnets
- EKS cluster with managed nodes
- Network security groups (cluster, nodes, pods)
- IAM roles and policies
- Optional Helm chart installation
- Optional Route53 DNS setup

### Security

- Dedicated security groups for cluster, nodes, and pods
- No SSH access to nodes
- Encrypted EBS volumes
- Control plane logging
- Private subnets for worker nodes

### Connect to Cluster

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
```

See [modules/eks/README.md](modules/eks/README.md) for full documentation.

