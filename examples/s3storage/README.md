# S3 Storage Module Example

This example demonstrates how to use the S3 storage module to create a secure S3 bucket for storing Terraform state files.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed

## Usage

1. **Update the variables** in `terraform.tfvars`:
   ```hcl
   bucket_name = "your-unique-bucket-name"
   environment = "dev"
   aws_region  = "us-east-1"
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

5. **View outputs**:
   ```bash
   terraform output
   ```

## What Gets Created

- S3 bucket with versioning enabled
- Server-side encryption (AES256)
- Public access blocked
- Appropriate tags for organization

## Using the Bucket for Terraform State

After creating the bucket, you can configure your Terraform backend in other projects:

```hcl
terraform {
  backend "s3" {
    bucket = "your-unique-bucket-name"
    key    = "path/to/terraform.tfstate"
    region = "us-east-1"
  }
}
```

**Note:** You'll need to run `terraform init` to migrate your state to the new backend.

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

**Warning:** Make sure the bucket is empty before destroying it. S3 buckets with objects cannot be deleted.
