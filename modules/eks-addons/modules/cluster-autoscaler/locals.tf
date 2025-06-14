locals {
  # Backend Config
  backend_s3_eks         = var.remote_backend.type == "s3" ? true : false
  backend_remote_eks     = var.remote_backend.type == "remote" ? true : false

  # Set cluster name [ EKS Cluster Name 직접 지정 -> S3 Backend -> TF Cloud Backend ]
  cluster_name = (
    var.cluster_name != "" ? var.cluster_name
    : var.remote_backend.type == "s3" ? data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_name
    : var.remote_backend.type == "remote" ? data.terraform_remote_state.remote_eks[0].outputs.eks_cluster_name
: ""
  )

  # EKS Auth Info.
  endpoint_url               = data.aws_eks_cluster.this.endpoint
  certificate_authority_data = data.aws_eks_cluster.this.certificate_authority[0].data
  oidc_provider_arn          = data.aws_iam_openid_connect_provider.this.arn
  oidc_provider_url          = data.aws_iam_openid_connect_provider.this.url
  auth_token                 = data.aws_eks_cluster_auth.this.token

  common_tags = merge(var.default_tags, {
    # "project"    = var.project
    # "region"     = var.region
    # "env"        = var.env
    # "org"        = var.org
    # "managed by" = "terraform"
  })
}