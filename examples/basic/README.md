# Basic EKS Module Example

This example demonstrates how to use the EKS module to create a complete infrastructure including VPC, subnets, and EKS cluster.

## What This Creates

- **VPC** with custom CIDR block
- **Public subnets** across multiple availability zones
- **Private subnets** across multiple availability zones
- **Internet Gateway** for public subnet access
- **NAT Gateways** (one per AZ) for private subnet internet access
- **EKS Cluster** with all required IAM roles
- **Managed Node Group** running in private subnets

## Prerequisites

- AWS credentials configured
- Terraform >= 1.0
- **No existing VPC required** - this example creates everything

## Usage

1. Edit `terraform.tfvars` with your desired values:
   - Choose your VPC CIDR block (e.g., `10.0.0.0/16`)
   - Define subnet CIDRs within your VPC range
   - Update `public_access_cidrs` with your allowed IP ranges
   - Select your availability zones

2. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Important Notes

- **VPC and Subnets Created Automatically**: No need to create VPC beforehand
- **Subnet Planning**: Ensure subnet CIDRs don't overlap and are within VPC CIDR
- **NAT Gateway Costs**: Each NAT Gateway costs ~$0.045/hour + data transfer
- **Public Access**: Specify allowed CIDR blocks for cluster API access
- **Availability Zones**: Must match the number of subnet CIDRs provided

## After Deployment

Configure kubectl to access your cluster:

```bash
terraform output -raw configure_kubectl | bash
```

Or manually:

```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
```

Verify the cluster:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Cleanup

To destroy the resources:

```bash
terraform destroy
```
