output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.tfstate_storage.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.tfstate_storage.bucket_arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.tfstate_storage.bucket_name
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.tfstate_storage.bucket_region
}
