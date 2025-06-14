module "cluster_autoscaler" {
  source = "./modules"
  
  project         = var.project
  env             = var.env
  org             = var.org
  region          = var.region
  cluster_name    = local.cluster_name

  oidc_provider   = {
    arn = local.oidc_provider_arn
    url = local.oidc_provider_url
  }

  helm_chart      = var.helm_chart
  helm_release    = var.helm_release

  iam_role_name   = var.iam_role_name
  iam_policy_name = var.iam_policy_name
  common_tags     = local.common_tags
}