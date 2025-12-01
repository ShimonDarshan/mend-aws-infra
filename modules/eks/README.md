# AWS EKS Fargate Module

Production-ready Terraform module for deploying an AWS EKS cluster with Fargate profiles. Optimized for stateless applications running on serverless compute.

## Features

1. **Serverless Compute**:
   - EKS Fargate profiles for pod execution
   - No EC2 instances to manage
   - Automatic scaling
   - Pay only for resources used

2. **Security First**:
   - Private cluster endpoint by default
   - AWS-managed encryption for secrets
   - Strict security group rules
   - Input validation on critical variables

3. **DNS Support**:
   - Dedicated CoreDNS Fargate profile
   - Automatic CoreDNS patching for Fargate compatibility
   - VPC CNI for pod networking

4. **Production Ready**:
   - All required variables must be provided
   - Secure defaults for optional settings
   - Comprehensive outputs
   - Proper resource dependencies

## Required Inputs

| Name | Description | Type |
|------|-------------|------|
| cluster_name | Name of the EKS cluster | string |
| kubernetes_version | Kubernetes version (1.28+) | string |
| vpc_id | VPC ID | string |
| subnet_ids | Subnet IDs for control plane | list(string) |
| fargate_subnet_ids | Private subnet IDs for Fargate | list(string) |

## Optional Inputs

| Name | Description | Default |
|------|-------------|---------|
| endpoint_private_access | Enable private endpoint | true |
| endpoint_public_access | Enable public endpoint | false |
| public_access_cidrs | CIDRs for public access | [] |
| fargate_profiles | Map of Fargate profile definitions | {} |
| vpc_cni_addon_version | VPC CNI addon version | null (latest) |
| kube_proxy_addon_version | kube-proxy addon version | null (latest) |
| coredns_addon_version | CoreDNS addon version | null (latest) |
| cluster_security_group_additional_rules | Additional SG rules | [] |
| tags | Resource tags | map(string) |

## Outputs

- `cluster_id` - EKS cluster ID
- `cluster_endpoint` - Kubernetes API endpoint
- `cluster_certificate_authority_data` - CA certificate data
- `cluster_security_group_id` - Cluster security group ID
- `fargate_pod_security_group_id` - Fargate pod security group ID
- `fargate_profile_ids` - Map of Fargate profile IDs
- `fargate_pod_execution_role_arn` - Fargate pod execution IAM role ARN

## Usage Example

```hcl
module "eks" {
  source = "./modules/eks"

  # Required
  cluster_name       = "my-fargate-cluster"
  kubernetes_version = "1.30"
  vpc_id             = "vpc-xxxxx"
  subnet_ids         = ["subnet-xxxxx", "subnet-yyyyy"]
  fargate_subnet_ids = ["subnet-private1", "subnet-private2"]

  # Optional: Define custom Fargate profiles
  fargate_profiles = {
    app-profile = {
      selectors = [
        {
          namespace = "production"
          labels = {
            app = "my-app"
          }
        }
      ]
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Fargate Profile Configuration

The module automatically creates a CoreDNS Fargate profile. Define additional profiles for your applications:

```hcl
fargate_profiles = {
  # Profile for production namespace
  production = {
    selectors = [
      {
        namespace = "production"
      }
    ]
  }
  
  # Profile with label selector
  backend = {
    selectors = [
      {
        namespace = "production"
        labels = {
          tier = "backend"
        }
      }
    ]
  }
}
```

## Important Notes

1. **Fargate Subnets**: Must be private subnets (no internet gateway route)
2. **CoreDNS**: Automatically configured to run on Fargate
3. **No EC2**: This module does not create any EC2 instances or node groups
4. **Stateless Only**: Fargate is best for stateless applications
5. **kubectl Access**: Requires AWS CLI and kubectl configured after cluster creation

## Security Considerations

- Cluster is private by default
- Public access requires explicit CIDR restrictions
- KMS encryption is optional but recommended for production
- Security groups follow least-privilege principle
- No SSH access required (no EC2 nodes)

## Prerequisites

- Terraform >= 1.3.0
- AWS Provider >= 5.0
- VPC with private subnets
- AWS CLI (for CoreDNS patching)
- kubectl (for CoreDNS patching)

## Module Structure

```
modules/eks/
├── addons.tf           # EKS managed addons
├── data.tf             # Data sources
├── eks.tf              # EKS cluster
├── fargate.tf          # Fargate profiles
├── iam.tf              # IAM roles
├── outputs.tf          # Module outputs
├── security_groups.tf  # Security groups
├── variables.tf        # Input variables
└── versions.tf         # Provider requirements
```
