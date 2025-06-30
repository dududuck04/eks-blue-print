## 환경별 설정

이 프로젝트는 다양한 환경(DEV, STG, PRD 등)에서 사용할 수 있도록 설계되었습니다. 각 환경에 대한 구성 방법은 다음과 같습니다.

### 환경 구조 설정

환경을 추가하려면 `ENV` 디렉토리 아래에 해당 환경에 대한 디렉토리를 생성하면 됩니다:

```bash
mkdir -p ENV/STG/{00_ECR,01_Network,02_EKS,03_Workload,04_S3}
mkdir -p ENV/PRD/{00_ECR,01_Network,02_EKS,03_Workload,04_S3}
```

### 환경별 변수 파일 구성

각 환경에 대해 환경별 변수 파일을 구성해야 합니다. DEV 환경의 파일을 기반으로 하여 필요한 변경을 적용할 수 있습니다:

```bash
# 스테이징 환경 예시
cp -r ENV/DEV/00_ECR/* ENV/STG/00_ECR/
cp -r ENV/DEV/01_Network/* ENV/STG/01_Network/
cp -r ENV/DEV/02_EKS/* ENV/STG/02_EKS/
cp -r ENV/DEV/03_Workload/* ENV/STG/03_Workload/
cp -r ENV/DEV/04_S3/* ENV/STG/04_S3/

# 프로덕션 환경 예시
cp -r ENV/DEV/00_ECR/* ENV/PRD/00_ECR/
cp -r ENV/DEV/01_Network/* ENV/PRD/01_Network/
cp -r ENV/DEV/02_EKS/* ENV/PRD/02_EKS/
cp -r ENV/DEV/03_Workload/* ENV/PRD/03_Workload/
cp -r ENV/DEV/04_S3/* ENV/PRD/04_S3/
```

### 환경별 주요 구성 차이

각 환경에 따라 다음과 같은 구성 차이가 있을 수 있습니다:

#### 1. 네트워크 구성

| 파라미터 | DEV | STG | PRD |
|------|------|------|------|
| VPC CIDR | 10.0.0.0/16 | 10.1.0.0/16 | 10.2.0.0/16 |
| 가용 영역 | 2개 | 2개 | 3개 |
| NAT 게이트웨이 | 단일 | 단일 | 가용 영역별 |
| 서브넷 구성 | 기본 | 확장 | 고가용성 |
| VPC 엔드포인트 | 최소 필수 | 표준 | 전체 |

#### 2. EKS 클러스터 구성

| 파라미터 | DEV | STG | PRD |
|------|------|------|------|
| 클러스터 버전 | 1.27 | 1.27 | 1.27 |
| 노드 그룹 크기 | min: 2, max: 4 | min: 2, max: 6 | min: 3, max: 10 |
| 인스턴스 타입 | t3.medium | t3.large | m5.large |
| 용량 타입 | Spot | Spot | On-Demand |
| 컨트롤 플레인 로깅 | 최소 | 표준 | 전체 |
| 클러스터 암호화 | 기본 | 고급 | 고급 |

#### 3. 워크로드 구성

| 파라미터 | DEV | STG | PRD |
|------|------|------|------|
| ArgoCD | 기본 | 고가용성 | 고가용성 |
| Karpenter | 기본 | 확장 | 확장 |
| 로깅 | 최소한 | 표준 | 확장 |
| 모니터링 | 기본 | 표준 | 확장 |
| 백업 | 비활성화 | 일일 | 일일+주간 |
| 정책 적용 | 느슨함 | 중간 | 엄격함 |

### 환경별 변수 파일 구조 및 설정

각 환경 디렉토리에는 해당 환경에 특화된 변수 파일이 포함되어 있습니다. 이러한 파일은 일반적으로 `terraform.tfvars` 또는 특정 환경 이름을 포함한 파일(예: `dev.tfvars`)로 명명됩니다.

#### 변수 파일 구조

변수 파일은 다음과 같은 섹션으로 구성됩니다:

1. **기본 정보**: 리전, 환경 이름, 프로젝트 이름 등
2. **네트워크 설정**: VPC CIDR, 서브넷 CIDR, 가용 영역 등
3. **EKS 클러스터 설정**: 클러스터 버전, 노드 그룹 설정 등
4. **태그 및 메타데이터**: 리소스에 적용할 태그 및 메타데이터

#### 환경별 변수 파일 예시

##### DEV 환경 (Network)

```hcl
# ENV/DEV/01_Network/terraform.tfvars
region = "ap-northeast-2"
name   = "eks-dev"
env    = "dev"
pjt    = "eks-terraform"
costc  = "dev-infra"

vpc_cidr = "10.0.0.0/16"

azs = ["ap-northeast-2a", "ap-northeast-2c"]

public_subnets   = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnets  = ["10.0.32.0/20", "10.0.48.0/20"]
database_subnets = ["10.0.64.0/20", "10.0.80.0/20"]
pod_subnets      = ["10.0.96.0/20", "10.0.112.0/20"]

enable_nat_gateway = true
single_nat_gateway = true

tags = {
  Environment = "dev"
  Project     = "eks-terraform"
  Terraform   = "true"
}
```

##### PRD 환경 (Network)

```hcl
# ENV/PRD/01_Network/terraform.tfvars
region = "ap-northeast-2"
name   = "eks-prd"
env    = "prd"
pjt    = "eks-terraform"
costc  = "prd-infra"

vpc_cidr = "10.2.0.0/16"

azs = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]

public_subnets   = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
private_subnets  = ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
database_subnets = ["10.2.20.0/24", "10.2.21.0/24", "10.2.22.0/24"]
pod_subnets      = ["10.2.30.0/24", "10.2.31.0/24", "10.2.32.0/24"]

enable_nat_gateway = true
single_nat_gateway = false  # 각 AZ마다 NAT 게이트웨이 생성

tags = {
  Environment = "prd"
  Project     = "eks-terraform"
  Terraform   = "true"
}
```

#### EKS 클러스터 환경별 설정 예시

##### DEV 환경 (EKS)

```hcl
# ENV/DEV/02_EKS/terraform.tfvars
region = "ap-northeast-2"
name   = "eks-dev"
env    = "dev"
pjt    = "eks-terraform"
costc  = "dev-infra"

cluster_version = "1.27"

# 노드 그룹 설정
node_groups = {
  default = {
    name             = "default"
    min_size         = 2
    max_size         = 4
    desired_size     = 2
    instance_types   = ["t3.medium"]
    capacity_type    = "SPOT"
    disk_size        = 50
  }
}

# 클러스터 로깅 설정
cluster_enabled_log_types = ["api", "audit"]

# 클러스터 암호화 설정
cluster_encryption_config = {
  provider_key_arn = "arn:aws:kms:ap-northeast-2:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
  resources        = ["secrets"]
}

tags = {
  Environment = "dev"
  Project     = "eks-terraform"
  Terraform   = "true"
}
```

##### PRD 환경 (EKS)

```hcl
# ENV/PRD/02_EKS/terraform.tfvars
region = "ap-northeast-2"
name   = "eks-prd"
env    = "prd"
pjt    = "eks-terraform"
costc  = "prd-infra"

cluster_version = "1.27"

# 노드 그룹 설정
node_groups = {
  system = {
    name             = "system"
    min_size         = 3
    max_size         = 6
    desired_size     = 3
    instance_types   = ["m5.large"]
    capacity_type    = "ON_DEMAND"
    disk_size        = 100
    taints = {
      dedicated = {
        key    = "dedicated"
        value  = "system"
        effect = "NO_SCHEDULE"
      }
    }
  },
  application = {
    name             = "application"
    min_size         = 3
    max_size         = 10
    desired_size     = 3
    instance_types   = ["m5.large"]
    capacity_type    = "ON_DEMAND"
    disk_size        = 100
  }
}

# 클러스터 로깅 설정
cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

# 클러스터 암호화 설정
cluster_encryption_config = {
  provider_key_arn = "arn:aws:kms:ap-northeast-2:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
  resources        = ["secrets"]
}

tags = {
  Environment = "prd"
  Project     = "eks-terraform"
  Terraform   = "true"
}
```

### 환경별 배포 방법

각 환경에 대해 동일한 배포 절차를 따르지만, 해당 환경의 디렉토리에서 작업합니다:

```bash
# 예: 스테이징 환경의 EKS 클러스터 배포
cd ENV/STG/02_EKS
make init
make plan
make apply
```

### 환경별 관리 전략

환경을 효율적으로 관리하기 위한 전략은 다음과 같습니다:

#### 1. 환경별 상태 관리

각 환경의 Terraform 상태를 별도로 관리하여 환경 간 격리를 유지합니다:

```hcl
# ENV/DEV/02_EKS/providers.tf
terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-dev"
    key            = "eks/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# ENV/STG/02_EKS/providers.tf
terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-stg"
    key            = "eks/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# ENV/PRD/02_EKS/providers.tf
terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-prd"
    key            = "eks/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

#### 2. 환경별 태그 및 명명 규칙

리소스 식별과 비용 추적을 위해 일관된 태그 및 명명 규칙을 사용합니다:

```hcl
# 공통 태그 구조
tags = {
  Environment = var.env           # "dev", "stg", "prd"
  Project     = var.pjt           # 프로젝트 이름
  CostCenter  = var.costc         # 비용 센터 코드
  Terraform   = "true"            # Terraform으로 관리됨을 표시
  GitRepo     = var.github_repo   # 소스 코드 저장소
  GitPath     = var.github_path   # 저장소 내 경로
}

# 리소스 명명 규칙
name = "${var.pjt}-${var.env}-${var.resource_type}"
```

#### 3. 환경별 변수 관리

공통 변수와 환경별 변수를 효율적으로 관리합니다:

1. **공통 변수**: 모든 환경에서 공유되는 변수는 모듈 내에서 기본값으로 정의
2. **환경별 변수**: 각 환경의 `terraform.tfvars` 파일에서 재정의
3. **민감한 변수**: AWS Secrets Manager 또는 환경 변수를 통해 관리

#### 4. 환경 간 승격 전략

코드와 구성이 개발에서 프로덕션으로 이동하는 과정을 관리합니다:

1. **개발(DEV)**: 새로운 기능 및 변경 사항 테스트
2. **스테이징(STG)**: 프로덕션과 유사한 환경에서 통합 테스트
3. **프로덕션(PRD)**: 최종 사용자에게 서비스 제공

승격 프로세스:

```bash
# 1. DEV 환경에서 변경 사항 테스트
cd ENV/DEV/02_EKS
make plan
make apply

# 2. 변경 사항을 STG 환경에 적용
cd ../../STG/02_EKS
# 필요한 경우 terraform.tfvars 파일 수정
vi terraform.tfvars
make plan
make apply

# 3. 변경 사항을 PRD 환경에 적용
cd ../../PRD/02_EKS
# 필요한 경우 terraform.tfvars 파일 수정
vi terraform.tfvars
make plan
make apply
```

#### 5. 환경별 접근 제어

각 환경에 대한 접근을 제한하여 보안을 강화합니다:

1. **DEV**: 개발자 팀에 광범위한 접근 권한 부여
2. **STG**: 제한된 개발자 및 QA 팀에 접근 권한 부여
3. **PRD**: 운영 팀에만 제한된 접근 권한 부여

IAM 정책 예시:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["eks:*"],
      "Resource": "arn:aws:eks:ap-northeast-2:123456789012:cluster/eks-dev-*"
    },
    {
      "Effect": "Deny",
      "Action": ["eks:*"],
      "Resource": [
        "arn:aws:eks:ap-northeast-2:123456789012:cluster/eks-stg-*",
        "arn:aws:eks:ap-northeast-2:123456789012:cluster/eks-prd-*"
      ]
    }
  ]
}
```