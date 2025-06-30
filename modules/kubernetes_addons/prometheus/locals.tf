locals {
  name            = "prometheus"
  service_account = try(var.helm_config.service_account, "${local.name}-sa")
  workspace_url          = var.amazon_prometheus_workspace_endpoint != null ? "${var.amazon_prometheus_workspace_endpoint}api/v1/remote_write" : ""
  ingest_iam_role_arn    = var.enable_amazon_prometheus ? module.irsa_amp_ingest[0].irsa_iam_role_arn : ""
  repository             = "https://prometheus-community.github.io/helm-charts"

  # https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/Chart.yaml
  default_helm_config = {
    name        = local.name
    chart       = local.name
    version     = "27.22.0"
    namespace   = "prometheus"
    repository  = local.repository
    values      = local.default_helm_values
    description = "Prometheus helm Chart deployment configuration"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  default_helm_values = [templatefile("${path.module}/values.yaml", {
    aws_region     = var.addon_context.aws_region_name,
    eks_cluster_id = var.addon_context.eks_cluster_id,
    operating_system = try(var.helm_config.operating_system, "linux")
    repository  = local.repository
  })]

  set_values = var.enable_amazon_prometheus ? concat(
    [
      {
        name  = "serviceAccount.name"
        value = local.service_account
      },
      {
        name  = "serviceAccount.create"
        value = false
      },
      {
        name  = "serviceAccounts.server.annotations.eks\\.amazonaws\\.com/role-arn"
        value = aws_iam_policy.ingest[0].arn
      },
      {
        name  = "server.remoteWrite[0].url"
        value = local.workspace_url
      },
      {
        name  = "server.remoteWrite[0].sigv4.region"
        value = var.addon_context.aws_region_name
      }
    ],
    try(var.helm_config.set_values, [])
  ) : try(var.helm_config.set_values, [])

  argocd_gitops_config = {
    enable             = var.manage_via_gitops
    serviceAccountName = local.service_account
  }

  irsa_config = {
    kubernetes_namespace              = local.helm_config["namespace"]
    kubernetes_service_account        = local.service_account
    create_kubernetes_namespace = try(local.helm_config["create_namespace"], true)
    create_kubernetes_service_account = true
    create_service_account_secret_token = try(local.helm_config["create_service_account_secret_token"], false)
    irsa_iam_policies = []
  }
}