module "Network" {
  source = "../../../modules/network"
  #version = "1.0.17"

  # 기본 변수
  pjt                 = var.pjt
  env                 = var.env
  service_id          = var.service_id
  region              = var.region

  # VPC 및 Subnet 구성
  vpc_cidr            = var.vpc_cidr
  bastion_cidr_block  = var.bastion_cidr_block
  create_bastion      = var.create_bastion
  bastion_username    = var.bastion_username
  secondary_cidr      = var.secondary_cidr

  # Subnet CIDR 설정
  puba_cidr           = var.puba_cidr
  pubb_cidr           = var.pubb_cidr
  pubc_cidr           = var.pubc_cidr
  pubd_cidr           = var.pubd_cidr
  pria_cidr           = var.pria_cidr
  prib_cidr           = var.prib_cidr
  pric_cidr           = var.pric_cidr
  prid_cidr           = var.prid_cidr
  pria_pod_cidr       = var.pria_pod_cidr
  prib_pod_cidr       = var.prib_pod_cidr
  pric_pod_cidr       = var.pric_pod_cidr
  prid_pod_cidr       = var.prid_pod_cidr
  pria_db_cidr        = var.pria_db_cidr
  prib_db_cidr        = var.prib_db_cidr
  pric_db_cidr        = var.pric_db_cidr
  prid_db_cidr        = var.prid_db_cidr

  # Direct Connect 및 Gateway 설정
  create_dx_gw        = var.create_dx_gw
  direct_connect_gw   = var.direct_connect_gw
  create_vpgw         = var.create_vpgw
  virtual_private_gw  = var.virtual_private_gw

  # Route53
  create_route53      = var.create_route53

  # NAT
  create_nat          = var.create_nat

  # VPC Endpoint 생성
  create_s3_vpcend    = var.create_s3_vpcend
  create_ecr_vpcend   = var.create_ecr_vpcend
  create_ec2_vpcend   = var.create_ec2_vpcend
  create_sts_vpcend   = var.create_sts_vpcend
  create_cwlogs_vpcend = var.create_cwlogs_vpcend
  create_elb_vpcend   = var.create_elb_vpcend
  create_eks_vpcend   = var.create_eks_vpcend

  # 기타 옵션
  create_efs          = var.create_efs
  selected_az         = var.selected_az
  use_single_nat      = var.use_single_nat
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}
