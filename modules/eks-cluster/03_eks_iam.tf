################################################################################
# IAM Role
################################################################################
locals {
  eks_role_name = coalesce(var.cluster_iam_role_name, "${var.cluster_name}-role")
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  # Not available on outposts
  count = var.create_cluster && !local.create_outposts_local_cluster ? 1 : 0

  client_id_list  = distinct(compact(concat(["sts.${local.dns_suffix}"], var.openid_connect_audiences)))
  thumbprint_list = concat(data.tls_certificate.this[0].certificates[*].sha1_fingerprint, var.custom_oidc_thumbprints)
  url             = aws_eks_cluster.this[0].identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    var.iam_role_tags,
  )
}

module "eks_cluster_role" {
  source = "../iam"

  create                         = var.create_cluster_iam_role && var.create_cluster
  name                           = var.iam_role_use_name_prefix ? null : local.eks_role_name
  name_prefix                    = var.iam_role_use_name_prefix ? "${local.eks_role_name}-" : null

  assume_role_policy             = "eks_cluster"
  managed_policy_arns = concat(
    [
      "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
      "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    ],
    try("${local.iam_role_policy_prefix}/${var.cluster_managed_iam_role_additional_policies}", [])
  )

  # (선택) Custom Policy 처리를 위해 여전히 policy 맵을 넘겨줄 수 있습니다.
  policy = var.cluster_iam_role_additional_policies

  description           = try(var.iam_role_description, null)
  max_session_duration  = try(var.iam_role_max_session_duration, 3600)
  force_detach_policies = true
  permissions_boundary  = try(var.iam_role_permissions_boundary, null)

  tags = merge(
    var.tags,
    var.iam_role_tags
  )

}
