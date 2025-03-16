#####################
# default tag
#####################
variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = ""
}

variable "env" {
  default = ""
}

variable "pjt" {
  description = "프로젝트명"
  default     = ""
}

variable "service_id" {
  default = "" //Web Eks Rds
}

variable "costc" {
  default = ""
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


variable "github_repo" {
  type        = string
  description = "테라폼 코드 리포"
  default     = ""
}

variable "github_path" {
  type        = string
  description = "테라폼 코드 경로"
  default     = ""
}

variable "github_revision" {
  type        = string
  description = "테라폼 코드 브랜치"
  default     = ""
}

#----------------------------------------------------------
// ENTITY
#----------------------------------------------------------
variable "authorized_oidc_entity" {
  type        = list(string)
  description = "The OIDC entity to use (e.g., 'github', 'gitlab')"
  default     = []
}

variable "custom_oidc_thumbprints" {
  type        = list(string)
  description = "Custom OIDC thumbprints to include in the configuration."
  default     = []
}

#----------------------------------------------------------
// ECR REPOSITORIES
#----------------------------------------------------------
variable "ecr_repo_names" {
  type        = list(string)
  description = "ECR repository names"
  default = []
}

variable "iam_policies_for_ecr_repo_json" {
  type        = list(string)
  description = "IAM Policies JSON for ECR Repository"
  default     = []
}

#----------------------------------------------------------
// GITHUB ACTIONS
#----------------------------------------------------------
variable "github_oidc_org_name" {
  type        = string
  description = "GitHub organization that will assume an IAM Role through OIDC"
  default     = ""
} 

variable "github_oidc_repo_name" {
  type        = string
  description = "GitHub repo that will assume an IAM Role through OIDC"
  default     = "*"
}

variable "github_oidc_branch" {
  type        = string
  description = "GitHub branch that will assume an IAM Role through OIDC"
  default     = "*"
}

#----------------------------------------------------------
// GITLAB RUNNER
#----------------------------------------------------------
variable "gitlab_oidc_org_name" {
  type        = string
  description = "GitLab organization that will assume an IAM Role through OIDC"
  default     = ""
}

variable "gitlab_oidc_repo_name" {
  type        = string
  description = "GitLab repo that will assume an IAM Role through OIDC"
  default     = "*"
}

variable "gitlab_oidc_branch" {
  type        = string
  description = "GitLab branch that will assume an IAM Role through OIDC"
  default     = "*"
}

#----------------------------------------------------------
// OIDC PROVIDER
#----------------------------------------------------------

variable "github_oidc_provider_url" {
  type        = string
  description = "GitHub OIDC provider URL"
  default     = "token.actions.githubusercontent.com"
}

variable "github_oidc_audiences" {
  type        = list(string)
  description = "Audiences for the GitHub OIDC provider"
  default     = ["sts.amazonaws.com"]
}

variable "github_oidc_thumbprints" {
  type        = list(string)
  description = "Hashes of the certificate from the GitHub OIDC provider"
  default     = []
}

variable "github_actions_role_name" {
  type        = string
  description = "GitHub Actions IAM Role Name"
  default     = ""
}

variable "gitlab_oidc_provider_url" {
  type        = string
  description = "GitLab OIDC provider URL"
  default     = "https://gitlab.com"
}

variable "gitlab_oidc_audiences" {
  type        = list(string)
  description = "Audiences for the GitLab OIDC provider"
  default     = ["sts.amazonaws.com"]
}

variable "gitlab_oidc_thumbprints" {
  type        = list(string)
  description = "Hashes of the certificate from the GitLab OIDC provider"
  default     = []
}

variable "gitlab_runner_role_name" {
  type        = string
  description = "GitLab Actions IAM Role Name"
  default     = ""
}