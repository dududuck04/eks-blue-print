############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region = var.shared_account.region

  alias = "SHARED"

  profile = var.shared_account.profile == "" ? null : var.shared_account.profile

  dynamic "assume_role" {
    for_each = [var.shared_account.assume_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  ignore_tags {
    key_prefixes = ["created"]
  }
}

provider "aws" {
  region = var.target_account.region

  alias = "TARGET"

  profile = var.target_account.profile == "" ? null : var.target_account.profile

  dynamic "assume_role" {
    for_each = [var.target_account.assume_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  ignore_tags {
    key_prefixes = ["created"]
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(module.cluster_autoscaler.certificate_authority_data)
    host                   = module.cluster_autoscaler.endpoint_url
    token                  = module.cluster_autoscaler.auth_token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.cluster_autoscaler.certificate_authority_data)
  host                   = module.cluster_autoscaler.endpoint_url
  token                  = module.cluster_autoscaler.auth_token
}