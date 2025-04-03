############################################
# Versions of terraform and providers
############################################
terraform {
  # This code is written for terraform 1.6.1 version.
  required_version = "~> 1.9.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"      
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14.0"      
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0"      
    }
  }

  # backend "s3" {}
}

