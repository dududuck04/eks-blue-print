resource "aws_iam_group" "group" {
  for_each = var.groups
  name     = each.key
}

resource "aws_iam_user_group_membership" "this" {
  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group
  ]

  for_each = var.users
  user     = each.key
  groups   = each.value.group
}

resource "aws_iam_group_policy_attachment" "this" {
  depends_on = [aws_iam_group.group]
  for_each   = { for at in local.flattened_attachments : "${at.group}.${at.policy_arn}" => at }
  group      = each.value.group
  policy_arn = each.value.policy_arn
}

//insert inline policy to group
resource "aws_iam_group_policy" "this" {
  depends_on = [aws_iam_group.group]
  for_each   = { for inline in local.flattened_inlines : "${inline.group}.${inline.inline_name}" => inline }
  group      = each.value.group
  name       = each.value.inline_name

  policy = templatefile("./policies/${each.value.inline_name}.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
}