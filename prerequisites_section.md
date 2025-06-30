# 사전 요구사항

이 프로젝트를 사용하기 위해 다음과 같은 도구와 계정이 필요합니다:

## 필수 도구 및 버전

| 도구 | 최소 버전 | 권장 버전 | 설명 | 설치 링크 |
|------|------|------|------|------|
| [Terraform](https://www.terraform.io/downloads.html) | 1.0.0 | 1.5.0 이상 | 인프라를 코드로 관리하기 위한 도구 | [설치 가이드](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) |
| [AWS CLI](https://aws.amazon.com/cli/) | 2.0.0 | 2.11.0 이상 | AWS 서비스와 상호 작용하기 위한 명령줄 인터페이스 | [설치 가이드](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | 1.24.0 | 1.27.0 이상 | Kubernetes 클러스터와 상호 작용하기 위한 명령줄 도구 | [설치 가이드](https://kubernetes.io/docs/tasks/tools/install-kubectl/) |
| [helm](https://helm.sh/docs/intro/install/) | 3.8.0 | 3.12.0 이상 | Kubernetes 패키지 관리자 | [설치 가이드](https://helm.sh/docs/intro/install/) |
| [jq](https://stedolan.github.io/jq/download/) | 1.6 | 1.6 이상 | JSON 데이터를 처리하기 위한 명령줄 도구 | [설치 가이드](https://stedolan.github.io/jq/download/) |
| [git](https://git-scm.com/downloads) | 2.30.0 | 2.40.0 이상 | 버전 관리 시스템 | [설치 가이드](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) |
| [eksctl](https://eksctl.io/) | 0.120.0 | 0.150.0 이상 | EKS 클러스터를 생성하고 관리하기 위한 명령줄 도구 | [설치 가이드](https://eksctl.io/installation/) |
| [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) | 0.5.0 | 0.6.0 이상 | AWS IAM 자격 증명을 사용하여 Kubernetes 클러스터에 인증하기 위한 도구 | [설치 가이드](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) |

## 시스템 요구사항

| 요구사항 | 최소 사양 | 권장 사양 |
|------|------|------|
| CPU | 2 코어 | 4 코어 이상 |
| 메모리 | 4 GB | 8 GB 이상 |
| 디스크 공간 | 10 GB | 20 GB 이상 |
| 운영 체제 | Linux, macOS, Windows 10/11 with WSL2 | Linux, macOS |
| 인터넷 연결 | 필수 (AWS API 및 패키지 다운로드용) | 고속 연결 권장 |

## AWS 계정 요구사항

### 기본 요구사항

- 활성화된 AWS 계정
- AWS 계정에 대한 관리자 액세스 권한 또는 아래 나열된 서비스에 대한 특정 권한
- AWS 서비스 할당량이 EKS 클러스터 및 관련 리소스를 생성하기에 충분한지 확인
- 결제 알림 설정 (비용 관리를 위해 권장)

### 필요한 AWS 서비스 권한

다음 서비스에 대한 권한을 가진 IAM 사용자 또는 역할이 필요합니다:

| AWS 서비스 | 필요한 이유 | 주요 권한 |
|------|------|------|
| EC2 | 노드 인스턴스, 보안 그룹, VPC 관리 | 인스턴스 생성/관리, 보안 그룹 구성, VPC 설정 |
| EKS | Kubernetes 클러스터 관리 | 클러스터 생성/관리, 노드 그룹 관리 |
| IAM | 역할 및 정책 관리 | 역할 생성/관리, 정책 연결 |
| S3 | Terraform 상태 파일 및 기타 데이터 저장 | 버킷 생성/관리, 객체 업로드/다운로드 |
| ECR | 컨테이너 이미지 저장 | 리포지토리 생성/관리, 이미지 푸시/풀 |
| CloudWatch | 로깅 및 모니터링 | 로그 그룹 생성/관리, 메트릭 수집 |
| KMS | 데이터 암호화 | 키 생성/관리, 암호화/복호화 |
| Route53 | DNS 관리 | 호스팅 영역 생성/관리, 레코드 설정 |
| ACM | SSL/TLS 인증서 관리 | 인증서 요청/관리, 도메인 검증 |
| EFS | 영구 스토리지 제공 | 파일 시스템 생성/관리, 마운트 대상 설정 |
| ELB/ALB | 로드 밸런싱 | 로드 밸런서 생성/관리, 대상 그룹 설정 |
| AutoScaling | 노드 자동 확장 | 스케일링 그룹 생성/관리, 정책 설정 |

## IAM 권한 설정

### 관리자 액세스 (개발/테스트 환경용)

개발 또는 테스트 환경에서는 `AdministratorAccess` 관리형 정책을 사용할 수 있습니다. 하지만 프로덕션 환경에서는 최소 권한 원칙에 따라 더 제한적인 권한을 사용하는 것이 좋습니다.

### 최소 권한 정책 (프로덕션 환경 권장)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "eks:*",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole",
        "iam:CreateRole",
        "iam:CreatePolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:DeleteRole",
        "iam:DeletePolicy",
        "iam:TagRole",
        "iam:TagPolicy",
        "s3:*",
        "ecr:*",
        "cloudwatch:*",
        "logs:*",
        "kms:*",
        "route53:*",
        "acm:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "elasticfilesystem:*"
      ],
      "Resource": "*"
    }
  ]
}
```

> **참고**: 프로덕션 환경에서는 위 정책을 더 세분화하여 특정 리소스에만 적용하는 것이 좋습니다. 예를 들어, 특정 VPC, 특정 S3 버킷 등에만 권한을 부여할 수 있습니다.

## 네트워크 요구사항

### 기본 네트워크 요구사항

- **인터넷 연결**: Terraform이 AWS API와 통신하고 필요한 패키지를 다운로드하기 위해 필요합니다.
- **방화벽 설정**: 다음 엔드포인트에 대한 아웃바운드 액세스가 필요합니다:
  - AWS API 엔드포인트 (리전별 서비스 엔드포인트)
  - GitHub (Terraform 모듈 및 프로바이더 다운로드)
  - Docker Hub 또는 기타 컨테이너 레지스트리
  - Helm 차트 리포지토리

### EKS 클러스터 네트워크 요구사항

- **VPC 설정**: 기존 VPC를 사용하거나 이 프로젝트를 통해 새 VPC를 생성할 수 있습니다.
- **서브넷 구성**: EKS 클러스터를 위한 다음 서브넷이 필요합니다:
  - **퍼블릭 서브넷**: 인터넷 게이트웨이를 통해 인터넷에 직접 액세스할 수 있는 서브넷
  - **프라이빗 서브넷**: NAT 게이트웨이를 통해 인터넷에 액세스할 수 있는 서브넷
  - **파드 서브넷** (선택 사항): 파드 IP 주소 할당을 위한 별도의 서브넷
  - **데이터베이스 서브넷** (선택 사항): 데이터베이스 인스턴스를 위한 별도의 서브넷
- **가용 영역**: 고가용성을 위해 최소 2개의 가용 영역에 서브넷을 배포해야 합니다. 프로덕션 환경에서는 3개 이상의 가용 영역을 권장합니다.
- **CIDR 블록**: VPC 및 서브넷에 충분한 IP 주소 공간을 할당해야 합니다. 권장 설정:
  - VPC CIDR: /16 (예: 10.0.0.0/16)
  - 서브넷 CIDR: /20 (예: 10.0.0.0/20, 10.0.16.0/20 등)

### 보안 그룹 요구사항

- **EKS 클러스터 보안 그룹**: 컨트롤 플레인과 노드 간의 통신을 허용
- **노드 보안 그룹**: 노드 간 통신 및 필요한 아웃바운드 트래픽 허용
- **추가 보안 그룹**: 데이터베이스, 캐시 등 다른 AWS 서비스에 대한 액세스 제어

## 도메인 및 DNS 요구사항 (선택 사항)

- **등록된 도메인 이름**: 애플리케이션 및 서비스에 대한 사용자 친화적인 URL 제공
- **Route53 호스팅 영역**: DNS 레코드 관리
- **ACM 인증서**: HTTPS 통신을 위한 SSL/TLS 인증서

## 비용 고려사항

이 프로젝트를 배포하면 다음과 같은 AWS 리소스에 대한 비용이 발생할 수 있습니다:

| AWS 리소스 | 비용 요소 | 비용 절감 팁 |
|------|------|------|
| EKS 클러스터 | 시간당 요금 (컨트롤 플레인) | 불필요한 클러스터 삭제 |
| EC2 인스턴스 | 노드 그룹에 사용되는 인스턴스 유형 및 수량 | Spot 인스턴스 사용, 자동 확장 구성 |
| EBS 볼륨 | 노드 및 영구 볼륨에 사용되는 스토리지 | 불필요한 볼륨 삭제, 적절한 크기 설정 |
| NAT 게이트웨이 | 시간당 요금 및 데이터 처리 요금 | 개발 환경에서는 단일 NAT 게이트웨이 사용 |
| 로드 밸런서 | ALB/NLB 사용 시 시간당 요금 및 데이터 처리 요금 | 불필요한 로드 밸런서 삭제 |
| Route53 | 호스팅 영역 및 쿼리 요금 | 불필요한 호스팅 영역 삭제 |
| S3 | 스토리지 및 요청 요금 | 수명 주기 정책 설정, 불필요한 객체 삭제 |
| CloudWatch | 로그 스토리지 및 대시보드 요금 | 로그 보존 기간 최적화 |

> **비용 최적화 팁**: 개발 환경에서는 Spot 인스턴스, 자동 확장, 리소스 제한 등을 활용하여 비용을 절감할 수 있습니다. AWS Cost Explorer 및 Budgets를 사용하여 비용을 모니터링하고 관리하세요.

## 호환성 정보

### Terraform 호환성

| Terraform 버전 | 호환성 상태 | 비고 |
|------|------|------|
| 1.5.x | 완전 호환 | 권장 버전 |
| 1.4.x | 호환 | 일부 기능 제한 가능 |
| 1.3.x | 제한적 호환 | 일부 모듈에서 문제 발생 가능 |
| 1.2.x 이하 | 비호환 | 지원되지 않음 |

### AWS 제공자 호환성

| AWS 제공자 버전 | 호환성 상태 | 비고 |
|------|------|------|
| 5.x | 완전 호환 | 권장 버전 |
| 4.x | 호환 | 일부 기능 제한 가능 |
| 3.x | 제한적 호환 | 일부 모듈에서 문제 발생 가능 |
| 2.x 이하 | 비호환 | 지원되지 않음 |

### Kubernetes 버전 호환성

| Kubernetes 버전 | 호환성 상태 | 비고 |
|------|------|------|
| 1.28.x | 완전 호환 | 권장 버전 |
| 1.27.x | 완전 호환 | 권장 버전 |
| 1.26.x | 호환 | 지원됨 |
| 1.25.x | 호환 | 지원됨 |
| 1.24.x 이하 | 제한적 호환 | 일부 기능 제한 가능 |

## 추가 요구사항

- **Git 지식**: 버전 관리 및 협업을 위한 기본적인 Git 명령어 이해
- **Terraform 지식**: HCL(HashiCorp Configuration Language) 및 Terraform 워크플로우 이해
- **Kubernetes 지식**: 기본적인 Kubernetes 개념 및 리소스 이해
- **AWS 지식**: 주요 AWS 서비스(EC2, VPC, IAM, S3 등) 이해
- **Linux/Unix 명령어**: 기본적인 쉘 명령어 이해