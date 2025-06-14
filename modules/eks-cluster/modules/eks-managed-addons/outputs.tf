output "aws_coredns" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_coredns[0], null)
}

output "aws_ebs_csi_driver" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_ebs_csi_driver[0], null)
}

output "aws_efs_csi_driver" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_efs_csi_driver[0], null)
}

output "aws_vpc_cni" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_vpc_cni[0], null)
}

output "aws_metrics_server" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_metrics_server[0], null)
}

output "aws_pod_identity_agent" {
  description = "Map of attributes of the Helm release and IRSA created"
  value       = try(module.aws_pod_identity_agent[0], null)
}
