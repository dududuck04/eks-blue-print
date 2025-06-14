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

variable "pod_subnet_info" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = any
  default     = {}
}

variable "public_subnet" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "enable_ipv6" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = bool
  default     = false
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
  default     = "ipv4"
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

variable "create_additional_cluster_security_group" {
  description = "Existing security group ID to be attached to the cluster"
  type        = bool
  default     = true
}

variable "additional_cluster_security_group_name" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
  default     = ""
}

variable "additional_cluster_security_group_extra_rules" {
  description = "Existing security group ID to be attached to the cluster"
  type        = any
  default     = []
}

variable "additional_cluster_security_group_description" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
  default     = "EKS cluster shared security group"
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


variable "additional_cluster_security_group_use_name_prefix" {
  description = "Determines whether to create a security group for the node groups or use the existing `node_security_group_id`"
  type        = bool
  default     = false
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

variable "iam_role_max_session_duration" {
  description = "Description of the role"
  type        = number
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_template_root" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "cluster_iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = list(object({
    name         = string
    description  = string
    policy_path  = string
  }))
  default     = []
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

variable "cluster_version" {
  description = "EKS 클러스터 버전, 없으면 데이터소스에서 가져옵니다"
  type        = string
  default     = null
}

variable "enable_amazon_eks_vpc_cni" {
  description = "EKS 관리형 VPC CNI 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_vpc_cni_config" {
  description = "EKS 관리형 VPC CNI 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_coredns" {
  description = "EKS 관리형 CoreDNS 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_coredns_config" {
  description = "EKS 관리형 CoreDNS 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_kube_proxy" {
  description = "EKS 관리형 kube-proxy 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_kube_proxy_config" {
  description = "EKS 관리형 kube-proxy 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_aws_ebs_csi_driver" {
  description = "EKS 관리형 AWS EBS CSI 드라이버 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_aws_ebs_csi_driver_config" {
  description = "EKS 관리형 AWS EBS CSI 드라이버 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_aws_efs_csi_driver" {
  description = "EKS 관리형 AWS EFS CSI 드라이버 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_aws_efs_csi_driver_config" {
  description = "EKS 관리형 AWS EFS CSI 드라이버 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_aws_metrics_server" {
  description = "EKS 관리형 AWS METRICS SERVER 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_aws_metrics_server_config" {
  description = "EKS 관리형 AWS METRICS SERVER 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "enable_amazon_eks_pod_identity_agent" {
  description = "EKS 관리형 AWS POD IDENTITY AGENT 애드온 활성화 여부"
  type        = bool
  default     = false
}

variable "amazon_eks_pod_identity_agent_config" {
  description = "EKS 관리형 AWS POD IDENTITY AGENT 애드온 설정값 맵"
  type        = any
  default     = {}
}

variable "hosted_zone_domain" {
  type        = string
  description = "호스티드 존 도메인 (예: dev.kimkm.com)"
  default     = ""
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
  description = "List of Fargate Profile definitions to create"
  type = list(object({
    name                        = string
    create                      = optional(bool, true)
    subnet_ids                  = optional(list(string))
    selectors                   = optional(list(object({
      namespace = string
      labels    = map(string)
    })))

    iam_role_name               = optional(string)
    iam_role_use_name_prefix    = optional(bool, false)
    iam_role_additional_policies = optional(map(any), {})
    tags                        = optional(map(string))
  }))
  default = []
}


variable "fargate_profile_defaults" {
  description = "Map of Fargate Profile default configurations"
  type        = any
  default = {
    # Fargate Profile 기본 생성 여부
    create                      = true

    # 네트워크 관련
    subnet_ids = []
    selectors  = []

    # IAM 역할 관련 (fargate_profiles에는 iam_role_name이 있지만, 기본값으로 다른 IAM 관련 설정도 함께 사용할 수 있음)
    iam_role_name               = "kkm-poc-fargate-profile-role"    # 비워두거나 필요에 따라 기본 IAM 역할 이름 지정
    iam_role_use_name_prefix    = false
    create_iam_role             = true
    iam_role_path               = null
    iam_role_arn                = null
    iam_role_permissions_boundary = null
    iam_role_tags               = {}
    iam_role_description        = "Fargate profile IAM role"
    iam_role_attach_cni_policy  = true
    iam_role_additional_policies = []

    # 추가 태그
    tags = {}

    # (필요 시) 시간 제한 등 추가 옵션도 defaults에 포함할 수 있음
    timeouts = {
      create = "10m"
      delete = "5m"
    }
  }
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
# EKS Fargate Profile
################################################################################

################################################################################
# EKS Managed Node Group
################################################################################

variable "eks_managed_node_groups" {
  description = "List of EKS managed node group definitions to create"
  type = list(object({
    name                       = string
    create                     = bool
    use_name_prefix            = optional(bool, false)
    capacity_type              = optional(string, "ON_DEMAND")
    instance_types             = optional(list(string), ["t3.medium"])
    spot_instance_type         = optional(list(string), ["t3a.small", "t3a.medium", "t3a.large", "c5.large", "m5a.large"])
    min_size                   = number
    desired_size               = number
    max_size                   = number
    disk_size                  = optional(number, 30)
    ami_id                     = optional(string)
    ami_type                   = optional(string, "AL2023_x86_64_STANDARD")
    is_eks_managed_node_group  = optional(bool, true)
    launch_template_name       = optional(string)
    enable_user_data           = optional(bool, true)
    user_data_template_path    = optional(string)
    cloudinit_post_nodeadm_path     = optional(string)
    cloudinit_pre_nodeadm_path      = optional(string)

    create_iam_role                         = optional(bool, true)
    iam_role_name                           = optional(string)
    iam_role_additional_policies            = optional(list(string), [])
    custom_iam_role_additional_policies     = optional(list(object({
      name            = string
      description     = string
      policy_path     = string
    })), [])
    create_node_security_group = optional(bool, false)
    node_security_group_name   = optional(string, null)
    additional_node_security_group_extra_rules  = optional(any, [])

    taints                     = optional(list(map(string)), [])
    labels                     = optional(map(string), {})
  }))
  default = []
}

variable "eks_managed_node_group_defaults" {
  description = "Default configurations for EKS Managed Node Groups"
  type = object({
    use_name_prefix                         = optional(bool, false)
    instance_types                          = optional(list(string), ["t3.medium"])
    spot_instance_type                      = optional(list(string), ["t3a.small", "t3a.medium", "t3a.large", "c5.large", "m5a.large"])
    min_size                                = optional(number, 1)
    max_size                                = optional(number, 5)
    desired_size                            = optional(number, 2)
    capacity_type                           = optional(string, "ON_DEMAND")
    disk_size                               = optional(number, 30)
    force_update_version                    = optional(bool, false)

    # AMI settings
    ami_id                                  = optional(string)
    ami_type                                = optional(string, "AL2023_x86_64_STANDARD")
    ami_release_version                     = optional(string)
    is_eks_managed_node_group               = optional(bool, true)

    # Platform & cluster info
    platform                                = optional(string, "linux")
    cluster_endpoint                        = optional(string)
    cluster_auth_base64                     = optional(string)

    # Bootstrap user data
    enable_bootstrap_user_data              = optional(bool, false)
    pre_bootstrap_user_data                 = optional(string)
    post_bootstrap_user_data                = optional(string)
    bootstrap_extra_args                    = optional(string)
    user_data_template_path                 = optional(string)
    cloudinit_post_nodeadm_path             = optional(string)
    cloudinit_pre_nodeadm_path              = optional(string)

    # Labels & taints
    labels                                  = optional(map(string), {})
    taints                                  = optional(list(map(string)), [])

    # Networking & security
    remote_access                           = optional(any, {})
    vpc_security_group_ids                  = optional(list(string), [])
    attach_cluster_primary_security_group   = optional(bool, true)

    # Update & scheduling
    update_config                           = optional(any, { max_unavailable_percentage = 33 })
    timeouts                                = optional(any, {})
    create_schedule                         = optional(bool, false)
    schedules                               = optional(any, {})

    # Launch template options
    create_launch_template                  = optional(bool, true)
    use_custom_launch_template              = optional(bool, true)
    launch_template_id                      = optional(string)
    launch_template_name                    = optional(string)
    launch_template_use_name_prefix         = optional(bool, false)
    launch_template_version                 = optional(string)
    launch_template_default_version         = optional(string)
    update_launch_template_default_version  = optional(bool, true)
    launch_template_description             = optional(string)
    launch_template_tags                    = optional(map(string), {})
    tag_specifications                      = optional(list(string), ["instance", "volume", "network-interface"])

    # EBS & instance options
    ebs_optimized                           = optional(bool)
    key_name                                = optional(string)
    disable_api_termination                  = optional(bool)
    kernel_id                               = optional(string)
    ram_disk_id                             = optional(string)
    block_device_mappings                   = optional(any, {})
    capacity_reservation_specification      = optional(any, {})
    cpu_options                             = optional(any, {})
    credit_specification                    = optional(any, {})
    elastic_gpu_specifications              = optional(list(any), [])
    elastic_inference_accelerator           = optional(any, {})
    enclave_options                         = optional(any, {})
    instance_market_options                 = optional(any, {})
    license_specifications                  = optional(any, {})
    metadata_options                        = optional(any, {})

    # Monitoring
    enable_monitoring                       = optional(bool, true)
    network_interfaces                      = optional(list(object({})),[])
    placement                               = optional(map(string), {})
    maintenance_options                     = optional(object({}), {})
    private_dns_name_options                = optional(object({}), {})

    # IAM role settings
    create_iam_role                         = optional(bool, true)
    iam_role_arn                            = optional(string)
    iam_role_name                           = optional(string)
    iam_role_use_name_prefix                = optional(bool, false)
    iam_role_path                           = optional(string)
    iam_role_description                    = optional(string, "EKS managed node group IAM role")
    iam_role_permissions_boundary           = optional(string)
    iam_role_tags                           = optional(map(string), {})
    iam_role_attach_cni_policy              = optional(bool, true)
    iam_role_additional_policies            = optional(list(string), [])
    custom_iam_role_additional_policies     = optional(list(object({
      name            = string
      description     = string
      policy_path     = string
    })), [])

    # Tags
    tags                                    = optional(map(string), {})
  })

  default = {}
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

variable "cluster_managed_iam_role_additional_policies" {
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

variable "eks_oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  type        = string
  default     = null
}

variable "eks_oidc_provider_arn" {
  description = "The OpenID Connect identity provider ARN"
  type        = string
  default     = null
}

variable "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type        = string
  default     = null
}

variable "eks_cluster_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = null
}

variable "irsa_iam_role_path" {
  description = "IAM role path for IRSA roles"
  type        = string
  default     = "/"
}

variable "irsa_iam_permissions_boundary" {
  description = "IAM permissions boundary for IRSA roles"
  type        = string
  default     = ""
}
