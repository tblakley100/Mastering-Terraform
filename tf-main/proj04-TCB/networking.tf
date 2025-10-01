##############################
# VPC & Subnets
##############################

data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "proj04-custom"
  }
}

resource "aws_subnet" "default" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.48.0/20"
    tags = {
        Name = "subnet-default"
    }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name   = "subnet-custom-vpc-private1"
    Access = "PRIVATE"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name   = "subnet-custom-vpc-private2"
    Access = "Private"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "subnet-custom-vpc-public1"
  }
}