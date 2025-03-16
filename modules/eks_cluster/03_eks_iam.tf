################################################################################
# IAM Role
################################################################################

locals {

  create_cluster_iam_role             = var.create_cluster && var.create_cluster_iam_role
  cluster_role                        = try(aws_iam_role.cluster_rol[0].arn, var.iam_role_arn)
  cluster_role_name                   = coalesce(var.cluster_iam_role_name, "${var.cluster_name}-rol")
  cluster_role_policy_prefix          = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  cluster_encryption_policy_name      = coalesce(var.cluster_encryption_policy_name, "${local.cluster_role_name}-ClusterEncryption")
  dns_suffix                          = coalesce(var.cluster_iam_role_dns_suffix, data.aws_partition.current.dns_suffix)

  managed_addon_roles_arn = {
    for k in keys(aws_iam_role.addon_roles) :
    k => aws_iam_role.addon_roles[k].arn
  }
}

################################################################################
# EKS IPV6 CNI Policy
# https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html#cni-iam-role-create-ipv6-policy
################################################################################

data "aws_iam_policy_document" "cni_ipv6_policy" {
  count = var.create_cluster && var.create_cni_ipv6_iam_policy ? 1 : 0

  statement {
    sid = "AssignDescribe"
    actions = [
      "ec2:AssignIpv6Addresses",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "CreateTags"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:${data.aws_partition.current.partition}:ec2:*:*:network-interface/*"]
  }
}

data "aws_iam_policy_document" "assume_trust_policy" {
  count = local.create_cluster_iam_role ? 1 : 0

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }

    dynamic "principals" {
      for_each = local.create_outposts_local_cluster ? [1] : []

      content {
        type = "Service"
        identifiers = [
          "ec2.${local.dns_suffix}",
        ]
      }
    }
  }
}


data "aws_iam_policy_document" "service_account_assume_trust_policy" {
  for_each = { for k, v in local.configured_addons : k => v if v.install && contains(keys(v), "service_account_name") }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider[0].url, "https://", "")}:sub"
      values   = [
        format("system:serviceaccount:kube-system:%s", each.value.service_account_name)
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider[0].url, "https://", "")}:aud"
      values   = ["sts.${local.dns_suffix}"]
    }
  }
}



resource "aws_iam_role" "cluster_rol" {
  count = local.create_cluster_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.cluster_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.cluster_role_name}${var.prefix_separator}" : null
  # path        = var.iam_role_path
  # description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_trust_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(
    var.tags,
    var.iam_role_tags,
  )

  dynamic "inline_policy" {
    for_each = var.create_cloudwatch_log_group ? [1] : []
    content {
      name = local.cluster_role_name

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action   = ["logs:CreateLogGroup"]
            Effect   = "Deny"
            Resource = "*"
          },
        ]
      })
    }
  }
}

# Policies attached ref https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in {
    AmazonEKSClusterPolicy         = local.create_outposts_local_cluster ? "${local.cluster_role_policy_prefix}/AmazonEKSLocalOutpostClusterPolicy" : "${local.cluster_role_policy_prefix}/AmazonEKSClusterPolicy",
    AmazonEKSVPCResourceController = "${local.cluster_role_policy_prefix}/AmazonEKSVPCResourceController",
  } : k => v if local.create_cluster_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster_rol[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.cluster_iam_role_additional_policies : k => v if local.create_cluster_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster_rol[0].name
}

# Using separate attachment due to `The "for_each" value depends on resource attributes that cannot be determined until apply`
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  # Encryption config not available on Outposts
  count = local.create_cluster_iam_role && var.attach_cluster_encryption_policy && local.enable_cluster_encryption_config ? 1 : 0

  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.cluster_rol[0].name
}

resource "aws_iam_policy" "cluster_encryption" {
  # Encryption config not available on Outposts
  count = local.create_cluster_iam_role && var.attach_cluster_encryption_policy && local.enable_cluster_encryption_config ? 1 : 0

  name        = var.cluster_encryption_policy_use_name_prefix ? null : local.cluster_encryption_policy_name
  name_prefix = var.cluster_encryption_policy_use_name_prefix ? local.cluster_encryption_policy_name : null

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = var.create_kms_key ? module.kms.key_arn : var.cluster_encryption_config.provider_key_arn
      },
    ]
  })

  tags = merge(
    var.tags,
    var.cluster_policy_tags,
  )

}


################################################################################
# IRSA
# Note - this is different from EKS identity provider
################################################################################

data "tls_certificate" "this" {
  # Not available on outposts
  count = var.enable_irsa && !local.create_outposts_local_cluster ? 1 : 0

  url = aws_eks_cluster.this[0].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  # Not available on outposts
  count = var.enable_irsa && !local.create_outposts_local_cluster ? 1 : 0

  client_id_list  = distinct(compact(concat(["sts.${local.dns_suffix}"], var.openid_connect_audiences)))
  thumbprint_list = concat(data.tls_certificate.this[0].certificates[*].sha1_fingerprint, var.custom_oidc_thumbprints)
  url             = aws_eks_cluster.this[0].identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    var.iam_role_tags,
  )
}

# Create the IAM role
resource "aws_iam_role" "addon_roles" {
  for_each = { for k, v in local.configured_addons : k => v if v.install && contains(keys(v), "service_account_name") }

  name               = "${each.key}-rol"
  assume_role_policy = data.aws_iam_policy_document.service_account_assume_trust_policy[each.key].json

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "vpc_cni_policy" {
  count      = contains(keys(local.managed_addon_roles_arn), "vpc-cni") ? 1 : 0
  role       = aws_iam_role.addon_roles["vpc-cni"].name
  policy_arn = "${local.cluster_role_policy_prefix}/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  count      = contains(keys(local.managed_addon_roles_arn), "aws-ebs-csi-driver") ? 1 : 0
  role       = aws_iam_role.addon_roles["aws-ebs-csi-driver"].name
  policy_arn = "${local.cluster_role_policy_prefix}/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "efs_csi_policy" {
  count      = contains(keys(local.managed_addon_roles_arn), "aws-efs-csi-driver") ? 1 : 0
  role       = aws_iam_role.addon_roles["aws-efs-csi-driver"].name
  policy_arn = "${local.cluster_role_policy_prefix}/service-role/AmazonEFSCSIDriverPolicy"
}

# Note - we are keeping this to a minimum in hopes that its soon replaced with an AWS managed policy like `AmazonEKS_CNI_Policy`
resource "aws_iam_policy" "cni_ipv6_policy" {
  count = var.create_cluster && var.create_cni_ipv6_iam_policy ? 1 : 0

  # Will cause conflicts if trying to create on multiple clusters but necessary to reference by exact name in sub-modules
  name        = "AmazonEKS_CNI_IPv6_Policy"
  description = "IAM policy for EKS CNI to assign IPV6 addresses"
  policy      = data.aws_iam_policy_document.cni_ipv6_policy[0].json

  tags = var.tags
}
