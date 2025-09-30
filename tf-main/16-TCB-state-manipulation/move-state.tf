locals {
  ec2_names = ["instance1", "instance2"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# moved {
#   from = aws_instance.new_list[0]
#   to   = aws_instance.new_list["instance1"]
# }

# moved {
#   from = aws_instance.new_list[1]
#   to   = aws_instance.new_list["instance2"]
# }

# resource "aws_instance" "new_list" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   for_each      = toset(local.ec2_names)
# }
