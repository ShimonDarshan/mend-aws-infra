output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.tfstate.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.tfstate.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.tfstate.bucket
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = aws_s3_bucket.tfstate.region
}
