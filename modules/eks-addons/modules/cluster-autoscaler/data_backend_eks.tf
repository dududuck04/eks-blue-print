# S3 Backend
data "terraform_remote_state" "s3_eks" {
  count = local.backend_s3_eks ? 1 : 0

  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = var.remote_backend.workspaces.bucket
    key    = var.remote_backend.workspaces.key
    region = var.remote_backend.workspaces.region
}
}

# Terraform Cloud Backend
data "terraform_remote_state" "remote_eks" {
  count = local.backend_remote_eks ? 1 : 0

  backend = "remote"
  config = {
    organization = var.remote_backend.workspaces.org
    workspaces = {
      name = var.remote_backend.workspaces.workspace_name
    }
  }
}