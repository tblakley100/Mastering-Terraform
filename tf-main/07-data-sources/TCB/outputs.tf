# Output to display the VPC ID retrieved from the data source
output "vpc_id" {
  description = "The ID of the VPC retrieved by the data source"
  value       = data.aws_vpc.prod_vpc.id
}

output "current_account_id" {
  description = "The AWS account ID of the current user"
  value       = data.aws_caller_identity.current.account_id
}

output "current_region" {
  description = "The AWS region of the current user"
  value       = data.aws_region.current.name
}

output "ubuntu_ami_data" {
  description = "The ID of the Ubuntu AMI retrieved by the data source"
  value       = data.aws_ami.ubuntu.id
}

