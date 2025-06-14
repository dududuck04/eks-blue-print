provider "aws" {
  region = var.region
  # assume_role {
  #   role_arn = join("", ["arn:aws:iam::", var.account_id, ":role/", var.TF_ROLE_NAME])
  # }
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
