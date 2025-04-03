# 조회한 서브넷 ID에 추가 태그 붙이기
resource "aws_ec2_tag" "private_subnets_karpenter_tags" {
  for_each    = toset(local.private_subnet_ids)
  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = aws_eks_cluster.this[0].name

  depends_on = [aws_eks_cluster.this]
}

resource "aws_ec2_tag" "security_group_karpenter_tags" {
  for_each = toset(concat(local.node_cluster_sg_ids))
  resource_id = each.value

  key   = "karpenter.sh/discovery"
  value = aws_eks_cluster.this[0].name
}

module "karpenter" {
  source = "../../eks_addons/modules/karpenter"

  cluster_name          = aws_eks_cluster.this[0].name
  enable_v1_permissions = true

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = aws_eks_cluster.this[0].name
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

}

resource "helm_release" "karpenter" {
  namespace           = "kube-system"
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
