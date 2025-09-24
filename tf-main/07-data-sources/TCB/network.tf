resource "aws_vpc" "terraform_managed" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform-managed"
    Env  = "Prod"
  }
}

# Data source to fetch VPC information based on Env tag
data "aws_vpc" "prod_vpc" {
  filter {
    name   = "tag:Env"
    values = ["Prod"]
  }

  depends_on = [aws_vpc.terraform_managed]
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "amazon_aws_azs" {
  value = data.aws_availability_zones.available.names

}