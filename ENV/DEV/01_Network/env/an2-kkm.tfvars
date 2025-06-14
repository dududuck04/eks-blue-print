#####################
# default tag
#####################
region = "ap-northeast-2"
env = "poc"
pjt = "kkm"
service_id = "eks_sandbox"
costc = "payer"
# tags = ""
github_repo = ""
github_path = "/ENV/DEV/Network"
github_revision = "main"

selected_az = ["ap-northeast-2a", "ap-northeast-2c"]

vpc_cidr = "172.33.0.0/20"
secondary_cidr = "100.64.0.0/20"

puba_cidr = "172.33.0.0/26"
pubc_cidr = "172.33.0.64/26"
pria_cidr = "172.33.1.0/24"
pric_cidr = "172.33.2.0/24"
pria_db_cidr = "172.33.3.0/24"
pric_db_cidr = "172.33.4.0/24"
pria_pod_cidr = "100.64.0.0/22"
pric_pod_cidr = "100.64.4.0/22"

# pubb_cidr = "172.33.0.0/26"
# pubd_cidr = "172.33.0.64/26"
# prib_cidr = "172.33.1.0/24"
# prid_cidr = "172.33.2.0/24"
# prib_db_cidr = "172.33.3.0/24"
# prid_db_cidr = "172.33.4.0/24"
# prib_pod_cidr = "100.64.0.0/22"
# prid_pod_cidr = "100.64.4.0/22"

create_nat = true

create_bastion = false
bastion_username = "ec2-user"

create_efs = true
create_eks_vpcend = false
create_sts_vpcend = false
create_s3_vpcend = false
create_ecr_vpcend = false
create_cwlogs_vpcend = false
create_ec2_vpcend = false
create_elb_vpcend = false

domain = ""
# sub_domain = ""
create_route53 = false

direct_connect_gw = "dev"
create_dx_gw = false
virtual_private_gw = "dev"
create_vpgw = false


## git config --global credential.helper "cache --timeout=86400"
