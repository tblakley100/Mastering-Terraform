terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Common tags used across resources in this folder
locals {
  common_tags = {
    ManagedBy = "Terraform"
    Project   = "06-resources"
    Owner     = "TCB"
    Env       = "Lab"
  }
}
