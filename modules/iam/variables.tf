variable "roles" {
  default = {}
}

variable "users" {
  default = {}
}

variable "groups" {
  default = {}
}

variable "policy" {
  type = list(object({
    name = string  # 정책 리소스 이름
    description = string  # 정책 설명
    policy_path = string  # 템플릿 파일 경로(모듈 상대경로, .json.tpl 제외)
  }))
  default = []
}

variable "password_policy" {
  default = {
    max_password_age               = 90
    minimum_password_length        = 14
    allow_users_to_change_password = true
    hard_expiry                    = false
    password_reuse_prevention      = 24
    require_lowercase_characters   = true
    require_uppercase_characters   = true
    require_numbers                = true
    require_symbols                = true
  }
}

# 1) 생성할 Role의 이름
variable "name" {
  description = "생성할 IAM Role의 이름(예: \"eks-cluster-role\")."
  type        = string
}

variable "name_prefix" {
  description = "생성할 IAM Role의 이름(예: \"eks-cluster-role\")."
  type        = string
}

variable "role_use_name_prefix" {
  type        = bool
  default     = false
}

variable "assume_role_policy" {
  description = "이 Role에 붙일 AWS 관리형 정책(Managed Policy) ARN 리스트."
  type        = string
}


# 3) Role에 Attach할 AWS 관리형 정책 ARN 목록
variable "managed_policy_arns" {
  description = "이 Role에 붙일 AWS 관리형 정책(Managed Policy) ARN 리스트."
  type        = list(string)
  default     = []
}

variable "additional_managed_policy_arns" {
  description = <<-EOT
    기본 managed_policy_arns 외에 추가로 Attach할 AWS 관리형 정책 ARN 리스트.
    예: ["arn:aws:iam::aws:policy/AmazonEKSAddonsPolicy", ...]
  EOT
  type        = list(string)
  default     = []
}

variable "additional_custom_policy_templates" {
  description = "이 Role에 붙일 AWS 추가 정책(Additional Policy) ARN 리스트."
  type        = list(string)
  default     = []
}

# 4) Role path (옵션)
variable "path" {
  description = "IAM Role의 path(예: \"/\")."
  type        = string
  default     = "/"
}

# 5) Role 설명(옵션)
variable "description" {
  description = "IAM Role의 설명(Description)."
  type        = string
  default     = null
}

# 6) 최대 세션 지속시간(옵션, 기본 3600초)
variable "max_session_duration" {
  description = "IAM Role 최대 세션 지속시간(초). 기본값 3600."
  type        = number
  default     = 3600
}

# 7) Role 삭제 시 정책 강제 분리 여부(옵션)
variable "force_detach_policies" {
  description = "Role 삭제 시 붙어있는 정책을 강제 분리할지 여부(기본 false)."
  type        = bool
  default     = false
}

# 8) Permissions boundary (옵션)
variable "permissions_boundary" {
  description = "이 Role에 설정할 Permissions Boundary ARN(선택)."
  type        = string
  default     = null
}

# 9) Role에 붙일 태그 (옵션)
variable "tags" {
  description = "IAM Role에 부착할 태그(Key=Value) 맵."
  type        = map(string)
  default     = {}
}

variable "template_root" {
  description = "정책 템플릿 파일들이 위치한 루트 디렉터리 경로.기본값은 ./policies. 호출부에서 상대경로·절대경로 지정 가능."
  type    = string
  default = "./policies"
}

variable "create" {
  description = "create cluster iam role"
  type      = bool
  default   = true
}