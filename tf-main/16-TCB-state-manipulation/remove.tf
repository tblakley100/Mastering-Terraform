# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "terraform-remove-tcb-43987247"
# }

removed {
  from = aws_s3_bucket.my_bucket

  lifecycle {
    destroy = false
  }
}