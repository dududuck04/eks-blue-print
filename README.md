# AWS EKS Terraform
## 📘 프로젝트 개요
이 Terraform 프로젝트는 AWS 기반의 EKS와 관련된 네트워크 및 기타 필요한 인프라 리소스를 관리 및 배포하기 위한 IaC(Infrastructure as Code) 솔루션입니다. 모듈화를 통해 유연한 네트워크 설정과 EKS 배포 과정을 제공합니다.
## 🔧 핵심 기능
- **AWS 네트워크 구성**:
    - VPC 및 서브넷 생성 (Public, Private, DB 서브넷 포함)
    - NAT Gateway 및 Bastion Host 설정
    - Direct Connect 및 Virtual Private Gateway 가능
    - VPC Endpoints 생성 (S3, ECR, EC2, STS 등)

- **EKS 연동**
    - Private Subnet 내 EKS 클러스터 구성 가능

- **Route53 설정**
    - 도메인 이름 관리 및 선택적 Route53 생성 가능

- **IAM 정책 연동**
    - GitHub Actions 및 GitLab Runner와의 통합을 지원하는 IAM Role/OIDC 설정

- **ECR 관리**
    - 컨테이너 이미지를 저장할 ECR 리포지토리 생성

- **모듈화된 접근**
    - 네트워크 모듈(`modules/network`)을 통한 효율적 관리

## 📦 디렉토리 구조
``` 
.
├── ENV/
│   └── DEV/
│       ├── ECR/                     # ECR 구성 파일
│       ├── Network/                 # 네트워크 및 VPC 구성 파일
│       ├── Makefile                 # Terraform 명령어 실행용 파일
│       ├── variables.tf             # 변수 정의
│       ├── output.tf                # 결과 값 출력
│       └── terraform.tfstate        # (관리 필요: .gitignore 권장)
├── modules/
│   └── network/                     # 네트워크 모듈
└── README.md                        # 프로젝트 문서
```
## 🚀 사용 방법
### 1. **사전 요구사항**
- Terraform CLI 설치 (버전 `>= 1.0`)
- AWS CLI 설치 및 자격 증명 구성
    - AWS 액세스 키 및 시크릿 키 설정

- `terraform.tfstate` 파일을 원격 Backend로 설정 권장 (Ex: AWS S3)

### 2. **초기화**
Terraform을 초기화합니다:
``` bash
AWS_PROFILE=<YOUR_AWS_PROFILE> terraform init
```
### 3. **계획 생성**
플랜을 생성하여 리소스 변경 사항을 미리 확인합니다:
``` bash
AWS_PROFILE=<YOUR_AWS_PROFILE> terraform plan -var-file=<ENV_NAME>.tfvars
```
### 4. **리소스 적용**
리소스를 생성하거나 변경 사항을 적용합니다:
``` bash
AWS_PROFILE=<YOUR_AWS_PROFILE> terraform apply -var-file=<ENV_NAME>.tfvars -auto-approve
```
### 5. **리소스 파괴 (선택 사항)**
모든 리소스를 제거합니다:
``` bash
AWS_PROFILE=<YOUR_AWS_PROFILE> terraform destroy -var-file=<ENV_NAME>.tfvars -auto-approve
```
## 🗂️ 주요 파일 설명
### `variables.tf`
환경별 설정을 관리하기 위한 변수 파일. 주요 설정은 다음과 같습니다:
- **Region**: AWS 리전을 설정 (예: `ap-northeast-2`)
- **vpc_cidr**: VPC의 CIDR 블록 설정
- **NAT**, **Bastion Host**, **Route53** 등의 선택적 생성 여부 설정 가능

### `output.tf`
Terraform 실행 결과로 생성된 리소스 정보를 출력. 주요 출력값:
- VPC ID
- Subnet ID 및 CIDR
- EIP (Elastic IP) 등

### `Makefile`
테라폼 명령어를 쉽게 실행할 수 있도록 정의된 설정 파일. 예제:
- `terraform init` → `make init`
- `terraform plan` → `make plan`
- `terraform apply` → `make apply`

## ⚠️ 주의사항
1. **`terraform.tfstate` 파일 관리**:
    - 로컬에서 관리하지 않고, AWS S3와 같은 Remote Backend로 설정 권장

2. **`*.tfvars` 파일 보호**:
    - 민감 정보 포함 가능, Git에 커밋하지 않도록 처리 (`.gitignore` 추가)

3. **환경별 네트워크 설정**:
    - Production 환경은 Public CIDR 접근 제한 설정 필요
    - Bastion Host 용도의 CIDR을 내부망으로 제한해야 보안 강화 가능
