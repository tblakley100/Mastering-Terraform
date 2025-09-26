locals {
  users_from_yaml = yamldecode(file("${path.module}/user-roles.yaml")).users
  users_map = {
    for user_config in local.users_from_yaml : user_config.username => user_config.roles
  }
}

resource "aws_iam_user" "users" {
  for_each = toset(local.users_from_yaml[*].username)
  name     = each.value

  tags = {
    Project = "proj02-iam-users"
    Purpose = "User with role-based access via assumption"
  }
}

resource "aws_iam_user_login_profile" "users" {
  for_each                = aws_iam_user.users
  user                    = each.value.name
  password_length         = 16
  password_reset_required = true

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}

# Policy that allows users to assume only their assigned roles
resource "aws_iam_user_policy" "assume_role_policy" {
  for_each = local.users_map
  
  name = "${each.key}-assume-role-policy"
  user = aws_iam_user.users[each.key].name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [
          for role in each.value : 
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${role}"
        ]
        # Condition = {
        #   Bool = {
        #     "aws:MultiFactorAuthPresent" = "true"
        #   }
        # }
      }
    ]
  })
}

# Policy to allow users to manage their own credentials and MFA
resource "aws_iam_user_policy" "self_manage_credentials" {
  for_each = local.users_map
  
  name = "${each.key}-self-manage-credentials"
  user = aws_iam_user.users[each.key].name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfo"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:ListVirtualMFADevices",
          "iam:ListMFADevices"
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

output "passwords" {
  value = {
    for user, user_login in aws_iam_user_login_profile.users : user => user_login.password
  }
}

#Added by me

output "user_role_mappings" {
  description = "Shows which roles each user can assume"
  value = local.users_map
}

output "role_arns" {
  description = "ARNs of all created IAM roles"
  value = {
    for role_name, role in aws_iam_role.roles : role_name => role.arn
  }
}

output "switch_role_urls" {
  description = "Console URLs for users to switch to their assigned roles"
  value = {
    for username, roles in local.users_map : username => {
      for role in roles : role => "https://signin.aws.amazon.com/switchrole?account=${data.aws_caller_identity.current.account_id}&roleName=${role}&displayName=${username}-${role}"
    }
  }
}

output "aws_cli_assume_role_commands" {
  description = "AWS CLI commands for users to assume their roles (no MFA required for testing)"
  value = {
    for username, roles in local.users_map : username => {
      for role in roles : role => "aws sts assume-role --role-arn arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${role} --role-session-name ${username}-${role}-session"
    }
  }
}

output "user_login_info" {
  description = "Login information for users"
  value = {
    for username in keys(local.users_map) : username => {
      console_url = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
      username    = username
      note        = "Use 'terraform output passwords' to get initial password. Must change password and setup MFA on first login."
    }
  }
}
