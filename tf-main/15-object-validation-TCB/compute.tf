locals {
  allowed_instance_types = ["t2.micro", "t3.micro"]
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

resource "aws_instance" "this" {
  count        = 4
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.this[count.index % length(aws_subnet.this)].id
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name       = format("Terraform-EC2-%02d", count.index + 1)
    CostCenter = "12345"
  }

  lifecycle {
    postcondition {
      condition     = contains(local.allowed_instance_types, self.instance_type)
      error_message = "Self invalid instance type: ${self.instance_type}. Allowed types are: ${join(", ", local.allowed_instance_types)}"
    }
    create_before_destroy = true
  }
}

check "cost_center_check" {
  assert {
    condition = alltrue([
      for instance in aws_instance.this : can(regex("^\\d{5}$", instance.tags.CostCenter))
    ])
    error_message = "All AWS Instance CostCenter tags must consist of exactly five digits."
  }
}