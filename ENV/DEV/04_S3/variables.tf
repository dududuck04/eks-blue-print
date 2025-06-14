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

#####################
# vpc
#####################
variable "vpc_name" {}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "secondary_cidr" {
  type    = string
  default = ""
}

#####################
# subnet
#####################
variable "selected_az" {
  description = "List of availability zones to deploy resources (e.g., ['ap-northeast-2a', 'ap-northeast-2c'])"
  type        = list(string)
  default     = []
}

variable "puba_cidr" {
  type    = string
  default = null
}
variable "pubb_cidr" {
  type    = string
  default = null
}
variable "pubc_cidr" {
  type    = string
  default = null
}
variable "pubd_cidr" {
  type    = string
  default = null
}
variable "pria_cidr" {
  type    = string
  default = null
}
variable "prib_cidr" {
  type    = string
  default = null
}
variable "pric_cidr" {
  type    = string
  default = null
}
variable "prid_cidr" {
  type    = string
  default = null
}
variable "pria_db_cidr" {
  type    = string
  default = null
}
variable "prib_db_cidr" {
  type    = string
  default = null
}
variable "pric_db_cidr" {
  type    = string
  default = null
}
variable "prid_db_cidr" {
  type    = string
  default = null
}
variable "pria_pod_cidr" {
  type    = string
  default = null
}
variable "prib_pod_cidr" {
  type    = string
  default = null
}
variable "pric_pod_cidr" {
  type    = string
  default = null
}
variable "prid_pod_cidr" {
  type    = string
  default = null
}
variable "bastion_cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}
variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "create_bastion" {
  type    = bool
  default = false
}

variable "bastion_username" {
  type    = string
  default = "ec2-user"
}

variable "create_efs" {
  type    = bool
  default = false
}

variable "use_single_nat" {
  description = "하나의 NAT 게이트웨이만 생성할지 여부"
  type        = bool
  default     = true
}

variable "create_nat" {
  type    = bool
  default = true
}

#####################
# VPC Endpoint
#####################
variable "create_s3_vpcend" {
  type    = bool
  default = true
}
variable "create_ecr_vpcend" {
  type    = bool
  default = true
}

variable "create_ec2_vpcend" {
  type    = bool
  default = true
}
variable "create_sts_vpcend" {
  type    = bool
  default = true
}
variable "create_cwlogs_vpcend" {
  type    = bool
  default = true
}
variable "create_elb_vpcend" {
  type    = bool
  default = true
}
variable "create_eks_vpcend" {
  type    = bool
  default = true
}

#####################
# Route53
#####################
variable "domain" {
  type    = string
  default = "cnp.mzcstc.com"
}
variable "create_route53" {
  type    = bool
  default = false
}

#####################
# Direct Connect
#####################
variable "direct_connect_gw" {
  type    = string
  default = false
}
variable "virtual_private_gw" {
  type    = string
  default = false
}
variable "create_dx_gw" {
  type    = bool
  default = false
}
variable "create_vpgw" {
  type    = bool
  default = false
}

#####################
# S3
#####################
variable "main_bucket_name" {}

variable "log_bucket_name" {}

variable "config_bucket_name" {}

variable "image_builder_bucket_name" {}

variable "key_pair_name" {}

variable "cloud_trail_name" {}

variable "config_bucket_config_file_name" {}

variable "config_bucket_dir" {}

