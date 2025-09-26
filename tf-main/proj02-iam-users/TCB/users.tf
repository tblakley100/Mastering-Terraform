# Load user-role mappings from YAML file (also used in roles.tf)
# Create a map of users with their roles for easier processing
locals {
  users = {
    for user in local.user_roles_data.users : user.username => {
      username = user.username
      roles    = user.roles
    }
  }
}

# Create IAM users
resource "aws_iam_user" "users" {
  for_each = local.users
  
  name = each.value.username
  path = "/"
  
  tags = {
    Project = "proj02-iam-users"
    Purpose = "User with role-based access"
  }
}

# Create login profiles for users (with console access and initial passwords)
resource "aws_iam_user_login_profile" "users" {
  for_each = local.users
  
  user                    = aws_iam_user.users[each.key].name
  password_reset_required = true
  password_length         = 16
  
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

# Note: Users no longer have inline policies to assume roles.
# Role assumption permissions are now controlled by the trust policies 
# of each role, which specify exactly which users can assume them.

# Policy to allow users to manage their own MFA devices
resource "aws_iam_user_policy" "self_manage_mfa" {
  for_each = local.users
  
  name = "${each.value.username}-self-manage-mfa"
  user = aws_iam_user.users[each.key].name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfo"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowManageOwnPasswords"
        Effect = "Allow"
        Action = [
          "iam:ChangePassword",
          "iam:GetUser"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "AllowManageOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = [
          "arn:aws:iam::*:mfa/$${aws:username}",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
      },
      {
        Sid    = "AllowDeactivateOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:DeactivateMFADevice"
        ]
        Resource = [
          "arn:aws:iam::*:mfa/$${aws:username}",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}