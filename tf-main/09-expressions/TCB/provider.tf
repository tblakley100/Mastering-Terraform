terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-east-2"
}


provider "aws" {
  region = "us-west-2"
  alias  = "us-west"
}


resource "aws_s3_bucket" "us-east-2" {
  bucket = "some-random-bucket-name-in-us-east-2-aosdh354832dhfu"
}


resource "aws_s3_bucket" "us_east_1" {
  bucket   = "some-random-bucket-name-in-us-west-2-18736481364"
  provider = aws.us-west
}