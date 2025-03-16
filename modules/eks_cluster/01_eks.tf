# 기본 EKS 클러스터 리소스
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

data "aws_subnets" "pod_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.pod_subnet_name]
  }
}

data "aws_subnet" "pod_subnet_info" {
  for_each = toset(data.aws_subnets.pod_subnets.ids)
  id       = each.key
}


locals {
  azs = [for subnet in data.aws_subnet.pod_subnet_info : subnet.availability_zone]


  pod_subnet_ids = data.aws_subnets.pod_subnets.ids
  private_subnet_ids = data.aws_subnets.private_subnets.ids
  create_outposts_local_cluster    = length(var.outpost_config) > 0
  enable_cluster_encryption_config = var.create_kms_key && length(var.cluster_encryption_config) > 0 && !local.create_outposts_local_cluster
}


resource "aws_eks_cluster" "this" {
  count = var.create_cluster ? 1 : 0
  name  = var.cluster_name
  role_arn = aws_iam_role.cluster_rol[0].arn
  version  = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    security_group_ids = local.cluster_security_group_ids
    subnet_ids = data.aws_subnets.private_subnets.ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access = var.cluster_endpoint_public_access
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  dynamic "kubernetes_network_config" {
    # Not valid on Outposts
    for_each = local.create_outposts_local_cluster ? [] : [1]

    content {
      ip_family         = var.cluster_ip_family
      service_ipv4_cidr = var.cluster_service_ipv4_cidr
      service_ipv6_cidr = var.cluster_service_ipv6_cidr
    }
  }

  dynamic "outpost_config" {
    for_each = local.create_outposts_local_cluster ? [var.outpost_config] : []

    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      outpost_arns                = outpost_config.value.outpost_arns
    }
  }

  dynamic "encryption_config" {
    # Not available on Outposts
    for_each = local.enable_cluster_encryption_config ? [var.cluster_encryption_config] : []

    content {
      provider {
        key_arn = var.create_kms_key ? module.kms.key_arn : encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  tags = merge(
    var.tags,
    var.cluster_tags,
  )

  lifecycle {
    ignore_changes = [
      vpc_config,
    ]
  }

  timeouts {
    create = lookup(var.cluster_timeouts, "create", null)
    update = lookup(var.cluster_timeouts, "update", null)
    delete = lookup(var.cluster_timeouts, "delete", null)
  }

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}

################################################################################
# KMS Key
################################################################################

module "kms" {
  source = "./modules/terraform-aws-kms"

  create = var.create_cluster && var.create_kms_key && local.enable_cluster_encryption_config # not valid on Outposts

  description             = coalesce(var.kms_key_description, "${var.cluster_name} cluster encryption key")
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.enable_kms_key_rotation

  # Policy
  enable_default_policy     = var.kms_key_enable_default_policy
  key_owners                = var.kms_key_owners
  key_administrators        = coalescelist(var.kms_key_administrators, [data.aws_iam_session_context.current.issuer_arn])
  key_users                 = concat([local.cluster_role], var.kms_key_users)
  key_service_users         = var.kms_key_service_users
  source_policy_documents   = var.kms_key_source_policy_documents
  override_policy_documents = var.kms_key_override_policy_documents

  # Aliases
  aliases = var.kms_key_aliases
  computed_aliases = {
    # Computed since users can pass in computed values for cluster name such as random provider resources
    cluster = { name = "eks/${var.cluster_name}" }
  }
  tags = var.tags
}


################################################################################
# VPC-CNI Custom Networking ENIConfig
################################################################################
resource "kubectl_manifest" "eni_config" {
  for_each = { for k, v in data.aws_subnet.pod_subnet_info : v.availability_zone => v.id }

  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata = {
      name = each.key
    }
    spec = {
      securityGroups = [
        local.primary_cluster_sg_id,
        local.node_cluster_sg_id,
      ]
      subnet = each.value
    }
  })
}
