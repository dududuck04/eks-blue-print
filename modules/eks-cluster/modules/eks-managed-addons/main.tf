#-----------------AWS Managed EKS Add-ons----------------------

module "aws_vpc_cni" {

  source = "./aws-vpc-cni"

  count = var.enable_amazon_eks_vpc_cni ? 1 : 0

  enable_ipv6 = var.enable_ipv6
  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_vpc_cni_config,
    {
      configuration_values = merge(
        lookup(var.amazon_eks_vpc_cni_config, "configuration_values", {}),
        { eniConfig = local.eniconfig }
      )
    }
  )
  addon_context = var.eks_context
}

module "aws_coredns" {
  source = "./aws-coredns"

  count = var.enable_amazon_eks_coredns && var.node_group_create ? 1 : 0
  addon_context = var.eks_context

  enable_amazon_eks_coredns = var.enable_amazon_eks_coredns
  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_coredns_config
  )
}

module "aws_kube_proxy" {
  source = "./aws-kube-proxy"

  count = var.enable_amazon_eks_kube_proxy ? 1 : 0

  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_kube_proxy_config,
  )

  addon_context = var.eks_context

}

module "aws_ebs_csi_driver" {
  source = "./aws-ebs-csi-driver"

  count = var.enable_amazon_eks_aws_ebs_csi_driver && var.node_group_create ? 1 : 0

  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_aws_ebs_csi_driver_config,
  )

  addon_context = var.eks_context
}

module "aws_efs_csi_driver" {
  source            = "./aws-efs-csi-driver"
  count             = var.enable_amazon_eks_aws_efs_csi_driver && var.node_group_create ? 1 : 0

  # EKS 관리형 애드온 전용 설정
  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_aws_efs_csi_driver_config,
  )

  addon_context = var.eks_context
}

module "aws_metrics_server" {
  source            = "./aws-metrics-server"
  count             = var.enable_amazon_eks_aws_metrics_server && var.node_group_create ? 1 : 0

  # EKS 관리형 애드온 전용 설정
  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_aws_metrics_server_config,
  )

  addon_context = var.eks_context
}

module "aws_pod_identity_agent" {
  source            = "./aws-pod-identity-agent"
  count             = var.enable_amazon_eks_pod_identity_agent && var.node_group_create ? 1 : 0

  # EKS 관리형 애드온 전용 설정
  addon_config = merge(
    {
      kubernetes_version = var.eks_context.eks_cluster_version
    },
    var.amazon_eks_pod_identity_agent_config,
  )

  addon_context = var.eks_context
}
