module "karpenter" {
  source = "../../../../modules/eks-addons"

  ###############################
  # 필수 변수 및 클러스터 설정
  ###############################
  cluster_name = var.cluster_name
  create       = var.create

  ###############################################
  # Karpenter Controller IAM Role 관련 변수들
  ###############################################
  create_iam_role                     = var.create_iam_role
  iam_role_name                       = var.iam_role_name
  iam_role_use_name_prefix            = var.iam_role_use_name_prefix
  iam_role_path                       = var.iam_role_path
  iam_role_description                = var.iam_role_description
  iam_role_max_session_duration       = var.iam_role_max_session_duration
  iam_role_permissions_boundary_arn   = var.iam_role_permissions_boundary_arn
  iam_role_tags                       = var.iam_role_tags

  iam_policy_name                     = var.iam_policy_name
  iam_policy_use_name_prefix          = var.iam_policy_use_name_prefix
  iam_policy_path                     = var.iam_policy_path
  iam_policy_description              = var.iam_policy_description
  iam_policy_statements               = var.iam_policy_statements
  iam_role_policies                   = var.iam_role_policies

  ami_id_ssm_parameter_arns           = var.ami_id_ssm_parameter_arns

  ###############################################
  # Pod Identity 및 IRSA 관련 변수들
  ###############################################
  enable_pod_identity                 = var.enable_pod_identity
  enable_v1_permissions               = var.enable_v1_permissions
  enable_irsa                         = var.enable_irsa
  irsa_oidc_provider_arn              = var.irsa_oidc_provider_arn
  irsa_namespace_service_accounts     = var.irsa_namespace_service_accounts
  irsa_assume_role_condition_test     = var.irsa_assume_role_condition_test

  create_pod_identity_association     = var.create_pod_identity_association
  namespace                           = var.namespace
  service_account                     = var.service_account

  ###############################################
  # Node Termination Queue 관련 변수들
  ###############################################
  enable_spot_termination             = var.enable_spot_termination
  queue_name                          = var.queue_name
  queue_managed_sse_enabled           = var.queue_managed_sse_enabled
  queue_kms_master_key_id             = var.queue_kms_master_key_id
  queue_kms_data_key_reuse_period_seconds = var.queue_kms_data_key_reuse_period_seconds

  ###############################################
  # Node IAM Role 관련 변수들
  ###############################################
  create_node_iam_role                = var.create_node_iam_role
  cluster_ip_family                   = var.cluster_ip_family
  node_iam_role_arn                   = var.node_iam_role_arn
  node_iam_role_name                  = var.node_iam_role_name
  node_iam_role_use_name_prefix       = var.node_iam_role_use_name_prefix
  node_iam_role_path                  = var.node_iam_role_path
  node_iam_role_description           = var.node_iam_role_description
  node_iam_role_max_session_duration  = var.node_iam_role_max_session_duration
  node_iam_role_permissions_boundary  = var.node_iam_role_permissions_boundary
  node_iam_role_attach_cni_policy     = var.node_iam_role_attach_cni_policy
  node_iam_role_additional_policies   = var.node_iam_role_additional_policies
  node_iam_role_tags                  = var.node_iam_role_tags

  ###############################################
  # Access Entry 및 Instance Profile 관련 변수들
  ###############################################
  create_access_entry                 = var.create_access_entry
  access_entry_type                   = var.access_entry_type
  create_instance_profile             = var.create_instance_profile

  ###############################################
  # Event Bridge Rules 관련 변수
  ###############################################
  rule_name_prefix                    = var.rule_name_prefix

  ###############################################
  # 추가 태그, 보안 그룹 및 서브넷 관련 변수
  ###############################################
  tags                                      = var.tags
  karpenter_security_group_name             = var.karpenter_security_group_name
  private_subnet_name                       = var.private_subnet_name


  chart                = var.chart
  helm_release_version = var.helm_release_version
  name                 = var.name
  repository           = var.repository

  instance_family_values          = var.instance_family_values
  instance_cpu_values             = var.instance_cpu_values
  instance_hypervisor_values      = var.instance_hypervisor_values
  instance_generation_threshold   = var.instance_generation_threshold
  kubernetes_arch_values          = var.kubernetes_arch_values
  kubernetes_os_values            = var.kubernetes_os_values
  capacity_type_values            = var.capacity_type_values
  nodepool_cpu_limit              = var.nodepool_cpu_limit
  nodepool_weight                 = var.nodepool_weight
  nodepool_memory_limit           = var.nodepool_memory_limit
  disruption_budgets              = var.disruption_budgets
  consolidate_after               = var.consolidate_after
  consolidation_policy            = var.consolidation_policy
  zone_values                     = var.zone_values
  termination_grace_period        = var.termination_grace_period
  expire_after                    = var.expire_after

}

