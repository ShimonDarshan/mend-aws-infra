# AWS Infrastructure Terraform Modules

Production-ready Terraform modules for AWS infrastructure with security-first design.

## Available Modules

### EKS Module (`modules/eks`)

Terraform module for AWS EKS clusters with managed node groups.

**Key Features:**
- Zero defaults - all parameters must be explicitly provided
- No default IP addresses or CIDR blocks
- Modular design split into logical files
- IAM roles and policies automatically configured
- Support for both ON_DEMAND and SPOT instances
- Full control plane logging capabilities

**Quick Start:**

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name       = "my-eks-cluster"
  kubernetes_version = "1.28"
  subnet_ids         = ["subnet-abc123", "subnet-def456"]

  # Network configuration - all required, no defaults
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["203.0.113.0/24"]

  # Logging
  cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Node group
  desired_capacity = 2
  max_capacity     = 4
  min_capacity     = 1
  instance_types   = ["t3.medium"]
  capacity_type    = "ON_DEMAND"
  disk_size        = 20
  max_unavailable  = 1

  tags = {
    Environment = "production"
  }
}
```

See [modules/eks/README.md](modules/eks/README.md) for complete documentation.

## Examples

Complete working examples are available in the `examples/` directory:

- **[examples/basic](examples/basic/)** - Basic EKS cluster setup with all required parameters

Each example includes:
- Complete Terraform configuration
- Example tfvars file
- Documentation and usage instructions

## Module Structure

```
.
├── modules/
│   └── eks/                    # EKS module
│       ├── cluster.tf          # EKS cluster resource
│       ├── node-group.tf       # Managed node group
│       ├── iam.tf              # IAM roles and policies
│       ├── variables.tf        # Input variables
│       ├── outputs.tf          # Module outputs
│       ├── versions.tf         # Provider requirements
│       └── README.md           # Module documentation
│
└── examples/
    └── basic/                  # Basic example
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── terraform.tfvars.example
        └── README.md
```

## Security Philosophy

This repository follows a **zero-defaults security model**:

- **No default IP addresses**: All CIDR blocks must be explicitly specified
- **No default network configuration**: Endpoint access must be explicitly configured
- **Explicit over implicit**: All critical parameters require user input
- **Validation built-in**: Variables include type constraints

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Existing VPC infrastructure
- AWS credentials with appropriate permissions

## Getting Started

1. **Choose a module**: Start with `modules/eks` for EKS clusters

2. **Review the example**: Check `examples/basic` for usage patterns

3. **Customize configuration**: Copy the example and adjust for your needs:
   ```bash
   cd examples/basic
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## After Deployment

Configure kubectl to connect to your cluster:

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

Verify the cluster is running:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Contributing

Contributions are welcome! Please ensure:
- No default IP addresses or CIDR blocks
- All security-critical parameters are required
- Documentation is updated
- Examples are provided for new features

## License

MIT

