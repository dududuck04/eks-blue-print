locals {

  # For addons that pull images from a region-specific ECR container registry by default
  # for more information see: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  amazon_container_image_registry_uris = merge(
    {
      af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com",
      ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com",
      ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com",
      ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com",
      ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com",
      ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com",
      ap-south-2     = "900889452093.dkr.ecr.ap-south-2.amazonaws.com",
      ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com",
      ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com",
      ap-southeast-3 = "296578399912.dkr.ecr.ap-southeast-3.amazonaws.com",
      ap-southeast-4 = "491585149902.dkr.ecr.ap-southeast-4.amazonaws.com",
      ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com",
      cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn",
      cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com.cn",
      eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com",
      eu-central-2   = "900612956339.dkr.ecr.eu-central-2.amazonaws.com",
      eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com",
      eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com",
      eu-south-2     = "455263428931.dkr.ecr.eu-south-2.amazonaws.com",
      eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com",
      eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com",
      eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com",
      me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com",
      me-central-1   = "759879836304.dkr.ecr.me-central-1.amazonaws.com",
      sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com",
      us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com",
      us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com",
      us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com",
      us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com",
      us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com",
      us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com"
    },
    var.custom_image_registry_uri
  )
  pod_eniconfig_map = {
    for _, info in data.aws_subnet.pod_subnet_info :
    info.availability_zone => {
      id             = info.id
      securityGroups = concat(
        [
          var.eks_context.cluster_security_group_id
        ],
        lookup(
          var.amazon_eks_vpc_cni_config,
          "eks_vpc_cni_eniconfig_additional_security_group",
          []
        )
      )
    }
  }

  eniconfig = {
    create = true
    region = var.eks_context.aws_region_name
    subnets = local.pod_eniconfig_map
  }
}
