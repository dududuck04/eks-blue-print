output "endpoint_url" {
  description = "EKS cluster endpoint URL for Karpenter"
  value       = data.aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = data.aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = data.aws_eks_cluster.this.name
}
