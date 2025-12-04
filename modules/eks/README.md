# AWS EKS Terraform Module

A production-ready Terraform module for creating Amazon EKS (Elastic Kubernetes Service) clusters with managed node groups.

## Features

- **Zero Defaults**: All parameters must be explicitly provided - no default IP addresses or CIDR blocks
- **Modular Design**: Organized into separate files by resource type
- **IAM Management**: Automated IAM role and policy creation for cluster and nodes
- **Flexible Configuration**: Full control over networking, scaling, and instance types
- **Control Plane Logging**: Configurable EKS control plane logging
- **Secure by Default**: Requires explicit specification of all security parameters

## Module Structure

```
modules/eks/
├── cluster.tf        # EKS cluster resource
├── node-group.tf     # Managed node group configuration
├── iam.tf           # IAM roles and policies
├── variables.tf     # Input variables (no defaults for critical params)
├── outputs.tf       # Module outputs
└── versions.tf      # Provider version constraints
```

## Usage

```hcl
module "eks" {
  source = "../../modules/eks"

  # Cluster configuration
  cluster_name       = "my-eks-cluster"
  kubernetes_version = "1.28"
  subnet_ids         = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]

  # Network access control - NO DEFAULTS
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["203.0.113.0/24", "198.51.100.0/24"]

  # Logging configuration
  cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Node group configuration
  desired_capacity = 3
  max_capacity     = 5
  min_capacity     = 1
  instance_types   = ["t3.medium"]
  capacity_type    = "ON_DEMAND"
  disk_size        = 20
  max_unavailable  = 1

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Examples

See the [examples/basic](../../examples/basic/) directory for a complete working example.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Required Inputs

All of the following variables **must** be provided - there are no defaults for critical security parameters:

| Name | Description | Type |
|------|-------------|------|
| cluster_name | Name of the EKS cluster | `string` |
| kubernetes_version | Kubernetes version (e.g., "1.28") | `string` |
| subnet_ids | List of subnet IDs (minimum 2, different AZs recommended) | `list(string)` |
| endpoint_private_access | Enable private API server endpoint | `bool` |
| endpoint_public_access | Enable public API server endpoint | `bool` |
| public_access_cidrs | CIDR blocks allowed to access public endpoint | `list(string)` |
| cluster_log_types | Control plane logging types to enable | `list(string)` |
| desired_capacity | Desired number of worker nodes | `number` |
| max_capacity | Maximum number of worker nodes | `number` |
| min_capacity | Minimum number of worker nodes | `number` |
| instance_types | EC2 instance types for node group | `list(string)` |
| capacity_type | Capacity type: "ON_DEMAND" or "SPOT" | `string` |
| disk_size | Disk size in GiB for worker nodes | `number` |
| max_unavailable | Max nodes unavailable during updates | `number` |

## Optional Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| cluster_security_group_ids | Additional security group IDs | `list(string)` | `[]` |
| tags | Tags to apply to all resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_arn | EKS cluster ARN |
| cluster_endpoint | EKS API server endpoint |
| cluster_security_group_id | Cluster security group ID |
| cluster_certificate_authority_data | Base64 encoded CA certificate (sensitive) |
| cluster_version | Kubernetes version |
| node_group_id | Node group ID |
| node_group_arn | Node group ARN |
| node_group_status | Node group status |
| cluster_iam_role_arn | Cluster IAM role ARN |
| node_iam_role_arn | Node IAM role ARN |

## Prerequisites

Before using this module:

1. **VPC Setup**: Have an existing VPC with subnets in at least 2 availability zones
2. **Subnet Planning**: Ensure subnets have sufficient IP addresses for your workload
3. **Network Access**: Know which CIDR blocks should access your cluster
4. **AWS Credentials**: Configure AWS credentials with appropriate permissions

## Security Considerations

### No Default IP Addresses

This module **does not provide default values** for:
- `public_access_cidrs` - You must explicitly specify which IPs can access the cluster
- Network configuration - All endpoint access settings must be explicitly set

### Best Practices

1. **Private Access**: Enable `endpoint_private_access` for production workloads
2. **Restrict Public Access**: 
   - Set `endpoint_public_access = false` if possible
   - If public access needed, restrict `public_access_cidrs` to known IP ranges
3. **Logging**: Enable all `cluster_log_types` for audit and compliance
4. **Subnets**: Use private subnets for node groups when possible

## Post-Deployment

After deploying the cluster, configure kubectl:

```bash
aws eks update-kubeconfig --region <your-region> --name <cluster-name>
```

Verify the cluster:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## IAM Roles Created

The module creates the following IAM roles:

1. **Cluster Role** (`<cluster-name>-cluster-role`)
   - AmazonEKSClusterPolicy
   - AmazonEKSVPCResourceController

2. **Node Role** (`<cluster-name>-node-role`)
   - AmazonEKSWorkerNodePolicy
   - AmazonEKS_CNI_Policy
   - AmazonEC2ContainerRegistryReadOnly

## License

MIT
