# output "role" {
#   value = { for k, v in var.roles : k => try(aws_iam_role.role[k], null) }
# }

output "user" {
  value = { for k, v in var.users : k => try(aws_iam_user.user[k], null) }
}

# output "group" {
#   value = { for k, v in var.groups : k => try(aws_iam_group.group[k], null) }
# }

# output "policy" {
#   value = { for k, v in var.policy : k => try(aws_iam_policy.policy[k], null) }
# }

output "aws_iam_user_login_profile" {
  # value = aws_iam_user_login_profile.this
  value = { for k, v in aws_iam_user_login_profile.this : k => v.password }
}

output "aws_iam_role_arn" {
  value = aws_iam_role.this[*].arn
}

output "aws_iam_role_name" {
  value = aws_iam_role.this[*].name
}

output "aws_iam_role_unique_id" {
  value = aws_iam_role.this[*].unique_id
}

# output "account_alias" {
#   value = aws_iam_account_alias.this
# }

output "password_policy" {
  value = aws_iam_account_password_policy.this
}