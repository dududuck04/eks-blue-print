module "eks_pre_managed_addons" {
  source = "./modules/eks-managed-addons"

  cluster_name                         = var.cluster_name
  eks_context                          = local.eks_context
  pod_subnet_name                      = var.pod_subnet_name

  enable_amazon_eks_vpc_cni            = var.enable_amazon_eks_vpc_cni
  amazon_eks_vpc_cni_config            = var.amazon_eks_vpc_cni_config

  enable_amazon_eks_kube_proxy         = var.enable_amazon_eks_kube_proxy
  amazon_eks_kube_proxy_config         = var.amazon_eks_kube_proxy_config

}

module "eks_post_managed_addons" {
  source = "./modules/eks-managed-addons"

  cluster_name                         = var.cluster_name
  eks_context                          = local.eks_context
  node_group_create                    = local.eks_node_group_context.node_group_create

  enable_amazon_eks_coredns            = var.enable_amazon_eks_coredns
  amazon_eks_coredns_config            = var.amazon_eks_coredns_config

  enable_amazon_eks_aws_ebs_csi_driver = var.enable_amazon_eks_aws_ebs_csi_driver
  amazon_eks_aws_ebs_csi_driver_config = var.amazon_eks_aws_ebs_csi_driver_config

  enable_amazon_eks_aws_efs_csi_driver = var.enable_amazon_eks_aws_efs_csi_driver
  amazon_eks_aws_efs_csi_driver_config = var.amazon_eks_aws_efs_csi_driver_config

  enable_amazon_eks_aws_metrics_server = var.enable_amazon_eks_aws_metrics_server
  amazon_eks_aws_metrics_server_config = var.amazon_eks_aws_metrics_server_config

  enable_amazon_eks_pod_identity_agent = var.enable_amazon_eks_pod_identity_agent
  amazon_eks_pod_identity_agent_config = var.amazon_eks_pod_identity_agent_config

  depends_on = [module.eks_managed_node_group]
}

