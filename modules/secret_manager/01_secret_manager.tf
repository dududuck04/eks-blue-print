
### GitHub SSH Key to AWS Secret Manager ###
### 향후 Terraform 공통 Module로 이관 필요 ###
resource "aws_secretsmanager_secret" "secret" {
  for_each = var.secret_manager_info

  name                    = each.value.secret_manager_name
  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
}


#resource "aws_secretsmanager_secret_version" "argocd" {
#  count         = local.create_argocd_admin_secret ? 1 : 0
#  secret_id     = aws_secretsmanager_secret.argocd[0].id
#  secret_string = random_password.argocd.result
#}

