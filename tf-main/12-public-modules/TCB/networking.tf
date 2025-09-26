data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24"]
}
module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  cidr            = local.vpc_cidr
  name            = "12-public-modules"
  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs
  tags            = local.common_tags
}