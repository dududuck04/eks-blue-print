module "eks" {
  source = "../../../modules/eks-cluster"

  # Cluster Settings
  cluster_name                        = var.cluster_name
  cluster_version                     = var.cluster_version
  cluster_endpoint_private_access     = var.cluster_endpoint_private_access
  cluster_endpoint_public_access      = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_ip_family                   = var.cluster_ip_family
  attach_cluster_encryption_policy    = var.attach_cluster_encryption_policy
  cluster_encryption_config           = var.cluster_encryption_config
  cluster_timeouts                    = var.cluster_timeouts

  # VPC & Subnets
  vpc_id                              = var.vpc_id
  vpc_name                            = var.vpc_name
  private_subnet_name                 = var.private_subnet_name
  private_subnet                      = var.private_subnet
  pod_subnet_name                     = var.pod_subnet_name
  pod_subnet                          = var.pod_subnet
  public_subnet                       = var.public_subnet
  enable_ipv6                         = var.enable_ipv6

  # Security Groups
  create_primary_cluster_security_group = var.create_primary_cluster_security_group
  primary_cluster_security_group_name   = var.primary_cluster_security_group_name
  cluster_security_group_tags           = var.cluster_security_group_tags
  additional_cluster_security_group_name = var.additional_cluster_security_group_name
  create_cni_ipv6_iam_policy          = var.create_cni_ipv6_iam_policy
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_security_group_description  = var.cluster_security_group_description
  node_cluster_security_group_name    = var.node_cluster_security_group_name

  # KMS Key
  create_kms_key                      = var.create_kms_key
  kms_key_description                 = var.kms_key_description
  kms_key_deletion_window_in_days     = var.kms_key_deletion_window_in_days
  enable_kms_key_rotation             = var.enable_kms_key_rotation
  kms_key_enable_default_policy       = var.kms_key_enable_default_policy
  kms_key_owners                      = var.kms_key_owners
  kms_key_administrators              = var.kms_key_administrators
  kms_key_users                       = var.kms_key_users
  kms_key_service_users               = var.kms_key_service_users
  kms_key_source_policy_documents     = var.kms_key_source_policy_documents
  kms_key_override_policy_documents   = var.kms_key_override_policy_documents
  kms_key_aliases                     = var.kms_key_aliases

  # CloudWatch Logs
  create_cloudwatch_log_group         = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id     = var.cloudwatch_log_group_kms_key_id
  cloudwatch_tags                     = var.cloudwatch_tags

  # EKS Addons
  cluster_addons                      = var.cluster_addons
  cluster_addons_timeouts             = var.cluster_addons_timeouts

  # IRSA (IAM Roles for Service Accounts)
  enable_irsa                         = var.enable_irsa
  openid_connect_audiences            = var.openid_connect_audiences
  custom_oidc_thumbprints             = var.custom_oidc_thumbprints

  # AWS Auth ConfigMap
  manage_aws_auth_configmap           = var.manage_aws_auth_configmap
  create_aws_auth_configmap           = var.create_aws_auth_configmap
  aws_auth_node_iam_role_arns_non_windows = var.aws_auth_node_iam_role_arns_non_windows
  aws_auth_node_iam_role_arns_windows = var.aws_auth_node_iam_role_arns_windows
  aws_auth_fargate_profile_pod_execution_role_arns = var.aws_auth_fargate_profile_pod_execution_role_arns
  aws_auth_roles                      = var.aws_auth_roles
  aws_auth_users                      = var.aws_auth_users
  aws_auth_accounts                   = var.aws_auth_accounts

  # IAM Role
  create_cluster_iam_role             = var.create_cluster_iam_role
  iam_role_tags                       = var.iam_role_tags
  cluster_policy_tags                 = var.cluster_policy_tags
  iam_role_arn                        = var.iam_role_arn
  cluster_iam_role_name               = var.cluster_iam_role_name
  iam_role_use_name_prefix            = var.iam_role_use_name_prefix
  iam_role_path                       = var.iam_role_path
  iam_role_description                = var.iam_role_description
  iam_role_permissions_boundary                   = var.iam_role_permissions_boundary
  cluster_iam_role_additional_policies            = var.cluster_iam_role_additional_policies
  cluster_managed_iam_role_additional_policies    = var.cluster_managed_iam_role_additional_policies
  iam_template_root                               = var.iam_template_root

  # Data Plane Configuration
  dataplane_wait_duration             = var.dataplane_wait_duration

  # Node Groups
  create_node_security_group          = var.create_node_security_group
  eks_managed_node_groups             = var.eks_managed_node_groups
  self_managed_node_groups            = var.self_managed_node_groups
  self_managed_node_group_defaults    = var.self_managed_node_group_defaults
  eks_managed_node_group_defaults     = var.eks_managed_node_group_defaults

  efs_id                              = var.efs_id

  # Fargate Profiles
  fargate_profiles                    = var.fargate_profiles
  fargate_profile_defaults            = var.fargate_profile_defaults

  # Miscellaneous
  before_compute                      = var.before_compute

  eks_cluster_version                  = var.cluster_version
  hosted_zone_domain                   = var.hosted_zone_domain

  enable_amazon_eks_vpc_cni            = var.enable_amazon_eks_vpc_cni
  amazon_eks_vpc_cni_config            = var.amazon_eks_vpc_cni_config

  enable_amazon_eks_coredns            = var.enable_amazon_eks_coredns
  amazon_eks_coredns_config            = var.amazon_eks_coredns_config

  enable_amazon_eks_kube_proxy         = var.enable_amazon_eks_kube_proxy
  amazon_eks_kube_proxy_config         = var.amazon_eks_kube_proxy_config

  enable_amazon_eks_aws_ebs_csi_driver = var.enable_amazon_eks_aws_ebs_csi_driver
  amazon_eks_aws_ebs_csi_driver_config = var.amazon_eks_aws_ebs_csi_driver_config

  enable_amazon_eks_aws_efs_csi_driver = var.enable_amazon_eks_aws_efs_csi_driver
  amazon_eks_aws_efs_csi_driver_config = var.amazon_eks_aws_efs_csi_driver_config

  enable_amazon_eks_aws_metrics_server = var.enable_amazon_eks_aws_metrics_server
  amazon_eks_aws_metrics_server_config = var.amazon_eks_aws_metrics_server_config

  enable_amazon_eks_pod_identity_agent = var.enable_amazon_eks_pod_identity_agent
  amazon_eks_pod_identity_agent_config = var.amazon_eks_pod_identity_agent_config
}
