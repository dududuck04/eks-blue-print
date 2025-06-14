data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

data "aws_security_groups" "karpenter_security_group" {
  filter {
    name   = "tag:Name"
    values = [var.karpenter_security_group_name]
  }
}

locals {
  private_subnet_ids  = data.aws_subnets.private_subnets.ids
  karpenter_security_group_ids = data.aws_security_groups.karpenter_security_group.ids
}

resource "aws_ec2_tag" "karpenter_discovery_subnet_tags" {
  for_each = toset(local.private_subnet_ids)

  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = data.aws_eks_cluster.this.name
}


resource "aws_ec2_tag" "security_group_karpenter_and_primary_tags" {
  for_each = toset(
    concat(
      local.karpenter_security_group_ids,
      [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
    )
  )

  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = data.aws_eks_cluster.this.name
}

resource "aws_ec2_tag" "security_group_karpenter_tags" {
  for_each    = toset(local.karpenter_security_group_ids)
  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = data.aws_eks_cluster.this.name
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

#########################
# 데이터 소스: IAM OIDC Provider (IRSA 용)
#########################
data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

module "karpenter" {
  source = "./modules/karpenter"

  cluster_name          = data.aws_eks_cluster.this.name
  enable_v1_permissions = var.enable_v1_permissions
  iam_role_name         = var.iam_role_name
  create_iam_role       = var.create_iam_role

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = var.node_iam_role_use_name_prefix
  node_iam_role_name              = var.node_iam_role_name
  create_pod_identity_association = var.create_pod_identity_association

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = var.node_iam_role_additional_policies

}

resource "helm_release" "karpenter" {
  namespace           = var.namespace
  create_namespace    = var.create_namespace
  name                = var.name
  repository          = var.repository
  chart               = var.chart
  version             = var.helm_release_version
  wait                = var.wait

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    additionalAnnotations:
      meta.helm.sh/release-namespace: ${var.namespace}
    # tolerations:
    #   - key: "karpenter"
    #     operator: "Equal"
    #     value: "true"
    #     effect: "NoSchedule"
    dnsPolicy: Default
    settings:
      clusterName: ${data.aws_eks_cluster.this.name}
      clusterEndpoint: ${data.aws_eks_cluster.this.endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    webhook:
      enabled: true
    EOT
  ]
}



# Provisioner 파일을 Kubernetes 클러스터에 적용
resource "kubectl_manifest" "ec2nodeclass" {
  depends_on = [helm_release.karpenter]
  yaml_body = templatefile("${path.module}/modules/karpenter/ec2nodeclass.yaml.tpl", {
    cluster_name       = data.aws_eks_cluster.this.name
    node_iam_role_name = var.node_iam_role_name
  })
}

# NodePool
resource "kubectl_manifest" "nodepool" {
  yaml_body = templatefile("${path.module}/modules/karpenter/nodepool.yaml.tpl", {
    instance_family_values          = var.instance_family_values
    instance_cpu_values             = var.instance_cpu_values
    instance_hypervisor_values      = var.instance_hypervisor_values
    instance_generation_threshold   = var.instance_generation_threshold
    kubernetes_arch_values          = var.kubernetes_arch_values
    kubernetes_os_values            = var.kubernetes_os_values
    capacity_type_values            = var.capacity_type_values
    nodepool_cpu_limit              = var.nodepool_cpu_limit
    expire_after                    = var.expire_after
    termination_grace_period        = var.termination_grace_period
    zone_values                     = var.zone_values
    consolidation_policy            = var.consolidation_policy
    consolidate_after               = var.consolidate_after
    disruption_budgets              = var.disruption_budgets
    nodepool_memory_limit           = var.nodepool_memory_limit
    nodepool_weight                 = var.nodepool_weight
  })
  depends_on = [kubectl_manifest.ec2nodeclass]
}

# module "karpenter_disabled" {
#   source = "./modules/karpenter"
#
#   create = false
# }