#####################
# Global Settings
#####################
variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "me-central-1"
}

variable "env" {
  description = "Deployment environment (dev, prod 등)"
  type        = string
  default     = "dev"
}

variable "pjt" {
  description = "프로젝트명"
  type        = string
  default     = "stc"
}

variable "org" {
  description = "Organization name"
  type        = string
  default     = "mzc"
}

variable "abbr_region" {
  description = "Abbreviated region identifier"
  type        = string
  default     = "an2"
}

variable "default_tags" {
  description = "Default tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

#####################
# Cluster Configuration
#####################
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "poc-kkm-cluster"
}

variable "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  type        = string
  default     = ""  # 실제 엔드포인트를 입력
}

variable "private_subnet_name" {
  description = "Private subnet Name tag filter for the EKS cluster"
  type        = string
  default     = "poc-kkm-eks-private-subnet-an2*"
}

#####################
# Karpenter Configuration
#####################
variable "node_iam_role_name" {
  description = "IAM role name for the Karpenter nodes. If empty, you can derive it from cluster_name."
  type        = string
  default     = ""
}

variable "node_iam_role_use_name_prefix" {
  description = "Whether to use a name prefix for the node IAM role"
  type        = bool
  default     = false
}

variable "create_pod_identity_association" {
  description = "Controls if a pod identity association is created"
  type        = bool
  default     = true
}

variable "node_iam_role_additional_policies" {
  description = "Additional IAM policies to attach to the Karpenter node IAM role"
  type        = map(string)
  default = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Karpenter"
  type        = string
  default     = "kube-system"
}

variable "karpenter_chart_version" {
  description = "Version of the Karpenter Helm chart"
  type        = string
  default     = "1.2.0"
}
