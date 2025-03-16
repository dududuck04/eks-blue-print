resource "aws_iam_role" "role" {
  depends_on = [
    aws_iam_policy.policy,
    aws_iam_group.group
  ]

  for_each = var.roles

  name                  = each.value.name
  path                  = try(each.value.path, "/")
  description           = try(each.value.description, null)
  max_session_duration  = try(each.value.max_session_duration, 3600)
  force_detach_policies = try(each.value.force_detach_policies, false)
  permissions_boundary  = try(each.value.permissions_boundary, null)

  # required
  assume_role_policy = templatefile("./policies/${each.value.assume_role_policy}.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })

  managed_policy_arns = try(["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${each.value.managed_policy_arns}"], null)

  tags = merge({
    Name = try("role-${var.env}-${var.pjt}-${each.value.name}", null)
  }, try(each.value.tags, null))
}