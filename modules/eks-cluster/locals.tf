locals {

  vpc_id = data.aws_vpc.cluster.id
  dns_suffix                          = coalesce(var.cluster_iam_role_dns_suffix, data.aws_partition.current.dns_suffix)

  eks_oidc_issuer_url  = var.eks_oidc_provider != null ? var.eks_oidc_provider : replace(aws_eks_cluster.this[0].identity[0].oidc[0].issuer, "https://", "")
  eks_cluster_endpoint = var.eks_cluster_endpoint != null ? var.eks_cluster_endpoint : aws_eks_cluster.this[0].endpoint
  eks_cluster_version  = var.eks_cluster_version != null ? var.eks_cluster_version : aws_eks_cluster.this[0].version
  eks_cluster_cidr = var.cluster_ip_family == "ipv6" ? aws_eks_cluster.this[0].kubernetes_network_config[0].service_ipv6_cidr : aws_eks_cluster.this[0].kubernetes_network_config[0].service_ipv4_cidr
  cluster_auth_base64 = aws_eks_cluster.this[0].certificate_authority[0].data

  eks_context = {
    aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
    aws_caller_identity_arn        = data.aws_caller_identity.current.arn
    aws_eks_cluster_endpoint       = local.eks_cluster_endpoint
    aws_partition_id               = data.aws_partition.current.partition
    aws_region_name                = data.aws_region.current.name
    eks_cluster_version            = local.eks_cluster_version
    eks_cluster_id                 = aws_eks_cluster.this[0].id
    cluster_name                   = aws_eks_cluster.this[0].name
    eks_oidc_issuer_url            = local.eks_oidc_issuer_url
    eks_oidc_provider_arn          = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_issuer_url}"
    tags                           = var.tags
    irsa_iam_role_path             = var.irsa_iam_role_path
    irsa_iam_permissions_boundary  = var.irsa_iam_permissions_boundary

    cluster_security_group_id      = aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id
    pod_subnet_ids                 = data.aws_subnets.pod_subnets.ids
  }

  eks_node_group_context = {
    node_group_create           = length([ for ng in var.eks_managed_node_groups : ng if ng.create ]) > 0
    private_subnet_ids          = data.aws_subnets.private_subnets.ids

  }
}
