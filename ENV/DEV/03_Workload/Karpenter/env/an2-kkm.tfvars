region = "ap-northeast-2"
env = "poc"
pjt = "kkm"
service_id = "eks_sandbox"
costc = "payer"
github_repo = ""
github_path = ""
github_revision = ""

cluster_name       = "poc-kkm-cluster"
private_subnet_name = "poc-kkm-eks-private-subnet-an2*"
karpenter_security_group_name = "karpenter-security-group"

namespace = "karpenter"

node_iam_role_name = "poc-kkm-karpenter-node-rol"
iam_role_name      = "poc-kkm-karpenter-controller-rol"

# Fargate Profile 로 Karpenter 구성 시 false
create_iam_role    = false

# create_node_iam_role = false
# principal_arn       = ""

# Helm chart 리포지토리 URL (Karpenter가 배포된 AWS Public ECR 주소)
repository = "oci://public.ecr.aws/karpenter"

# Karpenter Helm 차트의 특정 버전
helm_release_version = "1.2.0"

# # 노드를 생성할 때 사용할 가용 영역(Availability Zones) 설정
# zone_values = ["ap-northeast-2a", "ap-northeast-2c"]

# # 사용할 EC2 인스턴스 패밀리 (e.g., 카펜터 공식문서에 t 타입은 추천하지 않는다고 나옴)
# instance_family_values       = ["t", "c", "m"]

# # 사용할 EC2 인스턴스의 CPU 코어 수 (vCPU 기준, 4 또는 8 vCPU를 가진 인스턴스만 허용)
# instance_cpu_values          = ["2", "4", "8"]
#
# # 사용할 EC2 인스턴스 세대 (generation)의 최소 기준을 설정 (2세대보다 높은 세대만 허용)
# instance_generation_threshold = ["2"]

# # Kubernetes 노드에서 사용할 CPU 아키텍처 (AMD64 기반의 인스턴스만 허용)
# kubernetes_arch_values = ["amd64"]

# # Kubernetes 노드가 실행할 OS (리눅스만 허용)
# kubernetes_os_values = ["linux"]

# EC2 인스턴스 구매 옵션 (현재 spot 인스턴스만 사용하도록 제한)
# "spot"은 비용 효율적이나 중간에 중단될 수 있음, "on-demand"는 안정적이나 비용이 높음
capacity_type_values = ["spot"]
# ["spot", "on-demand"] 형태로 두 가지 옵션을 함께 허용할 수도 있음

# Karpenter가 노드를 자동으로 만료(expire)시키는 기간
# "Never"로 설정 시 만료되지 않고, 무기한 유지됨
expire_after = "Never"

# 노드를 삭제할 때 최대 허용되는 Drain 시간 (강제삭제 전 Pod의 graceful 종료 허용시간)
termination_grace_period = "48h"

# NodePool이 사용할 수 있는 총 CPU 자원의 제한 (최대 1000 vCPU까지 노드 생성 허용)
nodepool_cpu_limit = 1000

# NodePool이 사용할 수 있는 총 메모리 제한 (최대 1000Gi 까지 허용)
nodepool_memory_limit = "1000Gi"

# 노드 축소(deprovisioning) 속도를 제어하는 정책 (Deprovisioning Budget)
# 평소에는 전체 노드의 최대 10%까지만 동시에 삭제 가능하며,
# 평일 오전 9시부터 8시간 동안에는 노드를 전혀 삭제하지 않음 (운영 안정성 보장 목적)
# disruption_budgets = [
#   { nodes = "10%" },                      # 평상시 최대 동시 삭제 가능 노드 비율
#   { schedule = "0 9 * * mon-fri",         # 평일 09:00부터 시작
#     duration = "8h",                      # 8시간 지속
#     nodes = "0" }                         # 이 시간 동안 노드 삭제 금지
# ]

# 노드 통합(consolidation) 정책 설정
# "WhenEmpty" 설정 시, 노드가 완전히 비어있을 때만 통합하여 삭제
# "WhenEmptyOrUnderutilized" 설정 시, 비어 있거나 자원이 낭비될 경우에도 적극적으로 노드 통합
consolidation_policy = "WhenEmpty"

# 노드에 변경사항(팟 추가/삭제)이 발생한 이후 통합(consolidation)을 기다리는 시간
# 30초 동안 추가 변경이 없을 경우 노드 통합 시도
consolidate_after = "30s"