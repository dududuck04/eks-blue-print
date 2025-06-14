data "aws_acm_certificate" "hosted_zoner_acm" {
  domain      = "*.${var.hosted_zone_domain}"  # 예: *.cnp.mzcstc.com
  statuses    = ["ISSUED"]                     # 발급 완료(ISSUED)인 인증서만
  most_recent = true
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# 외부에서 참조용 data source
# data "aws_secretsmanager_secret_version" "admin_password_version" {
#   secret_id = aws_secretsmanager_secret.argocd[0].id
#   depends_on = [aws_secretsmanager_secret.argocd, aws_secretsmanager_secret_version.argocd]
# }

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "argocd_sg" {
  filter {
    name   = "group-name"
    values = [var.argocd_alb_security_group_name]
  }
  vpc_id = data.aws_vpc.vpc_id.id
}
