output "s3_website_endpoint" {
  description = "S3 Static Website endpoint for the tcb_website_bucket"
  value       = "http://${aws_s3_bucket.tcb_website_bucket.bucket}.s3-website.${aws_s3_bucket.tcb_website_bucket.region}.amazonaws.com"
}