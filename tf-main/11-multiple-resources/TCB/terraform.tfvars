# subnet_count = 2

ec2_instance_count = 0

# ec2_instance_config_list = [
#   {
#     instance_type = "t2.micro",
#     ami           = "ubuntu"
#   },
#   {
#     instance_type = "t2.micro",
#     ami           = "nginx"
#   }
# ]


#Exercise 32
ec2_instance_config_map = {

  nginx_1 = {
    instance_type = "t2.micro"
    ami           = "nginx"
  }
  ubuntu_1 = {
    instance_type = "t2.micro"
    ami           = "ubuntu"
  }
}

# Exercise 34

subnet_config = {
  "main" = {
    cidr_block = "10.0.0.0/24"
  }
}