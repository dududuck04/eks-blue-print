locals {
  existed = { for k, v in var.groups : k => try(v.existed_policy_arn, []) }
  inline  = { for k, v in var.groups : k => try(v.inline_policy_name, []) }

  attachments = try([
    for group_name, arns in local.existed : [
      for arn in arns : {
        group      = group_name
        policy_arn = arn
      }
    ]
  ], [])
  flattened_attachments = flatten(local.attachments)

  inlines = [
    for group_name, inline_names in local.inline : [
      for inline_name in inline_names : {
        group       = group_name
        inline_name = inline_name
      }
    ]
  ]
  flattened_inlines = flatten(local.inlines)

  user_group = try([
    for user, groups in var.users : [
      for group in groups : {
        user  = user
        group = group
      }
    ]
  ], [])
  user_group_list = flatten(local.user_group)
}