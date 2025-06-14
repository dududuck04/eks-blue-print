resource "aws_iam_user" "user" {
  for_each = var.users

  name          = each.key
  force_destroy = true

  tags = {
    Name = try("${each.key}", null)
  }
}

resource "aws_iam_user_login_profile" "this" {
  depends_on = [aws_iam_user.user]

  for_each = { for k, v in var.users : k => v if v.isConsoleUser }

  user = each.key

  password_reset_required = true

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}