locals {

  eks_oidc_issuer_url   = var.eks_oidc_provider != null ? var.eks_oidc_provider : replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  eks_cluster_endpoint  = var.eks_cluster_endpoint != null ? var.eks_cluster_endpoint : data.aws_eks_cluster.eks_cluster.endpoint
  eks_cluster_version   = var.eks_cluster_version != null ? var.eks_cluster_version : data.aws_eks_cluster.eks_cluster.version
  eks_oidc_provider_arn = join("", ["arn:aws:iam::", data.aws_caller_identity.current.account_id, ":oidc-provider/", var.eks_oidc_provider])

  default_argocd_application = {
    target_revision = "HEAD"
    destination     = "https://kubernetes.default.svc"
    project         = "default"
    values          = {}
    type            = "helm"
  }

  global_application_values = {
    clusterName = var.eks_cluster_id
  }

  apps = { for k, v in var.argocd_applications : k => v.apps if try(v.apps, null) != null }
  repo_list = flatten([
    for workload in values(var.argocd_applications) :
    [for app_name, app in workload.apps : {
      name                 = app.name
      repoUrl              = app.repoUrl,
      secret               = app.cfgstore_github_secret
      use_external_secrets = try(app.use_external_secrets, false)
    }]
  ])

  irsa_config = flatten([
    for workload in values(var.argocd_applications) :
    [for app_name, app in workload.apps : {
      name               = app.name
      namespace          = app.namespace
      serviceAccountName = app.serviceAccountName
      irsa_config        = app.irsa_config
    }]
  ])

  app_values = { workloads = {
    for k, v in local.apps.workloads : k => {
      for app_key, app_v in v : app_key =>
      app_key != "irsa_config" ? app_v : null
    }
  } }
}
