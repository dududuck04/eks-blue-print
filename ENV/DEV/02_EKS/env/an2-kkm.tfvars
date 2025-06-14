#####################
# default tag
#####################
region = "ap-northeast-2"
env = "poc"
pjt = "kkm"
service_id = "eks_sandbox"
costc = "payer"
github_repo = ""
github_path = ""
github_revision = ""

vpc_name = "poc-kkm-vpc"
cluster_name = "poc-kkm-cluster"
private_subnet_name = "poc-kkm-eks-private-subnet-an2*"
pod_subnet_name = "poc-kkm-pod-private-subnet-an2*"
cluster_endpoint_public_access = true

# cluster_ip_family = ""

create_kms_key = false
create_additional_cluster_security_group = true
additional_cluster_security_group_name ="poc-kkm-cluster-add-sg"
additional_cluster_security_group_extra_rules = []
# additional_cluster_security_group_extra_rules = [
#   {
#     rule        = "HTTPS"
#     cidr_blocks = "10.0.1.0/24,192.168.1.0/24"
#     description = "Allow HTTPS from internal subnets"
#   },
#   {
#     from_port   = 2222
#     to_port     = 2222
#     protocol    = "tcp"
#     cidr_blocks = "10.0.2.0/24"
#     description = "Allow SSH (port 2222) from specific subnet"
#   },
# ]

cluster_iam_role_name = "poc-kkm-eks-cluster-rol"
cluster_managed_iam_role_additional_policies = []
cluster_iam_role_additional_policies = [{
  name            = "poc-kkm-eks-cluster-pol"
  description     = "EKS Cluster가 S3 버킷에 접근하도록 허용하는 정책"
  policy_path     = "policies/eks-access-s3"
}]

enable_amazon_eks_vpc_cni = true
amazon_eks_vpc_cni_config = {
  addon_version = "v1.19.5-eksbuild.3"
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
  eks_vpc_cni_eniconfig_additional_security_group = []
  role_type           = "service_account"
  irsa_iam_role_name  = "poc-kkm-eks-vpc-cni-rol"
  irsa_iam_role_policy = "poc-kkm-eks-vpc-cni-pol"
  service_account_role_arn = ""
  additional_iam_policies = []
  resolve_conflicts = "OVERWRITE"
  preserve          = false
  tags = {
  }
}

enable_amazon_eks_coredns = true
amazon_eks_coredns_config = {
  addon_version = "v1.11.4-eksbuild.14"
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  preserve          = true
  tags = {
  }
}

enable_amazon_eks_kube_proxy = true
amazon_eks_kube_proxy_config = {
  addon_version = "v1.32.3-eksbuild.7"
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  preserve          = true
  tags = {
  }
}

enable_amazon_eks_aws_ebs_csi_driver = true
amazon_eks_aws_ebs_csi_driver_config = {
  addon_version = "v1.44.0-eksbuild.1"
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  irsa_iam_role_name  = "poc-kkm-eks-ebs-driver-rol"
  irsa_iam_role_policy = "poc-kkm-eks-ebs-driver-pol"
  role_type           = "service_account"
  preserve          = true
  tags = {
  }
}

enable_amazon_eks_aws_efs_csi_driver = true
amazon_eks_aws_efs_csi_driver_config = {
  addon_version = "v2.1.8-eksbuild.1"
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  role_type           = "service_account"
  irsa_iam_role_name  = "poc-kkm-eks-efs-driver-rol"
  irsa_iam_role_policy = "poc-kkm-eks-efs-driver-pol"
  preserve          = true
  storage_class_name  = "default-efs"
  efs_id              = "fs-07ed21fdaca9ec0cc"
  tags = {
  }
}

enable_amazon_eks_aws_metrics_server = true
amazon_eks_aws_metrics_server_config = {
  addon_version = "v0.7.2-eksbuild.3"
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  preserve          = true
  tags = {
  }
}

enable_amazon_eks_pod_identity_agent = true
amazon_eks_pod_identity_agent_config = {
  addon_version = null
  configuration_values = {}
  resolve_conflicts = "OVERWRITE"
  preserve          = true
  tags = {
  }
}

eks_managed_node_groups = [
  {
    name                       = "worker1"
    create                     = true
    use_name_prefix            = false
    capacity_type              = "SPOT"
    instance_types             = ["t3.medium"]
    spot_instance_type         = ["t3.medium", "t3.large" ,"t3a.small", "t3a.medium","t3a.large", "c5.large", "m5a.large"]
    min_size                   = 1
    desired_size               = 2
    max_size                   = 10
    create_node_security_group = true
    node_security_group_name   = "worker1-sg"
    launch_template_name       = "worker1-eks-node-group-lt"
    iam_role_name              = "worker1-iamrol"
    iam_role_additional_policies = ["AmazonSSMFullAccess"]
    custom_iam_role_additional_policies = [{
      name            = "poc-kkm-node-group-ec2-tag-pol"
      description     = "EKS NodeGroup이 EC2 tag 허용 정책"
      policy_path     = "policies/eks-ec2-tag"
    }]
    is_eks_managed_node_group   = true
    enable_user_data            = true
    cloudinit_post_nodeadm_path = "templates/post_nodeadm_cloudinit.tpl"
    taints                      = []
    labels                      = {
      "nodegroup" = "worker1"
    }
    tags                        = {}
  },
  {
    name                       = "worker2"
    create                     = true
    use_name_prefix            = false
    capacity_type              = "SPOT"
    instance_types             = ["t3.medium"]
    spot_instance_type         = ["t3.medium", "t3.large" ,"t3a.small", "t3a.medium","t3a.large", "c5.large", "m5a.large"]
    min_size                   = 1
    desired_size               = 2
    max_size                   = 10
    create_node_security_group = true
    node_security_group_name   = "worker2-sg"
    launch_template_name       = "worker2-eks-node-group-lt"
    iam_role_name              = "worker2-iamrol"
    iam_role_additional_policies = ["AmazonSSMFullAccess"]
    custom_iam_role_additional_policies = [{
      name            = "poc-kkm-node-group-ec2-tag-pol"
      description     = "EKS NodeGroup이 EC2 tag 허용 정책"
      policy_path     = "policies/eks-ec2-tag"
    }]
    is_eks_managed_node_group   = true
    enable_user_data            = true
    cloudinit_post_nodeadm_path = "templates/post_nodeadm_cloudinit.tpl"
    taints                      = []
    labels                      = {}
    tags                        = {}

  },
  {
    name                       = "worker3"
    create                     = false
    use_name_prefix            = false
    capacity_type              = "SPOT"
    instance_types             = ["t3.medium"]
    spot_instance_type         = ["t3.medium", "t3.large" ,"t3a.small", "t3a.medium","t3a.large", "c5.large", "m5a.large"]
    min_size                   = 1
    desired_size               = 2
    max_size                   = 10
    create_node_security_group = true
    node_security_group_name   = "worker3-sg"
    launch_template_name       = "worker3-eks-node-group-lt"
    iam_role_name              = "worker3-iamrol"
    iam_role_additional_policies = ["AmazonSSMFullAccess"]
    custom_iam_role_additional_policies = [{
      name            = "poc-kkm-node-group-ec2-tag-pol"
      description     = "EKS NodeGroup이 EC2 tag 허용 정책"
      policy_path     = "policies/eks-ec2-tag"
    }]
    is_eks_managed_node_group   = true
    enable_user_data            = true
    cloudinit_post_nodeadm_path = "templates/post_nodeadm_cloudinit.tpl"
    taints                      = []
    labels                      = {}
    tags                        = {}
  },
  # {
  #   name                       = "karpenter"
  #   create                     = false
  #   use_name_prefix            = false
  #   capacity_type              = "ON_DEMAND"
  #   instance_types             = ["t3.small"]
  #   spot_instance_type         = ["t3.medium", "t3.large" ,"t3a.small", "t3a.medium","t3a.large", "c5.large", "m5a.large"]
  #   min_size                   = 2
  #   desired_size               = 2
  #   max_size                   = 10
  #   create_node_security_group = true
  #   node_security_group_name   = "karpenter-security-group"
  #   enable_bootstrap_user_data = true
  #   user_data_template_path    = "template/al2023_nodegroup_userdata.tpl"
  #   taints = [{
  #     key    = "karpenter"
  #     value  = "true"
  #     effect = "NO_SCHEDULE"
  #   }]
  #   labels                     = {
  #     "karpenter.sh/controller" = "true"
  #     "nodegroup"               = "karpenter-controller"
  #   }
  # }
]

fargate_profiles = [
  {
    name                          = "karpenter"
    create                        = false
    selectors                     = [
      {
        namespace                   = "karpenter"
        labels                      = {
          "karpenter.sh/controller" = "true"
        }
      }
    ]
    iam_role_name               = "poc-kkm-karpenter-controller-rol"
    tags = {}
  }
]

hosted_zone_domain  = "cnp.mzcstc.com"

## git config --global credential.helper "cache --timeout=86400"
# [profile mzc-pops-cnps]
# role_arn = arn:aws:iam::539666729110:role/poc-kkm-eks-admin-role
# region = ap-northeast-2
# credential_source = Ec2InstanceMetadata
# output = json