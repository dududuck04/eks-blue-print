data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

# 조회한 서브넷 ID에 추가 태그 붙이기
resource "aws_ec2_tag" "private_subnets_karpenter_tags" {
  for_each    = data.aws_subnets.private_subnets.ids
  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name

}

# resource "aws_ec2_tag" "security_group_karpenter_tags" {
#   for_each = toset(concat(local.node_cluster_sg_ids))
#   resource_id = each.value
#
#   key   = "karpenter.sh/discovery"
#   value = aws_eks_cluster.this[0].name
# }

module "karpenter" {
  source = "modules/karpenter"

  cluster_name          = var.cluster_name
  enable_v1_permissions = true

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = var.node_iam_role_use_name_prefix
  node_iam_role_name              = var.node_iam_role_name
  create_pod_identity_association = var.create_pod_identity_association

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = var.node_iam_role_additional_policies


}

resource "helm_release" "karpenter" {
  namespace           = var.namespace
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = "1.2.0"
  wait                = false

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    tolerations:
      - key: "karpenter"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
    dnsPolicy: Default
    settings:
      clusterName: ${aws_eks_cluster.this[0].name}
      clusterEndpoint: ${aws_eks_cluster.this[0].endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    webhook:
      enabled: true
    EOT
  ]
}



# Provisioner 파일을 Kubernetes 클러스터에 적용
resource "kubectl_manifest" "karpenter_manifests" {
  # Helm 릴리스 등 CRD가 설치된 뒤에 배포되도록 설정
  depends_on = [
    helm_release.karpenter
  ]

  # 템플릿 파일(karpenter.yaml.tpl.tpl)을 읽고, 변수 치환
  yaml_body = templatefile("${path.module}/modules/karpenter/karpenter.yaml.tpl", {
    cluster_name = var.cluster_name
  })
}


# module "karpenter_disabled" {
#   source = "./modules/karpenter"
#
#   create = false
# }
