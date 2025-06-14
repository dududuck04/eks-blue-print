resource "aws_iam_policy" "policy" {
  for_each = {for k, v in var.policy : k => v if var.create }

  name_prefix        = "${each.value.name}-"
  description        = each.value.description

  policy = templatefile(
    "${each.value.policy_path}.json.tpl",
    { account_id = data.aws_caller_identity.current.account_id }
  )
}

# locals {
#   create_iam_role_policy = local.create_iam_role && var.create_iam_role_policy && length(var.iam_role_policy_statements) > 0
# }

# resource "aws_iam_role_policy" "this" {
#   count = local.create_iam_role_policy ? 1 : 0
#
#   name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
#   name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
#   policy      = data.aws_iam_policy_document.role[0].json
#   role        = aws_iam_role.this[0].id
# }
