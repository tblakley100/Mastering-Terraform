variable "ami_id" {
  description = "Bitnami NGINX AMI id to use (us-east-2)."
  type        = string
  default     = "ami-0485d0e4a4e8f225d"
}



resource "aws_security_group" "nginx_sg" {
  name        = "tcb-nginx-sg"
  description = "Allow HTTP and HTTPS from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "tcb-nginx-sg" })
}

resource "aws_instance" "web-nginx" {
  #This configuration requires a Bitnami NGINX AMI. If the data lookup returns no results Terraform will fail —
  #ensure a Bitnami NGINX AMI exists in the region or supply the correct AMI via other means before applying.
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

  tags = merge(local.common_tags, {
    Name = "tcb-nginx-instance-01"
  })
  lifecycle {
    create_before_destroy = true
    #ignore_changes = [ tags ]
  }
}
