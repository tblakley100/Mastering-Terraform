terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "tf-s3-backend-tcb"
    key    = "04-backends/state.tfstate"
    region = "us-east-2"

  }
}

provider "aws" {
  region = "us-east-2"
}
