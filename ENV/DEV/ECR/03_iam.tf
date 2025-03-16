data "tls_certificate" "oidc_provider_cert" {
  for_each = { for idx, entity in local.selected_oidc_entities : idx => entity }
  url      = "https://${each.value.url}"
}

locals {
  # OIDC Provider Configurations
  oidc_provider_config = {
    github = {
      url           = "token.actions.githubusercontent.com"
      audiences     = ["sts.amazonaws.com"]
      thumbprint_list = []
      role_name     = "${var.env}-${var.pjt}-github-oidc-role"
      ecr_repo_iam_policies_json = [ file("./iam_policies/github_actions_policy.json") ]

    }
    gitlab = {
      url           = "gitlab.com"
      audiences     = ["sts.amazonaws.com"]
      thumbprint_list = []
      role_name     = "${var.env}-${var.pjt}-gitlab-oidc-role"
      ecr_repo_iam_policies_json = [ file("./iam_policies/gitlab_runner_policy.json") ]
    }
  }

  # 선택된 엔터티의 설정값
  selected_oidc_entities = [
    for entity in var.authorized_oidc_entity : try(local.oidc_provider_config[entity], null)
    if contains(keys(local.oidc_provider_config), entity)
  ]

  ecr_repo_iam_policies_json = [ file("./iam_policies/gitlab_runner_policy.json") ]
  ecr_repo_iam_policies = ["arn:aws:iam::aws:policy/AmazonECRFullAccess"]
}


# ---------------------------------------------------------------------------------------------------------------------
# GITHUB ACTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  for_each = { for idx, entity in local.selected_oidc_entities : idx => entity }

  url             = "https://${each.value.url}"
  client_id_list  = each.value.audiences
  thumbprint_list = concat(
    data.tls_certificate.oidc_provider_cert[each.key].certificates[*].sha1_fingerprint,
    var.custom_oidc_thumbprints
  )
  tags = var.tags
}

resource "aws_iam_role" "trusted_entity_role" {
  for_each = { for idx, entity in local.selected_oidc_entities : idx => entity }

  name = each.value.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.oidc_provider[each.key].arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            "${each.value.url}:sub": "repo:<org>/<repo>:ref:refs/heads/<branch>"
          },
          "StringEquals": {
            "${each.value.url}:aud": each.value.audiences
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Role Policy Attachment for predefined policies
# resource "aws_iam_role_policy_attachment" "ecr_repo_policy" {
#   for_each = {
#     for idx, entity in local.selected_oidc_entities :
#     idx => {
#       policies = local.ecr_repo_iam_policies != null ? local.ecr_repo_iam_policies : []
#       role     = aws_iam_role.trusted_entity_role[idx].name
#     }
#   }
#
#   # Predefined managed policy attachments
#   dynamic "policy_arn" {
#     for_each = each.value.policies
#     content {
#       policy_arn = policy_arn
#     }
#   }
#   role = each.value.role
# }

# ---------------------------------------------------------------------------------------------------------------------
# Iam policies attach by json
# ---------------------------------------------------------------------------------------------------------------------
# resource "aws_iam_policy" "ecr_repo_policy_json" {
#   for_each = {
#     for idx, entity in local.selected_oidc_entities :
#     idx => {
#       json_policies = local.oidc_provider_config[entity].ecr_repo_iam_policies_json
#     }
#   }
#
#   description = "IAM Policy for the Service ECR"
#   policy      = file(each.value.json_policies[0]) # JSON 파일에서 첫 번째 정책을 읽음
#   tags        = var.tags
# }
#
# # IAM Role Policy Attachment for managed or JSON-defined policies
# resource "aws_iam_role_policy_attachment" "ecr_repo_policy" {
#   for_each = {
#     for idx, entity in local.selected_oidc_entities :
#     idx => {
#       assume_target = aws_iam_role.trusted_entity_role[idx].name,
#       policies = length(local.ecr_repo_iam_policies) > 0 ? local.ecr_repo_iam_policies : length(local.ecr_repo_iam_policies_json) > 0 ? [aws_iam_policy.ecr_repo_policy_json[idx].arn] : []
#     }
#   }
#
#   policy_arns = policies
#
#   role = each.value.assume_target
# }
#
# resource "aws_iam_policy_attachment" "ecr_repo_policies" {
#   name       = "attach-multiple-policies"
#   roles      = [for idx in keys(local.selected_oidc_entities) : aws_iam_role.trusted_entity_role[idx].name]
#   policy_arns = concat(
#     local.ecr_repo_iam_policies,
#     [for idx in keys(local.selected_oidc_entities) : aws_iam_policy.ecr_repo_policy_json[idx].arn]
#   )
# }