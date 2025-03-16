resource "aws_kms_key" "this" {
  for_each = var.kms_key

  description = each.value.description
  key_usage   = each.value.key_usage

  customer_master_key_spec = try(each.value.customer_master_key_spec, "SYMMETRIC_DEFAULT")

  deletion_window_in_days = each.value.deletion_window_in_days
  # enable_key_rotation      = each.value.enable_key_rotation

  tags = {
    Name    = "kms-${var.env}-${var.pjt}",
    Service = "kms"
  }
}

resource "aws_kms_alias" "this" {
  for_each = var.kms_key

  name          = "alias/kms-${var.env}-${var.pjt}-${each.key}"
  target_key_id = aws_kms_key.this[each.key].id
}