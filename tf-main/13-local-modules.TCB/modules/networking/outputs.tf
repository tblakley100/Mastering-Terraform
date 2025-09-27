locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
      cidr_block       = aws_subnet.this[key].cidr_block
    }
  }

  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
      cidr_block       = aws_subnet.this[key].cidr_block
    }
  }
}

output "vpc_id" {
  description = "The AWS ID from the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnets" {
  description = "The AZ, ID and CIDR block of public subnets."
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "The AZ, ID and CIDR block of private subnets."
  value       = local.output_private_subnets
}