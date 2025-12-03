module "tfstate_storage" {
  source = "../../modules/s3storage"

  bucket_name = var.bucket_name
  environment = var.environment

  tags = {
    Project     = "AWS Infrastructure"
    Owner       = "DevOps Team"
    ManagedBy   = "Terraform"
    Description = "Terraform state storage bucket"
  }
}
