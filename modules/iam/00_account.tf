# resource "aws_iam_account_alias" "this" {
#   account_alias = var.account_alias
# }

resource "aws_iam_account_password_policy" "this" {
  max_password_age               = var.password_policy.max_password_age
  minimum_password_length        = var.password_policy.minimum_password_length
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  hard_expiry                    = var.password_policy.hard_expiry
  password_reuse_prevention      = var.password_policy.password_reuse_prevention
  require_lowercase_characters   = var.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.password_policy.require_uppercase_characters
  require_numbers                = var.password_policy.require_numbers
  require_symbols                = var.password_policy.require_symbols
}