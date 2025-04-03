output "eks_cluster_name" {
  value = var.cluster_name
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
