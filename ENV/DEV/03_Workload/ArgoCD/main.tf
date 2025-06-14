locals {
  create_argocd_sg = var.enable_argocd && var.create_argocd_sg
  argocd_sg_id = length(data.aws_security_group.argocd_sg.id) > 0 ? data.aws_security_group.argocd_sg.id[0] : null
}

module "argocd_alb_sg" {
  source = "../../../../modules/security_group"

  create_sg                 = local.create_argocd_sg
  name                      = var.argocd_alb_security_group_name
  use_name_prefix           = var.argocd_alb_security_group_name_use_name_prefix
  description               = var.argocd_alb_security_group_description

  vpc_id                    = data.aws_vpc.vpc_id.id
  security_group_id         = local.argocd_sg_id

  ingress_rules             = ["https-443-tcp"]
  ingress_cidr_blocks       = ["0.0.0.0/0"]

  ingress_with_cidr_blocks  = []
  egress_rules              = ["all-all"]

  tags = {
    Name = var.argocd_alb_security_group_name
  }

}

################################################################################
# Argocd Admn Password
################################################################################
# 랜덤 패스워드 생성
# resource "random_password" "argocd" {
#   count            = var.create_argocd_admin_secret ? 1 : 0
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# 실제 secret 저장 (고정된 이름으로 alias처럼 사용)
# resource "aws_secretsmanager_secret" "argocd" {
#   count                   = var.create_argocd_admin_secret ? 1 : 0
#   name                    = var.argocd_admin_secret_name
#   recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
#   kms_key_id              = aws_kms_alias.argocd_alias.arn
#   tags = {
#     Terraform = "true"
#   }
# }

# secret 값 저장 (버전)
# resource "aws_secretsmanager_secret_version" "argocd" {
#   count         = var.create_argocd_admin_secret ? 1 : 0
#   secret_id     = aws_secretsmanager_secret.argocd[0].id
#   secret_string = jsonencode({ password = random_password.argocd[0].result })
# }
#
# resource "aws_kms_key" "argocd" {
#   description             = "KMS key for ArgoCD admin password secret"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
# }
#
# resource "aws_kms_alias" "argocd_alias" {
#   name          = var.argocd_kms_key_id
#   target_key_id = aws_kms_key.argocd.key_id
# }

# module "secret_manager" {
#   source = "../../../../modules/secret_manager"
#
#   env = var.env
#   pjt = var.pjt
#
#   secret_manager_info = local.secret_manager_info
# }

module "kubernetes_addons" {
  source = "../../../../modules/kubernetes_addons"

  ###############################
  # 필수 변수 및 클러스터 설정
  ###############################
  cluster_name               = data.aws_eks_cluster.this.name
  eks_cluster_id             = data.aws_eks_cluster.this.id
  eks_cluster_endpoint       = data.aws_eks_cluster.this.endpoint
  hosted_zone_domain         = var.hosted_zone_domain

  #---------------------------------------------------------------
  # ARGO CD ADD-ON
  #---------------------------------------------------------------
  enable_argocd         = var.enable_argocd
  argocd_manage_add_ons = var.argocd_manage_add_ons # Indicates that ArgoCD is responsible for managing/deploying Add-ons.

  # This example shows how to set default ArgoCD Admin Password using SecretsManager with Helm Chart set_sensitive values.
  argocd_helm_config = {
    values = [templatefile("${path.cwd}/templates/argocd_values.yaml.tftpl",
      {
        domain                  = var.hosted_zone_domain
        repository              = var.repository
        acm_arn                 = try(data.aws_acm_certificate.hosted_zoner_acm.arn , "")
        argocd_login_url        = var.argocd_login_url
        argocd_ingress_alb_name = var.argocd_ingress_alb_name
        alb_security_group_id   = aws_security_group.argocd_alb_sg[0].id
      }
    )],
    set_sensitive = [
      # {
      #   name  = "configs.secret.argocdServerAdminPassword"
      #   value = bcrypt(data.aws_secretsmanager_secret_version.admin_password_version.secret_string)
      # }
    ]
    # set = flatten([
    #   [
    #     {
    #       name  = "server.service.type"
    #       value = "LoadBalancer"
    #     }
    #   ],
    #   # directly set argocd config values
    #   local.argocd_oidc_config,
    #   local.okta_argocd_login_url,
    #   local.argocd_admin_enabled,
    # ])
  }

  # ArgoCD Root Application 설정
  # argocd_applications = {
  #   addons = {
  #     path                     = var.addons_repo_path
  #     repo_url                 = var.addons_repo_url
  #     target_revision          = var.addons_repo_revision
  #     repo_token_secret_name   = var.addons_repo_token
  #     # ssh_key_secret_name      = var.ssh_key_secret_name
  #     values = {
  #       targetRevision = var.addons_repo_revision
  #     }
  #     add_on_application = false
  #   }
  # }

  #---------------------------------------------------------------
  # EKS Managed Addons
  #---------------------------------------------------------------
  enable_argo_rollouts = false

  ### 아래는 향후 eni_config를 사용해서 secondary CIDR 구성을 하고자 할 경우, 그때 사용을 위해 보유 ###
  # amazon_eks_vpc_cni_config = {
  #   configuration_values = jsonencode({
  #     env = {
  #       # Reference https://aws.github.io/aws-eks-best-practices/reliability/docs/networkmanagement/#cni-custom-networking
  #       AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
  #       ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
  #     }
  #   })
  # }

  # enable_amazon_eks_vpc_cni            = true
  # enable_amazon_eks_coredns            = true
  # enable_amazon_eks_kube_proxy         = true
  # enable_amazon_eks_aws_ebs_csi_driver = true
  # amazon_eks_aws_ebs_csi_driver_config = {
  #   most_recent        = true
  #   kubernetes_version = "1.26"
  # }

  #---------------------------------------------------------------
  # ADD-ONS - You can add additional addons here
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/
  #---------------------------------------------------------------
  ### 아래의 aws_load_balancer_controller는 Ingress용 ALB를 생성하는 것임으로 Addons에서는 생성하지 않고, Workloads 워크스페이스에서 생성
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller_helm_config = {
    namespace       = "kube-system"
    service_account = "alb-controller-sa"
    set_values = [
      { name = "vpcId",                  value = data.aws_vpc.vpc_id.id },
      { name = "image.repository",       value = var.aws_load_balancer_controller_image_path },
      { name = "image.tag",              value = var.aws_load_balancer_controller_image_tag },
      { name = "helm_chart.version",       value = var.aws_load_balancer_controller_helm_chart },
    ]
  }

  enable_cluster_autoscaler = false
  cluster_autoscaler_helm_config = {
    namespace = "kube-system"
  }

  enable_external_secrets = false
  external_secrets_helm_config = {
    namespace = "addons"
  }

  enable_aws_efs_csi_driver = false
  aws_efs_csi_driver_helm_config = {
    namespace = "kube-system"
  }

  enable_aws_cloudwatch_metrics = false
  aws_cloudwatch_metrics_helm_config = {
    namespace = "addons"
  }

  enable_external_dns = false
  external_dns_helm_config = {
    namespace = "addons"
  }
  eks_cluster_domain = var.hosted_zone_domain

  enable_cert_manager = false
  cert_manager_helm_config = {
    namespace = "addons"
  }

  enable_aws_for_fluentbit = false
  aws_for_fluentbit_helm_config = {
    namespace = "addons"
  }
}
