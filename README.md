# AWS EKS Fargate Terraform Module

Production-ready Terraform module for deploying AWS EKS clusters with Fargate profiles. Designed for stateless applications running on serverless compute without managing EC2 instances.

## Features

- **Serverless Compute**: EKS Fargate profiles with no EC2 instances
- **Security First**: Private by default, optional KMS encryption, strict security groups
- **Production Ready**: Input validation, secure defaults, comprehensive outputs
- **DNS Support**: Automatic CoreDNS configuration for Fargate
- **Flexible Profiles**: Support for namespace and label-based pod selectors

## Quick Start

```hcl
module "eks" {
  source = "github.com/ShimonDarshan/mend-aws-infra//modules/eks?ref=main"

  cluster_name       = "my-cluster"
  kubernetes_version = "1.30"
  vpc_id             = "vpc-xxxxx"
  subnet_ids         = ["subnet-xxxxx", "subnet-yyyyy"]
  fargate_subnet_ids = ["subnet-private1", "subnet-private2"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    EKS Cluster                      │
│                 (Control Plane)                     │
└──────────────────┬──────────────────────────────────┘
                   │
                   │ Private Endpoint
                   │
┌──────────────────┴──────────────────────────────────┐
│              Fargate Profiles                       │
├─────────────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐                    │
│  │  CoreDNS   │  │  Default   │                    │
│  │ (kube-sys) │  │ Namespace  │                    │
│  └────────────┘  └────────────┘                    │
│                                                     │
│  ┌─────────────────────────────────────────────┐  │
│  │     Pods run on serverless Fargate         │  │
│  │     (no EC2 instances to manage)            │  │
│  └─────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Module Structure

```
.
├── modules/eks/          # Main EKS module
│   ├── addons.tf         # EKS managed addons (VPC CNI, CoreDNS, kube-proxy)
│   ├── data.tf           # Data sources
│   ├── eks.tf            # EKS cluster resource
│   ├── fargate.tf        # Fargate profiles and CoreDNS patching
│   ├── iam.tf            # IAM roles (cluster, Fargate pod execution)
│   ├── outputs.tf        # Module outputs
│   ├── security_groups.tf # Security groups for cluster and Fargate pods
│   ├── variables.tf      # Input variables with validation
│   ├── versions.tf       # Provider requirements
│   └── README.md         # Module documentation
│
└── examples/
    ├── basic/            # Minimal configuration example
    └── complete/         # Full-featured production example
```

## Examples

### Basic Example

Minimal setup with a single Fargate profile for the default namespace:

```bash
cd examples/basic
terraform init
terraform apply
```

### Complete Example

Production-ready setup with multiple Fargate profiles and advanced features:

```bash
cd examples/complete
terraform init
terraform apply
```

## Required Inputs

| Name | Description | Type |
|------|-------------|------|
| cluster_name | Name of the EKS cluster | `string` |
| kubernetes_version | Kubernetes version (1.28+) | `string` |
| vpc_id | VPC ID | `string` |
| subnet_ids | Subnet IDs for control plane | `list(string)` |
| fargate_subnet_ids | Private subnet IDs for Fargate profiles | `list(string)` |

## Key Features

### 🚀 Serverless Compute
- No EC2 instances to patch or manage
- Automatic scaling based on pod requirements
- Pay only for the resources your pods use

### 🔒 Security Best Practices
- Private cluster endpoint by default
- AWS-managed encryption for secrets
- Security groups follow least-privilege principle
- Input validation prevents misconfigurations

### 📊 Observability
- CloudWatch integration ready
- OIDC provider for IAM roles for service accounts
- Comprehensive outputs for monitoring tools

### ⚙️ Operational Excellence
- Automatic CoreDNS configuration for Fargate
- Default namespace Fargate profile included
- Production-tested defaults

## Important Notes

1. **Fargate Subnet Requirements**
   - Must be private subnets (no direct internet gateway)
   - NAT gateway required for pulling images

2. **No EC2 Instances**
   - This module creates ONLY Fargate profiles
   - No managed node groups or self-managed nodes

3. **Stateless Applications**
   - Fargate is optimized for stateless workloads
   - No local persistent storage support

4. **CoreDNS**
   - Automatically configured to run on Fargate
   - Requires kubectl and AWS CLI for patching

5. **Default Namespace**
   - Fargate profile automatically created for default namespace
   - All pods in default namespace run on Fargate

## Prerequisites

- Terraform >= 1.3.0
- AWS Provider >= 5.0
- VPC with private subnets and NAT gateway
- AWS CLI (for CoreDNS patching)
- kubectl (for CoreDNS patching)

## After Deployment

Configure kubectl:
```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

Verify the cluster:
```bash
kubectl get nodes
kubectl get pods -A
```

Deploy a test application:
```bash
kubectl run nginx --image=nginx --namespace=default
kubectl get pods
```

## Limitations

- **No EBS Volumes**: Fargate doesn't support EBS CSI driver
- **No DaemonSets**: Fargate doesn't support DaemonSets
- **No Host Networking**: Pods must use AWS VPC networking
- **No Privileged Containers**: Security restriction on Fargate
- **No GPUs**: Fargate doesn't support GPU workloads

## Troubleshooting

### Pods stuck in Pending
- Check Fargate profile selectors match pod namespace/labels
- Verify subnets have available IPs
- Check security group rules

### CoreDNS not working
- Run the null_resource provisioner manually if needed
- Verify kubectl access to the cluster

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details
