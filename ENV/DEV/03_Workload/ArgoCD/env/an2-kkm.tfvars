region = "ap-northeast-2"
env = "poc"
pjt = "kkm"
service_id = "eks_sandbox"
costc = "payer"
github_repo = ""
github_path = ""
github_revision = ""

cluster_name       = "poc-kkm-cluster"
vpc_name           = "poc-kkm-vpc"

# create_node_iam_role = false
# principal_arn       = ""

enable_argocd = true
argocd_manage_add_ons = false
argocd_kms_key_id = "alias/argocd-secret-key"

# ArgoCD Helm Chart Value
repository                      = "https://argoproj.github.io/argo-helm"
helm_release_version            = "7.8.23"
hosted_zone_domain              = "cnp.mzcstc.com"
argocd_login_url                = "https://argocd.cnp.mzcstc.com"
argocd_ingress_alb_name         = "poc-kkm-argocd-alb"
argocd_alb_security_group_name  = "poc-kkm-argocd-alb-sg"

# ArgoCD Application Field Value
addons_repo_url                 = "https://gitlab.wb.mzcstc.com/KimKyoungMin/eks-terraform-module.git"
addons_repo_path                = "all-k8s-addon-charts/addon-apps"
addons_repo_revision            = "main"
addons_repo_token               = "kkm-gitops-pat"

# addon AWS Load Balancer Controller
enable_aws_load_balancer_controller = true
aws_load_balancer_controller_image_path = "539666729110.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-load-balancer-controller"
aws_load_balancer_controller_image_tag = "v2.11.0"
aws_load_balancer_controller_helm_chart = "1.11.0"