locals {
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # EKS managed node group
  default_update_config = {
    max_unavailable_percentage = 33
  }

  # Self-managed node group
  # default_instance_refresh = {
  #   strategy = "Rolling"
  #   preferences = {
  #     min_healthy_percentage = 66
  #   }
  # }
}

data "aws_ami" "latest" {
  most_recent = true

  # Specify the AMI owners (e.g., amazon, self, or specific AWS account ID)
  owners = ["amazon"]

  # Use a regex pattern to match the AMI name
  name_regex = "^amzn2-ami-hvm-[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+-x86_64-gp2$" # Amazon Linux 2 example

  # Apply additional filters for the AMI
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "platform-details"
    values = ["Linux/UNIX"]
  }
}

resource "time_sleep" "this" {
  count = var.create_cluster ? 1 : 0

  create_duration = var.dataplane_wait_duration

  triggers = {
    cluster_name     = aws_eks_cluster.this[0].name
    cluster_endpoint = aws_eks_cluster.this[0].endpoint
    cluster_version  = aws_eks_cluster.this[0].version

    cluster_certificate_authority_data = aws_eks_cluster.this[0].certificate_authority[0].data
  }
}

################################################################################
# Fargate Profile
################################################################################

# module "fargate_profile" {
#   source = "./modules/fargate-profile"
#
#   for_each = { for k, v in var.fargate_profiles : k => v if var.create_cluster && !local.create_outposts_local_cluster }
#
#   create = try(each.value.create, true)
#
#   # Fargate Profile
#   cluster_name      = time_sleep.this[0].triggers["cluster_name"]
#   cluster_ip_family = var.cluster_ip_family
#   name              = each.value.name
#   subnet_ids        = try(each.value.subnet_ids, var.fargate_profile_defaults.subnet_ids, var.subnet_ids)
#   selectors         = try(each.value.selectors, var.fargate_profile_defaults.selectors, [])
#   timeouts          = try(each.value.timeouts, var.fargate_profile_defaults.timeouts, {})
#
#   # IAM role
#   create_iam_role               = try(each.value.create_iam_role, var.fargate_profile_defaults.create_iam_role, true)
#   iam_role_arn                  = try(each.value.iam_role_arn, var.fargate_profile_defaults.iam_role_arn, null)
#   iam_role_name                 = try(each.value.iam_role_name, var.fargate_profile_defaults.iam_role_name, null)
#   iam_role_use_name_prefix      = try(each.value.iam_role_use_name_prefix, var.fargate_profile_defaults.iam_role_use_name_prefix, true)
#   iam_role_path                 = try(each.value.iam_role_path, var.fargate_profile_defaults.iam_role_path, null)
#   iam_role_description          = try(each.value.iam_role_description, var.fargate_profile_defaults.iam_role_description, "Fargate profile IAM role")
#   iam_role_permissions_boundary = try(each.value.iam_role_permissions_boundary, var.fargate_profile_defaults.iam_role_permissions_boundary, null)
#   iam_role_tags                 = try(each.value.iam_role_tags, var.fargate_profile_defaults.iam_role_tags, {})
#   iam_role_attach_cni_policy    = try(each.value.iam_role_attach_cni_policy, var.fargate_profile_defaults.iam_role_attach_cni_policy, true)
#   # To better understand why this `lookup()` logic is required, see:
#   # https://github.com/hashicorp/terraform/issues/31646#issuecomment-1217279031
#   iam_role_additional_policies = lookup(each.value, "iam_role_additional_policies", lookup(var.fargate_profile_defaults, "iam_role_additional_policies", {}))
#
#   tags = merge(var.tags, try(each.value.tags, var.fargate_profile_defaults.tags, {}))
# }

################################################################################
# EKS Managed Node Group
################################################################################

module "eks_managed_node_group" {
  source   = "./modules/eks-managed-node-group"
  for_each = { for k, v in var.eks_managed_node_groups : k => v if var.create_cluster && !local.create_outposts_local_cluster }

  create = coalesce(lookup(each.value, "create", null), true)

  cluster_name      = time_sleep.this[0].triggers["cluster_name"]
  cluster_version   = time_sleep.this[0].triggers["cluster_version"]
  cluster_ip_family = var.cluster_ip_family

  # EKS Managed Node Group
  name                = coalesce(lookup(each.value, "name", "${time_sleep.this[0].triggers.cluster_name}-nodegroup-${each.key}"))
  use_name_prefix     = coalesce(lookup(each.value, "use_name_prefix", var.eks_managed_node_group_defaults.use_name_prefix))

  subnet_ids          = coalesce(lookup(each.value, "subnet_ids", local.private_subnet_ids))
  min_size            = coalesce(lookup(each.value, "min_size", var.eks_managed_node_group_defaults.min_size))
  max_size            = coalesce(lookup(each.value, "max_size", var.eks_managed_node_group_defaults.max_size))
  desired_size        = coalesce(lookup(each.value, "desired_size", var.eks_managed_node_group_defaults.desired_size))

  ami_id = lookup(each.value, "ami_id", null) != null ? lookup(each.value, "ami_id", null) : var.eks_managed_node_group_defaults.ami_id
  ami_type = lookup(each.value, "ami_type", null) != null ? lookup(each.value, "ami_type", null) : var.eks_managed_node_group_defaults.ami_type
  ami_release_version = lookup(each.value, "ami_release_version", null) != null ? lookup(each.value, "ami_release_version", null) : var.eks_managed_node_group_defaults.ami_release_version
  capacity_type = lookup(each.value, "capacity_type", null) != null ? lookup(each.value, "capacity_type", null) : var.eks_managed_node_group_defaults.capacity_type
  disk_size = lookup(each.value, "disk_size", null) != null ? lookup(each.value, "disk_size", null) : var.eks_managed_node_group_defaults.disk_size
  force_update_version = lookup(each.value, "force_update_version", null) != null ? lookup(each.value, "force_update_version", null) : var.eks_managed_node_group_defaults.force_update_version
  instance_types = lookup(each.value, "instance_types", null) != null ? lookup(each.value, "instance_types", null) : var.eks_managed_node_group_defaults.instance_types
  labels = lookup(each.value, "labels", null) != null ? lookup(each.value, "labels", null) : var.eks_managed_node_group_defaults.labels
  remote_access = lookup(each.value, "remote_access", null) != null ? lookup(each.value, "remote_access", null) : var.eks_managed_node_group_defaults.remote_access
  taints = lookup(each.value, "taints", null) != null ? lookup(each.value, "taints", null) : var.eks_managed_node_group_defaults.taints
  update_config = lookup(each.value, "update_config", null) != null ? lookup(each.value, "update_config", null) : var.eks_managed_node_group_defaults.update_config
  timeouts = lookup(each.value, "timeouts", null) != null ? lookup(each.value, "timeouts", null) : var.eks_managed_node_group_defaults.timeouts

  # User data 관련
  platform = lookup(each.value, "platform", null) != null ? lookup(each.value, "platform", null) : var.eks_managed_node_group_defaults.platform
  cluster_endpoint = lookup(each.value, "cluster_endpoint", null) != null ? lookup(each.value, "cluster_endpoint", null) : var.eks_managed_node_group_defaults.cluster_endpoint
  cluster_auth_base64 = lookup(each.value, "cluster_auth_base64", null) != null ? lookup(each.value, "cluster_auth_base64", null) : var.eks_managed_node_group_defaults.cluster_auth_base64
  cluster_service_ipv4_cidr = lookup(each.value, "cluster_service_ipv4_cidr", null) != null ? lookup(each.value, "cluster_service_ipv4_cidr", null) : var.eks_managed_node_group_defaults.cluster_service_ipv4_cidr
  enable_bootstrap_user_data = lookup(each.value, "enable_bootstrap_user_data", null) != null ? lookup(each.value, "enable_bootstrap_user_data", null) : var.eks_managed_node_group_defaults.enable_bootstrap_user_data
  pre_bootstrap_user_data = lookup(each.value, "pre_bootstrap_user_data", null) != null ? lookup(each.value, "pre_bootstrap_user_data", null) : var.eks_managed_node_group_defaults.pre_bootstrap_user_data
  post_bootstrap_user_data = lookup(each.value, "post_bootstrap_user_data", null) != null ? lookup(each.value, "post_bootstrap_user_data", null) : var.eks_managed_node_group_defaults.post_bootstrap_user_data
  bootstrap_extra_args = lookup(each.value, "bootstrap_extra_args", null) != null ? lookup(each.value, "bootstrap_extra_args", null) : var.eks_managed_node_group_defaults.bootstrap_extra_args
  user_data_template_path = lookup(each.value, "user_data_template_path", null) != null ? lookup(each.value, "user_data_template_path", null) : var.eks_managed_node_group_defaults.user_data_template_path

  # Launch Template 관련
  create_launch_template = lookup(each.value, "create_launch_template", null) != null ? lookup(each.value, "create_launch_template", null) : var.eks_managed_node_group_defaults.create_launch_template
  use_custom_launch_template = lookup(each.value, "use_custom_launch_template", null) != null ? lookup(each.value, "use_custom_launch_template", null) : var.eks_managed_node_group_defaults.use_custom_launch_template
  launch_template_id = lookup(each.value, "launch_template_id", null) != null ? lookup(each.value, "launch_template_id", null) : var.eks_managed_node_group_defaults.launch_template_id
  launch_template_name = lookup(each.value, "launch_template_name", null) != null ? lookup(each.value, "launch_template_name", null) : each.value.name
  launch_template_use_name_prefix = lookup(each.value, "launch_template_use_name_prefix", null) != null ? lookup(each.value, "launch_template_use_name_prefix", null) : var.eks_managed_node_group_defaults.launch_template_use_name_prefix
  launch_template_version = lookup(each.value, "launch_template_version", null) != null ? lookup(each.value, "launch_template_version", null) : var.eks_managed_node_group_defaults.launch_template_version
  launch_template_default_version = lookup(each.value, "launch_template_default_version", null) != null ? lookup(each.value, "launch_template_default_version", null) : var.eks_managed_node_group_defaults.launch_template_default_version
  update_launch_template_default_version = lookup(each.value, "update_launch_template_default_version", null) != null ? lookup(each.value, "update_launch_template_default_version", null) : var.eks_managed_node_group_defaults.update_launch_template_default_version
  launch_template_description = lookup(each.value, "launch_template_description", null) != null ? lookup(each.value, "launch_template_description", null) : var.eks_managed_node_group_defaults.launch_template_description
  launch_template_tags = lookup(each.value, "launch_template_tags", null) != null ? lookup(each.value, "launch_template_tags", null) : var.eks_managed_node_group_defaults.launch_template_tags
  tag_specifications = lookup(each.value, "tag_specifications", null) != null ? lookup(each.value, "tag_specifications", null) : var.eks_managed_node_group_defaults.tag_specifications

  ebs_optimized = lookup(each.value, "ebs_optimized", null) != null ? lookup(each.value, "ebs_optimized", null) : var.eks_managed_node_group_defaults.ebs_optimized
  key_name = lookup(each.value, "key_name", null) != null ? lookup(each.value, "key_name", null) : var.eks_managed_node_group_defaults.key_name
  disable_api_termination = lookup(each.value, "disable_api_termination", null) != null ? lookup(each.value, "disable_api_termination", null) : var.eks_managed_node_group_defaults.disable_api_termination
  kernel_id = lookup(each.value, "kernel_id", null) != null ? lookup(each.value, "kernel_id", null) : var.eks_managed_node_group_defaults.kernel_id
  ram_disk_id = lookup(each.value, "ram_disk_id", null) != null ? lookup(each.value, "ram_disk_id", null) : var.eks_managed_node_group_defaults.ram_disk_id

  block_device_mappings = lookup(each.value, "block_device_mappings", null) != null ? lookup(each.value, "block_device_mappings", null) : var.eks_managed_node_group_defaults.block_device_mappings
  capacity_reservation_specification = lookup(each.value, "capacity_reservation_specification", null) != null ? lookup(each.value, "capacity_reservation_specification", null) : var.eks_managed_node_group_defaults.capacity_reservation_specification
  cpu_options = lookup(each.value, "cpu_options", null) != null ? lookup(each.value, "cpu_options", null) : var.eks_managed_node_group_defaults.cpu_options
  credit_specification = lookup(each.value, "credit_specification", null) != null ? lookup(each.value, "credit_specification", null) : var.eks_managed_node_group_defaults.credit_specification
  elastic_gpu_specifications = lookup(each.value, "elastic_gpu_specifications", null) != null ? lookup(each.value, "elastic_gpu_specifications", null) : var.eks_managed_node_group_defaults.elastic_gpu_specifications
  elastic_inference_accelerator = lookup(each.value, "elastic_inference_accelerator", null) != null ? lookup(each.value, "elastic_inference_accelerator", null) : var.eks_managed_node_group_defaults.elastic_inference_accelerator
  enclave_options = lookup(each.value, "enclave_options", null) != null ? lookup(each.value, "enclave_options", null) : var.eks_managed_node_group_defaults.enclave_options
  instance_market_options = lookup(each.value, "instance_market_options", null) != null ? lookup(each.value, "instance_market_options", null) : var.eks_managed_node_group_defaults.instance_market_options
  license_specifications = lookup(each.value, "license_specifications", null) != null ? lookup(each.value, "license_specifications", null) : var.eks_managed_node_group_defaults.license_specifications
  metadata_options = lookup(each.value, "metadata_options", null) != null ? lookup(each.value, "metadata_options", null) : var.eks_managed_node_group_defaults.metadata_options
  enable_monitoring = lookup(each.value, "enable_monitoring", null) != null ? lookup(each.value, "enable_monitoring", null) : var.eks_managed_node_group_defaults.enable_monitoring
  network_interfaces = lookup(each.value, "network_interfaces", null) != null ? lookup(each.value, "network_interfaces", null) : var.eks_managed_node_group_defaults.network_interfaces
  placement = lookup(each.value, "placement", null) != null ? lookup(each.value, "placement", null) : var.eks_managed_node_group_defaults.placement
  maintenance_options = lookup(each.value, "maintenance_options", null) != null ? lookup(each.value, "maintenance_options", null) : var.eks_managed_node_group_defaults.maintenance_options
  private_dns_name_options = lookup(each.value, "private_dns_name_options", null) != null ? lookup(each.value, "private_dns_name_options", null) : var.eks_managed_node_group_defaults.private_dns_name_options

  # IAM role
  create_iam_role              = lookup(each.value, "create_iam_role", null) != null ? lookup(each.value, "create_iam_role", null) : var.eks_managed_node_group_defaults.create_iam_role
  iam_role_arn                 = lookup(each.value, "iam_role_arn", null) != null ? lookup(each.value, "iam_role_arn", null) : var.eks_managed_node_group_defaults.iam_role_arn
  iam_role_name                = lookup(each.value, "iam_role_name", null) != null ? lookup(each.value, "iam_role_name", null) : var.eks_managed_node_group_defaults.iam_role_name
  iam_role_use_name_prefix     = lookup(each.value, "iam_role_use_name_prefix", null) != null ? lookup(each.value, "iam_role_use_name_prefix", null) : var.eks_managed_node_group_defaults.iam_role_use_name_prefix
  iam_role_path                = lookup(each.value, "iam_role_path", null) != null ? lookup(each.value, "iam_role_path", null) : var.eks_managed_node_group_defaults.iam_role_path
  iam_role_description         = lookup(each.value, "iam_role_description", null) != null ? lookup(each.value, "iam_role_description", null) : var.eks_managed_node_group_defaults.iam_role_description
  iam_role_permissions_boundary = lookup(each.value, "iam_role_permissions_boundary", null) != null ? lookup(each.value, "iam_role_permissions_boundary", null) : var.eks_managed_node_group_defaults.iam_role_permissions_boundary
  iam_role_tags                = lookup(each.value, "iam_role_tags", null) != null ? lookup(each.value, "iam_role_tags", null) : var.eks_managed_node_group_defaults.iam_role_tags
  iam_role_attach_cni_policy   = lookup(each.value, "iam_role_attach_cni_policy", null) != null ? lookup(each.value, "iam_role_attach_cni_policy", null) : var.eks_managed_node_group_defaults.iam_role_attach_cni_policy
  iam_role_additional_policies = lookup(each.value, "iam_role_additional_policies", null) != null ? lookup(each.value, "iam_role_additional_policies", null) : var.eks_managed_node_group_defaults.iam_role_additional_policies

  create_schedule = lookup(each.value, "create_schedule", null) != null ? lookup(each.value, "create_schedule", null) : var.eks_managed_node_group_defaults.create_schedule
  schedules       = lookup(each.value, "schedules", null) != null ? lookup(each.value, "schedules", null) : var.eks_managed_node_group_defaults.schedules

  # Security group
  # vpc_security_group_ids = (lookup(each.value, "create_node_security_group", false)) ? [aws_security_group.node_cluster_security_group[each.value.name].id] : []
  vpc_security_group_ids = lookup(each.value, "create_node_security_group", false) ? [local.node_cluster_sg_ids[each.value.name]] : []
  cluster_primary_security_group_id = lookup(each.value, "attach_cluster_primary_security_group", true) ? aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id : null

  tags = merge(var.tags, coalesce(try(each.value.tags, var.eks_managed_node_group_defaults.tags), {}))
}

################################################################################
# Self Managed Node Group
################################################################################

# module "self_managed_node_group" {
#   source = "./modules/self-managed-node-group"
#
#   for_each = { for k, v in var.self_managed_node_groups : k => v if var.create }
#
#   create = try(each.value.create, true)
#
#   cluster_name      = time_sleep.this[0].triggers["cluster_name"]
#   cluster_ip_family = var.cluster_ip_family
#
#   # Autoscaling Group
#   create_autoscaling_group = try(each.value.create_autoscaling_group, var.self_managed_node_group_defaults.create_autoscaling_group, true)
#
#   name            = each.value.name
#   use_name_prefix = try(each.value.use_name_prefix, var.self_managed_node_group_defaults.use_name_prefix, true)
#
#   availability_zones = try(each.value.availability_zones, var.self_managed_node_group_defaults.availability_zones, null)
#   subnet_ids         = try(each.value.subnet_ids, var.self_managed_node_group_defaults.subnet_ids, var.subnet_ids)
#
#   min_size                  = try(each.value.min_size, var.self_managed_node_group_defaults.min_size, 0)
#   max_size                  = try(each.value.max_size, var.self_managed_node_group_defaults.max_size, 3)
#   desired_size              = try(each.value.desired_size, var.self_managed_node_group_defaults.desired_size, 1)
#   capacity_rebalance        = try(each.value.capacity_rebalance, var.self_managed_node_group_defaults.capacity_rebalance, null)
#   min_elb_capacity          = try(each.value.min_elb_capacity, var.self_managed_node_group_defaults.min_elb_capacity, null)
#   wait_for_elb_capacity     = try(each.value.wait_for_elb_capacity, var.self_managed_node_group_defaults.wait_for_elb_capacity, null)
#   wait_for_capacity_timeout = try(each.value.wait_for_capacity_timeout, var.self_managed_node_group_defaults.wait_for_capacity_timeout, null)
#   default_cooldown          = try(each.value.default_cooldown, var.self_managed_node_group_defaults.default_cooldown, null)
#   default_instance_warmup   = try(each.value.default_instance_warmup, var.self_managed_node_group_defaults.default_instance_warmup, null)
#   protect_from_scale_in     = try(each.value.protect_from_scale_in, var.self_managed_node_group_defaults.protect_from_scale_in, null)
#   context                   = try(each.value.context, var.self_managed_node_group_defaults.context, null)
#
#   target_group_arns         = try(each.value.target_group_arns, var.self_managed_node_group_defaults.target_group_arns, [])
#   placement_group           = try(each.value.placement_group, var.self_managed_node_group_defaults.placement_group, null)
#   health_check_type         = try(each.value.health_check_type, var.self_managed_node_group_defaults.health_check_type, null)
#   health_check_grace_period = try(each.value.health_check_grace_period, var.self_managed_node_group_defaults.health_check_grace_period, null)
#
#   force_delete           = try(each.value.force_delete, var.self_managed_node_group_defaults.force_delete, null)
#   force_delete_warm_pool = try(each.value.force_delete_warm_pool, var.self_managed_node_group_defaults.force_delete_warm_pool, null)
#   termination_policies   = try(each.value.termination_policies, var.self_managed_node_group_defaults.termination_policies, [])
#   suspended_processes    = try(each.value.suspended_processes, var.self_managed_node_group_defaults.suspended_processes, [])
#   max_instance_lifetime  = try(each.value.max_instance_lifetime, var.self_managed_node_group_defaults.max_instance_lifetime, null)
#
#   enabled_metrics         = try(each.value.enabled_metrics, var.self_managed_node_group_defaults.enabled_metrics, [])
#   metrics_granularity     = try(each.value.metrics_granularity, var.self_managed_node_group_defaults.metrics_granularity, null)
#   service_linked_role_arn = try(each.value.service_linked_role_arn, var.self_managed_node_group_defaults.service_linked_role_arn, null)
#
#   initial_lifecycle_hooks    = try(each.value.initial_lifecycle_hooks, var.self_managed_node_group_defaults.initial_lifecycle_hooks, [])
#   instance_refresh           = try(each.value.instance_refresh, var.self_managed_node_group_defaults.instance_refresh, local.default_instance_refresh)
#   use_mixed_instances_policy = try(each.value.use_mixed_instances_policy, var.self_managed_node_group_defaults.use_mixed_instances_policy, false)
#   mixed_instances_policy     = try(each.value.mixed_instances_policy, var.self_managed_node_group_defaults.mixed_instances_policy, null)
#   warm_pool                  = try(each.value.warm_pool, var.self_managed_node_group_defaults.warm_pool, {})
#
#   create_schedule = try(each.value.create_schedule, var.self_managed_node_group_defaults.create_schedule, true)
#   schedules       = try(each.value.schedules, var.self_managed_node_group_defaults.schedules, {})
#
#   delete_timeout         = try(each.value.delete_timeout, var.self_managed_node_group_defaults.delete_timeout, null)
#   autoscaling_group_tags = try(each.value.autoscaling_group_tags, var.self_managed_node_group_defaults.autoscaling_group_tags, {})
#
#   # User data
#   platform                 = try(each.value.platform, var.self_managed_node_group_defaults.platform, "linux")
#   cluster_endpoint         = try(time_sleep.this[0].triggers["cluster_endpoint"], "")
#   cluster_auth_base64      = try(time_sleep.this[0].triggers["cluster_certificate_authority_data"], "")
#   pre_bootstrap_user_data  = try(each.value.pre_bootstrap_user_data, var.self_managed_node_group_defaults.pre_bootstrap_user_data, "")
#   post_bootstrap_user_data = try(each.value.post_bootstrap_user_data, var.self_managed_node_group_defaults.post_bootstrap_user_data, "")
#   bootstrap_extra_args     = try(each.value.bootstrap_extra_args, var.self_managed_node_group_defaults.bootstrap_extra_args, "")
#   user_data_template_path  = try(each.value.user_data_template_path, var.self_managed_node_group_defaults.user_data_template_path, "")
#
#   # Launch Template
#   create_launch_template                 = try(each.value.create_launch_template, var.self_managed_node_group_defaults.create_launch_template, true)
#   launch_template_id                     = try(each.value.launch_template_id, var.self_managed_node_group_defaults.launch_template_id, "")
#   launch_template_name                   = try(each.value.launch_template_name, var.self_managed_node_group_defaults.launch_template_name, each.value.name)
#   launch_template_use_name_prefix        = try(each.value.launch_template_use_name_prefix, var.self_managed_node_group_defaults.launch_template_use_name_prefix, false)
#   launch_template_version                = try(each.value.launch_template_version, var.self_managed_node_group_defaults.launch_template_version, null)
#   launch_template_default_version        = try(each.value.launch_template_default_version, var.self_managed_node_group_defaults.launch_template_default_version, null)
#   update_launch_template_default_version = try(each.value.update_launch_template_default_version, var.self_managed_node_group_defaults.update_launch_template_default_version, true)
#   launch_template_description            = try(each.value.launch_template_description, var.self_managed_node_group_defaults.launch_template_description, "Custom launch template for ${each.value.name} self managed node group")
#   launch_template_tags                   = try(each.value.launch_template_tags, var.self_managed_node_group_defaults.launch_template_tags, {})
#   tag_specifications                     = try(each.value.tag_specifications, var.self_managed_node_group_defaults.tag_specifications, ["instance", "volume", "network-interface"])
#
#   ebs_optimized   = try(each.value.ebs_optimized, var.self_managed_node_group_defaults.ebs_optimized, null)
#   ami_id          = try(each.value.ami_id, var.self_managed_node_group_defaults.ami_id, "")
#   cluster_version = try(each.value.cluster_version, var.self_managed_node_group_defaults.cluster_version, time_sleep.this[0].triggers["cluster_version"])
#   instance_type   = try(each.value.instance_type, var.self_managed_node_group_defaults.instance_type, "m6i.large")
#   key_name        = try(each.value.key_name, var.self_managed_node_group_defaults.key_name, null)
#
#   disable_api_termination              = try(each.value.disable_api_termination, var.self_managed_node_group_defaults.disable_api_termination, null)
#   instance_initiated_shutdown_behavior = try(each.value.instance_initiated_shutdown_behavior, var.self_managed_node_group_defaults.instance_initiated_shutdown_behavior, null)
#   kernel_id                            = try(each.value.kernel_id, var.self_managed_node_group_defaults.kernel_id, null)
#   ram_disk_id                          = try(each.value.ram_disk_id, var.self_managed_node_group_defaults.ram_disk_id, null)
#
#   block_device_mappings              = try(each.value.block_device_mappings, var.self_managed_node_group_defaults.block_device_mappings, {})
#   capacity_reservation_specification = try(each.value.capacity_reservation_specification, var.self_managed_node_group_defaults.capacity_reservation_specification, {})
#   cpu_options                        = try(each.value.cpu_options, var.self_managed_node_group_defaults.cpu_options, {})
#   credit_specification               = try(each.value.credit_specification, var.self_managed_node_group_defaults.credit_specification, {})
#   elastic_gpu_specifications         = try(each.value.elastic_gpu_specifications, var.self_managed_node_group_defaults.elastic_gpu_specifications, {})
#   elastic_inference_accelerator      = try(each.value.elastic_inference_accelerator, var.self_managed_node_group_defaults.elastic_inference_accelerator, {})
#   enclave_options                    = try(each.value.enclave_options, var.self_managed_node_group_defaults.enclave_options, {})
#   hibernation_options                = try(each.value.hibernation_options, var.self_managed_node_group_defaults.hibernation_options, {})
#   instance_requirements              = try(each.value.instance_requirements, var.self_managed_node_group_defaults.instance_requirements, {})
#   instance_market_options            = try(each.value.instance_market_options, var.self_managed_node_group_defaults.instance_market_options, {})
#   license_specifications             = try(each.value.license_specifications, var.self_managed_node_group_defaults.license_specifications, {})
#   metadata_options                   = try(each.value.metadata_options, var.self_managed_node_group_defaults.metadata_options, local.metadata_options)
#   enable_monitoring                  = try(each.value.enable_monitoring, var.self_managed_node_group_defaults.enable_monitoring, true)
#   network_interfaces                 = try(each.value.network_interfaces, var.self_managed_node_group_defaults.network_interfaces, [])
#   placement                          = try(each.value.placement, var.self_managed_node_group_defaults.placement, {})
#   maintenance_options                = try(each.value.maintenance_options, var.self_managed_node_group_defaults.maintenance_options, {})
#   private_dns_name_options           = try(each.value.private_dns_name_options, var.self_managed_node_group_defaults.private_dns_name_options, {})
#
#   # IAM role
#   create_iam_instance_profile   = try(each.value.create_iam_instance_profile, var.self_managed_node_group_defaults.create_iam_instance_profile, true)
#   iam_instance_profile_arn      = try(each.value.iam_instance_profile_arn, var.self_managed_node_group_defaults.iam_instance_profile_arn, null)
#   iam_role_name                 = try(each.value.iam_role_name, var.self_managed_node_group_defaults.iam_role_name, null)
#   iam_role_use_name_prefix      = try(each.value.iam_role_use_name_prefix, var.self_managed_node_group_defaults.iam_role_use_name_prefix, true)
#   iam_role_path                 = try(each.value.iam_role_path, var.self_managed_node_group_defaults.iam_role_path, null)
#   iam_role_description          = try(each.value.iam_role_description, var.self_managed_node_group_defaults.iam_role_description, "Self managed node group IAM role")
#   iam_role_permissions_boundary = try(each.value.iam_role_permissions_boundary, var.self_managed_node_group_defaults.iam_role_permissions_boundary, null)
#   iam_role_tags                 = try(each.value.iam_role_tags, var.self_managed_node_group_defaults.iam_role_tags, {})
#   iam_role_attach_cni_policy    = try(each.value.iam_role_attach_cni_policy, var.self_managed_node_group_defaults.iam_role_attach_cni_policy, true)
#   # To better understand why this `lookup()` logic is required, see:
#   # https://github.com/hashicorp/terraform/issues/31646#issuecomment-1217279031
#   iam_role_additional_policies = lookup(each.value, "iam_role_additional_policies", lookup(var.self_managed_node_group_defaults, "iam_role_additional_policies", {}))
#
#   # Security group
#   vpc_security_group_ids            = compact(concat([local.node_security_group_id], try(each.value.vpc_security_group_ids, var.self_managed_node_group_defaults.vpc_security_group_ids, [])))
#   cluster_primary_security_group_id = try(each.value.attach_cluster_primary_security_group, var.self_managed_node_group_defaults.attach_cluster_primary_security_group, false) ? aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id : null
#
#   tags = merge(var.tags, try(each.value.tags, var.self_managed_node_group_defaults.tags, {}))
# }
