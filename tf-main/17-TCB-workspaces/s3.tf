resource "random_id" "bucket_suffix" {
  count       = var.bucket_count
  byte_length = 4

  keepers = {
    workspace = terraform.workspace
  }
}


resource "aws_s3_bucket" "this" {
  count  = var.bucket_count
  bucket = "workspaces-demo-${terraform.workspace}-${random_id.bucket_suffix[count.index].hex}"
}

output "bucket_arns" {
  value = aws_s3_bucket.this[*].arn
}

output "bucket_regions" {
  value = aws_s3_bucket.this[*].region
}

output "bucket_names" {
  value = aws_s3_bucket.this[*].bucket
}


