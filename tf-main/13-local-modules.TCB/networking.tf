module "vpc" {

  source = "./modules/networking"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules"
  }

  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-2a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-2b"
    }
    subnet_3 = {
      cidr_block = "10.0.128.0/24"
      az         = "us-east-2c"
      public     = true
    }
  }
}