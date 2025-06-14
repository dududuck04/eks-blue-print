#================================================================================
# Outputs for EKS Cluster Module
#================================================================================

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this[0].name
}

output "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = aws_eks_cluster.this[0].endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this[0].certificate_authority[0].data
}

output "cluster_primary_security_group_id" {
  description = "ID of the cluster control-plane security group"
  value       = aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id
}

# Optional: expose KMS key outputs.tf if a KMS key is created alongside the cluster
output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt cluster data, if created"
  value       = try(module.kms.key_arn, null)
}

output "kms_key_id" {
  description = "ID of the KMS key, if created"
  value       = try(module.kms.key_id, null)
}
