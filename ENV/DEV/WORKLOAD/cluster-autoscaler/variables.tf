############################################
# Common Variables
############################################
variable "project" {
  type        = string
  default     = ""
  description = "project code or corporate code"
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region e.g. ap-northeast-2"
}

variable "abbr_region" {
  type        = string
  default     = ""
  description = "abbreviation of aws region. e.g. AN2"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "org" {
  type        = string
  default     = ""
  description = "organization name"
}

variable "default_tags" {
  description = "tags for AWS Resources"
  default     = {}
  }

# Backend Config
variable "remote_backend" {
  type = object({
    type = optional(string, "")
    workspaces = optional(object({
      service        = optional(string, "")
      bucket         = optional(string, "")
      key            = optional(string, "")
      region         = optional(string, "")
      org            = optional(string, "")
      workspace_name = optional(string, "")
    }), {})
  })
  default     = {}
  description = "remote backend information"
}

############################################
# EKS Access Variables
############################################
variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "iam_role_name" {
  description = "IRSA Role Name for Cluster Autoscaler SA"
  type = string 
  default = ""
}

variable "iam_policy_name" {
  description = "IRSA Policy Name for Cluster Autoscaler SA"
  type = string
  default = ""
}

############################################
# Helm Variables
############################################
variable "helm_chart" {
  type = object({
    name           = optional(string, "cluster-autoscaler")
    version        = optional(string, "")
    repository_url = optional(string, "https://kubernetes.github.io/autoscaler")
    namespace      = optional(object({
      create = optional(bool, false)
      name   = optional(string, "kube-system")
    }), {})
  })
  description = "helm chart info"
}

variable "helm_release" {
type = object({
    service_account_name        = optional(string, "cluster-autoscaler-sa")
    replica                     = optional(number, 1)
    resources                   = optional(string, "")
    affinity                    = optional(string, "")
    node_selector               = optional(string, "")
    tolerations                 = optional(string, "")
    service_monitor_enabled     = optional(bool, false)
    topology_spread_constraints = optional(string, "")
    image_repo                  = optional(string, "registry.k8s.io/autoscaling/cluster-autoscaler")
    image_tag                   = optional(string, "v1.27.2")
    
    sets = optional(list(object({
      key   = string
      value = string
    })), [])
  })
}

############################################
# Terraform Account Variables
############################################
variable "shared_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })

  description = "default account"
}

variable "target_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  description = "target account"
}
