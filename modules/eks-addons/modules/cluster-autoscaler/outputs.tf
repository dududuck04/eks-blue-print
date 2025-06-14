output "eks_cluster_name" {
  value = local.cluster_name
}

output "endpoint_url" {
  description = "EKS Cluster Endpoint"
  value       = local.endpoint_url
}

output "auth_token" {
  description = "EKS Cluster Auth Token"
  value       = local.auth_token
}

output "certificate_authority_data" {
  description = "EKS Cluster Auth Data ( Base64 Encoded Certificate Data )"
  value       = local.certificate_authority_data
}

output "irsa_iam_role_name" {
  description = "IRSA IAM Role Name for Clsuter-Autoscaler"
  value       = module.cluster_autoscaler.irsa_iam_role_name
}

output "irsa_iam_role_arn" {
  description = "IRSA IAM Role ARN for Clsuter-Autoscaler"
  value       = module.cluster_autoscaler.irsa_iam_role_arn
}

output "irsa_iam_policy_name" {
  description = "IRSA IAM Policy Name for Clsuter-Autoscaler"
	value       = module.cluster_autoscaler.irsa_iam_policy_name
}

output "helm_chart_name" {
  value = var.helm_chart.name
}

output "helm_chart_version" {
  value = var.helm_chart.version
} 
