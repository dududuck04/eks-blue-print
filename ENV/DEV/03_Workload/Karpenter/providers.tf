provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment      = var.env
      Project          = var.pjt
      COST_CENTER      = var.costc
      TerraformManaged = true
      CodeRepo         = var.github_repo
      CodePath         = var.github_path
      CodeRevision     = var.github_revision
    }
  }
}

provider "kubernetes" {
  host                   = module.karpenter.endpoint_url
  cluster_ca_certificate = base64decode(module.karpenter.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.karpenter.cluster_name]
  }
}


provider "helm" {
  kubernetes {
    host                   = module.karpenter.endpoint_url
    cluster_ca_certificate = base64decode(module.karpenter.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.karpenter.cluster_name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.karpenter.endpoint_url
  cluster_ca_certificate = base64decode(module.karpenter.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.karpenter.cluster_name]
  }
}

