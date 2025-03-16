resource "aws_iam_policy" "policy" {
  for_each    = var.policy
  name        = each.key
  description = each.value.description

  policy = templatefile("./policies/${each.key}.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
}
