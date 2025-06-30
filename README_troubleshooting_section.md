# 문제 해결

이 섹션에서는 AWS EKS Terraform 프로젝트를 사용하면서 발생할 수 있는 일반적인 문제와 해결 방법을 제공합니다. 또한 디버깅 팁과 자주 묻는 질문(FAQ)도 포함되어 있습니다.

## 일반적인 문제와 해결 방법

### Terraform 관련 문제

#### 1. Terraform 초기화 실패

**문제**: `terraform init` 또는 `make init` 명령이 실패하고 프로바이더 또는 모듈을 다운로드할 수 없습니다.

**해결 방법**:
- 인터넷 연결을 확인하세요.
- 프록시 설정이 올바른지 확인하세요.
- Terraform 버전이 요구 사항을 충족하는지 확인하세요 (`terraform version`).
- AWS 프로필이 올바르게 설정되어 있는지 확인하세요. Makefile의 `PROFILE_NAME` 변수를 확인하고 필요한 경우 수정하세요.
- 다음 명령을 사용하여 Terraform 캐시를 정리해 보세요:
  ```bash
  make clean
  make init
  ```

#### 2. Terraform 계획/적용 실패

**문제**: `terraform plan` 또는 `terraform apply` 명령이 오류와 함께 실패합니다.

**해결 방법**:
- 오류 메시지를 주의 깊게 읽고 문제를 파악하세요.
- AWS 자격 증명이 올바르게 구성되어 있는지 확인하세요 (`aws sts get-caller-identity`).
- 필요한 IAM 권한이 있는지 확인하세요.
- 변수 파일(`env/<환경>.tfvars`)이 올바르게 구성되어 있는지 확인하세요.
- 결과 로그 파일을 확인하세요 (`results/plan-<환경>-output-<타임스탬프>.log` 또는 `results/apply-<환경>-output-<타임스탬프>.log`).
- 자세한 로그를 확인하려면 다음 명령을 사용하세요:
  ```bash
  TF_LOG=DEBUG AWS_PROFILE=<프로필명> terraform apply -var-file=env/<환경>.tfvars
  ```

#### 3. Terraform 상태 잠금 문제

**문제**: 다른 Terraform 작업이 실행 중이라는 오류 메시지가 표시됩니다.

**해결 방법**:
- 다른 Terraform 작업이 실행 중인지 확인하세요.
- 이전 작업이 비정상적으로 종료된 경우 DynamoDB에서 잠금을 수동으로 해제해야 할 수 있습니다:
  ```bash
  aws dynamodb delete-item \
    --table-name terraform-state-lock \
    --key '{"LockID": {"S": "your-lock-id"}}'
  ```
- 로컬 상태 파일을 사용하는 경우 `.terraform.tfstate.lock.info` 파일을 삭제하세요.

### AWS 관련 문제

#### 1. AWS 자격 증명 문제

**문제**: AWS 자격 증명이 없거나 만료되었다는 오류 메시지가 표시됩니다.

**해결 방법**:
- AWS CLI가 올바르게 구성되어 있는지 확인하세요:
  ```bash
  aws configure list
  ```
- 자격 증명이 만료된 경우 갱신하세요:
  ```bash
  aws configure
  ```
- IAM Identity Center(SSO)를 사용하는 경우 다시 로그인하세요:
  ```bash
  aws sso login --profile <프로필명>
  ```
- 환경 변수가 올바르게 설정되어 있는지 확인하세요:
  ```bash
  echo $AWS_ACCESS_KEY_ID
  echo $AWS_SECRET_ACCESS_KEY
  echo $AWS_REGION
  ```
- Makefile에서 사용하는 프로필이 올바른지 확인하세요. 필요한 경우 Makefile의 `PROFILE_NAME` 변수를 수정하세요.

#### 2. 서비스 할당량 초과

**문제**: AWS 서비스 할당량을 초과했다는 오류 메시지가 표시됩니다.

**해결 방법**:
- AWS 콘솔에서 Service Quotas 서비스를 확인하여 현재 사용량과 한도를 확인하세요.
- 필요한 경우 할당량 증가를 요청하세요.
- 리소스를 정리하거나 불필요한 리소스를 삭제하여 사용량을 줄이세요.

#### 3. VPC 리소스 제한

**문제**: VPC, 서브넷, 보안 그룹 등의 네트워크 리소스를 생성할 수 없습니다.

**해결 방법**:
- 리전별 VPC 리소스 제한을 확인하세요.
- 불필요한 VPC 리소스를 정리하세요.
- 필요한 경우 할당량 증가를 요청하세요.

### EKS 관련 문제

#### 1. EKS 클러스터 생성 실패

**문제**: EKS 클러스터 생성이 실패하고 오류 메시지가 표시됩니다.

**해결 방법**:
- IAM 권한이 충분한지 확인하세요.
- VPC 및 서브넷 구성이 EKS 요구 사항을 충족하는지 확인하세요.
- 서브넷에 올바른 태그가 지정되어 있는지 확인하세요:
  ```bash
  aws ec2 describe-subnets --subnet-ids <서브넷ID> --query "Subnets[].Tags"
  ```
- CloudTrail 로그를 확인하여 자세한 오류 정보를 확인하세요.
- 결과 로그 파일을 확인하세요 (`results/apply-<환경>-output-<타임스탬프>.log`).

#### 2. 노드 그룹 생성 실패

**문제**: EKS 노드 그룹 생성이 실패하고 오류 메시지가 표시됩니다.

**해결 방법**:
- IAM 역할 및 정책이 올바르게 구성되어 있는지 확인하세요.
- 인스턴스 유형이 선택한 리전에서 사용 가능한지 확인하세요.
- AMI ID가 올바른지 확인하세요.
- 보안 그룹 규칙이 노드와 컨트롤 플레인 간의 통신을 허용하는지 확인하세요.
- CloudFormation 스택 이벤트를 확인하여 자세한 오류 정보를 확인하세요:
  ```bash
  aws cloudformation describe-stack-events --stack-name <스택명>
  ```

#### 3. kubectl 연결 문제

**문제**: kubectl을 사용하여 EKS 클러스터에 연결할 수 없습니다.

**해결 방법**:
- kubeconfig가 올바르게 구성되어 있는지 확인하세요:
  ```bash
  aws eks update-kubeconfig --name <클러스터명> --region <리전> --profile <프로필명>
  ```
- AWS CLI 버전이 최신인지 확인하세요:
  ```bash
  aws --version
  ```
- IAM 자격 증명이 클러스터에 액세스할 수 있는 권한이 있는지 확인하세요:
  ```bash
  aws sts get-caller-identity --profile <프로필명>
  ```
- aws-iam-authenticator가 설치되어 있고 PATH에 있는지 확인하세요:
  ```bash
  aws-iam-authenticator version
  ```

## 디버깅 팁과 로그 확인 방법

### Terraform 디버깅

#### 1. 자세한 로그 활성화

Terraform 작업의 자세한 로그를 확인하려면 `TF_LOG` 환경 변수를 설정하세요:

```bash
# 가장 자세한 로그 수준
TF_LOG=TRACE AWS_PROFILE=<프로필명> terraform apply -var-file=env/<환경>.tfvars

# 디버그 수준 로그
TF_LOG=DEBUG AWS_PROFILE=<프로필명> terraform apply -var-file=env/<환경>.tfvars

# 로그를 파일에 저장
TF_LOG=DEBUG TF_LOG_PATH=./terraform.log AWS_PROFILE=<프로필명> terraform apply -var-file=env/<환경>.tfvars
```

#### 2. Terraform 상태 검사

현재 Terraform 상태를 검사하여 문제를 진단하세요:

```bash
# 상태에 있는 모든 리소스 나열
AWS_PROFILE=<프로필명> terraform state list

# 특정 리소스의 상태 확인
AWS_PROFILE=<프로필명> terraform state show 'aws_eks_cluster.this'

# 상태 파일 검사
AWS_PROFILE=<프로필명> terraform show
```

#### 3. Terraform 계획 파일 저장 및 검사

계획 파일을 저장하고 검사하여 예상 변경 사항을 확인하세요:

```bash
# 계획 저장
AWS_PROFILE=<프로필명> terraform plan -var-file=env/<환경>.tfvars -out=tfplan

# 계획 검사
terraform show tfplan

# JSON 형식으로 계획 검사
terraform show -json tfplan | jq
```

### AWS 디버깅

#### 1. AWS CLI를 사용한 리소스 검사

AWS CLI를 사용하여 리소스 상태를 확인하세요:

```bash
# EKS 클러스터 상태 확인
aws eks describe-cluster --name <클러스터명> --profile <프로필명>

# EC2 인스턴스 확인
aws ec2 describe-instances --filters "Name=tag:Name,Values=eks-node*" --profile <프로필명>

# VPC 및 서브넷 확인
aws ec2 describe-vpcs --profile <프로필명>
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<VPC-ID>" --profile <프로필명>
```

#### 2. CloudTrail 로그 확인

AWS CloudTrail을 사용하여 API 호출 및 오류를 확인하세요:

```bash
# 최근 이벤트 확인
aws cloudtrail lookup-events --max-results 10 --profile <프로필명>

# 특정 리소스에 대한 이벤트 확인
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceName,AttributeValue=<리소스명> --profile <프로필명>
```

#### 3. CloudWatch 로그 확인

CloudWatch Logs를 사용하여 EKS 및 기타 서비스의 로그를 확인하세요:

```bash
# 로그 그룹 나열
aws logs describe-log-groups --profile <프로필명>

# 로그 스트림 나열
aws logs describe-log-streams --log-group-name <로그그룹명> --profile <프로필명>

# 로그 이벤트 확인
aws logs get-log-events --log-group-name <로그그룹명> --log-stream-name <로그스트림명> --profile <프로필명>
```

### Kubernetes 디버깅

#### 1. 클러스터 상태 확인

클러스터 상태를 확인하여 문제를 진단하세요:

```bash
# 노드 상태 확인
kubectl get nodes
kubectl describe nodes

# 네임스페이스 확인
kubectl get namespaces

# 모든 리소스 확인
kubectl get all --all-namespaces
```

#### 2. 파드 로그 및 이벤트 확인

파드 로그 및 이벤트를 확인하여 문제를 진단하세요:

```bash
# 파드 로그 확인
kubectl logs <파드명> -n <네임스페이스>

# 이전 컨테이너의 로그 확인
kubectl logs <파드명> -n <네임스페이스> --previous

# 파드 이벤트 확인
kubectl describe pod <파드명> -n <네임스페이스>

# 실시간 로그 스트리밍
kubectl logs -f <파드명> -n <네임스페이스>
```

#### 3. 네트워크 연결 테스트

네트워크 연결 문제를 진단하세요:

```bash
# 임시 디버깅 파드 생성
kubectl run debug --image=busybox --rm -it -- sh

# 네트워크 연결 테스트
ping <서비스명>
wget -O- http://<서비스명>:<포트>
nc -zv <서비스명> <포트>
```

#### 4. kube-system 네임스페이스 확인

시스템 구성 요소의 상태를 확인하세요:

```bash
# kube-system 파드 확인
kubectl get pods -n kube-system

# CoreDNS 로그 확인
kubectl logs -l k8s-app=kube-dns -n kube-system

# kube-proxy 로그 확인
kubectl logs -l k8s-app=kube-proxy -n kube-system
```

## 자주 묻는 질문(FAQ)

### 일반적인 질문

#### Q: 이 프로젝트를 사용하기 위한 최소 AWS 권한은 무엇인가요?
A: 최소한 EKS, EC2, IAM, VPC, S3, CloudWatch 서비스에 대한 권한이 필요합니다. 자세한 내용은 [사전 요구사항](#사전-요구사항) 섹션의 IAM 권한 설정을 참조하세요.

#### Q: 프로덕션 환경에서 이 프로젝트를 사용하기 위한 권장 사항은 무엇인가요?
A: 프로덕션 환경에서는 다음을 권장합니다:
- 원격 Terraform 백엔드(S3 + DynamoDB) 사용
- 최소 3개의 가용 영역에 걸쳐 고가용성 구성
- 적절한 노드 크기 및 자동 확장 설정
- 보안 강화(KMS 암호화, 프라이빗 엔드포인트, 네트워크 정책 등)
- 정기적인 백업 및 재해 복구 계획

#### Q: 여러 환경(개발, 스테이징, 프로덕션)을 어떻게 관리해야 하나요?
A: ENV 디렉토리 아래에 각 환경에 대한 별도의 디렉토리(DEV, STG, PRD 등)를 생성하고, 환경별 변수 파일을 사용하여 구성을 관리하세요. 각 환경에 대해 별도의 Terraform 상태 파일을 사용하는 것이 좋습니다.

### Terraform 관련 질문

#### Q: Terraform 상태 파일을 어떻게 안전하게 관리해야 하나요?
A: 다음 방법을 사용하여 Terraform 상태 파일을 안전하게 관리하세요:
- S3 버킷에 원격으로 저장
- 버전 관리 활성화
- 서버 측 암호화 사용
- DynamoDB를 사용한 상태 잠금 구현
- 액세스 제한 및 로깅 활성화

#### Q: Terraform 모듈을 어떻게 업데이트해야 하나요?
A: 모듈을 업데이트하려면 다음 단계를 따르세요:
1. 변경 사항을 테스트 환경에서 먼저 테스트
2. `terraform init -upgrade` 명령을 사용하여 모듈 업데이트
3. `terraform plan`을 실행하여 변경 사항 확인
4. 변경 사항이 안전한 경우 `terraform apply` 실행

#### Q: Terraform 작업이 중간에 실패하면 어떻게 해야 하나요?
A: 다음 단계를 따르세요:
1. 오류 메시지를 확인하고 문제 해결
2. 필요한 경우 수동으로 불완전한 리소스 정리
3. 상태 파일이 손상된 경우 백업에서 복원
4. 문제가 해결되면 `terraform plan` 및 `terraform apply` 다시 실행

### EKS 관련 질문

#### Q: EKS 클러스터 버전을 어떻게 업그레이드해야 하나요?
A: EKS 클러스터 버전을 업그레이드하려면 다음 단계를 따르세요:
1. Terraform 변수 파일(`env/<환경>.tfvars`)에서 `cluster_version` 값을 업데이트
2. `make plan`을 실행하여 변경 사항 확인
3. `make apply`를 실행하여 컨트롤 플레인 업그레이드
4. 노드 그룹을 업그레이드하려면 새 노드 그룹을 생성하고 워크로드를 마이그레이션한 후 이전 노드 그룹 삭제

#### Q: EKS 클러스터에 새 노드 그룹을 어떻게 추가하나요?
A: 새 노드 그룹을 추가하려면 다음 단계를 따르세요:
1. Terraform 변수 파일(`env/<환경>.tfvars`)에 새 노드 그룹 구성 추가
2. `make plan`을 실행하여 변경 사항 확인
3. `make apply`를 실행하여 새 노드 그룹 생성
4. 필요한 경우 워크로드를 새 노드 그룹으로 마이그레이션

#### Q: EKS 클러스터에 새 애드온을 어떻게 추가하나요?
A: 새 애드온을 추가하려면 다음 단계를 따르세요:
1. Terraform 변수 파일(`env/<환경>.tfvars`)에 새 애드온 구성 추가
2. `make plan`을 실행하여 변경 사항 확인
3. `make apply`를 실행하여 새 애드온 배포
4. 애드온 상태 확인: `kubectl get pods -n <애드온-네임스페이스>`

### Kubernetes 관련 질문

#### Q: kubectl이 "Unable to connect to the server" 오류를 표시하면 어떻게 해야 하나요?
A: 다음을 확인하세요:
1. kubeconfig가 올바르게 구성되어 있는지 확인: `aws eks update-kubeconfig --name <클러스터명> --region <리전> --profile <프로필명>`
2. AWS 자격 증명이 유효한지 확인: `aws sts get-caller-identity --profile <프로필명>`
3. VPN 또는 프록시 설정이 연결을 방해하지 않는지 확인
4. 클러스터 API 서버가 실행 중인지 확인: `aws eks describe-cluster --name <클러스터명> --profile <프로필명>`

#### Q: 파드가 ImagePullBackOff 오류를 표시하면 어떻게 해야 하나요?
A: 다음을 확인하세요:
1. 이미지 이름과 태그가 올바른지 확인
2. 프라이빗 레지스트리를 사용하는 경우 이미지 풀 시크릿이 구성되어 있는지 확인
3. 노드가 인터넷에 액세스할 수 있는지 확인
4. ECR을 사용하는 경우 노드 IAM 역할에 ECR 액세스 권한이 있는지 확인

#### Q: Kubernetes 리소스를 삭제할 수 없고 "Terminating" 상태로 멈춰 있으면 어떻게 해야 하나요?
A: 다음 명령을 사용하여 리소스를 강제로 삭제하세요:
```bash
kubectl delete pod <파드명> -n <네임스페이스> --grace-period=0 --force
```
또는 파이널라이저를 제거하세요:
```bash
kubectl patch pod <파드명> -n <네임스페이스> -p '{"metadata":{"finalizers":[]}}' --type=merge
```

#### Q: EKS 클러스터의 DNS 문제를 어떻게 해결하나요?
A: 다음을 확인하세요:
1. CoreDNS 파드가 실행 중인지 확인: `kubectl get pods -n kube-system -l k8s-app=kube-dns`
2. CoreDNS 로그 확인: `kubectl logs -l k8s-app=kube-dns -n kube-system`
3. DNS 구성 확인: `kubectl get configmap coredns -n kube-system -o yaml`
4. 테스트 파드를 생성하여 DNS 확인 테스트:
   ```bash
   kubectl run dnsutils --image=tutum/dnsutils --rm -it -- bash
   # 파드 내에서
   nslookup kubernetes.default.svc.cluster.local
   ```