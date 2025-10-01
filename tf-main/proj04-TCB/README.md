# RDS PostgreSQL Database Module (proj04-TCB)

This Terraform project creates a PostgreSQL RDS database instance using a custom local module. The project includes networking infrastructure with a custom VPC and subnets, and deploys a PostgreSQL database with proper security configurations.

## Overview

This project demonstrates the use of local Terraform modules to create reusable infrastructure components. It includes:

- Custom VPC with public and private subnets
- Default VPC reference for comparison
- RDS PostgreSQL instance deployed in private subnets
- Input validation for security best practices
- Subnet and security group validation to ensure proper deployment

## Architecture

The project creates the following infrastructure:

1. **Custom VPC** (10.0.0.0/16)
   - Private subnet 1: 10.0.0.0/24 (us-east-2a)
   - Private subnet 2: 10.0.1.0/24 (us-east-2b) 
   - Public subnet: 10.0.2.0/24

2. **Default VPC Reference**
   - Additional subnet in default VPC (172.31.48.0/20)

3. **RDS PostgreSQL Database**
   - Deployed in private subnet(s)
   - Free-tier instance class (db.t3.micro)
   - 5-10GB storage allocation
   - PostgreSQL engine (latest or version 14)

## Requirements

### Terraform Version
- Terraform ~> 1.7

### Provider Requirements
- AWS Provider ~> 5.0

### AWS Requirements
- Valid AWS credentials configured
- Access to create VPC, subnet, and RDS resources
- Free-tier eligible AWS account (for db.t3.micro instances)

### Regional Requirements
- This configuration is set to deploy in `us-east-2` region
- Availability zones used: `us-east-2a`, `us-east-2b`

## Module Structure

```
proj04-TCB/
├── README.md
├── provider.tf          # Terraform and AWS provider configuration
├── networking.tf        # VPC and subnet resources
├── rds.tf              # RDS module instantiation
├── outputs.tf          # Output definitions (currently empty)
└── modules/
    └── rds/
        ├── provider.tf              # Module provider requirements
        ├── variables.tf             # Input variable definitions
        ├── rds.tf                  # RDS resource definitions (implementation pending)
        ├── outputs.tf              # Module outputs (implementation pending)
        └── networking-validation.tf # Subnet and security group validation
```

## Module Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `credentials` | `object({username = string, password = string})` | Database administrator credentials |
| `project_name` | `string` | Project name for resource naming and tagging |
| `subnet_ids` | `list(string)` | List of subnet IDs for RDS deployment |
| `security_group_ids` | `list(string)` | List of security group IDs for RDS instance |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `instance_class` | `string` | `"db.t3.micro"` | RDS instance class (free-tier only) |
| `storage_size` | `number` | `10` | Storage allocation in GB (5-10 GB) |
| `engine` | `string` | `"postgres-latest"` | Database engine version |

## Input Validation

The module includes comprehensive input validation:

### Password Requirements
- Minimum 8 characters (validation shows 15, but code enforces 8)
- At least 1 uppercase letter
- At least 1 lowercase letter  
- At least 1 digit
- At least 1 special character from: `! # $ % & * + - . : ; < = > ? [ ] ^ _ { | } ~ ( ) , '`
- Must NOT contain: `@ / " \ (space)`

### Instance Class Validation
- Only `db.t3.micro` is allowed (free-tier restriction)

### Storage Size Validation
- Must be between 5GB and 10GB

### Engine Validation
- Only `postgres-latest` or `postgres-14` are supported

### Subnet Validation
- Subnets must NOT be in the default VPC
- Subnets must be tagged with `Access = "private"`

## Usage Examples

### Basic Usage

```hcl
module "database" {
  source = "./modules/rds"

  credentials = {
    username = "db-admin"
    password = "YourSecureP@ssw0rd123!"
  }
  project_name       = "my-project"
  subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  security_group_ids = [aws_security_group.rds.id]
}
```

### Complete Example with Networking

```hcl
# VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  
  tags = {
    Name   = "private-subnet-1"
    Access = "private"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  
  tags = {
    Name   = "private-subnet-2"
    Access = "private"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "rds-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Module
module "database" {
  source = "./modules/rds"

  credentials = {
    username = "db-admin"
    password = "1a2bC3!45$&MySecurePassword"
  }
  project_name       = "my-application"
  subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  security_group_ids = [aws_security_group.rds.id]
  
  # Optional parameters
  instance_class = "db.t3.micro"
  storage_size   = 10
  engine         = "postgres-latest"
}
```

## Deployment Instructions

1. **Prerequisites**
   ```bash
   # Ensure AWS credentials are configured
   aws configure list
   
   # Verify Terraform installation
   terraform version
   ```

2. **Initialize Terraform**
   ```bash
   cd /path/to/proj04-TCB
   terraform init
   ```

3. **Plan the deployment**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Clean up resources**
   ```bash
   terraform destroy
   ```

## Security Considerations

- Database is deployed in private subnets only
- Default VPC deployment is prevented through validation
- Password complexity requirements are enforced
- Security group validation ensures proper network isolation
- Credentials are marked as sensitive in variables

## Limitations

- Only supports PostgreSQL engine
- Restricted to free-tier instance classes
- Storage limited to 5-10GB
- Hardcoded to us-east-2 region
- RDS module implementation appears incomplete (rds.tf and outputs.tf are empty)

## Development Status

⚠️ **Note**: This module appears to be in development. The RDS module's `rds.tf` and `outputs.tf` files are currently empty and need implementation to create the actual RDS resources.

## Contributing

When contributing to this module:

1. Ensure all validation rules are met
2. Test with free-tier resources only
3. Update documentation for any new variables or features
4. Follow Terraform best practices for module development

## License

This project is part of the Mastering Terraform course materials.