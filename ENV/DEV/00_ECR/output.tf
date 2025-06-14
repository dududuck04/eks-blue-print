output "current_region" {
  value       = var.region
  description = "The AWS region being used, determined dynamically or from input."
}

output "oidc_provider_arns" {
  value       = [for idx, _ in local.selected_oidc_entities : aws_iam_openid_connect_provider.oidc_provider[idx].arn]
  description = "The ARNs of the OIDC providers being used by the selected entities."
}

output "oidc_role_arns" {
  value       = [for idx, _ in local.selected_oidc_entities : aws_iam_role.trusted_entity_role[idx].arn]
  description = "The ARNs of the IAM roles associated with the selected OIDC entities."
}

output "oidc_role_names" {
  value       = [for entity in local.selected_oidc_entities : entity.role_name]
  description = "The names of the IAM roles associated with the selected OIDC entities."
}

output "all_oidc_entities" {
  value       = local.oidc_provider_config
  description = "Details of all supported OIDC entities and their configurations."
}

output "selected_oidc_entities" {
  value       = var.authorized_oidc_entity
  description = "The OIDC entities being authorized (e.g., ['github'], ['github', 'gitlab'])."
}

output "ecr_repository_arns" {
  value       = { for repo_name, repo in aws_ecr_repository.ecr_repository : repo_name => repo.arn }
  description = "ARNs of the created ECR repositories."
}

output "ecr_repository_urls" {
  value       = { for repo_name, repo in aws_ecr_repository.ecr_repository : repo_name => repo.repository_url }
  description = "URLs of the created ECR repositories."
}
