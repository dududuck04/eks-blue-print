locals {
  name = "aws-ebs-csi-driver"
  create_irsa     = try(var.addon_config.service_account_role_arn == "", true)
}

data "aws_eks_addon_version" "this" {
  addon_name            = local.name
  kubernetes_version    = var.addon_config.kubernetes_version
  most_recent           = try(var.addon_config.most_recent, false)
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name                        = var.addon_context.eks_cluster_id
  addon_name                          = local.name
  addon_version                       = try(var.addon_config.addon_version, data.aws_eks_addon_version.this.version)
  resolve_conflicts_on_create         = try(var.addon_config.resolve_conflicts, "OVERWRITE")
  service_account_role_arn            = local.create_irsa ? module.irsa_addon[0].irsa_iam_role_arn : try(var.addon_config.service_account_role_arn, null)
  preserve                            = try(var.addon_config.preserve, true)
  configuration_values                = (var.addon_config.configuration_values != null ? jsonencode(var.addon_config.configuration_values) : null)

  dynamic "pod_identity_association" {
    for_each = try(var.addon_config.role_type, "service_account") == "pod_identity" ? [1] : []
    content {
      role_arn        = local.create_irsa ? module.irsa_addon[0].irsa_iam_role_arn : try(var.addon_config.service_account_role_arn, null)
      service_account = "aws-node"
    }
  }

  tags = merge(
    var.addon_context.tags,
    try(var.addon_config.tags, {})
  )
}

module "irsa_addon" {
  source = "../../../../irsa"

  count = local.create_irsa ? 1 : 0

  create_kubernetes_namespace       = false
  create_kubernetes_service_account = false
  irsa_iam_role_name                = try(var.addon_config.irsa_iam_role_name, null)
  kubernetes_namespace              = "kube-system"
  kubernetes_service_account        = "ebs-csi-controller-sa"
  irsa_iam_policies                 = concat([aws_iam_policy.aws_ebs_csi_driver[0].arn], lookup(var.addon_config, "additional_iam_policies", []))
  irsa_iam_role_path                = var.addon_context.irsa_iam_role_path
  irsa_iam_permissions_boundary     = var.addon_context.irsa_iam_permissions_boundary
  eks_cluster_id                    = var.addon_context.eks_cluster_id
  eks_oidc_provider_arn             = var.addon_context.eks_oidc_provider_arn
}

resource "aws_iam_policy" "aws_ebs_csi_driver" {
  count = local.create_irsa ? 1 : 0

  name        = try(var.addon_config.irsa_iam_role_policy,"${var.addon_context.eks_cluster_id}-aws-ebs-csi-driver-irsa")
  description = "IAM Policy for AWS EBS CSI Driver"
  path        = try(var.addon_context.irsa_iam_role_path, null)
  policy      = data.aws_iam_policy_document.aws_ebs_csi_driver[0].json

  tags = merge(
    var.addon_context.tags,
    try(var.addon_config.tags, {})
  )
}


resource "kubernetes_storage_class" "gp3" {
  count = local.create_irsa ? 1 : 0

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
    aws_eks_addon.aws_ebs_csi_driver
  ]
}
