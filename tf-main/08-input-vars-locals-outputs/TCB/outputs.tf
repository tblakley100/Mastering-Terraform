output "s3_bucket_name" {
  value       = aws_s3_bucket.project_bucket.bucket
  sensitive   = true
  description = "The name of the S3 bucket"
}

output "sensitive_var" {
  sensitive = true # We must set this to true since the variable is sensitive!
  value     = var.my_sensitive_value
}