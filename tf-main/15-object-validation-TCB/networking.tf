data "aws_vpc" "main" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  count             = 4
  vpc_id            = data.aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[
        count.index % length(data.aws_availability_zones.available.names)
      ]
  cidr_block        = "172.31.${128 + count.index}.0/24"
  tags = {
    Name = format("Terraform-Network-%02d", count.index + 1)
  }

  lifecycle {
    postcondition {
      condition     = contains(data.aws_availability_zones.available.names, self.availability_zone)
      error_message = "Invalid AZ"
    }
  }
}

check "high_availability_check" {
  assert {
    condition     = length(toset([for subnet in aws_subnet.this : subnet.availability_zone])) > 1
    error_message = <<-EOT
          You are deploying all subnets within the same AZ.
          Please consider distributing them across AZs for higher availability.
          EOT
  }
}
