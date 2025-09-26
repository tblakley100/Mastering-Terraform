# Load user-role mappings from YAML file for trust policies
locals {
  user_roles_data = yamldecode(file("${path.module}/user-roles.yaml"))
  
  # Create role-to-users mapping for trust policies
  role_users = {
    for role in ["readonly", "admin", "auditor", "developer"] : role => [
      for user in local.user_roles_data.users : user.username
      if contains(user.roles, role)
    ]
  }
}

# IAM Role Trust Policy Documents - specific to each role
data "aws_iam_policy_document" "readonly_assume_role_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type = "AWS"
      identifiers = [
        for username in local.role_users.readonly :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
      ]
    }
    
    actions = ["sts:AssumeRole"]
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "admin_assume_role_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type = "AWS"
      identifiers = [
        for username in local.role_users.admin :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
      ]
    }
    
    actions = ["sts:AssumeRole"]
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "auditor_assume_role_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type = "AWS"
      identifiers = [
        for username in local.role_users.auditor :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
      ]
    }
    
    actions = ["sts:AssumeRole"]
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "developer_assume_role_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type = "AWS"
      identifiers = [
        for username in local.role_users.developer :
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
      ]
    }
    
    actions = ["sts:AssumeRole"]
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# ReadOnly Role - Provides read-only access to AWS resources
resource "aws_iam_role" "readonly" {
  name               = "readonly"
  description        = "Role with read-only access to AWS resources"
  assume_role_policy = data.aws_iam_policy_document.readonly_assume_role_policy.json

  tags = {
    Purpose = "ReadOnlyAccess"
    Project = "proj02-iam-users"
  }
}

# Attach ReadOnlyAccess managed policy to readonly role
resource "aws_iam_role_policy_attachment" "readonly_policy" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Admin Role - Provides full administrative access
resource "aws_iam_role" "admin" {
  name               = "admin"
  description        = "Role with full administrative access to AWS resources"
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role_policy.json

  tags = {
    Purpose = "AdministratorAccess"
    Project = "proj02-iam-users"
  }
}

# Attach AdministratorAccess managed policy to admin role
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Auditor Role - Provides security audit access
resource "aws_iam_role" "auditor" {
  name               = "auditor"
  description        = "Role with security audit access to AWS resources"
  assume_role_policy = data.aws_iam_policy_document.auditor_assume_role_policy.json

  tags = {
    Purpose = "SecurityAudit"
    Project = "proj02-iam-users"
  }
}

# Attach SecurityAudit managed policy to auditor role
resource "aws_iam_role_policy_attachment" "auditor_policy" {
  role       = aws_iam_role.auditor.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Developer Role - Provides development-focused access to VPC, EC2, and RDS
resource "aws_iam_role" "developer" {
  name               = "developer"
  description        = "Role with development access to VPC, EC2, and RDS services"
  assume_role_policy = data.aws_iam_policy_document.developer_assume_role_policy.json

  tags = {
    Purpose = "DeveloperAccess"
    Project = "proj02-iam-users"
  }
}

# Attach VPC Full Access managed policy to developer role
resource "aws_iam_role_policy_attachment" "developer_vpc_policy" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# Attach EC2 Full Access managed policy to developer role
resource "aws_iam_role_policy_attachment" "developer_ec2_policy" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Attach RDS Full Access managed policy to developer role
resource "aws_iam_role_policy_attachment" "developer_rds_policy" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
