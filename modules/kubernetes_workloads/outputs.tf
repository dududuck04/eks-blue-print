
output "app_of_apps_values" {
  description = "Argocd Application Chart Values"
  value       = yamlencode(local.app_values)
}

output "repo_list" {
  description = "Argocd Application Chart Values"
  value       = local.repo_list
}