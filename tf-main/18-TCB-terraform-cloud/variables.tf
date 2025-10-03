variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID for authentication"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key for authentication"
  type        = string
  sensitive   = true
}