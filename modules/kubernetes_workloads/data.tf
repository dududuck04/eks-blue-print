data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "time_sleep" "dataplane" {
  create_duration = "10s"

  triggers = {
    data_plane_wait_arn = var.data_plane_wait_arn # this waits for the data plane to be ready
    eks_cluster_id      = var.eks_cluster_id      # this ties it to downstream resources
  }
}

data "aws_eks_cluster" "eks_cluster" {
  # this makes downstream resources wait for data plane to be ready
  name = time_sleep.dataplane.triggers["eks_cluster_id"]
}

# ---------------------------------------------------------------------------------------------------------------------
# SSH Key for Workloads ArgoCD Application charts
# ---------------------------------------------------------------------------------------------------------------------

data "aws_secretsmanager_secret" "github_secret" {
  for_each = { for k, v in var.argocd_applications : k => v if try(v.github_secret, null) != null }
  name     = each.value.github_secret
}

data "aws_secretsmanager_secret_version" "github_secret_version" {
  for_each  = { for k, v in var.argocd_applications : k => v if try(v.github_secret, null) != null }
  secret_id = data.aws_secretsmanager_secret.github_secret[each.key].id
}

# ---------------------------------------------------------------------------------------------------------------------
# PAT for Workloads Argocd Application charts / GITLAB
# ---------------------------------------------------------------------------------------------------------------------
data "aws_secretsmanager_secret" "gitlab_token" {
  for_each = { for k, v in var.argocd_applications : k => v if try(v.workloads_gitlab_secret, null) != null && startswith(v.workload_repo_url, "https://") }
  name     = each.value.workloads_gitlab_secret
}

data "aws_secretsmanager_secret_version" "gitlab_token_version" {
  for_each  = { for k, v in var.argocd_applications : k => v if try(v.workloads_gitlab_secret, null) != null && startswith(v.workload_repo_url, "https://") }
  secret_id = data.aws_secretsmanager_secret.gitlab_token[each.key].id
}


# ---------------------------------------------------------------------------------------------------------------------
# PAT for Workloads Argocd Application charts
# ---------------------------------------------------------------------------------------------------------------------
# data "aws_secretsmanager_secret" "github_token" {
#   for_each = { for k, v in var.argocd_applications : k => v if try(v.workloads_github_secret, null) != null && startswith(v.workload_repo_url, "https://") }
#   name     = each.value.workloads_github_secret
# }

# data "aws_secretsmanager_secret_version" "github_token_version" {
#   for_each  = { for k, v in var.argocd_applications : k => v if try(v.workloads_github_secret, null) != null && startswith(v.workload_repo_url, "https://") }
#   secret_id = data.aws_secretsmanager_secret.github_token[each.key].id
# }

# ---------------------------------------------------------------------------------------------------------------------
# SSH Key for Application charts
# ---------------------------------------------------------------------------------------------------------------------

# data "aws_secretsmanager_secret" "app_repo_ssh_key" {
#   for_each = { for k, v in local.apps : k =>
#     { for apps_k, apps_v in v : apps_k => apps_v.ssh_key_secret_name if try(apps_v.ssh_key_secret_name, null) != null }
#   }
#   name     = each.value
# }

# data "aws_secretsmanager_secret_version" "app_repo_ssh_key_version" {
#   for_each  = { for k, v in local.apps : k =>
#     { for apps_k, apps_v in v : apps_k => apps_v.ssh_key_secret_name if try(apps_v.ssh_key_secret_name, null) != null }
#   }
#   secret_id = data.aws_secretsmanager_secret.ssh_key[each.key].id
# }


# ---------------------------------------------------------------------------------------------------------------------
# PAT for Application charts
# ---------------------------------------------------------------------------------------------------------------------
data "aws_secretsmanager_secret" "app_repo_github_secret" {
  for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null }
  name     = each.value.secret
}

data "aws_secretsmanager_secret_version" "app_repo_github_secret_version" {
  for_each  = { for k, v in local.repo_list : k => v if try(v.secret, null) != null }
  secret_id = data.aws_secretsmanager_secret.app_repo_github_secret[each.key].id
}

data "aws_iam_policy_document" "external_secrets" {
  for_each = { for k, v in local.repo_list : k => v if try(v.secret, null) != null && try(v.use_external_secrets, false) }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = [data.aws_secretsmanager_secret.app_repo_github_secret[each.key].arn]
  }
}

# data "aws_secretsmanager_secret" "app_repo_github_token" {
#   for_each = { for k, v in local.repo_list : v.name => v.secret }
#   name     = each.key
# }

# data "aws_secretsmanager_secret_version" "app_repo_github_token_version" {
#   for_each = { for k, v in local.repo_list : v.name => v.secret }
#   secret_id = data.aws_secretsmanager_secret.app_repo_github_token[each.key].id
# }