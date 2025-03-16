# ---------------------------------------------------------------------------------------------------------------------
# ArgoCD App of Apps Bootstrapping (Helm)
# ---------------------------------------------------------------------------------------------------------------------
resource "helm_release" "argocd_application" {
  for_each = { for k, v in var.argocd_applications : k => merge(local.default_argocd_application, v) if merge(local.default_argocd_application, v).type == "helm" }

  name      = each.key
  chart     = "${path.module}/argocd-application/helm"
  version   = "1.0.0"
  namespace = try(each.value.namespace, "argocd")

  # Application Meta.
  set {
    name  = "name"
    value = each.key
    type  = "string"
  }

  set {
    name  = "project"
    value = each.value.project
    type  = "string"
  }

  # Source Config.
  set {
    name  = "source.repoUrl"
    value = each.value.repo_url
    type  = "string"
  }

  set {
    name  = "source.targetRevision"
    value = each.value.target_revision
    type  = "string"
  }

  set {
    name  = "source.path"
    value = each.value.path
    type  = "string"
  }

  set {
    name  = "source.helm.releaseName"
    value = each.key
    type  = "string"
  }

  # Destination Config.
  set {
    name  = "destination.server"
    value = each.value.destination
    type  = "string"
  }

  values = [
    # Application ignoreDifferences
    yamlencode({
      "ignoreDifferences" = lookup(each.value, "ignoreDifferences", [])
    })
  ]

  set {
    name = "source.helm.values"
    value = yamlencode(merge(
      { "destinationServer" : "${each.value.destination}" },
      { "repoUrl" : "${each.value.repo_url}" },
      { "target_revision" : "${each.value.target_revision}" },
      { "argoProject" : "${each.value.project}" },
      { "argoNamespace" : "${try(each.value.namespace, "argocd")}" },
      local.app_values
    ))
    type = "auto"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access from ArgoCD via GITLAB TOKEN for Workloads Argocd Application charts
# ---------------------------------------------------------------------------------------------------------------------

resource "kubernetes_secret" "argocd_gitlab_gitops_token" {
  for_each = { for k, v in var.argocd_applications : k => v if try(v.gitlab_secret, null) != null && startswith(v.repo_url, "https://") }

  metadata {
    name      = "${each.key}-repo-token-secret"
    namespace = "argocd"
    labels    = { "argocd.argoproj.io/secret-type" : "repository" }
  }

  data = {
    insecure = lookup(each.value, "insecure", false)
    username = jsondecode(data.aws_secretsmanager_secret_version.gitlab_secret_version[each.key].secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.gitlab_secret_version[each.key].secret_string)["token"]
    type     = "git"
    url      = each.value.repo_url
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access from ArgoCD via GITHUB TOKEN for Workloads Argocd Application charts
# ---------------------------------------------------------------------------------------------------------------------

# resource "kubernetes_secret" "argocd_github_gitops_token" {
#   for_each = { for k, v in var.argocd_applications : k => v if try(v.github_secret, null) != null && startswith(v.repo_url, "https://") }
#
#   metadata {
#     name      = "${each.key}-repo-token-secret"
#     namespace = "argocd"
#     labels    = { "argocd.argoproj.io/secret-type" : "repository" }
#   }
#
#   data = {
#     insecure = lookup(each.value, "insecure", false)
#     username = jsondecode(data.aws_secretsmanager_secret_version.github_secret_version[each.key].secret_string)["username"]
#     password = jsondecode(data.aws_secretsmanager_secret_version.github_secret_version[each.key].secret_string)["token"]
#     type     = "git"
#     url      = each.value.repo_url
#   }
# }

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access from ArgoCD via SSH KEY for Workloads Argocd Application charts
# ---------------------------------------------------------------------------------------------------------------------

# resource "kubernetes_secret" "argocd_gitops_ssh" {
#   for_each = { for k, v in var.argocd_applications : k => v if try(v.github_secret, null) != null && !startswith(v.repo_url, "https://") }
#
#   metadata {
#     name      = "${each.key}-repo-ssh-secret"
#     namespace = "argocd"
#     labels    = { "argocd.argoproj.io/secret-type" : "repository" }
#   }
#
#   data = {
#     insecure      = lookup(each.value, "insecure", false)
#     sshPrivateKey = data.aws_secretsmanager_secret_version.github_secret_version[each.key].secret_string
#     type          = "git"
#     url           = each.value.repo_url
#   }
# }

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access from ArgoCD via GITHUB TOKEN for cfgStore Repos
# ---------------------------------------------------------------------------------------------------------------------

resource "kubernetes_secret" "app_argocd_gitops_token" {
  for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && startswith(v.repoUrl, "https://") && !try(v.use_external_secrets, false) }

  metadata {
    name      = "${each.value.name}-repo-token-secret"
    namespace = "argocd"
    labels    = { "argocd.argoproj.io/secret-type" : "repository" }
  }

  data = {
    insecure = lookup(each.value, "insecure", false)
    username = jsondecode(data.aws_secretsmanager_secret_version.app_repo_github_secret_version[each.key].secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.app_repo_github_secret_version[each.key].secret_string)["token"]
    type     = "git"
    url      = each.value.repoUrl
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access from ArgoCD via SSH KEY for cfgStore Repos
# ---------------------------------------------------------------------------------------------------------------------

# resource "kubernetes_secret" "app_argocd_gitops_ssh" {
#   for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && !startswith(v.repoUrl, "https://") && !try(v.use_external_secrets, false) }
#
#   metadata {
#     name      = "${each.value.name}-repo-token-secret"
#     namespace = "argocd"
#     labels    = { "argocd.argoproj.io/secret-type" : "repository" }
#   }
#
#   data = {
#     insecure      = lookup(each.value, "insecure", false)
#     sshPrivateKey = data.aws_secretsmanager_secret_version.app_repo_github_secret_version[each.key].secret_string
#     type          = "git"
#     url           = each.value.repoUrl
#   }
# }


# # ---------------------------------------------------------------------------------------------------------------------
# # Private Repo Access from ArgoCD via GITHUB TOKEN for Application Charts using ExternalSecrets
# # ---------------------------------------------------------------------------------------------------------------------
# resource "helm_release" "cfgstore_repo_external_secrets" {
#   for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && try(v.use_external_secrets, false) }
#
#   name      = "${each.value.name}-external-secret"
#   chart     = "${path.module}/cfgstore-repo-external-secrets/helm"
#   version   = "0.1.1"
#   namespace = try(each.value.namespace, "argocd")
#
#   # Application Meta.
#   set {
#     name  = "name"
#     value = each.value.name
#     type  = "string"
#   }
#
#   set {
#     name  = "namespace"
#     value = try(each.value.namespace, "argocd")
#     type  = "string"
#   }
#
#   set {
#     name  = "region"
#     value = data.aws_region.current.name
#     type  = "string"
#   }
#
#   # Source Config.
#   set {
#     name  = "repoUrl"
#     value = each.value.repoUrl
#     type  = "string"
#   }
#
#   set {
#     name  = "insecure"
#     value = lookup(each.value, "insecure", false)
#     type  = "string"
#   }
#
#   set {
#     name  = "username"
#     value = "username"
#     type  = "string"
#   }
#
#   set {
#     name  = "password"
#     value = "token"
#     type  = "string"
#   }
#
#   set {
#     name  = "secretManagerName"
#     value = each.value.secret
#     type  = "string"
#   }
#
#   set {
#     name  = "serviceAccountName"
#     value = "external-secrets-${each.value.name}-sa"
#     type  = "string"
#   }
# }

resource "aws_iam_policy" "external_secrets" {
  for_each    = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && try(v.use_external_secrets, false) }
  name        = "${var.eks_cluster_id}-external-secrets-${each.value.name}-irsa"
  description = "Provides permissions to for External Secrets to retrieve secrets from AWS SSM and AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.external_secrets[each.key].json
}

module "external_secrets_irsa" {
  source = "../irsa_workloads"

  for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && try(v.use_external_secrets, false) }

  create_kubernetes_namespace         = false
  create_kubernetes_service_account   = true
  create_service_account_secret_token = false
  kubernetes_namespace                = lookup(each.value, "namespace", "argocd")
  kubernetes_service_account          = "external-secrets-${each.value.name}-sa"
  irsa_iam_policies                   = [aws_iam_policy.external_secrets[each.key].arn]
  irsa_iam_role_name                  = "${var.eks_cluster_id}-external-secrets-${each.value.name}-irsa-role"
  eks_cluster_id                      = var.eks_cluster_id
  eks_oidc_provider_arn               = local.eks_oidc_provider_arn
  tags                                = {}
}


module "irsa" {
  source = "../irsa_workloads"

  for_each = { for k, v in local.irsa_config : k => v if v.irsa_config != null }
#  for_each = { for k, v in local.irsa_config : k => v if lookup(v, irsa_config, null) != null }

  create_kubernetes_namespace         = try(each.value.irsa_config.create_kubernetes_namespace, false)
  create_kubernetes_service_account   = try(each.value.irsa_config.create_kubernetes_service_account, true)
  create_service_account_secret_token = try(each.value.irsa_config.create_service_account_secret_token, false)
  kubernetes_namespace                = lookup(each.value, "namespace", "default")
  kubernetes_service_account          = lookup(each.value, "serviceAccountName", "")
  kubernetes_svc_image_pull_secrets   = try(each.value.irsa_config.kubernetes_svc_image_pull_secrets, null)
  irsa_iam_policies                   = lookup(each.value.irsa_config, "irsa_iam_policies", null)
  irsa_iam_policies_json              = lookup(each.value.irsa_config, "irsa_iam_policies_json", null)
  irsa_iam_role_name                  = lookup(each.value.irsa_config, "irsa_iam_role_name", "")
  irsa_iam_role_path                  = lookup(each.value.irsa_config, "irsa_iam_role_path", null)
  irsa_iam_permissions_boundary       = lookup(each.value.irsa_config, "irsa_iam_permissions_boundary", null)
  eks_cluster_id                      = var.eks_cluster_id
  eks_oidc_provider_arn               = local.eks_oidc_provider_arn
  tags                                = {}
}