# Output the ARNs of all created roles
output "readonly_role_arn" {
  description = "ARN of the ReadOnly role"
  value       = aws_iam_role.readonly.arn
}

output "admin_role_arn" {
  description = "ARN of the Admin role"
  value       = aws_iam_role.admin.arn
}

output "auditor_role_arn" {
  description = "ARN of the Auditor role"
  value       = aws_iam_role.auditor.arn
}

output "developer_role_arn" {
  description = "ARN of the Developer role"
  value       = aws_iam_role.developer.arn
}

# Output role names for easy reference
output "role_names" {
  description = "Names of all created IAM roles"
  value = {
    readonly  = aws_iam_role.readonly.name
    admin     = aws_iam_role.admin.name
    auditor   = aws_iam_role.auditor.name
    developer = aws_iam_role.developer.name
  }
}

# Output assume role commands for easy use
output "assume_role_commands" {
  description = "AWS CLI commands to assume each role"
  value = {
    readonly  = "aws sts assume-role --role-arn ${aws_iam_role.readonly.arn} --role-session-name readonly-session"
    admin     = "aws sts assume-role --role-arn ${aws_iam_role.admin.arn} --role-session-name admin-session"
    auditor   = "aws sts assume-role --role-arn ${aws_iam_role.auditor.arn} --role-session-name auditor-session"
    developer = "aws sts assume-role --role-arn ${aws_iam_role.developer.arn} --role-session-name developer-session"
  }
}

# Output user information
output "user_passwords" {
  description = "Initial passwords for created users (will need to be changed on first login)"
  sensitive   = true
  value = {
    for username, user in aws_iam_user_login_profile.users : 
    username => user.password
  }
}

output "user_arns" {
  description = "ARNs of all created IAM users"
  value = {
    for username, user in aws_iam_user.users : 
    username => user.arn
  }
}

output "user_role_mappings" {
  description = "Shows which roles each user can assume"
  value = {
    for username, user_data in local.users : 
    username => user_data.roles
  }
}

output "user_console_login_instructions" {
  description = "Instructions for users to log into AWS console"
  value = {
    for username in keys(local.users) : 
    username => "Username: ${username} | Password: (check user_passwords output) | Console URL: https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console | Note: You must change password and setup MFA on first login"
  }
}

output "user_assume_role_examples" {
  description = "Example commands for each user to assume their assigned roles"
  value = {
    for username, user_data in local.users : 
    username => [
      for role in user_data.roles : 
      "aws sts assume-role --role-arn arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${role} --role-session-name ${username}-${role}-session"
    ]
  }
}