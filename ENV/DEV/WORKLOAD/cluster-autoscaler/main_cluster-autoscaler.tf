module "cluster_autoscaler" {
  source = "git::https://gitlab.wb.mzcstc.com/cnp/eks-base/terraform-autoscaler.git"

  # Common Variables
  project        = var.project
  env            = var.env
  org            = var.org
  region         = var.region
  default_tags   = var.default_tags

  # EKS Variables
  cluster_name   = var.cluster_name
  helm_chart     = var.helm_chart
  helm_release   = var.helm_release

  iam_role_name  = var.iam_role_name
  iam_policy_name = var.iam_policy_name

  # Backend Config
  remote_backend = var.remote_backend

  providers = {
    aws = aws.TARGET
  }
}