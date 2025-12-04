# S3 Storage Module

This module creates an S3 bucket configured for storing Terraform state files with best practices including:

- **Versioning enabled** - Track changes to state files over time
- **Server-side encryption** - Encrypt state files at rest using AES256
- **Public access blocked** - Prevent accidental public exposure of state files

## Usage

```hcl
module "tfstate_storage" {
  source = "./modules/s3storage"

  bucket_name = "my-terraform-state-bucket"
  environment = "prod"
  
  tags = {
    Project = "Infrastructure"
    Owner   = "DevOps Team"
  }
}
```

## Backend Configuration

After creating the bucket, configure your Terraform backend:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "path/to/my/state.tfstate"
    region = "us-east-1"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | The name of the S3 bucket for Terraform state storage | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| tags | Additional tags to apply to the S3 bucket | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The ID of the S3 bucket |
| bucket_arn | The ARN of the S3 bucket |
| bucket_name | The name of the S3 bucket |
| bucket_region | The AWS region this bucket resides in |

## Security Features

- **Versioning**: Enabled by default to maintain history of state files
- **Encryption**: AES256 server-side encryption enabled
- **Public Access**: All public access blocked by default
