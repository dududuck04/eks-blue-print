###############################
# 기본 설정 변수 (Default Settings)
###############################
variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment (예: dev, prod 등)"
  type        = string
  default     = ""
}

variable "pjt" {
  description = "프로젝트명"
  type        = string
  default     = ""
}

variable "service_id" {
  description = "서비스 식별자 (예: Web, Eks, Rds 등)"
  type        = string
  default     = ""
}

variable "costc" {
  description = "Cost center 또는 비용 관련 태그"
  type        = string
  default     = ""
}

variable "tags" {
  description = "모든 리소스에 추가할 태그들의 맵"
  type        = map(string)
  default     = {}
}

###############################
# GitHub 관련 변수
###############################
variable "github_repo" {
  description = "테라폼 코드가 위치한 GitHub 리포지토리 URL"
  type        = string
  default     = ""
}

variable "github_path" {
  description = "테라폼 코드 경로"
  type        = string
  default     = ""
}

variable "github_revision" {
  description = "테라폼 코드 브랜치"
  type        = string
  default     = ""
}

variable "prefix_separator" {
  description = "리소스 이름 생성 시 접두사와 타임스탬프 사이의 구분자"
  type        = string
  default     = "-"
}

variable "create" {
  description = "리소스 생성 여부 제어 (거의 모든 리소스에 적용)"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = ""
}

###############################
# Karpenter Controller IAM Role
###############################
variable "create_iam_role" {
  description = "IAM 역할 생성 여부 결정"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "IAM 역할 이름"
  type        = string
  default     = "KarpenterController"
}

variable "iam_role_use_name_prefix" {
  description = "IAM 역할 이름(`iam_role_name`)을 접두사로 사용할지 여부"
  type        = bool
  default     = false
}

variable "iam_role_path" {
  description = "IAM 역할 경로"
  type        = string
  default     = "/"
}

variable "iam_role_description" {
  description = "IAM 역할 설명"
  type        = string
  default     = "Karpenter controller IAM role"
}

variable "iam_role_max_session_duration" {
  description = "최대 API 세션 지속 시간 (초 단위, 3600~43200 사이)"
  type        = number
  default     = null
}

variable "iam_role_permissions_boundary_arn" {
  description = "IAM 역할에 사용할 권한 경계 ARN"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "IAM 역할에 추가할 태그들의 맵"
  type        = map(any)
  default     = {}
}

variable "iam_policy_name" {
  description = "IAM 정책 이름"
  type        = string
  default     = "KarpenterController"
}

variable "iam_policy_use_name_prefix" {
  description = "IAM 정책 이름(`iam_policy_name`)을 접두사로 사용할지 여부"
  type        = bool
  default     = true
}

variable "iam_policy_path" {
  description = "IAM 정책 경로"
  type        = string
  default     = "/"
}

variable "iam_policy_description" {
  description = "IAM 정책 설명"
  type        = string
  default     = "Karpenter controller IAM policy"
}

variable "iam_policy_statements" {
  description = "특정 IAM 권한을 추가하기 위한 정책 문(statement) 리스트"
  type        = any
  default     = []
}

variable "iam_role_policies" {
  description = "IAM 역할에 첨부할 정책 (형식: {'static_name' = 'policy_arn'})"
  type        = map(string)
  default     = {}
}

variable "ami_id_ssm_parameter_arns" {
  description = "Karpenter controller가 읽기 권한을 가지는 AMI ID SSM 파라미터 ARN 리스트"
  type        = list(string)
  default     = []
}

variable "enable_pod_identity" {
  description = "EKS pod identity 지원 여부"
  type        = bool
  default     = true
}

variable "enable_v1_permissions" {
  description = "v1+용 권한 (true) 또는 v0.33.x-v0.37.x용 권한 (false) 사용 여부"
  type        = bool
  default     = false
}

###############################
# IAM Role for Service Account (IRSA)
###############################
variable "enable_irsa" {
  description = "IAM role for service accounts 지원 여부"
  type        = bool
  default     = false
}

variable "irsa_oidc_provider_arn" {
  description = "신뢰 정책에 사용될 OIDC provider ARN"
  type        = string
  default     = ""
}

variable "irsa_namespace_service_accounts" {
  description = "신뢰 정책에 사용할 'namespace:serviceaccount' 페어 리스트"
  type        = list(string)
  default     = ["karpenter:karpenter"]
}

variable "irsa_assume_role_condition_test" {
  description = "역할 수임 시 평가할 IAM 조건 연산자 (예: StringEquals)"
  type        = string
  default     = "StringEquals"
}

###############################
# Pod Identity Association
###############################
variable "create_pod_identity_association" {
  description = "Karpenter Pod Identity에 대한 pod identity association 생성 여부"
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Karpenter Pod Identity와 연관시킬 네임스페이스"
  type        = string
  default     = "kube-system"
}

variable "create_namespace" {
  description = "네임스페이스 생성 여부"
  type        = bool
  default     = true
}

variable "name" {
  description = "릴리즈 이름 (필요 시)"
  type        = string
  default     = "karpenter"
}

variable "repository" {
  description = "Helm 리포지토리 URL (필요 시)"
  type        = string
}

variable "chart" {
  description = "Helm 차트 이름 (필요 시)"
  type        = string
  default     = "karpenter"
}

variable "helm_release_version" {
  description = "Helm 릴리즈 버전 (필요 시)"
  type        = string
}

variable "wait" {
  description = "Helm 릴리즈 적용 시 대기 여부"
  type        = bool
  default     = true
}

variable "service_account" {
  description = "Karpenter Pod Identity와 연관시킬 서비스 어카운트 이름"
  type        = string
  default     = "karpenter"
}

###############################
# Node Termination Queue (Spot Termination)
###############################
variable "enable_spot_termination" {
  description = "네이티브 스팟 종료 처리 활성화 여부"
  type        = bool
  default     = true
}

variable "queue_name" {
  description = "SQS 큐 이름"
  type        = string
  default     = null
}

variable "queue_managed_sse_enabled" {
  description = "SQS 메시지 암호화를 위해 SQS 소유 암호화 키 사용 여부"
  type        = bool
  default     = true
}

variable "queue_kms_master_key_id" {
  description = "SQS용 AWS 관리형 또는 커스텀 CMK ID"
  type        = string
  default     = null
}

variable "queue_kms_data_key_reuse_period_seconds" {
  description = "데이터 키 재사용 기간 (초)"
  type        = number
  default     = null
}

###############################
# Node IAM Role 관련 설정
###############################
variable "create_node_iam_role" {
  description = "IAM 역할을 새로 생성할지 기존 역할을 사용할지 여부"
  type        = bool
  default     = true
}

variable "cluster_ip_family" {
  description = "Kubernetes pod와 service 주소에 할당할 IP 패밀리 (ipv4 또는 ipv6)"
  type        = string
  default     = "ipv4"
}

variable "node_iam_role_arn" {
  description = "기존 IAM 역할 ARN (create_node_iam_role이 false일 경우 필요)"
  type        = string
  default     = null
}

variable "node_iam_role_name" {
  description = "생성될 IAM 역할의 이름 (옵션)"
  type        = string
  default     = null
}

variable "node_iam_role_use_name_prefix" {
  description = "IAM 역할 이름(node_iam_role_name)을 접두사로 사용할지 여부"
  type        = bool
  default     = false
}

variable "node_iam_role_path" {
  description = "IAM 역할 경로"
  type        = string
  default     = "/"
}

variable "node_iam_role_description" {
  description = "IAM 역할에 대한 설명"
  type        = string
  default     = null
}

variable "node_iam_role_max_session_duration" {
  description = "최대 API 세션 지속 시간 (초)"
  type        = number
  default     = null
}

variable "node_iam_role_permissions_boundary" {
  description = "IAM 역할에 설정할 권한 경계 정책 ARN"
  type        = string
  default     = null
}

variable "node_iam_role_attach_cni_policy" {
  description = "IAM 역할에 'AmazonEKS_CNI_Policy' 또는 'AmazonEKS_CNI_IPv6_Policy'를 첨부할지 여부"
  type        = bool
  default     = true
}

variable "node_iam_role_additional_policies" {
  description = "추가로 IAM 역할에 첨부할 정책들"
  type        = map(string)
  default     = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_iam_role_tags" {
  description = "IAM 역할에 추가할 태그들의 맵"
  type        = map(string)
  default     = {}
}

###############################
# Access Entry 설정
###############################
variable "create_access_entry" {
  description = "노드 IAM 역할용 Access Entry 생성 여부"
  type        = bool
  default     = true
}

variable "access_entry_type" {
  description = "Access Entry 유형 (EC2_LINUX, FARGATE_LINUX, EC2_WINDOWS)"
  type        = string
  default     = "EC2_LINUX"
}

###############################
# Node IAM Instance Profile
###############################
variable "create_instance_profile" {
  description = "IAM 인스턴스 프로파일 생성 여부"
  type        = bool
  default     = false
}

###############################
# Event Bridge Rules 설정
###############################
variable "rule_name_prefix" {
  description = "모든 Event Bridge 규칙에 사용할 접두사"
  type        = string
  default     = "Karpenter"
}

###############################
# 기타 (Optional Variables)
###############################
variable "private_subnet_name" {
  description = "프라이빗 서브넷 이름 (옵션)"
}

variable "karpenter_security_group_name" {
  description = "Karpenter용 보안 그룹 이름 (옵션)"
}

variable "zone_values" {
  description = "허용할 가용 영역"
  type        = list(string)
  default     = []
}

variable "instance_family_values" {
  description = "사용할 EC2 인스턴스 패밀리"
  type        = list(string)
  default     = []
}

variable "instance_cpu_values" {
  description = "사용할 인스턴스의 vCPU 수"
  type        = list(string)
  default     = []
}

variable "instance_generation_threshold" {
  description = "허용할 인스턴스 세대의 최소 기준"
  type        = list(string)
  default     = []
}

variable "kubernetes_arch_values" {
  description = "허용할 CPU 아키텍처"
  type        = list(string)
  default     = ["amd64"]
}

variable "kubernetes_os_values" {
  description = "허용할 OS 타입"
  type        = list(string)
  default     = ["linux"]
}

variable "capacity_type_values" {
  description = "인스턴스 구매 옵션 (spot, on-demand 등)"
  type        = list(string)
  default     = ["spot","on-demand"]
}

variable "expire_after" {
  description = "노드 자동 만료 시간 (Never는 무기한)"
  type        = string
  default     = "720h"
}

variable "termination_grace_period" {
  description = "노드 삭제 전 최대 대기 시간"
  type        = string
  default     = "48h"
}

variable "nodepool_cpu_limit" {
  description = "NodePool CPU 자원 제한"
  type        = number
  default     = 1000
}

variable "nodepool_memory_limit" {
  description = "NodePool 메모리 자원 제한"
  type        = string
  default     = "1000Gi"
}

variable "nodepool_weight" {
  description = "NodePool 우선순위"
  type        = number
  default     = 10
}

variable "consolidation_policy" {
  description = "노드 통합 정책 (WhenEmpty 또는 WhenEmptyOrUnderutilized)"
  type        = string
  default     = "WhenEmpty"
}

variable "consolidate_after" {
  description = "노드 통합 대기 시간"
  type        = string
  default     = "30s"
}

variable "instance_hypervisor_values" {
  description = "허용할 인스턴스 하이퍼바이저 유형"
  type        = list(string)
  default     = []
}

variable "disruption_budgets" {
  description = "노드 축소 속도 제어를 위한 예산 설정"
  type        = list(any)
  default = []
}
