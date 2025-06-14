data "aws_caller_identity"    "current" {}
data "aws_partition"          "current" {}

# data "aws_iam_policy_document" "policy_assume_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "AWS"
#       identifiers = []
#     }

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# data "aws_iam_policy_document" "role" {
#   count = local.create_iam_role_policy ? 1 : 0
#
#   dynamic "statement" {
#     for_each = var.iam_role_policy_statements
#
#     content {
#       sid           = try(statement.value.sid, null)
#       actions       = try(statement.value.actions, null)
#       not_actions   = try(statement.value.not_actions, null)
#       effect        = try(statement.value.effect, null)
#       resources     = try(statement.value.resources, null)
#       not_resources = try(statement.value.not_resources, null)
#
#       dynamic "principals" {
#         for_each = try(statement.value.principals, [])
#
#         content {
#           type        = principals.value.type
#           identifiers = principals.value.identifiers
#         }
#       }
#
#       dynamic "not_principals" {
#         for_each = try(statement.value.not_principals, [])
#
#         content {
#           type        = not_principals.value.type
#           identifiers = not_principals.value.identifiers
#         }
#       }
#
#       dynamic "condition" {
#         for_each = try(statement.value.conditions, [])
#
#         content {
#           test     = condition.value.test
#           values   = condition.value.values
#           variable = condition.value.variable
#         }
#       }
#     }
#   }
# }
