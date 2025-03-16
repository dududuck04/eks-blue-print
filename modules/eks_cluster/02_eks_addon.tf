data "aws_eks_addon_version" "this" {
  for_each = { for k, v in local.aws_managed_addons : k => v if v.install }
  addon_name            = each.key
  most_recent           = true
  kubernetes_version    = coalesce(var.cluster_version, aws_eks_cluster.this[0].version)
}

locals {
  efs_id = var.efs_id

  aws_managed_addons = {
    "vpc-cni" = {
      install              = true
      before_compute       = true
      service_account_name = "aws-node"
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
      install              = true
      before_compute       = true
      configuration_values = {}
    },
    "coredns" = {
      install              = true
      before_compute       = true
      configuration_values = {
        replicaCount = 2
      }
    },
    "aws-ebs-csi-driver" = {
      install              = true
      before_compute       = false
      service_account_name = "ebs-csi-controller-sa"
      configuration_values = {}
    },
    "aws-efs-csi-driver" = {
      install              = true
      before_compute       = false
      service_account_name = "efs-csi-controller-sa"
      configuration_values = {}
    }
  }

  default_common_addon_config = {
    preserve                    = true
    resolve_conflicts           = "OVERWRITE"
    service_account_role_arn    = null
    configuration_values = {
      resources = {
        limits = {
          cpu    = "250m"
          memory = "256Mi"
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
    for k, v in local.aws_managed_addons : k => merge(
      {
        configuration_values = merge(
          local.default_common_addon_config.configuration_values,
          v.configuration_values
        )
      },
      local.default_common_addon_config,
      v
    )
  }

  configured_addons = {
    for k, v in merge(local.local_addons_merged, var.cluster_addons) : k => merge(
      v,
      {
        configuration_values = merge(
          try(local.local_addons_merged[k].configuration_values, {}),
          try(var.cluster_addons[k].configuration_values, {})
        )
      }
    )
  }

  configured_addon_roles_arn = {
    for k, v in local.configured_addons : k =>
      contains(keys(local.managed_addon_roles_arn), k) ? local.managed_addon_roles_arn[k] : null
  }

}

resource "aws_eks_addon" "this" {
  for_each = { for k, v in local.configured_addons : k => v if v.install && !v.before_compute && !local.create_outposts_local_cluster }

  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = each.key

  addon_version               = lookup(each.value, "addon_version", data.aws_eks_addon_version.this[each.key].version)
  configuration_values        = jsonencode(lookup(each.value, "configuration_values", local.default_common_addon_config.configuration_values))
  preserve                    = lookup(each.value, "preserve", local.default_common_addon_config.preserve)
  resolve_conflicts_on_create = lookup(each.value, "resolve_conflicts", local.default_common_addon_config.resolve_conflicts)
  service_account_role_arn    = lookup(local.configured_addon_roles_arn, each.key, null)

  timeouts {
    create = lookup(each.value.timeouts, "create", local.default_common_addon_config.timeouts.create)
    update = lookup(each.value.timeouts, "update", local.default_common_addon_config.timeouts.update)
    delete = lookup(each.value.timeouts, "delete", local.default_common_addon_config.timeouts.delete)
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
  for_each = { for k, v in local.aws_managed_addons : k => v if v.install && v.before_compute && !local.create_outposts_local_cluster }

  cluster_name = aws_eks_cluster.this[0].name
  addon_name   = each.key

  addon_version               = lookup(each.value, "addon_version", data.aws_eks_addon_version.this[each.key].version)
  configuration_values        = jsonencode(lookup(each.value, "configuration_values", local.default_common_addon_config.configuration_values))
  preserve                    = lookup(each.value, "preserve", local.default_common_addon_config.preserve)
  resolve_conflicts_on_create = lookup(each.value, "resolve_conflicts", local.default_common_addon_config.resolve_conflicts)
  service_account_role_arn    = lookup(local.configured_addon_roles_arn, each.key, null)

  depends_on = [
    kubectl_manifest.eni_config,
  ]

  tags = var.tags
}

resource "kubernetes_storage_class" "efs_storage_class" {
  count = lookup(local.configured_addons, "aws-efs-csi-driver", { install = false }).install ? 1 : 0

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


