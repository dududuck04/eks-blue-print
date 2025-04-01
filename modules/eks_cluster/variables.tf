#####################
# default tag
#####################
variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = ""
}

variable "env" {
  default = ""
}

variable "pjt" {
  description = "프로젝트명"
  default     = ""
}

variable "service_id" {
  default = "" //Web Eks Rds
}

variable "costc" {
  default = ""
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


variable "github_repo" {
  type        = string
  description = "테라폼 코드 리포"
  default     = ""
}

variable "github_path" {
  type        = string
  description = "테라폼 코드 경로"
  default     = ""
}

variable "github_revision" {
  type        = string
  description = "테라폼 코드 브랜치"
  default     = ""
}

variable "prefix_separator" {
  description = "The separator to use between the prefix and the generated timestamp for resource names"
  type        = string
  default     = "-"
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = null
}

################################################################################
# Cluster
################################################################################
variable "create_cluster" {
  description = "Controls if EKS resources should be created"
  type        = bool
  default     = true
}

variable "cluster_tags" {
  description = "A map of additional tags to add to the cluster"
  type        = map(string)
  default     = {
    Service = "eks"
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
  type        = string
  default     = null
}

variable "eks_cluster_upgrade_policy" {
  type        = string
  default     = "EXTENDED"
  description = "EKS Cluster Upgrade policy"
  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.eks_cluster_upgrade_policy)
    error_message = "Err: EKS Cluster 업그레이드 정책값이 유효하지 않습니다. 유효한 값은 'STANDARD', 'EXTENDED' 입니다."
  }
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
}

variable "private_subnet" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "private_subnet_name" {
  description = "private subnet name for eks cluster provisioning"
  type        = string
  default     = ""
}

variable "pod_subnet" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "pod_subnet_name" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = string
  default     = ""
}

variable "public_subnet" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses. Valid values are `ipv4` (default) and `ipv6`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created"
  type        = string
  default     = null
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks"
  type        = string
  default     = null
}

variable "cluster_service_ipv6_cidr" {
  description = "The CIDR block to assign Kubernetes pod and service IP addresses from if `ipv6` was specified when the cluster was created. Kubernetes assigns service addresses from the unique local address range (fc00::/7) because you can't specify a custom IPv6 CIDR block when you create the cluster"
  type        = string
  default     = null
}

variable "outpost_config" {
  description = "Configuration for the AWS Outpost to provision the cluster on"
  type        = any
  default     = {}
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}`"
  type        = any
  default = {
    resources = ["secrets"]
  }
}

variable "attach_cluster_encryption_policy" {
  description = "Indicates whether or not to attach an additional policy for the cluster IAM role to utilize the encryption key provided"
  type        = bool
  default     = true
}

variable "cluster_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default     = {}
}

################################################################################
# KMS Key
################################################################################
variable "create_kms_key" {
  description = "Controls if a KMS key for cluster encryption should be created"
  type        = bool
  default     = true
}

variable "kms_tags" {
  description = "A map of additional tags to add to the cluster"
  type        = map(string)
  default     = {
    Service = "kms"
  }
}

variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = null
}

variable "kms_key_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = null
}

variable "enable_kms_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}

variable "kms_key_enable_default_policy" {
  description = "Specifies whether to enable the default key policy. Defaults to `false`"
  type        = bool
  default     = false
}

variable "kms_key_owners" {
  description = "A list of IAM ARNs for those who will have full key permissions (`kms:*`)"
  type        = list(string)
  default     = []
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for [key administrators](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators). If no value is provided, the current caller identity is used to ensure at least one key admin is available"
  type        = list(string)
  default     = []
}

variable "kms_key_users" {
  description = "A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users)"
  type        = list(string)
  default     = []
}

variable "kms_key_service_users" {
  description = "A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration)"
  type        = list(string)
  default     = []
}

variable "kms_key_source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "kms_key_override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "kms_key_aliases" {
  description = "A list of aliases to create. Note - due to the use of `toset()`, values must be static strings and not computed values"
  type        = list(string)
  default     = []
}

################################################################################
# CloudWatch Log Group
################################################################################
variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_tags" {
  description = "A map of additional tags to add to the cluster"
  type        = map(string)
  default     = {
    Service = "cloud watch"
  }
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

################################################################################
# Cluster Security Group
################################################################################
variable "create_primary_cluster_security_group" {
  description = "Determines if a security group is created for the cluster. Note: the EKS service creates a primary security group for the cluster by default"
  type        = bool
  default     = true
}

variable "cluster_security_group_tags" {
  description = "A map of additional tags to add to the cluster security group created"
  type        = map(string)
  default     = {
    Service = "security group"
  }
}

variable "primary_cluster_security_group_name" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
  default     = ""
}

variable "additional_cluster_security_group_name" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
  default     = ""
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
}

variable "cluster_security_group_use_name_prefix" {
  description = "Determines whether cluster security group name (`cluster_security_group_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "cluster_security_group_description" {
  description = "Description of the cluster security group created"
  type        = string
  default     = "EKS cluster security group"
}

################################################################################
# EKS IPV6 CNI Policy
################################################################################
variable "create_cni_ipv6_iam_policy" {
  description = "Determines whether to create an [`AmazonEKS_CNI_IPv6_Policy`](https://docs.aws.amazon.com/eks/latest/userguide/cni-iam-role.html#cni-iam-role-create-ipv6-policy)"
  type        = bool
  default     = false
}

################################################################################
# Node Security Group
################################################################################

variable "create_node_security_group" {
  description = "Determines whether to create a security group for the node groups or use the existing `node_security_group_id`"
  type        = bool
  default     = true
}

variable "create_additional_security_group" {
  description = "Determines whether to create a security group for the node groups or use the existing `node_security_group_id`"
  type        = bool
  default     = true
}

variable "node_security_group_id" {
  description = "ID of an existing security group to attach to the node groups created"
  type        = string
  default     = ""
}

variable "node_cluster_security_group_name" {
  description = "Name to use on node security group created"
  type        = string
  default     = null
}

variable "node_security_group_description" {
  description = "Description of the node security group created"
  type        = string
  default     = "EKS node shared security group"
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source"
  type        = any
  default     = {}
}

variable "node_security_group_enable_recommended_rules" {
  description = "Determines whether to enable recommended security group rules for the node security group created. This includes node-to-node TCP ingress on ephemeral ports and allows all egress traffic"
  type        = bool
  default     = true
}

variable "node_security_group_tags" {
  description = "A map of additional tags to add to the node security group created"
  type        = map(string)
  default     = {}
}

################################################################################
# IRSA
################################################################################
variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "openid_connect_audiences" {
  description = "List of OpenID Connect audience client IDs to add to the IRSA provider"
  type        = list(string)
  default     = []
}

variable "custom_oidc_thumbprints" {
  description = "Additional list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  type        = list(string)
  default     = []
}

################################################################################
# Cluster IAM Role
################################################################################
variable "create_cluster_iam_role" {
  description = "Determines whether a an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {
    Service = "rol"
  }
}

variable "cluster_policy_tags" {
  description = "A map of additional tags to add to the cluster"
  type        = map(string)
  default     = {
    Service = "pol"
  }
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the cluster. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "cluster_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "Cluster IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "cluster_iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = map(string)
  default     = {}
}

# TODO - hopefully this can be removed once the AWS endpoint is named properly in China
# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1904
variable "cluster_iam_role_dns_suffix" {
  description = "Base DNS domain name for the current partition (e.g., amazonaws.com in AWS Commercial, amazonaws.com.cn in AWS China)"
  type        = string
  default     = null
}

variable "cluster_encryption_policy_use_name_prefix" {
  description = "Determines whether cluster encryption policy name (`cluster_encryption_policy_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "cluster_encryption_policy_name" {
  description = "Name to use on cluster encryption policy created"
  type        = string
  default     = null
}

variable "cluster_encryption_policy_description" {
  description = "Description of the cluster encryption policy created"
  type        = string
  default     = "Cluster encryption policy to allow cluster role to utilize CMK provided"
}

variable "cluster_encryption_policy_path" {
  description = "Cluster encryption policy path"
  type        = string
  default     = null
}

variable "dataplane_wait_duration" {
  description = "Duration to wait after the EKS cluster has become active before creating the dataplane components (EKS managed nodegroup(s), self-managed nodegroup(s), Fargate profile(s))"
  type        = string
  default     = "30s"
}

################################################################################
# EKS Addons
################################################################################


variable "cluster_addons" {
  description = "사용자 정의 클러스터 애드온 구성"
  type        = any
  default     = {}
}

variable "cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type        = map(string)
  default     = {}
}

################################################################################
# EKS Identity Provider
################################################################################

variable "cluster_identity_providers" {
  description = "Map of cluster identity provider configurations to enable for the cluster. Note - this is different/separate from IRSA"
  type        = any
  default     = {}
}

################################################################################
# Fargate
################################################################################

variable "fargate_profiles" {
  description = "Map of Fargate Profile definitions to create"
  type        = any
  default     = {}
}

variable "fargate_profile_defaults" {
  description = "Map of Fargate Profile default configurations"
  type        = any
  default     = {}
}

################################################################################
# Self Managed Node Group
################################################################################
variable "self_managed_node_groups" {
  description = "Map of self-managed node group definitions to create"
  type        = any
  default     = {}
}

variable "self_managed_node_group_defaults" {
  description = "Map of self-managed node group default configurations"
  type        = any
  default     = {}
}

################################################################################
# EKS Managed Node Group
################################################################################

variable "eks_managed_node_groups" {
  description = "List of EKS managed node group definitions to create"
  type = list(object({
    name                       = string
    use_name_prefix            = optional(bool, false)
    min_size                   = number
    desired_size               = number
    max_size                   = number
    create_node_security_group = optional(bool, false)
    node_security_group_name   = optional(string, null)
    taints                     = optional(list(map(string)), [])
    labels                     = optional(map(string), {})
  }))
  default = []
}

variable "eks_managed_node_group_defaults" {
  description = "Default configurations for EKS Managed Node Groups"
  type        = any
  default = {

    use_name_prefix = false
    ########################################################################
    # 노드 그룹의 기본 스케일, 인스턴스 타입, AMI 설정
    ########################################################################
    instance_types       = ["t3.medium"]
    min_size            = 1
    max_size            = 3
    desired_size        = 1
    capacity_type       = "ON_DEMAND"
    disk_size           = 20                  # EKS NodeGroup에서 기본 디스크 사이즈
    force_update_version = false

    # AMI 관련
    ami_id              = null                  # 사용자 정의 AMI를 사용하지 않는다면 "" 유지
    ami_type            = null                # "AL2_x86_64", "AL2_x86_64_GPU", etc.
    ami_release_version = null                # 예: "1.27.14-20230901", 없으면 null

    ########################################################################
    # 플랫폼/부트스트랩 설정
    ########################################################################
    platform                    = "linux"
    cluster_endpoint            = ""
    cluster_auth_base64         = ""
    cluster_service_ipv4_cidr   = ""
    enable_bootstrap_user_data  = false
    pre_bootstrap_user_data     = ""
    post_bootstrap_user_data    = null
    bootstrap_extra_args        = ""
    user_data_template_path     = ""

    ########################################################################
    # 기타 NodeGroup 파라미터
    ########################################################################
    labels         = {}
    remote_access  = {}
    taints         = []
    update_config  = { max_unavailable_percentage = 33 }
    timeouts       = {}

    ########################################################################
    # Launch Template 설정
    ########################################################################
    create_launch_template                 = true
    use_custom_launch_template             = true
    launch_template_id                     = null
    launch_template_name                   = null
    launch_template_use_name_prefix        = false
    launch_template_version                = null
    launch_template_default_version        = null
    update_launch_template_default_version = true
    launch_template_description            = null
    launch_template_tags                   = {}
    tag_specifications                     = ["instance", "volume", "network-interface"]

    ebs_optimized           = null
    key_name                = null
    disable_api_termination = null
    kernel_id               = null
    ram_disk_id             = null

    # 블록 디바이스(루트볼륨 등) 상세 설정
    block_device_mappings              = {}
    capacity_reservation_specification = {}
    cpu_options                        = {}
    credit_specification               = {}
    elastic_gpu_specifications         = []
    elastic_inference_accelerator      = {}
    enclave_options                    = {}
    instance_market_options            = {}
    license_specifications             = {}
    metadata_options                   = {}
    enable_monitoring                  = true
    network_interfaces                 = []
    placement                          = {}
    maintenance_options                = {}
    private_dns_name_options           = {}

    ########################################################################
    # IAM Role 관련
    ########################################################################
    create_iam_role               = true
    iam_role_arn                  = null
    iam_role_name                 = null
    iam_role_use_name_prefix      = false
    iam_role_path                 = null
    iam_role_description          = "EKS managed node group IAM role"
    iam_role_permissions_boundary = null
    iam_role_tags                 = {}
    iam_role_attach_cni_policy    = true
    iam_role_additional_policies  = {}

    ########################################################################
    # Autoscaling Schedule
    ########################################################################
    create_schedule = false
    schedules       = {}

    ########################################################################
    # 보안 그룹
    ########################################################################
    # 보통 Node Group에 붙일 SG가 별도로 없다면 빈 리스트로 남김
    vpc_security_group_ids = []
    attach_cluster_primary_security_group = true

    ########################################################################
    # 태그
    ########################################################################
    tags = {}
  }
}

variable "eks_managed_node_group_add_role" {
  description = "Additional IAM role policies for EKS managed node groups."
  type        = map(string)
  default = {
    "AmazonSSMManagedInstanceCore" = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

# Access Entries
variable "authentication_mode" {
  type        = string
  default     = "API_AND_CONFIG_MAP"
  description = "클러스터가 인증된 IAM 보안 주체에 사용할 소스를 설정. (CONFIG_MAP|API_AND_CONFIG_MAP|API)"
  validation {
    condition     = contains(["CONFIG_MAP", "API_AND_CONFIG_MAP", "API"], var.authentication_mode)
    error_message = "Err: cluster_authentication_mode 값이 유효하지 않습니다. 유효한 값은 \"CONFIG_MAP|API_AND_CONFIG_MAP|API\" 중 하나입니다. "
  }
}

################################################################################
# aws-auth configmap
################################################################################

variable "manage_aws_auth_configmap" {
  description = "Determines whether to manage the aws-auth configmap"
  type        = bool
  default     = false
}

variable "create_aws_auth_configmap" {
  description = "Determines whether to create the aws-auth configmap. NOTE - this is only intended for scenarios where the configmap does not exist (i.e. - when using only self-managed node groups). Most users should use `manage_aws_auth_configmap`"
  type        = bool
  default     = false
}

variable "aws_auth_node_iam_role_arns_non_windows" {
  description = "List of non-Windows based node IAM role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_node_iam_role_arns_windows" {
  description = "List of Windows based node IAM role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_fargate_profile_pod_execution_role_arns" {
  description = "List of Fargate profile pod execution role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "before_compute" {
  description = "Determines if addons should be created before compute resources"
  type        = bool
  default     = true
}

variable "efs_id" {
  description = "EFS ID"
  type        = string
  default     = ""
}
