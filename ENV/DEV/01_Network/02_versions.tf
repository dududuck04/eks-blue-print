terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
#      version = ">= 4.0.0, < 4.10.0"
      version = "~> 5.58.0"
    }
  }
}
