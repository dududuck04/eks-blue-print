data "aws_eks_addon_version" "this" {
  for_each = { for k, v in local.aws_managed_addons_default : k => v if v.install }
  addon_name            = each.key
  most_recent           = true
  kubernetes_version    = coalesce(var.cluster_version, aws_eks_cluster.this[0].version)
}

locals {
  efs_id = var.efs_id

  aws_managed_addons_default = {
    "vpc-cni" = {
      install              = true
      before_compute       = true
      service_account_name = "aws-node"
      role_type            = "service_account"
      configuration_values = {
        env = {
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
          AWS_VPC_K8S_CNI_LOGLEVEL           = "DEBUG"
          AWS_VPC_K8S_CNI_EXTERNALSNAT       = "false"
          ENABLE_PREFIX_DELEGATION           = "true"
          WARM_PREFIX_TARGET                 = "1"
          WARM_ENI_TARGET                    = "2"
          WARM_IP_TARGET                     = "5"
        }
      }
    },
    "kube-proxy" = {
      install        = true
      before_compute = true
      role_type            = "service_account"
      configuration_values = {}
    },
    "coredns" = {
      install        = true
      before_compute = false
      role_type            = "service_account"
      configuration_values = {
        replicaCount = 2
      }
    },
    "aws-ebs-csi-driver" = {
      install              = true
      before_compute       = false
      service_account_name = "ebs-csi-controller-sa"
      role_type            = "service_account"
      configuration_values = {}
    },
    "aws-efs-csi-driver" = {
      install              = true
      before_compute       = false
      service_account_name = "efs-csi-controller-sa"
      role_type            = "service_account"
      configuration_values = {}
    },
    "eks-pod-identity-agent" = {
      install              = true
      before_compute       = false
      role_type            = "pod_identity"
      configuration_values = {}
    }

  }
  aws_managed_addons_common = {
    preserve                 = true
    resolve_conflicts        = "OVERWRITE"
    service_account_role_arn = null
    configuration_values = {
      resources = {
        limits = {
          cpu    = "100m"
          memory = "150Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }
    }
    timeouts = {
      create = "10m"
      update = "10m"
      delete = "10m"
    }
  }

  local_addons_merged = {
    for k, v in local.aws_managed_addons_default : k => merge(
      {
        configuration_values = merge(
          local.aws_managed_addons_common.configuration_values,
          v.configuration_values
        )
      },
      local.aws_managed_addons_common,
      v
    )
  }

  merged_configuration_addons = {
    for k, v in merge(local.local_addons_merged, var.cluster_addons) : k => {
      configuration_values = merge(
        local.local_addons_merged[k].configuration_values,
        try(var.cluster_addons[k].configuration_values, {})
      )
    }
  }

}

resource "aws_eks_addon" "this" {
  for_each = { for addon_name, addon_config in local.local_addons_merged : addon_name => addon_config if try(var.cluster_addons[addon_name].install, addon_config.install) && !addon_config.before_compute && !local.create_outposts_local_cluster }

  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = each.key

  addon_version               = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  configuration_values        = jsonencode(try(local.merged_configuration_addons[each.key].configuration_values, each.value.configuration_values))
  preserve                    = try(var.cluster_addons.preserve, each.value.preserve)
  resolve_conflicts_on_create = try(var.cluster_addons.resolve_conflicts, each.value.resolve_conflicts)
  service_account_role_arn    = try(var.cluster_addons[each.key].role_type, each.value.role_type, "service_account") == "service_account" ? lookup(local.configured_addon_roles_arn, each.key, null) : null

  # CSI Storage Driver용 Addon 에서는 사용하면 안됨 (지원하지 않음)
  # https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/pod-identities.html#pod-id-considerations

  dynamic "pod_identity_association" {
    for_each = (try(var.cluster_addons[each.key].role_type, each.value.role_type) == "pod_identity" && lookup(each.value, "service_account_name", null) != null) ? [1] : []

    content {
      role_arn        = lookup(local.configured_addon_roles_arn, each.key, null)
      service_account = lookup(each.value, "service_account_name", null)
    }
  }

  depends_on = [
    #   module.fargate_profile,
    module.eks_managed_node_group,
    #   module.self_managed_node_group,
    aws_iam_role.addon_roles
  ]

  lifecycle {
    ignore_changes = [
      addon_version
    ]
  }

  tags = var.tags
}

resource "aws_eks_addon" "before_compute" {
  for_each = { for addon_name, addon_config in local.local_addons_merged : addon_name => addon_config if try(var.cluster_addons[addon_name].install, addon_config.install ) && addon_config.before_compute && !local.create_outposts_local_cluster }

  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = each.key

  addon_version               = coalesce(try(each.value.addon_version, null), data.aws_eks_addon_version.this[each.key].version)
  configuration_values        = jsonencode(try(local.merged_configuration_addons[each.key].configuration_values, each.value.configuration_values))
  preserve                    = try(var.cluster_addons.preserve, each.value.preserve)
  resolve_conflicts_on_create = try(var.cluster_addons.resolve_conflicts, each.value.resolve_conflicts)
  service_account_role_arn    = try(var.cluster_addons[each.key].role_type, each.value.role_type, "service_account") == "service_account" ? lookup(local.configured_addon_roles_arn, each.key, null) : null

  # CSI Storage Driver용 Addon 에서는 사용하면 안됨 (지원하지 않음)
  # https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/pod-identities.html#pod-id-considerations
  dynamic "pod_identity_association" {
    for_each = try(var.cluster_addons[each.key].role_type, each.value.role_type) == "pod_identity" ? [1] : []
    content {
      role_arn        = lookup(local.configured_addon_roles_arn, each.key, null)
      service_account = each.value.service_account_name
    }
  }

  depends_on = [
    kubectl_manifest.eni_config,
  ]

  tags = var.tags
}

resource "kubernetes_storage_class" "efs_storage_class" {
  count = (try(var.cluster_addons["aws-efs-csi-driver"].install, local.aws_managed_addons_default["aws-efs-csi-driver"].install) ? 1 : 0)

  metadata {
    name = "default-efs"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    "provisioningMode" = "efs-ap"
    "directoryPerms"   = "700"
    "fileSystemId"     = var.efs_id
  }
  allow_volume_expansion = true
  volume_binding_mode    = "Immediate"

  mount_options = ["iam"]

  depends_on = [
    aws_eks_addon.this["aws-efs-csi-driver"]
  ]
}

# Add new default storage class - GP3 EBS
resource "kubernetes_storage_class" "gp3" {
  count = (try(var.cluster_addons["aws-ebs-csi-driver"].install, local.aws_managed_addons_default["aws-ebs-csi-driver"].install) ? 1 : 0)

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
    # "encrypted"                 = local.enable_ebs_encryption ? "'true'" : null
    # "kmsKeyId"                  = local.enable_ebs_encryption ? "${local.kmsKeyId}" : null
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.this["aws-ebs-csi-driver"]
  ]
}

# resource "kubernetes_service_account" "addon" {
#   for_each = { for k, v in local.configured_addons : k => v if v.install && contains(keys(v), "service_account_name") }
#
#   metadata {
#     name      = each.value.service_account_name
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = local.managed_addon_roles_arn[each.key]
#     }
#   }
#
#   lifecycle {
#     ignore_changes = [
#       metadata["annotations"]
#     ]
#   }
# }


