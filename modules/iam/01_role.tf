resource "aws_iam_role" "this" {
  count                 = var.create ? 1 : 0

  name                  = var.name
  name_prefix           = var.name_prefix
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary

  # required
  assume_role_policy = templatefile("${path.module}/policies/${var.assume_role_policy}.json.tpl", { account_id = data.aws_caller_identity.current.account_id })

  tags = merge(
    { Name = var.name },
    try(var.tags, {})
 )
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.create ? length(var.managed_policy_arns) : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.managed_policy_arns[count.index]

  depends_on = [aws_iam_role.this]
}

resource "aws_iam_role_policy_attachment" "additional_custom" {
  for_each = var.create ? aws_iam_policy.policy : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value.arn

  depends_on = [aws_iam_role.this]
}