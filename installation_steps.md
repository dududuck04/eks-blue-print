## 설치 및 구성

이 섹션에서는 AWS EKS Terraform 프로젝트를 설치하고 구성하는 단계별 지침을 제공합니다. 각 단계를 순서대로 따라 완전한 EKS 환경을 구축하세요.

### 1. 리포지토리 클론

먼저 Git을 사용하여 프로젝트 리포지토리를 로컬 시스템에 클론합니다:

```bash
git clone https://github.com/your-username/aws-eks-terraform.git
cd aws-eks-terraform
```

### 2. AWS 자격 증명 구성

AWS 리소스에 액세스하려면 적절한 자격 증명이 필요합니다. 다음 방법 중 하나를 선택하여 자격 증명을 구성하세요.

#### 2.1 AWS CLI 사용

AWS CLI를 사용하여 대화형으로 자격 증명을 구성합니다:

```bash
aws configure
```

#### 2.2 환경 변수 사용

또는 환경 변수를 설정하여 자격 증명을 구성할 수 있습니다:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="your-region"
```

#### 2.3 AWS IAM Identity Center(SSO) 사용

AWS IAM Identity Center(이전의 AWS SSO)를 사용하는 경우:

```bash
# SSO 로그인
aws sso login --profile your-sso-profile

# 프로필 사용 설정
export AWS_PROFILE=your-sso-profile
```

### 3. Terraform 백엔드 구성 (선택 사항)

프로덕션 환경에서는 Terraform 상태를 원격 백엔드에 저장하는 것이 좋습니다. S3 버킷과 DynamoDB 테이블을 생성하여 상태 파일을 안전하게 저장하고 잠금 기능을 구현할 수 있습니다.

```bash
# S3 버킷 생성
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region your-region \
  --create-bucket-configuration LocationConstraint=your-region

# 버킷 버전 관리 활성화
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# DynamoDB 테이블 생성
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

그런 다음 각 환경 디렉토리의 `versions.tf` 또는 `providers.tf` 파일에 백엔드 구성을 추가합니다:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "env/dev/network/terraform.tfstate"
    region         = "your-region"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### 4. 환경 변수 파일 설정

각 환경 디렉토리에서 예제 변수 파일을 복사하고 필요에 따라 수정합니다. 이 파일들은 Terraform에 필요한 변수 값을 제공합니다.

```bash
# 작업 디렉토리로 이동
cd ENV/DEV

# ECR 설정
cd 00_ECR
cp an2-kkm.tfvars terraform.tfvars

# terraform.tfvars 파일 편집
vi terraform.tfvars
```

`terraform.tfvars` 파일 예시 (ECR):

```hcl
region = "ap-northeast-2"
name   = "eks-dev"

ecr_repositories = [
  "app1",
  "app2",
  "app3"
]

tags = {
  Environment = "dev"
  Project     = "eks-terraform"
  Terraform   = "true"
}
```

네트워크 설정을 위한 변수 파일도 준비합니다:

```bash
# 네트워크 설정
cd ../01_Network
cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars 파일 편집
vi terraform.tfvars
```

`terraform.tfvars` 파일 예시 (Network):

```hcl
region = "ap-northeast-2"
name   = "eks-dev"

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

마찬가지로 EKS 및 기타 구성 요소에 대한 변수 파일도 설정합니다:

```bash
# EKS 설정
cd ../02_EKS
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars

# 필요에 따라 다른 디렉토리에 대해서도 동일한 작업 수행
```

### 5. 순차적 리소스 배포

리소스는 의존성을 고려하여 다음 순서로 배포해야 합니다. 각 단계에서는 `make` 명령어를 사용하여 Terraform 작업을 실행합니다.

#### 5.1 ECR 리포지토리 생성

```bash
cd ENV/DEV/00_ECR

# Terraform 초기화
make init

# 배포 계획 검토
make plan

# 리소스 배포
make apply
```

`make` 명령어가 작동하지 않는 경우 직접 Terraform 명령어를 실행할 수 있습니다:

```bash
terraform init
terraform plan -var-file=terraform.tfvars -out=tfplan
terraform apply tfplan
```

#### 5.2 네트워크 인프라 구성

```bash
cd ../01_Network

# Terraform 초기화
make init

# 배포 계획 검토
make plan

# 리소스 배포
make apply
```

배포가 완료되면 VPC ID, 서브넷 ID 등의 출력 값을 확인하고 기록해 둡니다. 이 값들은 다음 단계에서 필요할 수 있습니다.

#### 5.3 EKS 클러스터 배포

```bash
cd ../02_EKS

# Terraform 초기화
make init

# 배포 계획 검토
make plan

# 리소스 배포
make apply
```

EKS 클러스터 배포는 시간이 오래 걸릴 수 있습니다(약 15-20분). 배포가 완료될 때까지 기다립니다.

배포가 완료되면 클러스터 이름, 엔드포인트 URL 등의 출력 값을 확인하고 기록해 둡니다.

#### 5.4 Kubernetes 워크로드 배포

EKS 클러스터가 준비되면 Kubernetes 워크로드를 배포합니다. 워크로드는 다음 순서로 배포하는 것이 좋습니다:

```bash
cd ../03_Workload

# ArgoCD 배포
cd ArgoCD
make init
make plan
make apply

# Karpenter 배포
cd ../Karpenter
make init
make plan
make apply

# Cluster Autoscaler 배포
cd ../cluster-autoscaler
make init
make plan
make apply
```

각 워크로드 배포 후 상태를 확인하는 것이 좋습니다:

```bash
# kubectl 구성 업데이트 (클러스터 이름과 리전을 적절히 변경)
aws eks update-kubeconfig --name eks-dev --region ap-northeast-2

# ArgoCD 상태 확인
kubectl get pods -n argocd

# Karpenter 상태 확인
kubectl get pods -n karpenter

# Cluster Autoscaler 상태 확인
kubectl get pods -n kube-system | grep cluster-autoscaler
```

#### 5.5 S3 버킷 생성

```bash
cd ../04_S3
make init
make plan
make apply
```

### 6. kubectl 구성

EKS 클러스터에 접근하기 위해 kubectl 구성을 업데이트합니다. 이 명령은 로컬 kubeconfig 파일을 업데이트하여 EKS 클러스터에 접근할 수 있도록 합니다.

```bash
# 클러스터 이름과 리전을 적절히 변경
aws eks update-kubeconfig --name eks-dev --region ap-northeast-2

# kubeconfig 확인
kubectl config get-contexts
```

### 7. 클러스터 상태 확인

클러스터가 올바르게 배포되었는지 확인하기 위해 다음 명령을 실행합니다:

```bash
# 노드 상태 확인
kubectl get nodes

# 시스템 파드 상태 확인
kubectl get pods --all-namespaces

# 클러스터 정보 확인
kubectl cluster-info

# 네임스페이스 확인
kubectl get namespaces
```

### 8. 추가 구성 (선택 사항)

#### 8.1 대시보드 접근

ArgoCD 대시보드에 접근하려면 다음 명령을 사용하여 포트 포워딩을 설정합니다:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

그런 다음 웹 브라우저에서 `https://localhost:8080`으로 접속합니다.

초기 관리자 비밀번호를 가져오려면:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### 8.2 로그 확인

특정 파드의 로그를 확인하려면:

```bash
# 파드 이름 확인
kubectl get pods -n <namespace>

# 로그 확인
kubectl logs -f <pod-name> -n <namespace>
```

#### 8.3 클러스터 스케일링 테스트

Karpenter 또는 Cluster Autoscaler가 올바르게 작동하는지 테스트하려면 리소스 요청이 많은 워크로드를 배포합니다:

```bash
# 테스트 디플로이먼트 생성
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 5
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      containers:
      - name: inflate
        image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
        resources:
          requests:
            cpu: 1
            memory: 1Gi
EOF

# 노드 상태 모니터링
kubectl get nodes -w
```

### 9. 문제 해결 팁

#### 9.1 Terraform 오류

Terraform 적용 중 오류가 발생하면 다음을 확인하세요:

```bash
# 자세한 로그 확인
TF_LOG=DEBUG terraform apply

# 상태 확인
terraform state list
```

#### 9.2 EKS 클러스터 연결 문제

EKS 클러스터에 연결할 수 없는 경우:

```bash
# AWS CLI 버전 확인
aws --version

# IAM 자격 증명 확인
aws sts get-caller-identity

# EKS 클러스터 상태 확인
aws eks describe-cluster --name eks-dev --region ap-northeast-2
```

#### 9.3 파드 상태 문제

파드가 `Pending` 또는 `CrashLoopBackOff` 상태인 경우:

```bash
# 파드 세부 정보 확인
kubectl describe pod <pod-name> -n <namespace>

# 파드 로그 확인
kubectl logs <pod-name> -n <namespace>

# 노드 리소스 확인
kubectl describe node <node-name>
```

### 10. 정리 (선택 사항)

리소스를 삭제하려면 배포 순서의 역순으로 진행합니다:

```bash
# S3 버킷 삭제
cd ENV/DEV/04_S3
make destroy

# 워크로드 삭제
cd ../03_Workload/cluster-autoscaler
make destroy
cd ../Karpenter
make destroy
cd ../ArgoCD
make destroy

# EKS 클러스터 삭제
cd ../../02_EKS
make destroy

# 네트워크 인프라 삭제
cd ../01_Network
make destroy

# ECR 리포지토리 삭제
cd ../00_ECR
make destroy
```

> **주의**: `make destroy` 명령은 관련 리소스를 영구적으로 삭제합니다. 프로덕션 환경에서는 신중하게 사용하세요.