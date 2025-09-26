locals {
  role_policies = {
    readonly = [
      "ReadOnlyAccess"
    ]
    admin = [
      "AdministratorAccess"
    ]
    auditor = [
      "SecurityAudit"
    ]
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess",
      "AmazonS3FullAccess"
    ]
  }

  role_policies_list = flatten([
    for role, policies in local.role_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])
}

data "aws_caller_identity" "current" {}

# Trust policy for each role - only allows specific users to assume each role
data "aws_iam_policy_document" "assume_role_policy" {
  for_each = toset(keys(local.role_policies))

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)
      ]
    }

    # Require MFA for role assumption (comment out if you don't want MFA requirement for testing)
    # condition {
    #   test     = "Bool"
    #   variable = "aws:MultiFactorAuthPresent"
    #   values   = ["true"]
    # }
  }
}

resource "aws_iam_role" "roles" {
  for_each = toset(keys(local.role_policies))

  name                 = each.key
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy[each.value].json
  max_session_duration = 43200  # 12 hours (43200 seconds)

  tags = {
    Project = "proj02-iam-users"
    Purpose = "Role-based access via assumption"
    Role    = each.key
  }
}

data "aws_iam_policy" "managed_policies" {
  for_each = toset(local.role_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachments" {
  count = length(local.role_policies_list)
  role = aws_iam_role.roles[
    local.role_policies_list[count.index].role
  ].name
  policy_arn = data.aws_iam_policy.managed_policies[
    local.role_policies_list[count.index].policy
  ].arn
}