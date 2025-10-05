# resource "random_id" "bucket_id" {
#   byte_length = 4
# }

# resource "aws_s3_bucket" "tf_cloud" {
#   bucket = "tf-cloud-bucket-tcb-${random_id.bucket_id.hex}"
#   tags = {
#     Name        = "tf-cloud-bucket"
#     Environment = "Dev"
#   }
# }

# resource "random_id" "bucket_id_2" {
#   byte_length = 4
# }

# resource "aws_s3_bucket" "tf_cloud_2-cli" {
#   bucket = "tf-cloud-bucket-cli-tcb-${random_id.bucket_id_2.hex}"
#   tags = {
#     Name        = "tf-cloud-bucket-cli"
#     Environment = "Dev"
#   }
# }
