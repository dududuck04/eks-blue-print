

# Cluster Name
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

# Cluster Endpoint
output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

# Configured Addon Roles ARN
# output "configured_addon_roles_arn" {
#   description = "The ARNs of the configured addon IAM roles"
#   value       = module.eks.configured_addon_roles_arn
# }

# Pod Subnet IDs
# output "pod_subnet_ids" {
#   description = "The IDs of the subnets used for pods"
#   value       = module.eks.pod_subnet_ids
# }

# # Cluster Security Group
# output "cluster_security_group_id" {
#   description = "The ID of the EKS cluster's primary security group"
#   value       = module.eks.cluster_security_group_id
# }
#
# # Node Security Group
# output "node_security_group_id" {
#   description = "The ID of the EKS node group security group"
#   value       = module.eks.node_security_group_id
# }
#
# # KMS Key ARN
# output "kms_key_arn" {
#   description = "The ARN of the KMS key used for cluster encryption"
#   value       = module.eks.kms_key_arn
# }
#
# # CloudWatch Log Group Name
# output "cloudwatch_log_group_name" {
#   description = "The name of the CloudWatch Log Group created for the cluster"
#   value       = module.eks.cloudwatch_log_group_name
# }
#
# # EKS Managed Node Groups
# output "managed_node_group_names" {
#   description = "The names of the EKS managed node groups"
#   value       = module.eks.managed_node_group_names
# }
#
# # Self-Managed Node Groups
# output "self_managed_node_group_names" {
#   description = "The names of the self-managed node groups"
#   value       = module.eks.self_managed_node_group_names
# }
#
# # Fargate Profiles
# output "fargate_profile_names" {
#   description = "The names of the Fargate profiles"
#   value       = module.eks.fargate_profile_names
# }
#
# # VPC ID
# output "vpc_id" {
#   description = "The ID of the VPC used by the EKS cluster"
#   value       = module.eks.vpc_id
# }
#
# # Private Subnet IDs
# output "private_subnet_ids" {
#   description = "The IDs of the private subnets used by the EKS cluster"
#   value       = module.eks.private_subnet_ids
# }
#
# # Public Subnet IDs
# output "public_subnet_ids" {
#   description = "The IDs of the public subnets used by the EKS cluster"
#   value       = module.eks.public_subnet_ids
# }
#
# # Addon Status
# output "addon_status" {
#   description = "The status of the EKS cluster addons"
#   value       = module.eks.addon_status
# }
