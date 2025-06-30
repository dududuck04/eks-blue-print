## 주요 명령어 및 예제

이 섹션에서는 AWS EKS Terraform 프로젝트를 사용할 때 자주 사용되는 명령어와 그 용도를 설명하고, 실제 사용 예제와 코드 스니펫을 제공합니다.

### Terraform 기본 명령어

| 명령어 | 설명 | 사용 예시 |
|------|------|------|
| `terraform init` | 작업 디렉토리를 초기화하고 필요한 플러그인을 다운로드합니다. | `terraform init` 또는 `make init` |
| `terraform plan` | 현재 상태와 구성 파일을 비교하여 실행 계획을 생성합니다. | `terraform plan -var-file=terraform.tfvars` 또는 `make plan` |
| `terraform apply` | 실행 계획을 적용하여 인프라를 생성 또는 변경합니다. | `terraform apply tfplan` 또는 `make apply` |
| `terraform destroy` | 생성된 모든 리소스를 삭제합니다. | `terraform destroy -var-file=terraform.tfvars` 또는 `make destroy` |
| `terraform state list` | 현재 상태에 있는 모든 리소스를 나열합니다. | `terraform state list` |
| `terraform output` | 출력 변수의 값을 표시합니다. | `terraform output vpc_id` |
| `terraform validate` | 구성 파일의 구문을 검증합니다. | `terraform validate` |
| `terraform fmt` | 구성 파일을 표준 형식으로 재구성합니다. | `terraform fmt` |

### Makefile 명령어

프로젝트의 각 디렉토리에는 Terraform 작업을 간소화하기 위한 `Makefile`이 포함되어 있습니다. 다음은 주요 `make` 명령어입니다:

```bash
# Terraform 초기화
make init

# 실행 계획 생성
make plan

# 변경 사항 적용
make apply

# 리소스 삭제
make destroy

# 상태 확인
make state
```

### AWS CLI 명령어

#### EKS 클러스터 관리

```bash
# EKS 클러스터 목록 조회
aws eks list-clusters --region ap-northeast-2

# 특정 클러스터 세부 정보 조회
aws eks describe-cluster --name eks-dev --region ap-northeast-2

# kubectl 구성 업데이트
aws eks update-kubeconfig --name eks-dev --region ap-northeast-2

# 클러스터 버전 업데이트 상태 확인
aws eks describe-update --name eks-dev --update-id <update-id> --region ap-northeast-2

# 클러스터의 노드 그룹 목록 조회
aws eks list-nodegroups --cluster-name eks-dev --region ap-northeast-2

# 특정 노드 그룹 세부 정보 조회
aws eks describe-nodegroup --cluster-name eks-dev --nodegroup-name eks-dev-node-group --region ap-northeast-2
```

#### ECR 관리

```bash
# ECR 리포지토리 목록 조회
aws ecr describe-repositories --region ap-northeast-2

# ECR 로그인
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-northeast-2.amazonaws.com

# 이미지 태그 지정
docker tag my-app:latest <account-id>.dkr.ecr.ap-northeast-2.amazonaws.com/my-app:latest

# 이미지 푸시
docker push <account-id>.dkr.ecr.ap-northeast-2.amazonaws.com/my-app:latest

# 이미지 목록 조회
aws ecr list-images --repository-name my-app --region ap-northeast-2
```

#### IAM 관리

```bash
# OIDC 제공자 목록 조회
aws iam list-open-id-connect-providers

# 역할 목록 조회
aws iam list-roles | grep eks

# 정책 목록 조회
aws iam list-policies --scope Local

# 역할에 연결된 정책 목록 조회
aws iam list-attached-role-policies --role-name eks-dev-cluster-role
```

### kubectl 명령어

#### 기본 리소스 관리

```bash
# 노드 목록 조회
kubectl get nodes

# 파드 목록 조회 (모든 네임스페이스)
kubectl get pods --all-namespaces

# 특정 네임스페이스의 파드 목록 조회
kubectl get pods -n kube-system

# 서비스 목록 조회
kubectl get services --all-namespaces

# 디플로이먼트 목록 조회
kubectl get deployments --all-namespaces

# 스테이트풀셋 목록 조회
kubectl get statefulsets --all-namespaces

# 데몬셋 목록 조회
kubectl get daemonsets --all-namespaces

# 컨피그맵 목록 조회
kubectl get configmaps -n kube-system

# 시크릿 목록 조회
kubectl get secrets -n kube-system

# 영구 볼륨 클레임 목록 조회
kubectl get pvc --all-namespaces
```

#### 리소스 세부 정보 및 디버깅

```bash
# 노드 세부 정보 조회
kubectl describe node <node-name>

# 파드 세부 정보 조회
kubectl describe pod <pod-name> -n <namespace>

# 파드 로그 조회
kubectl logs <pod-name> -n <namespace>

# 이전 파드 로그 조회
kubectl logs <pod-name> -n <namespace> --previous

# 컨테이너 로그 조회 (다중 컨테이너 파드)
kubectl logs <pod-name> -c <container-name> -n <namespace>

# 파드 내 명령 실행
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash

# 파드 내 특정 명령 실행
kubectl exec <pod-name> -n <namespace> -- ls -la

# 리소스 YAML 출력
kubectl get pod <pod-name> -n <namespace> -o yaml

# 리소스 JSON 출력
kubectl get pod <pod-name> -n <namespace> -o json
```

#### 네임스페이스 및 컨텍스트 관리

```bash
# 네임스페이스 목록 조회
kubectl get namespaces

# 네임스페이스 생성
kubectl create namespace <namespace-name>

# 현재 컨텍스트 조회
kubectl config current-context

# 컨텍스트 목록 조회
kubectl config get-contexts

# 컨텍스트 전환
kubectl config use-context <context-name>

# 네임스페이스 전환
kubectl config set-context --current --namespace=<namespace-name>
```

### 실제 사용 예제

#### 예제 1: 새로운 EKS 클러스터 배포

```bash
# 1. 네트워크 인프라 배포
cd ENV/DEV/01_Network
make init
make plan
make apply

# 2. EKS 클러스터 배포
cd ../02_EKS
make init
make plan
make apply

# 3. kubectl 구성 및 클러스터 접근
aws eks update-kubeconfig --name eks-dev --region ap-northeast-2
kubectl get nodes
```

#### 예제 2: 노드 그룹 스케일링

```bash
# terraform.tfvars 파일 수정
cd ENV/DEV/02_EKS
vi terraform.tfvars

# 변경 사항:
# eks_managed_node_groups = {
#   default = {
#     desired_size = 2  # 2에서 3으로 변경
#     min_size     = 1
#     max_size     = 5
#   }
# }

# 변경 사항 적용
make plan
make apply

# 노드 상태 확인
kubectl get nodes
```

#### 예제 3: 새로운 애플리케이션 배포

```bash
# 1. 네임스페이스 생성
kubectl create namespace my-app

# 2. 디플로이먼트 생성
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: <account-id>.dkr.ecr.ap-northeast-2.amazonaws.com/my-app:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
EOF

# 3. 서비스 생성
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: my-app
  namespace: my-app
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
EOF

# 4. 인그레스 생성
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: my-app
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app
            port:
              number: 80
EOF

# 5. 배포 상태 확인
kubectl get pods -n my-app
kubectl get svc -n my-app
kubectl get ingress -n my-app
```

#### 예제 4: EKS 클러스터 버전 업그레이드

```bash
# 1. 현재 클러스터 버전 확인
kubectl version --short
aws eks describe-cluster --name eks-dev --region ap-northeast-2 --query "cluster.version"

# 2. terraform.tfvars 파일 수정
cd ENV/DEV/02_EKS
vi terraform.tfvars

# 변경 사항:
# cluster_version = "1.27" -> cluster_version = "1.28"

# 3. 변경 사항 적용
make plan
make apply

# 4. 업그레이드 상태 확인
aws eks describe-cluster --name eks-dev --region ap-northeast-2 --query "cluster.version"

# 5. 노드 그룹 업그레이드 (필요한 경우)
# terraform.tfvars 파일에서 노드 그룹 버전 업데이트
vi terraform.tfvars

# 변경 사항:
# eks_managed_node_groups = {
#   default = {
#     ami_release_version = "1.28.x-xxxx.xx.xx"
#   }
# }

make plan
make apply

# 6. 노드 버전 확인
kubectl get nodes -o wide
```

#### 예제 5: 클러스터 애드온 관리

```bash
# 1. 현재 설치된 애드온 확인
aws eks list-addons --cluster-name eks-dev --region ap-northeast-2

# 2. terraform.tfvars 파일 수정하여 애드온 추가
cd ENV/DEV/02_EKS
vi terraform.tfvars

# 변경 사항:
# cluster_addons = {
#   coredns = {
#     most_recent = true
#   }
#   kube-proxy = {
#     most_recent = true
#   }
#   vpc-cni = {
#     most_recent = true
#   }
#   aws-ebs-csi-driver = {  # 새로운 애드온 추가
#     most_recent = true
#   }
# }

# 3. 변경 사항 적용
make plan
make apply

# 4. 애드온 상태 확인
aws eks list-addons --cluster-name eks-dev --region ap-northeast-2
kubectl get pods -n kube-system | grep ebs-csi-controller
```

#### 예제 6: IRSA(IAM Roles for Service Accounts) 설정

```bash
# 1. terraform.tfvars 파일 수정
cd ENV/DEV/02_EKS
vi terraform.tfvars

# 변경 사항:
# irsa_roles = {
#   "s3-reader" = {
#     namespace       = "default"
#     service_account = "s3-reader"
#     policy_arns     = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
#   }
# }

# 2. 변경 사항 적용
make plan
make apply

# 3. 서비스 계정 생성
kubectl create serviceaccount s3-reader -n default

# 4. 파드 생성하여 IRSA 테스트
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: s3-reader-test
  namespace: default
spec:
  serviceAccountName: s3-reader
  containers:
  - name: aws-cli
    image: amazon/aws-cli:latest
    command:
    - sleep
    - "3600"
EOF

# 5. 파드에서 AWS CLI 명령 실행하여 IRSA 테스트
kubectl exec -it s3-reader-test -- aws s3 ls
```

#### 예제 7: 클러스터 로깅 및 모니터링 설정

```bash
# 1. CloudWatch 로깅 활성화
cd ENV/DEV/02_EKS
vi terraform.tfvars

# 변경 사항:
# cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

make plan
make apply

# 2. Prometheus 및 Grafana 배포
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=gp2 \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=10Gi

# 3. Grafana 대시보드 접근
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring

# 4. CloudWatch 로그 확인
aws logs describe-log-groups --log-group-name-prefix /aws/eks/eks-dev --region ap-northeast-2
```

#### 예제 8: 클러스터 백업 및 복원

```bash
# 1. Velero 설치
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update

kubectl create namespace velero

# S3 버킷 생성
aws s3api create-bucket \
  --bucket eks-dev-backup \
  --region ap-northeast-2 \
  --create-bucket-configuration LocationConstraint=ap-northeast-2

# Velero 배포
helm install velero vmware-tanzu/velero \
  --namespace velero \
  --set configuration.provider=aws \
  --set-file credentials.secretContents.cloud=./credentials-velero \
  --set configuration.backupStorageLocation.name=aws \
  --set configuration.backupStorageLocation.bucket=eks-dev-backup \
  --set configuration.backupStorageLocation.config.region=ap-northeast-2 \
  --set snapshotsEnabled=true \
  --set deployRestic=true

# 2. 백업 생성
velero backup create eks-dev-backup --include-namespaces default,kube-system

# 3. 백업 상태 확인
velero backup describe eks-dev-backup

# 4. 백업에서 복원
velero restore create --from-backup eks-dev-backup

# 5. 복원 상태 확인
velero restore describe
```

이러한 명령어와 예제를 통해 AWS EKS Terraform 프로젝트를 효과적으로 관리하고 운영할 수 있습니다. 각 명령어의 자세한 옵션과 사용법은 해당 도구의 공식 문서를 참조하세요.