## 사용 방법

이 섹션에서는 AWS EKS Terraform 프로젝트의 일반적인 사용 사례와 시나리오를 설명합니다. 각 사용 사례에 대한 단계별 지침을 통해 프로젝트를 효과적으로 활용할 수 있습니다.

### 일반적인 사용 사례

#### 1. 새로운 EKS 클러스터 배포

새로운 EKS 클러스터를 처음부터 배포하는 가장 기본적인 사용 사례입니다.

**단계:**

1. **환경 디렉토리 설정**
   ```bash
   # 작업할 환경 디렉토리로 이동
   cd ENV/DEV
   ```

2. **ECR 리포지토리 생성**
   ```bash
   cd 00_ECR
   
   # terraform.tfvars 파일 설정
   cp an2-kkm.tfvars terraform.tfvars
   
   # 필요에 따라 변수 수정
   vi terraform.tfvars
   
   # 리소스 배포
   make init
   make plan
   make apply
   ```

3. **네트워크 인프라 구성**
   ```bash
   cd ../01_Network
   
   # terraform.tfvars 파일 설정
   cp terraform.tfvars.example terraform.tfvars
   
   # 필요에 따라 변수 수정 (VPC CIDR, 서브넷 등)
   vi terraform.tfvars
   
   # 리소스 배포
   make init
   make plan
   make apply
   ```

4. **EKS 클러스터 배포**
   ```bash
   cd ../02_EKS
   
   # terraform.tfvars 파일 설정
   cp terraform.tfvars.example terraform.tfvars
   
   # 필요에 따라 변수 수정 (클러스터 버전, 노드 그룹 등)
   vi terraform.tfvars
   
   # 리소스 배포
   make init
   make plan
   make apply
   ```

5. **Kubernetes 워크로드 배포**
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
   
   # 기타 필요한 워크로드 배포
   ```

6. **S3 버킷 생성 (선택 사항)**
   ```bash
   cd ../../04_S3
   make init
   make plan
   make apply
   ```

7. **kubectl 구성 및 클러스터 접근**
   ```bash
   # kubectl 구성 업데이트
   aws eks update-kubeconfig --name eks-dev --region ap-northeast-2
   
   # 클러스터 상태 확인
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

#### 2. 기존 EKS 클러스터 업그레이드

Kubernetes 버전 업그레이드 또는 노드 그룹 구성 변경과 같은 클러스터 업그레이드를 수행합니다.

**단계:**

1. **현재 클러스터 상태 백업**
   ```bash
   # 현재 Kubernetes 리소스 백업
   kubectl get all --all-namespaces -o yaml > cluster-backup.yaml
   
   # Terraform 상태 백업 (S3 백엔드를 사용하는 경우 필요 없음)
   cd ENV/DEV/02_EKS
   terraform state pull > terraform.tfstate.backup
   ```

2. **업그레이드 계획 수립**
   ```bash
   # terraform.tfvars 파일에서 클러스터 버전 업데이트
   vi terraform.tfvars
   
   # 변경 사항:
   # cluster_version = "1.27" -> cluster_version = "1.28"
   
   # 업그레이드 계획 검토
   make plan
   ```

3. **업그레이드 적용**
   ```bash
   # 변경 사항 적용
   make apply
   
   # 업그레이드 상태 모니터링
   aws eks describe-update --name eks-dev --update-id <update-id> --region ap-northeast-2
   ```

4. **노드 그룹 업그레이드**
   ```bash
   # terraform.tfvars 파일에서 노드 그룹 구성 업데이트
   vi terraform.tfvars
   
   # 변경 사항:
   # instance_types = ["t3.medium"] -> instance_types = ["t3.large"]
   
   # 업그레이드 계획 검토 및 적용
   make plan
   make apply
   ```

5. **업그레이드 검증**
   ```bash
   # 클러스터 버전 확인
   kubectl version --short
   
   # 노드 상태 확인
   kubectl get nodes
   
   # 시스템 파드 상태 확인
   kubectl get pods -n kube-system
   ```

#### 3. 새로운 애플리케이션 배포를 위한 인프라 준비

새로운 애플리케이션을 배포하기 위한 필요한 인프라 구성 요소를 준비합니다.

**단계:**

1. **필요한 IAM 역할 및 정책 생성**
   ```bash
   # IRSA 모듈을 사용하여 서비스 계정에 대한 IAM 역할 생성
   cd ENV/DEV/02_EKS
   
   # terraform.tfvars 파일에 IRSA 구성 추가
   vi terraform.tfvars
   
   # 예시 구성:
   # irsa_roles = {
   #   "app-name" = {
   #     namespace      = "app-namespace"
   #     service_account = "app-service-account"
   #     policy_arns    = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
   #   }
   # }
   
   # 변경 사항 적용
   make plan
   make apply
   ```

2. **필요한 Kubernetes 네임스페이스 생성**
   ```bash
   # 애플리케이션 네임스페이스 생성
   kubectl create namespace app-namespace
   
   # 리소스 할당량 설정 (선택 사항)
   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: app-quota
     namespace: app-namespace
   spec:
     hard:
       requests.cpu: "2"
       requests.memory: 4Gi
       limits.cpu: "4"
       limits.memory: 8Gi
   EOF
   ```

3. **필요한 Kubernetes 애드온 배포**
   ```bash
   # 예: AWS Load Balancer Controller가 필요한 경우
   cd ENV/DEV/03_Workload
   
   # AWS Load Balancer Controller 배포
   kubectl apply -f aws-load-balancer-controller.yaml
   
   # 상태 확인
   kubectl get pods -n kube-system | grep aws-load-balancer-controller
   ```

4. **ArgoCD를 통한 애플리케이션 배포 설정**
   ```bash
   # ArgoCD Application 리소스 생성
   kubectl apply -f - <<EOF
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: my-application
     namespace: argocd
   spec:
     project: default
     source:
       repoURL: https://github.com/your-org/your-app-repo.git
       targetRevision: HEAD
       path: kubernetes
     destination:
       server: https://kubernetes.default.svc
       namespace: app-namespace
     syncPolicy:
       automated:
         prune: true
         selfHeal: true
   EOF
   ```

5. **필요한 스토리지 리소스 프로비저닝**
   ```bash
   # EBS 볼륨을 위한 StorageClass 생성
   kubectl apply -f - <<EOF
   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
     name: ebs-sc
   provisioner: ebs.csi.aws.com
   volumeBindingMode: WaitForFirstConsumer
   parameters:
     type: gp3
     encrypted: "true"
   EOF
   
   # PersistentVolumeClaim 생성
   kubectl apply -f - <<EOF
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: app-data
     namespace: app-namespace
   spec:
     accessModes:
       - ReadWriteOnce
     storageClassName: ebs-sc
     resources:
       requests:
         storage: 10Gi
   EOF
   ```

#### 4. 멀티 환경 관리 및 환경 간 승격

개발(DEV)에서 스테이징(STG), 프로덕션(PRD)으로 변경 사항을 승격하는 워크플로우를 관리합니다.

**단계:**

1. **새로운 환경 디렉토리 생성**
   ```bash
   # 스테이징 환경 디렉토리 생성
   mkdir -p ENV/STG/{00_ECR,01_Network,02_EKS,03_Workload,04_S3}
   
   # 개발 환경 구성 파일 복사
   cp -r ENV/DEV/00_ECR/* ENV/STG/00_ECR/
   cp -r ENV/DEV/01_Network/* ENV/STG/01_Network/
   cp -r ENV/DEV/02_EKS/* ENV/STG/02_EKS/
   cp -r ENV/DEV/03_Workload/* ENV/STG/03_Workload/
   cp -r ENV/DEV/04_S3/* ENV/STG/04_S3/
   ```

2. **환경별 변수 파일 수정**
   ```bash
   # 스테이징 환경 변수 파일 수정
   cd ENV/STG/01_Network
   vi terraform.tfvars
   
   # 변경 사항:
   # name = "eks-dev" -> name = "eks-stg"
   # vpc_cidr = "10.0.0.0/16" -> vpc_cidr = "10.1.0.0/16"
   # tags = { Environment = "dev" } -> tags = { Environment = "stg" }
   
   # 다른 디렉토리에 대해서도 동일한 작업 수행
   ```

3. **개발 환경에서 변경 사항 테스트**
   ```bash
   cd ENV/DEV/02_EKS
   
   # 변경 사항 적용 및 테스트
   make plan
   make apply
   
   # 변경 사항 검증
   kubectl get pods --all-namespaces
   ```

4. **스테이징 환경에 변경 사항 적용**
   ```bash
   cd ../../STG/02_EKS
   
   # 변경 사항 적용
   make plan
   make apply
   
   # 변경 사항 검증
   aws eks update-kubeconfig --name eks-stg --region ap-northeast-2
   kubectl get pods --all-namespaces
   ```

5. **프로덕션 환경에 변경 사항 적용**
   ```bash
   cd ../../PRD/02_EKS
   
   # 변경 사항 적용
   make plan
   make apply
   
   # 변경 사항 검증
   aws eks update-kubeconfig --name eks-prd --region ap-northeast-2
   kubectl get pods --all-namespaces
   ```

#### 5. 클러스터 모니터링 및 로깅 설정

EKS 클러스터에 대한 모니터링 및 로깅 솔루션을 설정합니다.

**단계:**

1. **CloudWatch Logs 활성화**
   ```bash
   cd ENV/DEV/02_EKS
   
   # terraform.tfvars 파일에서 클러스터 로깅 설정 업데이트
   vi terraform.tfvars
   
   # 변경 사항:
   # cluster_enabled_log_types = ["api", "audit"] -> cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
   
   # 변경 사항 적용
   make plan
   make apply
   ```

2. **Prometheus 및 Grafana 배포**
   ```bash
   # Prometheus 네임스페이스 생성
   kubectl create namespace prometheus
   
   # Helm을 사용하여 Prometheus 배포
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace prometheus \
     --set grafana.adminPassword=admin \
     --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=ebs-sc \
     --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=10Gi
   
   # 상태 확인
   kubectl get pods -n prometheus
   ```

3. **Fluent Bit 배포**
   ```bash
   # Fluent Bit 네임스페이스 생성
   kubectl create namespace logging
   
   # AWS for Fluent Bit 배포
   kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml
   
   # 상태 확인
   kubectl get pods -n logging
   ```

4. **대시보드 접근**
   ```bash
   # Grafana 대시보드 접근을 위한 포트 포워딩
   kubectl port-forward svc/prometheus-grafana 3000:80 -n prometheus
   
   # 브라우저에서 http://localhost:3000 접속 (기본 사용자 이름: admin, 비밀번호: admin)
   ```

5. **CloudWatch 대시보드 생성**
   ```bash
   # AWS CLI를 사용하여 CloudWatch 대시보드 생성
   aws cloudwatch put-dashboard \
     --dashboard-name EKS-Monitoring \
     --dashboard-body file://cloudwatch-dashboard.json
   ```

이러한 일반적인 사용 사례를 통해 AWS EKS Terraform 프로젝트를 효과적으로 활용할 수 있습니다. 각 사용 사례는 실제 운영 환경에서 자주 발생하는 시나리오를 다루며, 단계별 지침을 통해 필요한 작업을 수행할 수 있습니다.