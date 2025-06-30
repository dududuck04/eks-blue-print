# AWS EKS Terraform

[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge)](LICENSE)

AWS EKS(Elastic Kubernetes Service) 클러스터를 Terraform을 사용하여 배포하고 관리하기 위한 인프라스트럭처 코드(IaC) 프로젝트입니다. 이 프로젝트는 모듈화된 구조로 설계되어 있어 다양한 환경(개발, 스테이징, 프로덕션 등)에서 재사용 가능합니다.

---

## 📋 목차

- [🚀 소개](#-소개)
- [✨ 주요 기능](#-주요-기능)
- [🏗️ 프로젝트 구조](#️-프로젝트-구조)
- [📋 사전 요구사항](#-사전-요구사항)
- [⚙️ 설치 및 구성](#️-설치-및-구성)
- [💻 사용 방법](#-사용-방법)
- [🌍 환경별 설정](#-환경별-설정)
- [🔧 문제 해결](#-문제-해결)
- [🤝 기여 방법](#-기여-방법)
- [📄 라이센스](#-라이센스)

---

## 🚀 소개

이 프로젝트는 AWS EKS(Elastic Kubernetes Service) 클러스터를 Terraform을 사용하여 배포하고 관리하기 위한 종합적인 인프라스트럭처 코드(IaC)를 제공합니다. 모듈화된 접근 방식을 통해 다양한 환경(개발, 스테이징, 프로덕션)에서 일관되고 반복 가능한 Kubernetes 인프라를 구축할 수 있습니다.

### 🎆 AWS EKS와 Terraform을 사용하는 이점

#### **AWS EKS의 이점:**
- **관리형 Kubernetes**: AWS가 컨트롤 플레인을 관리하므로 Kubernetes 클러스터 운영 부담 감소
- **고가용성**: 여러 가용 영역에 걸쳐 컨트롤 플레인 구성 요소 자동 배포
- **AWS 서비스 통합**: IAM, VPC, ELB, ECR 등 다른 AWS 서비스와 원활한 통합
- **보안 강화**: AWS 보안 모델과 통합된 Kubernetes 보안 기능 제공
- **확장성**: 워크로드 요구 사항에 따라 쉽게 확장 가능한 노드 그룹 관리

#### **Terraform을 사용하는 이점:**
- **인프라 코드화(IaC)**: 인프라를 코드로 정의하여 버전 관리 및 협업 용이
- **선언적 구성**: 원하는 최종 상태를 정의하고 Terraform이 필요한 변경 사항 처리
- **멱등성**: 동일한 코드를 여러 번 적용해도 동일한 결과 보장
- **모듈화**: 재사용 가능한 모듈을 통해 인프라 구성 요소 추상화
- **상태 관리**: 인프라 상태를 추적하여 변경 사항 관리 및 드리프트 감지

### 🎯 프로젝트의 주요 목표

1. **자동화된 EKS 배포**: Terraform을 사용하여 EKS 클러스터 및 관련 AWS 리소스의 배포 자동화
2. **환경 일관성**: 개발, 스테이징, 프로덕션 등 모든 환경에서 일관된 인프라 구성 유지
3. **모듈화 및 재사용성**: 재사용 가능한 모듈을 통해 인프라 구성 요소 추상화 및 유지보수 용이성 향상
4. **보안 강화**: IAM 역할, 보안 그룹, KMS 암호화 등을 통한 보안 모범 사례 구현
5. **확장성**: 다양한 워크로드 요구 사항에 맞게 확장 가능한 인프라 구축
6. **운영 효율성**: Kubernetes 애드온 및 도구를 통한 클러스터 운영 및 관리 효율성 향상

## ✨ 주요 기능

### 📚 모듈화된 인프라 구성
- **유연한 네트워크 설계**: VPC, 서브넷, NAT 게이트웨이, VPC 엔드포인트 등을 포함한 완전한 네트워크 인프라 구성으로 애플리케이션에 최적화된 네트워크 환경 제공
- **다양한 노드 유형 지원**: EKS Managed Node Group, Self Managed Node Group, Fargate Profile 등 다양한 컴퓨팅 옵션을 제공하여 워크로드 특성에 맞는 최적의 인프라 선택 가능
- **환경별 구성**: 개발, 스테이징, 프로덕션 등 다양한 환경에 대한 분리된 설정 관리로 환경 간 일관성을 유지하면서 환경별 특성 반영 가능
- **재사용 가능한 모듈**: 표준화된 모듈을 통해 인프라 구성 요소를 추상화하여 코드 중복을 줄이고 유지보수성 향상

### ⚙️ 강력한 Kubernetes 기능
- **포괄적인 애드온 지원**: AWS Load Balancer Controller, EBS/EFS CSI Driver, Metrics Server, CoreDNS 등 다양한 Kubernetes 애드온을 쉽게 배포하고 관리하여 클러스터 기능 확장
- **자동 확장**: Cluster Autoscaler, Karpenter 등을 통한 워크로드 기반 자동 확장 기능으로 리소스 사용 최적화 및 비용 절감
- **GitOps 지원**: ArgoCD를 통한 선언적 애플리케이션 배포 및 관리로 애플리케이션 배포 프로세스 자동화 및 일관성 유지
- **워크로드 관리**: 다양한 Kubernetes 워크로드(Deployment, StatefulSet, DaemonSet 등)를 쉽게 배포하고 관리할 수 있는 구조 제공

### 🔒 보안 및 접근 제어
- **IRSA(IAM Roles for Service Accounts)**: Kubernetes 서비스 계정에 IAM 역할 연결을 통한 세분화된 권한 관리로 최소 권한 원칙 구현
- **KMS 암호화**: EKS 클러스터 및 관련 리소스에 대한 암호화 지원으로 데이터 보안 강화
- **네트워크 보안**: 세분화된 보안 그룹 및 네트워크 정책을 통한 트래픽 제어로 클러스터 내/외부 통신 보안 강화
- **보안 모범 사례**: AWS 및 Kubernetes 보안 모범 사례를 기본으로 구현하여 보안 취약점 최소화
- **인증 및 권한 관리**: AWS IAM과 Kubernetes RBAC의 통합을 통한 강력한 인증 및 권한 관리 체계 구축

### 📈 운영 효율성
- **로깅 및 모니터링**: AWS CloudWatch, Fluent Bit 등을 통한 통합 로깅 및 모니터링으로 클러스터 상태 및 성능 실시간 파악
- **백업 및 복구**: Velero를 통한 클러스터 리소스 백업 및 복구 지원으로 데이터 손실 방지 및 신속한 복구 가능
- **비용 최적화**: 적절한 인스턴스 유형 선택 및 자동 확장을 통한 비용 효율성 향상으로 불필요한 리소스 비용 절감
- **운영 자동화**: 반복적인 운영 작업을 자동화하여 운영 부담 감소 및 인적 오류 최소화
- **문제 해결 도구**: 클러스터 및 애플리케이션 문제를 신속하게 진단하고 해결할 수 있는 도구 및 프로세스 제공

### 👨‍💻 개발자 경험
- **일관된 환경**: 개발부터 프로덕션까지 일관된 환경 제공으로 개발자 경험 향상 및 "works on my machine" 문제 해소
- **인프라 코드화**: 인프라를 코드로 관리하여 버전 관리 및 협업이 용이하고 인프라 변경 이력 추적 가능
- **자동화된 워크플로우**: CI/CD 파이프라인과의 통합을 통한 자동화된 배포 워크플로우로 개발-테스트-배포 주기 단축
- **셀프 서비스 인프라**: 개발자가 필요한 인프라를 셀프 서비스로 프로비저닝할 수 있는 기반 제공
- **표준화된 개발 환경**: 모든 개발자에게 동일한 개발 환경을 제공하여 협업 효율성 향상 및 온보딩 시간 단축

---

## 🏗️ 프로젝트 구조

이 프로젝트는 모듈화된 구조로 설계되어 있어 다양한 환경에서 재사용 가능하며, 각 모듈은 특정 AWS 리소스 또는 관련 리소스 그룹을 관리합니다. 아래는 프로젝트의 주요 디렉토리 구조입니다.

### 📊 디렉토리 구조 다이어그램

아래는 프로젝트의 주요 디렉토리 구조를 시각적으로 표현한 다이어그램입니다:

```mermaid
flowchart TD
    classDef rootNode fill:#f9f,stroke:#333,stroke-width:2px
    classDef envNode fill:#bbf,stroke:#33f,stroke-width:1px
    classDef moduleNode fill:#dfd,stroke:#3a3,stroke-width:1px
    classDef chartNode fill:#ffd,stroke:#aa3,stroke-width:1px
    classDef templateNode fill:#ddd,stroke:#333,stroke-width:1px

    Root["AWS EKS Terraform"] --> ENV["ENV\n환경별 설정 디렉토리"]
    Root --> modules["modules\n재사용 가능한 Terraform 모듈"]
    Root --> charts["all-k8s-addon-charts\nKubernetes 애드온 Helm 차트"]
    Root --> templates["templates\n템플릿 파일"]

    %% ENV 디렉토리 구조
    ENV --> DEV["DEV\n개발 환경 설정"]
    DEV --> ECR["00_ECR\nECR 설정"]
    DEV --> Network["01_Network\n네트워크 인프라 설정"]
    DEV --> EKS["02_EKS\nEKS 클러스터 설정"]
    DEV --> Workload["03_Workload\n워크로드 관련 설정"]
    DEV --> S3["04_S3\nS3 버킷 설정"]

    %% modules 디렉토리 구조
    modules --> acm["acm\nAWS Certificate Manager"]
    modules --> aws_kms["aws-kms\nAWS Key Management Service"]
    modules --> eks_addons["eks-addons\nEKS 애드온"]
    modules --> eks_cluster["eks-cluster\nEKS 클러스터"]
    modules --> iam["iam\nIAM 관리"]
    modules --> irsa["irsa\nIAM Roles for Service Accounts"]
    modules --> irsa_workloads["irsa_workloads\n워크로드용 IRSA"]
    modules --> kms["kms\nKey Management Service"]
    modules --> k8s_addons["kubernetes_addons\nKubernetes 애드온"]
    modules --> k8s_workloads["kubernetes_workloads\nKubernetes 워크로드"]
    modules --> network["network\n네트워크 인프라"]
    modules --> secret_manager["secret_manager\nAWS Secrets Manager"]
    modules --> security_group["security_group\n보안 그룹"]

    %% all-k8s-addon-charts 디렉토리 구조
    charts --> addon_apps["addon-apps\n애드온 애플리케이션"]
    charts --> addon_charts["addon-charts\n애드온 차트"]

    %% 주요 모듈 간의 관계
    EKS -.-> Network
    EKS -.-> ECR
    Workload -.-> EKS

    %% 스타일 적용
    class Root rootNode
    class ENV,DEV,ECR,Network,EKS,Workload,S3 envNode
    class modules,acm,aws_kms,eks_addons,eks_cluster,iam,irsa,irsa_workloads,kms,k8s_addons,k8s_workloads,network,secret_manager,security_group moduleNode
    class charts,addon_apps,addon_charts chartNode
    class templates templateNode
```

텍스트 형식의 디렉토리 구조:

```
.
├── ENV                     # 환경별 설정 디렉토리
│   └── DEV                 # 개발 환경 설정
│       ├── 00_ECR          # ECR(Elastic Container Registry) 설정
│       ├── 01_Network      # 네트워크 인프라 설정(VPC, 서브넷 등)
│       ├── 02_EKS          # EKS 클러스터 설정
│       ├── 03_Workload     # 워크로드 관련 설정(ArgoCD, Karpenter 등)
│       └── 04_S3           # S3 버킷 설정
├── modules                 # 재사용 가능한 Terraform 모듈
│   ├── acm                 # AWS Certificate Manager 모듈
│   ├── aws-kms             # AWS Key Management Service 모듈
│   ├── eks-addons          # EKS 애드온 모듈
│   ├── eks-cluster         # EKS 클러스터 모듈
│   ├── iam                 # IAM(Identity and Access Management) 모듈
│   ├── irsa                # IRSA(IAM Roles for Service Accounts) 모듈
│   ├── irsa_workloads      # 워크로드용 IRSA 모듈
│   ├── kms                 # KMS(Key Management Service) 모듈
│   ├── kubernetes_addons   # Kubernetes 애드온 모듈
│   ├── kubernetes_workloads # Kubernetes 워크로드 모듈
│   ├── network             # 네트워크 인프라 모듈
│   ├── secret_manager      # AWS Secrets Manager 모듈
│   └── security_group      # 보안 그룹 모듈
├── all-k8s-addon-charts    # Kubernetes 애드온 Helm 차트
│   ├── addon-apps          # 애드온 애플리케이션
│   └── addon-charts        # 애드온 차트(argo-rbac, aws-load-balancer-controller 등)
└── templates               # 템플릿 파일(사용자 데이터 스크립트 등)
```

### 📝 주요 모듈 및 디렉토리 설명

#### 🎆 핵심 모듈

1. **eks-cluster**: AWS EKS 클러스터를 생성하고 관리하는 모듈입니다.
    - **주요 파일**: `01_eks.tf`, `02_eks_addon.tf`, `03_eks_iam.tf`, `04_eks_security_group.tf`, `05_eks_node_group.tf`
    - **기능**:
        - 다양한 노드 유형 지원(EKS Managed Node Group, Self Managed Node Group, Fargate Profile)
        - 클러스터 애드온 관리(CoreDNS, kube-proxy, VPC CNI)
        - IAM 역할 및 정책 설정을 통한 권한 관리
        - 보안 그룹 구성으로 네트워크 트래픽 제어
        - KMS 암호화를 통한 데이터 보안 강화
    - **사용 사례**: 완전 관리형 Kubernetes 클러스터 배포 및 구성

2. **network**: VPC, 서브넷, 라우팅 테이블, NAT 게이트웨이, VPC 엔드포인트 등 네트워크 인프라를 구성하는 모듈입니다.
    - **주요 파일**: `01_vpc.tf`, `02_subnet.tf`, `03_igw.tf`, `05_nat.tf`, `06_route_table.tf`, `09_vpc_endpoint.tf`, `10_security_group.tf`
    - **기능**:
        - VPC 및 서브넷 생성(퍼블릭, 프라이빗, 파드, 데이터베이스 서브넷)
        - 인터넷 게이트웨이 및 NAT 게이트웨이 설정으로 인터넷 연결 관리
        - VPC 엔드포인트 구성으로 AWS 서비스에 대한 비공개 연결 제공
        - 보안 그룹 설정을 통한 네트워크 트래픽 제어
        - EFS(Elastic File System) 구성으로 영구 스토리지 제공
    - **사용 사례**: EKS 클러스터를 위한 안전하고 확장 가능한 네트워크 인프라 구축

3. **irsa**: Kubernetes 서비스 계정에 대한 IAM 역할을 생성하는 모듈입니다. 이를 통해 Kubernetes 파드가 AWS 서비스에 안전하게 액세스할 수 있습니다.
    - **주요 파일**: `main.tf`, `outputs.tf`, `variables.tf`
    - **기능**:
        - Kubernetes 네임스페이스 및 서비스 계정 생성
        - IAM 역할 및 정책 설정으로 세분화된 권한 관리
        - OIDC(OpenID Connect) 기반 인증 구성으로 안전한 인증 제공
        - 최소 권한 원칙 구현을 통한 보안 강화
    - **사용 사례**: Kubernetes 파드가 AWS 서비스(S3, DynamoDB, SQS 등)에 안전하게 액세스해야 하는 경우

4. **kubernetes_addons**: EKS 클러스터에 다양한 Kubernetes 애드온을 배포하는 모듈입니다.
    - **주요 파일**: `main.tf`, `locals.tf`, `variables.tf`, 각 애드온별 디렉토리
    - **기능**:
        - AWS Load Balancer Controller: Kubernetes 서비스를 AWS ALB/NLB와 통합
        - AWS EBS CSI Driver: EBS 볼륨을 Kubernetes PersistentVolume으로 사용
        - AWS EFS CSI Driver: EFS 파일 시스템을 Kubernetes PersistentVolume으로 사용
        - Metrics Server: 파드 및 노드 리소스 사용량 수집
        - CoreDNS: Kubernetes 클러스터 내 DNS 서비스 제공
        - Cluster Autoscaler: 워크로드 요구에 따라 노드 자동 확장
        - 기타 다양한 애드온(ArgoCD, Cert Manager, External DNS 등)
    - **사용 사례**: EKS 클러스터 기능 확장 및 운영 효율성 향상

5. **kubernetes_workloads**: Kubernetes 워크로드를 관리하는 모듈입니다.
    - **주요 파일**: `main.tf`, `locals.tf`, `variables.tf`
    - **기능**:
        - ArgoCD Application 리소스 관리
        - External Secrets 구성
        - 다양한 Kubernetes 워크로드 배포 및 관리
    - **사용 사례**: GitOps 방식으로 애플리케이션 배포 및 관리

#### 🔧 지원 모듈

1. **aws-kms**: AWS KMS(Key Management Service) 키를 생성하고 관리하는 모듈입니다.
    - **주요 파일**: `main.tf`, `outputs.tf`, `variables.tf`
    - **기능**:
        - KMS 키 생성 및 관리
        - 키 정책 및 별칭 설정
        - 키 회전 구성
    - **사용 사례**: EKS 클러스터 및 관련 리소스의 암호화에 사용

2. **acm**: AWS Certificate Manager 인증서를 관리하는 모듈입니다.
    - **주요 파일**: `01_acm.tf`, `data.tf`, `outputs.tf`, `variables.tf`
    - **기능**:
        - SSL/TLS 인증서 요청 및 관리
        - 도메인 검증 구성
        - 인증서 갱신 자동화
    - **사용 사례**: HTTPS 통신을 위한 인증서 관리

3. **iam**: IAM 역할, 정책, 사용자, 그룹 등을 관리하는 모듈입니다.
    - **주요 파일**: `01_role.tf`, `02_user.tf`, `03_group.tf`, `04_policy.tf`
    - **기능**:
        - IAM 역할 및 정책 생성
        - 사용자 및 그룹 관리
        - 권한 경계 설정
        - 최소 권한 원칙 구현
    - **사용 사례**: AWS 리소스에 대한 액세스 제어 및 권한 관리

4. **security_group**: AWS 보안 그룹을 관리하는 모듈입니다.
    - **주요 파일**: `main.tf`, `rules.tf`, `outputs.tf`, `variable.tf`
    - **기능**:
        - 보안 그룹 생성 및 관리
        - 인바운드 및 아웃바운드 규칙 설정
        - 보안 그룹 간 참조 관리
    - **사용 사례**: EC2 인스턴스, RDS 데이터베이스, EKS 클러스터 등의 네트워크 트래픽 제어

5. **secret_manager**: AWS Secrets Manager를 통해 비밀 정보를 관리하는 모듈입니다.
    - **주요 파일**: `01_secret_manager.tf`, `outputs.tf`, `variables.tf`
    - **기능**:
        - 비밀 정보 생성 및 관리
        - 비밀 정보 회전 구성
        - 액세스 정책 설정
    - **사용 사례**: 데이터베이스 자격 증명, API 키, 토큰 등의 민감한 정보 관리

6. **eks-addons**: EKS 클러스터에 추가 기능을 제공하는 모듈입니다.
    - **주요 파일**: `06_karpenter.tf`, `output.tf`, `variable.tf`
    - **기능**:
        - Karpenter 설정 및 구성
        - 기타 EKS 관련 애드온 관리
    - **사용 사례**: EKS 클러스터의 자동 확장 및 관리 기능 향상

7. **irsa_workloads**: 워크로드별 IRSA(IAM Roles for Service Accounts)를 관리하는 모듈입니다.
    - **주요 파일**: `main.tf`, `outputs.tf`, `variables.tf`
    - **기능**:
        - 워크로드별 IAM 역할 및 정책 설정
        - 서비스 계정과 IAM 역할 연결
    - **사용 사례**: 특정 워크로드에 대한 세분화된 권한 관리

### 기타 디렉토리 설명

1. **all-k8s-addon-charts**: Kubernetes 애드온을 위한 Helm 차트를 포함합니다.
    - **addon-apps**: 애드온 애플리케이션을 정의하는 차트
        - **주요 파일**: `Chart.yaml`, `values.yaml`, `templates/Applications.yaml`
        - **기능**: ArgoCD를 통해 배포할 애플리케이션 정의
    - **addon-charts**: 각 애드온에 대한 구체적인 차트 정의
        - **포함된 차트**: argo-rbac, aws-load-balancer-controller, cert-manager, external-dns, kyverno 등
        - **기능**: 각 애드온의 구성 및 배포 정의
    - **사용 사례**: GitOps 방식으로 Kubernetes 애드온 관리

2. **templates**: 사용자 데이터 스크립트 등 다양한 템플릿 파일을 포함합니다.
    - **주요 파일**: `al2023_user_data.tpl`, `bottlerocket_user_data.tpl`, `linux_user_data.tpl`, `windows_user_data.tpl`
    - **기능**:
        - EC2 인스턴스 및 노드 그룹 초기화를 위한 사용자 데이터 스크립트 제공
        - 다양한 운영 체제(Amazon Linux 2023, Bottlerocket, Linux, Windows) 지원
    - **사용 사례**: EKS 노드 그룹 생성 시 초기 설정 자동화

### 환경 설정 디렉토리(ENV) 설명

ENV 디렉토리는 다양한 환경(개발, 스테이징, 프로덕션 등)에 대한 설정을 포함합니다. 현재는 DEV(개발) 환경만 구성되어 있으며, 필요에 따라 STG(스테이징), PRD(프로덕션) 등의 환경을 추가할 수 있습니다.

#### DEV 환경 구조

1. **00_ECR**:
    - 컨테이너 이미지를 저장하기 위한 ECR(Elastic Container Registry) 리포지토리를 생성합니다.
    - 이미지 스캔 및 태그 불변성 설정을 포함합니다.
    - `Makefile`을 통해 쉽게 리소스를 관리할 수 있습니다.

2. **01_Network**:
    - VPC, 서브넷, 라우팅 테이블, NAT 게이트웨이 등 네트워크 인프라를 구성합니다.
    - 퍼블릭 및 프라이빗 서브넷, 파드 서브넷, 데이터베이스 서브넷 등을 설정합니다.
    - VPC 엔드포인트, Direct Connect, Route53 등의 설정을 포함합니다.
    - `terraform.tfvars.example` 파일을 통해 환경별 변수를 쉽게 구성할 수 있습니다.

3. **02_EKS**:
    - EKS 클러스터 및 노드 그룹을 구성합니다.
    - 클러스터 버전, 엔드포인트 액세스, 보안 그룹, IAM 역할 등을 설정합니다.
    - 클러스터 애드온(CoreDNS, kube-proxy, VPC CNI 등)을 구성합니다.
    - 노드 그룹 설정(인스턴스 유형, 크기, 용량 유형 등)을 포함합니다.
    - `env` 디렉토리에서 환경별 변수를 관리합니다.

4. **03_Workload**:
    - ArgoCD, Karpenter, Cluster Autoscaler 등 Kubernetes 워크로드를 관리합니다.
    - 이러한 워크로드는 클러스터의 운영 및 관리를 지원합니다.
    - GitOps 방식으로 애플리케이션을 관리하기 위한 ArgoCD 설정을 포함합니다.
    - 자동 확장을 위한 Karpenter 및 Cluster Autoscaler 설정을 포함합니다.

5. **04_S3**:
    - S3 버킷을 생성하고 구성합니다.
    - 이 버킷은 로그, 백업, 정적 파일 등을 저장하는 데 사용될 수 있습니다.
    - `terraform.tfvars.example` 파일을 통해 버킷 구성을 쉽게 설정할 수 있습니다.

#### 환경별 설정 방법

환경별 설정을 관리하기 위해 다음과 같은 방법을 사용합니다:

1. **환경별 디렉토리 구조**:
    - 각 환경(DEV, STG, PRD 등)에 대해 ENV 디렉토리 아래에 별도의 디렉토리를 생성합니다.
    - 각 환경은 동일한 구조를 가지지만 환경별 특성에 맞게 구성됩니다.

2. **환경별 변수 파일**:
    - `terraform.tfvars` 파일을 통해 환경별 변수를 정의합니다.
    - 예제 파일(`terraform.tfvars.example`)을 제공하여 사용자가 쉽게 자신의 환경에 맞게 구성할 수 있도록 합니다.

3. **Makefile을 통한 자동화**:
    - 각 디렉토리에는 `Makefile`이 포함되어 있어 일관된 명령어로 리소스를 관리할 수 있습니다.
    - `make init`, `make plan`, `make apply`, `make destroy` 등의 명령어를 통해 Terraform 작업을 수행합니다.

4. **순차적 배포**:
    - 리소스는 순차적으로 배포해야 합니다(00_ECR → 01_Network → 02_EKS → 03_Workload → 04_S3).
    - 이는 리소스 간의 의존성을 고려한 것으로, 예를 들어 EKS 클러스터는 네트워크 인프라가 구성된 후에 배포해야 합니다.

이러한 구조를 통해 다양한 환경에서 일관된 방식으로 인프라를 관리할 수 있으며, 환경별 특성을 쉽게 반영할 수 있습니다.

---

## 📋 사전 요구사항

이 프로젝트를 사용하기 위해 다음과 같은 도구와 계정이 필요합니다:

### 🛠️ 필수 도구

| 도구 | 버전 | 설명 | 설치 링크 |
|:-----|:-----|:-----|:-----|
| [**Terraform**](https://www.terraform.io/downloads.html) | `>= 1.5.0` | 인프라를 코드로 관리하기 위한 도구 | [설치 가이드](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) |
| [**AWS CLI**](https://aws.amazon.com/cli/) | `>= 2.11.0` | AWS 서비스와 상호 작용하기 위한 명령줄 인터페이스 | [설치 가이드](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| [**kubectl**](https://kubernetes.io/docs/tasks/tools/) | `>= 1.27.0` | Kubernetes 클러스터와 상호 작용하기 위한 명령줄 도구 | [설치 가이드](https://kubernetes.io/docs/tasks/tools/install-kubectl/) |
| [**Helm**](https://helm.sh/docs/intro/install/) | `>= 3.12.0` | Kubernetes 패키지 관리자 | [설치 가이드](https://helm.sh/docs/intro/install/) |
| [**jq**](https://stedolan.github.io/jq/download/) | `>= 1.6` | JSON 데이터를 처리하기 위한 명령줄 도구 | [설치 가이드](https://stedolan.github.io/jq/download/) |
| [**Git**](https://git-scm.com/downloads) | `>= 2.40.0` | 버전 관리 시스템 | [설치 가이드](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) |
| [**eksctl**](https://eksctl.io/) | `>= 0.150.0` | EKS 클러스터를 생성하고 관리하기 위한 명령줄 도구 | [설치 가이드](https://eksctl.io/installation/) |
| [**aws-iam-authenticator**](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) | `>= 0.6.0` | AWS IAM 자격 증명을 사용하여 Kubernetes 클러스터에 인증하기 위한 도구 | [설치 가이드](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) |

### 💻 시스템 요구사항

| 요구사항 | 최소 사양 | 권장 사양 |
|:-----|:-----|:-----|
| **CPU** | 2 코어 | 4 코어 이상 |
| **메모리** | 4 GB | 8 GB 이상 |
| **디스크 공간** | 10 GB | 20 GB 이상 |
| **운영 체제** | Linux, macOS, Windows 10/11 with WSL2 | Linux, macOS |
| **인터넷 연결** | 필수 (AWS API 및 패키지 다운로드용) | 고속 연결 권장 |

### ☁️ AWS 계정 요구사항

#### 기본 요구사항

- 활성화된 AWS 계정
- AWS 계정에 대한 관리자 액세스 권한 또는 아래 나열된 서비스에 대한 특정 권한
- AWS 서비스 할당량이 EKS 클러스터 및 관련 리소스를 생성하기에 충분한지 확인
- 결제 알림 설정 (비용 관리를 위해 권장)

#### 필요한 AWS 서비스 권한

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

### IAM 권한 설정

#### 관리자 액세스 (개발/테스트 환경용)

개발 또는 테스트 환경에서는 `AdministratorAccess` 관리형 정책을 사용할 수 있습니다. 하지만 프로덕션 환경에서는 최소 권한 원칙에 따라 더 제한적인 권한을 사용하는 것이 좋습니다.

#### 최소 권한 정책 (프로덕션 환경 권장)

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

> **⚠️ 주의**
>
> 프로덕션 환경에서는 위 정책을 더 세분화하여 특정 리소스에만 적용하는 것이 좋습니다. 예를 들어, 특정 VPC, 특정 S3 버킷 등에만 권한을 부여할 수 있습니다.

### 네트워크 요구사항

#### 기본 네트워크 요구사항

- **인터넷 연결**: Terraform이 AWS API와 통신하고 필요한 패키지를 다운로드하기 위해 필요합니다.
- **방화벽 설정**: 다음 엔드포인트에 대한 아웃바운드 액세스가 필요합니다:
    - AWS API 엔드포인트 (리전별 서비스 엔드포인트)
    - GitHub (Terraform 모듈 및 프로바이더 다운로드)
    - Docker Hub 또는 기타 컨테이너 레지스트리
    - Helm 차트 리포지토리

#### EKS 클러스터 네트워크 요구사항

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

#### 보안 그룹 요구사항

- **EKS 클러스터 보안 그룹**: 컨트롤 플레인과 노드 간의 통신을 허용
- **노드 보안 그룹**: 노드 간 통신 및 필요한 아웃바운드 트래픽 허용
- **추가 보안 그룹**: 데이터베이스, 캐시 등 다른 AWS 서비스에 대한 액세스 제어

### 도메인 및 DNS 요구사항 (선택 사항)

- **등록된 도메인 이름**: 애플리케이션 및 서비스에 대한 사용자 친화적인 URL 제공
- **Route53 호스팅 영역**: DNS 레코드 관리
- **ACM 인증서**: HTTPS 통신을 위한 SSL/TLS 인증서

### 비용 고려사항

이 프로젝트를 배포하면 다음과 같은 AWS 리소스에 대한 비용이 발생할 수 있습니다:

- **EKS 클러스터**: 시간당 요금 (컨트롤 플레인)
- **EC2 인스턴스**: 노드 그룹에 사용되는 인스턴스 유형 및 수량에 따라 다름
- **EBS 볼륨**: 노드 및 영구 볼륨에 사용되는 스토리지
- **NAT 게이트웨이**: 시간당 요금 및 데이터 처리 요금
- **로드 밸런서**: ALB/NLB 사용 시 시간당 요금 및 데이터 처리 요금
- **Route53**: 호스팅 영역 및 쿼리 요금
- **S3**: 스토리지 및 요청 요금
- **CloudWatch**: 로그 스토리지 및 대시보드 요금

> **💰 비용 최적화 팁**
>
> 개발 환경에서는 Spot 인스턴스, 자동 확장, 리소스 제한 등을 활용하여 비용을 절감할 수 있습니다. AWS Cost Explorer 및 Budgets를 사용하여 비용을 모니터링하고 관리하세요.

## ⚙️ 설치 및 구성

이 섹션에서는 AWS EKS Terraform 프로젝트를 설치하고 구성하는 단계별 지침을 제공합니다. 각 단계를 순서대로 따라 완전한 EKS 환경을 구축하세요.

### 1. 리포지토리 클론

먼저 Git을 사용하여 프로젝트 리포지토리를 로컬 시스템에 클론합니다:

```bash
# 리포지토리 클론
git clone https://github.com/your-username/aws-eks-terraform.git

# 프로젝트 디렉토리로 이동
cd aws-eks-terraform
```

### 2. AWS 자격 증명 구성

AWS 리소스에 액세스하려면 적절한 자격 증명이 필요합니다. 다음 방법 중 하나를 선택하여 자격 증명을 구성하세요.

#### 2.1 AWS CLI 사용

AWS CLI를 사용하여 대화형으로 자격 증명을 구성합니다:

```bash
# AWS CLI 자격 증명 구성
aws configure
```

프롬프트에 따라 액세스 키, 시크릿 키, 기본 리전 및 출력 형식을 입력합니다:

```text
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: ap-northeast-2
Default output format [None]: json
```

#### 2.2 환경 변수 사용

또는 환경 변수를 설정하여 자격 증명을 구성할 수 있습니다:

```bash
# 환경 변수로 자격 증명 설정
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="your-region"

# 설정 확인
echo $AWS_REGION
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
# ECR 리포지토리 설정
region = "ap-northeast-2"
name   = "eks-dev"

# 생성할 ECR 리포지토리 목록
ecr_repositories = [
  "app1",
  "app2",
  "app3"
]

# 리소스 태그
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
# 기본 설정
region = "ap-northeast-2"
name   = "eks-dev"

# VPC CIDR 블록
vpc_cidr = "10.0.0.0/16"

# 가용 영역
azs = ["ap-northeast-2a", "ap-northeast-2c"]

# 서브넷 CIDR 블록
public_subnets   = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnets  = ["10.0.32.0/20", "10.0.48.0/20"]
database_subnets = ["10.0.64.0/20", "10.0.80.0/20"]
pod_subnets      = ["10.0.96.0/20", "10.0.112.0/20"]

# NAT 게이트웨이 설정
enable_nat_gateway = true
single_nat_gateway = true

# 리소스 태그
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

> **⚠️ 주의**
>
> `make destroy` 명령은 관련 리소스를 영구적으로 삭제합니다. 프로덕션 환경에서는 신중하게 사용하세요.

## 💻 사용 방법

이 섹션에서는 AWS EKS Terraform 프로젝트의 일반적인 사용 사례와 시나리오를 설명합니다. 각 사용 사례에 대한 단계별 지침을 통해 프로젝트를 효과적으로 활용할 수 있습니다.

### 주요 명령어 및 예제

이 섹션에서는 AWS EKS Terraform 프로젝트를 사용할 때 자주 사용되는 명령어와 그 용도를 설명하고, 실제 사용 예제와 코드 스니펫을 제공합니다.

#### Terraform 기본 명령어

| 명령어 | 설명 | 사용 예시 |
|:-----|:-----|:-----|
| `terraform init` | 작업 디렉토리를 초기화하고 필요한 플러그인을 다운로드합니다. | `terraform init` 또는 `make init` |
| `terraform plan` | 현재 상태와 구성 파일을 비교하여 실행 계획을 생성합니다. | `terraform plan -var-file=terraform.tfvars` 또는 `make plan` |
| `terraform apply` | 실행 계획을 적용하여 인프라를 생성 또는 변경합니다. | `terraform apply tfplan` 또는 `make apply` |
| `terraform destroy` | 생성된 모든 리소스를 삭제합니다. | `terraform destroy -var-file=terraform.tfvars` 또는 `make destroy` |
| `terraform state list` | 현재 상태에 있는 모든 리소스를 나열합니다. | `terraform state list` |
| `terraform output` | 출력 변수의 값을 표시합니다. | `terraform output vpc_id` |
| `terraform validate` | 구성 파일의 구문을 검증합니다. | `terraform validate` |
| `terraform fmt` | 구성 파일을 표준 형식으로 재구성합니다. | `terraform fmt` |

#### Makefile 명령어

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

#### AWS CLI 명령어

##### EKS 클러스터 관리

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

##### ECR 관리

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

##### kubectl 명령어

```bash
# 노드 목록 조회
kubectl get nodes

# 파드 목록 조회 (모든 네임스페이스)
kubectl get pods --all-namespaces

# 특정 네임스페이스의 파드 목록 조회
kubectl get pods -n kube-system

# 파드 세부 정보 조회
kubectl describe pod <pod-name> -n <namespace>

# 파드 로그 조회
kubectl logs <pod-name> -n <namespace>

# 파드 내 명령 실행
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash
```

자세한 명령어 목록과 예제는 [AWS CLI 문서](https://docs.aws.amazon.com/cli/latest/reference/eks/index.html), [Terraform 문서](https://www.terraform.io/docs/cli/commands/index.html), [kubectl 문서](https://kubernetes.io/docs/reference/kubectl/overview/)를 참조하세요.

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

## 🌍 환경별 설정

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

## 🔧 문제 해결

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

### 일반적인 문제와 해결 방법

#### Terraform 관련 문제

##### 1. Terraform 초기화 실패

**문제**: `terraform init` 또는 `make init` 명령이 실패하고 프로바이더 또는 모듈을 다운로드할 수 없습니다.

**해결 방법**:
- 인터넷 연결을 확인하세요.
- 프록시 설정이 올바른지 확인하세요.
- Terraform 버전이 요구 사항을 충족하는지 확인하세요 (`terraform version`).
- 다음 명령을 사용하여 Terraform 캐시를 정리해 보세요:
  ```bash
  rm -rf .terraform
  terraform init
  # 또는
  make clean
  make init
  ```

##### 2. Terraform 계획/적용 실패

**문제**: `terraform plan` 또는 `terraform apply` 명령이 오류와 함께 실패합니다.

**해결 방법**:
- 오류 메시지를 주의 깊게 읽고 문제를 파악하세요.
- AWS 자격 증명이 올바르게 구성되어 있는지 확인하세요 (`aws sts get-caller-identity`).
- 필요한 IAM 권한이 있는지 확인하세요.
- 변수 파일(`terraform.tfvars` 또는 `env/<환경>.tfvars`)이 올바르게 구성되어 있는지 확인하세요.
- 자세한 로그를 확인하려면 다음 명령을 사용하세요:
  ```bash
  TF_LOG=DEBUG terraform apply -var-file=env/<환경>.tfvars
  ```

##### 3. Terraform 상태 잠금 문제

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

#### AWS 관련 문제

##### 1. AWS 자격 증명 문제

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
  aws sso login --profile your-profile
  ```
- 환경 변수가 올바르게 설정되어 있는지 확인하세요:
  ```bash
  echo $AWS_ACCESS_KEY_ID
  echo $AWS_SECRET_ACCESS_KEY
  echo $AWS_REGION
  ```
- Makefile에서 사용하는 프로필이 올바른지 확인하세요. 필요한 경우 Makefile의 `PROFILE_NAME` 변수를 수정하세요.

##### 2. 서비스 할당량 초과

**문제**: AWS 서비스 할당량을 초과했다는 오류 메시지가 표시됩니다.

**해결 방법**:
- AWS 콘솔에서 Service Quotas 서비스를 확인하여 현재 사용량과 한도를 확인하세요.
- 필요한 경우 할당량 증가를 요청하세요.
- 리소스를 정리하거나 불필요한 리소스를 삭제하여 사용량을 줄이세요.

#### EKS 관련 문제

##### 1. EKS 클러스터 생성 실패

**문제**: EKS 클러스터 생성이 실패하고 오류 메시지가 표시됩니다.

**해결 방법**:
- IAM 권한이 충분한지 확인하세요.
- VPC 및 서브넷 구성이 EKS 요구 사항을 충족하는지 확인하세요.
- 서브넷에 올바른 태그가 지정되어 있는지 확인하세요:
  ```bash
  aws ec2 describe-subnets --subnet-ids subnet-id --query "Subnets[].Tags"
  ```
- CloudTrail 로그를 확인하여 자세한 오류 정보를 확인하세요.
- 결과 로그 파일을 확인하세요 (`results/apply-<환경>-output-<타임스탬프>.log`).

##### 2. kubectl 연결 문제

**문제**: kubectl을 사용하여 EKS 클러스터에 연결할 수 없습니다.

**해결 방법**:
- kubeconfig가 올바르게 구성되어 있는지 확인하세요:
  ```bash
  aws eks update-kubeconfig --name your-cluster-name --region your-region
  ```
- AWS CLI 버전이 최신인지 확인하세요:
  ```bash
  aws --version
  ```
- IAM 자격 증명이 클러스터에 액세스할 수 있는 권한이 있는지 확인하세요:
  ```bash
  aws sts get-caller-identity
  ```

### 디버깅 팁과 로그 확인 방법

#### Terraform 디버깅

##### 1. 자세한 로그 활성화

Terraform 작업의 자세한 로그를 확인하려면 `TF_LOG` 환경 변수를 설정하세요:

```bash
# 가장 자세한 로그 수준
TF_LOG=TRACE terraform apply -var-file=env/<환경>.tfvars

# 디버그 수준 로그
TF_LOG=DEBUG terraform apply -var-file=env/<환경>.tfvars

# 로그를 파일에 저장
TF_LOG=DEBUG TF_LOG_PATH=./terraform.log terraform apply -var-file=env/<환경>.tfvars
```

##### 2. Terraform 상태 검사

현재 Terraform 상태를 검사하여 문제를 진단하세요:

```bash
# 상태에 있는 모든 리소스 나열
terraform state list

# 특정 리소스의 상태 확인
terraform state show 'aws_eks_cluster.this'

# 상태 파일 검사
terraform show
```

#### AWS 디버깅

##### 1. AWS CLI를 사용한 리소스 검사

AWS CLI를 사용하여 리소스 상태를 확인하세요:

```bash
# EKS 클러스터 상태 확인
aws eks describe-cluster --name cluster-name

# EC2 인스턴스 확인
aws ec2 describe-instances --filters "Name=tag:Name,Values=eks-node*"

# VPC 및 서브넷 확인
aws ec2 describe-vpcs
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-id"
```

#### Kubernetes 디버깅

##### 1. 클러스터 상태 확인

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

##### 2. 파드 로그 및 이벤트 확인

파드 로그 및 이벤트를 확인하여 문제를 진단하세요:

```bash
# 파드 로그 확인
kubectl logs pod-name -n namespace

# 이전 컨테이너의 로그 확인
kubectl logs pod-name -n namespace --previous

# 파드 이벤트 확인
kubectl describe pod pod-name -n namespace

# 실시간 로그 스트리밍
kubectl logs -f pod-name -n namespace
```

### 자주 묻는 질문(FAQ)

#### 일반적인 질문

##### Q: 이 프로젝트를 사용하기 위한 최소 AWS 권한은 무엇인가요?
A: 최소한 EKS, EC2, IAM, VPC, S3, CloudWatch 서비스에 대한 권한이 필요합니다. 자세한 내용은 [사전 요구사항](#사전-요구사항) 섹션의 IAM 권한 설정을 참조하세요.

##### Q: 프로덕션 환경에서 이 프로젝트를 사용하기 위한 권장 사항은 무엇인가요?
A: 프로덕션 환경에서는 다음을 권장합니다:
- 원격 Terraform 백엔드(S3 + DynamoDB) 사용
- 최소 3개의 가용 영역에 걸쳐 고가용성 구성
- 적절한 노드 크기 및 자동 확장 설정
- 보안 강화(KMS 암호화, 프라이빗 엔드포인트, 네트워크 정책 등)
- 정기적인 백업 및 재해 복구 계획

#### EKS 관련 질문

##### Q: EKS 클러스터 버전을 어떻게 업그레이드해야 하나요?
A: EKS 클러스터 버전을 업그레이드하려면 다음 단계를 따르세요:
1. Terraform 변수 파일에서 `cluster_version` 값을 업데이트
2. `terraform plan`을 실행하여 변경 사항 확인
3. `terraform apply`를 실행하여 컨트롤 플레인 업그레이드
4. 노드 그룹을 업그레이드하려면 새 노드 그룹을 생성하고 워크로드를 마이그레이션한 후 이전 노드 그룹 삭제

##### Q: Kubernetes 리소스를 삭제할 수 없고 "Terminating" 상태로 멈춰 있으면 어떻게 해야 하나요?
A: 다음 명령을 사용하여 리소스를 강제로 삭제하세요:
```bash
kubectl delete pod pod-name -n namespace --grace-period=0 --force
```
또는 파이널라이저를 제거하세요:
```bash
kubectl patch pod pod-name -n namespace -p '{"metadata":{"finalizers":[]}}' --type=merge
```

### 일반적인 문제와 해결 방법

#### Terraform 관련 문제

##### 1. Terraform 초기화 실패

**문제**: `terraform init` 명령이 실패하고 프로바이더 또는 모듈을 다운로드할 수 없습니다.

**해결 방법**:
- 인터넷 연결을 확인하세요.
- 프록시 설정이 올바른지 확인하세요.
- Terraform 버전이 요구 사항을 충족하는지 확인하세요.
- 다음 명령을 사용하여 Terraform 캐시를 정리해 보세요:
  ```bash
  rm -rf .terraform
  terraform init
  ```

##### 2. Terraform 계획/적용 실패

**문제**: `terraform plan` 또는 `terraform apply` 명령이 오류와 함께 실패합니다.

**해결 방법**:
- 오류 메시지를 주의 깊게 읽고 문제를 파악하세요.
- AWS 자격 증명이 올바르게 구성되어 있는지 확인하세요.
- 필요한 IAM 권한이 있는지 확인하세요.
- 변수 파일(`terraform.tfvars`)이 올바르게 구성되어 있는지 확인하세요.
- 자세한 로그를 확인하려면 다음 명령을 사용하세요:
  ```bash
  TF_LOG=DEBUG terraform apply
  ```

##### 3. Terraform 상태 잠금 문제

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

#### AWS 관련 문제

##### 1. AWS 자격 증명 문제

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
  aws sso login --profile your-profile
  ```

##### 2. 서비스 할당량 초과

**문제**: AWS 서비스 할당량을 초과했다는 오류 메시지가 표시됩니다.

**해결 방법**:
- AWS 콘솔에서 Service Quotas 서비스를 확인하여 현재 사용량과 한도를 확인하세요.
- 필요한 경우 할당량 증가를 요청하세요.
- 리소스를 정리하거나 불필요한 리소스를 삭제하여 사용량을 줄이세요.

#### EKS 관련 문제

##### 1. EKS 클러스터 생성 실패

**문제**: EKS 클러스터 생성이 실패하고 오류 메시지가 표시됩니다.

**해결 방법**:
- IAM 권한이 충분한지 확인하세요.
- VPC 및 서브넷 구성이 EKS 요구 사항을 충족하는지 확인하세요.
- 서브넷에 올바른 태그가 지정되어 있는지 확인하세요:
  ```bash
  aws ec2 describe-subnets --subnet-ids subnet-id --query "Subnets[].Tags"
  ```
- CloudTrail 로그를 확인하여 자세한 오류 정보를 확인하세요.

##### 2. kubectl 연결 문제

**문제**: kubectl을 사용하여 EKS 클러스터에 연결할 수 없습니다.

**해결 방법**:
- kubeconfig가 올바르게 구성되어 있는지 확인하세요:
  ```bash
  aws eks update-kubeconfig --name your-cluster-name --region your-region
  ```
- AWS CLI 버전이 최신인지 확인하세요:
  ```bash
  aws --version
  ```
- IAM 자격 증명이 클러스터에 액세스할 수 있는 권한이 있는지 확인하세요:
  ```bash
  aws sts get-caller-identity
  ```

### 디버깅 팁과 로그 확인 방법

#### Terraform 디버깅

자세한 로그를 활성화하려면 `TF_LOG` 환경 변수를 설정하세요:

```bash
# 가장 자세한 로그 수준
TF_LOG=TRACE terraform apply

# 디버그 수준 로그
TF_LOG=DEBUG terraform apply

# 로그를 파일에 저장
TF_LOG=DEBUG TF_LOG_PATH=./terraform.log terraform apply
```

현재 Terraform 상태를 검사하여 문제를 진단하세요:

```bash
# 상태에 있는 모든 리소스 나열
terraform state list

# 특정 리소스의 상태 확인
terraform state show 'aws_eks_cluster.this'
```

#### Kubernetes 디버깅

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

파드 로그 및 이벤트를 확인하여 문제를 진단하세요:

```bash
# 파드 로그 확인
kubectl logs pod-name -n namespace

# 이전 컨테이너의 로그 확인
kubectl logs pod-name -n namespace --previous

# 파드 이벤트 확인
kubectl describe pod pod-name -n namespace
```

### 자주 묻는 질문(FAQ)

#### Q: 이 프로젝트를 사용하기 위한 최소 AWS 권한은 무엇인가요?
A: 최소한 EKS, EC2, IAM, VPC, S3, CloudWatch 서비스에 대한 권한이 필요합니다. 자세한 내용은 [사전 요구사항](#사전-요구사항) 섹션의 IAM 권한 설정을 참조하세요.

#### Q: 프로덕션 환경에서 이 프로젝트를 사용하기 위한 권장 사항은 무엇인가요?
A: 프로덕션 환경에서는 다음을 권장합니다:
- 원격 Terraform 백엔드(S3 + DynamoDB) 사용
- 최소 3개의 가용 영역에 걸쳐 고가용성 구성
- 적절한 노드 크기 및 자동 확장 설정
- 보안 강화(KMS 암호화, 프라이빗 엔드포인트, 네트워크 정책 등)
- 정기적인 백업 및 재해 복구 계획

#### Q: EKS 클러스터 버전을 어떻게 업그레이드해야 하나요?
A: EKS 클러스터 버전을 업그레이드하려면 다음 단계를 따르세요:
1. Terraform 변수 파일에서 `cluster_version` 값을 업데이트
2. `terraform plan`을 실행하여 변경 사항 확인
3. `terraform apply`를 실행하여 컨트롤 플레인 업그레이드
4. 노드 그룹을 업그레이드하려면 새 노드 그룹을 생성하고 워크로드를 마이그레이션한 후 이전 노드 그룹 삭제

#### Q: 파드가 ImagePullBackOff 오류를 표시하면 어떻게 해야 하나요?
A: 다음을 확인하세요:
1. 이미지 이름과 태그가 올바른지 확인
2. 프라이빗 레지스트리를 사용하는 경우 이미지 풀 시크릿이 구성되어 있는지 확인
3. 노드가 인터넷에 액세스할 수 있는지 확인
4. ECR을 사용하는 경우 노드 IAM 역할에 ECR 액세스 권한이 있는지 확인

> **참고**: 더 자세한 문제 해결 정보와 추가 FAQ는 [troubleshooting_guide.md](troubleshooting_guide.md) 파일을 참조하세요.

## 🤝 기여 방법

이 프로젝트에 기여해 주셔서 감사합니다! 다음 가이드라인을 따라 효과적으로 기여할 수 있습니다.

### 기여 프로세스 개요

1. **이슈 확인**: 기존 이슈를 확인하거나 새로운 이슈를 생성합니다
2. **포크 및 브랜치**: 리포지토리를 포크하고 기능 브랜치를 생성합니다
3. **개발**: 코드를 작성하고 테스트합니다
4. **Pull Request**: 변경 사항을 제출합니다
5. **리뷰**: 코드 리뷰를 받고 피드백을 반영합니다
6. **병합**: 승인 후 메인 브랜치에 병합됩니다

### Pull Request 워크플로우

#### 1. 리포지토리 포크 및 클론

```bash
# GitHub에서 리포지토리를 포크한 후
git clone https://github.com/your-username/aws-eks-terraform.git
cd aws-eks-terraform

# 원본 리포지토리를 upstream으로 추가
git remote add upstream https://github.com/original-owner/aws-eks-terraform.git
```

#### 2. 기능 브랜치 생성

```bash
# 최신 main 브랜치로 업데이트
git checkout main
git pull upstream main

# 기능 브랜치 생성 (브랜치 명명 규칙 참조)
git checkout -b feature/add-new-module
# 또는
git checkout -b fix/security-group-issue
# 또는
git checkout -b docs/update-readme
```

#### 3. 변경 사항 커밋

```bash
# 변경된 파일 스테이징
git add .

# 의미 있는 커밋 메시지 작성 (커밋 메시지 규칙 참조)
git commit -m "feat: add support for EFS CSI driver"

# 또는 더 자세한 커밋 메시지
git commit -m "feat: add support for EFS CSI driver

- Add EFS CSI driver module
- Update documentation for EFS configuration
- Add example terraform.tfvars for EFS

Closes #123"
```

#### 4. Pull Request 생성

```bash
# 변경 사항을 포크된 리포지토리에 푸시
git push origin feature/add-new-module
```

GitHub에서 Pull Request를 생성할 때:

- **제목**: 명확하고 간결한 제목 작성
- **설명**: 변경 사항에 대한 자세한 설명 포함
- **체크리스트**: PR 템플릿의 체크리스트 완료
- **라벨**: 적절한 라벨 추가 (feature, bugfix, documentation 등)
- **리뷰어**: 관련 팀 멤버를 리뷰어로 지정

#### 5. 코드 리뷰 및 피드백 반영

```bash
# 피드백 반영 후 추가 커밋
git add .
git commit -m "fix: address code review feedback"
git push origin feature/add-new-module
```

### 브랜치 명명 규칙

브랜치 이름은 다음 패턴을 따라야 합니다:

- `feature/description`: 새로운 기능 추가
- `fix/description`: 버그 수정
- `docs/description`: 문서 업데이트
- `refactor/description`: 코드 리팩토링
- `test/description`: 테스트 추가 또는 수정
- `chore/description`: 빌드 프로세스 또는 도구 변경

**예시:**
- `feature/add-karpenter-support`
- `fix/security-group-rules`
- `docs/update-installation-guide`
- `refactor/eks-module-structure`

### 커밋 메시지 규칙

[Conventional Commits](https://www.conventionalcommits.org/) 형식을 따릅니다:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**타입:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 스타일 변경 (포맷팅, 세미콜론 누락 등)
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가 또는 수정
- `chore`: 빌드 프로세스 또는 도구 변경

**예시:**
```
feat(eks): add support for Fargate profiles

fix(network): resolve NAT gateway configuration issue

docs(readme): update installation instructions

refactor(modules): restructure kubernetes_addons module
```

### 이슈 보고 방법

#### 버그 리포트

버그를 발견했다면 다음 정보를 포함하여 이슈를 생성해 주세요:

**이슈 제목:** `[BUG] 간단한 버그 설명`

**이슈 내용:**
```markdown
## 버그 설명
버그에 대한 명확하고 간결한 설명

## 재현 단계
1. '...'로 이동
2. '...'를 클릭
3. '...'까지 스크롤
4. 오류 확인

## 예상 동작
예상했던 동작에 대한 명확하고 간결한 설명

## 실제 동작
실제로 발생한 동작에 대한 설명

## 스크린샷
해당하는 경우 스크린샷 추가

## 환경 정보
- OS: [예: Ubuntu 20.04]
- Terraform 버전: [예: 1.5.0]
- AWS CLI 버전: [예: 2.11.0]
- kubectl 버전: [예: 1.27.0]

## 추가 컨텍스트
문제에 대한 기타 컨텍스트 추가

## 로그
관련 로그나 오류 메시지가 있다면 포함
```

#### 기능 요청

새로운 기능을 제안하려면:

**이슈 제목:** `[FEATURE] 기능 요청 제목`

**이슈 내용:**
```markdown
## 기능 설명
원하는 기능에 대한 명확하고 간결한 설명

## 동기
이 기능이 필요한 이유와 해결하려는 문제

## 제안된 해결책
원하는 동작에 대한 명확하고 간결한 설명

## 대안 고려사항
고려한 대안 솔루션이나 기능에 대한 설명

## 추가 컨텍스트
기능 요청에 대한 기타 컨텍스트나 스크린샷 추가
```

#### 질문 또는 도움 요청

**이슈 제목:** `[QUESTION] 질문 내용`

**이슈 내용:**
```markdown
## 질문
명확하고 구체적인 질문

## 컨텍스트
질문과 관련된 배경 정보

## 시도한 것
문제를 해결하기 위해 시도한 방법들

## 환경 정보
- OS: [예: Ubuntu 20.04]
- Terraform 버전: [예: 1.5.0]
- 관련 모듈: [예: eks-cluster, network]
```

### 개발 환경 설정 가이드

#### 1. 개발 도구 설치

프로젝트 개발을 위해 다음 도구들이 필요합니다:

```bash
# Terraform 설치 (1.5.0 이상)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# AWS CLI 설치 (2.11.0 이상)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# kubectl 설치 (1.27.0 이상)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Helm 설치 (3.12.0 이상)
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# 기타 유용한 도구들
sudo apt-get install jq git make
```

#### 2. 개발 환경 구성

```bash
# 프로젝트 클론
git clone https://github.com/your-username/aws-eks-terraform.git
cd aws-eks-terraform

# AWS 자격 증명 구성
aws configure

# 개발용 환경 변수 설정
export TF_LOG=INFO  # Terraform 로그 레벨 설정
export AWS_REGION=ap-northeast-2  # 기본 AWS 리전 설정
```

#### 3. 코드 품질 도구 설정

##### Terraform 포맷팅 및 검증

```bash
# Terraform 코드 포맷팅
terraform fmt -recursive

# Terraform 구성 검증
terraform validate

# Terraform 보안 스캔 (tfsec 설치 필요)
tfsec .
```

##### Pre-commit 훅 설정

```bash
# pre-commit 설치
pip install pre-commit

# pre-commit 훅 설치
pre-commit install

# 모든 파일에 대해 pre-commit 실행
pre-commit run --all-files
```

`.pre-commit-config.yaml` 파일 예시:

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.81.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_docs
      - id: terraform_tflint
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

#### 4. 테스트 환경 구성

```bash
# 테스트용 AWS 계정 설정 (개발/테스트 전용 계정 권장)
export AWS_PROFILE=dev-test

# 테스트용 리소스 배포
cd ENV/DEV

# ECR 테스트
cd 00_ECR
make init
make plan
# 실제 배포는 신중하게 결정
# make apply
```

#### 5. 문서 작성 도구

```bash
# terraform-docs 설치 (모듈 문서 자동 생성)
curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/terraform-docs

# 모듈 문서 생성
terraform-docs markdown table --output-file README.md modules/eks-cluster/
```

### 코드 스타일 및 표준

이 프로젝트는 일관된 코드 품질과 유지보수성을 보장하기 위해 엄격한 코드 스타일과 표준을 따릅니다. 모든 기여자는 다음 가이드라인을 준수해야 합니다.

#### Terraform 코드 스타일 가이드라인

##### 1. 파일 구조 및 명명 규칙

**파일 명명 규칙:**
```
01_main_resource.tf      # 주요 리소스 (번호 순서로 배치)
02_secondary_resource.tf # 보조 리소스
data.tf                  # 데이터 소스
locals.tf                # 로컬 값
variables.tf             # 입력 변수
outputs.tf               # 출력 값
versions.tf              # 프로바이더 및 버전 제약
```

**디렉토리 구조:**
```
modules/
├── module-name/
│   ├── main.tf          # 주요 리소스 정의
│   ├── variables.tf     # 입력 변수
│   ├── outputs.tf       # 출력 값
│   ├── versions.tf      # 프로바이더 버전
│   ├── README.md        # 모듈 문서
│   └── examples/        # 사용 예제
│       └── basic/
│           ├── main.tf
│           └── variables.tf
```

##### 2. 코드 포맷팅 규칙

**들여쓰기 및 공백:**
```hcl
# 올바른 예시
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}

# 잘못된 예시 - 일관되지 않은 들여쓰기
resource "aws_instance" "example" {
ami           = var.ami_id
    instance_type = var.instance_type
  tags = {
Name        = var.instance_name
    Environment = var.environment
  }
}
```

**블록 구조:**
```hcl
# 올바른 예시 - 논리적 그룹화
resource "aws_security_group" "eks_cluster" {
  name_prefix = "${var.cluster_name}-cluster-"
  vpc_id      = var.vpc_id
  description = "Security group for EKS cluster control plane"

  # 인바운드 규칙
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # 아웃바운드 규칙
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
    Type = "cluster"
  })
}
```

##### 3. 변수 및 출력 정의 규칙

**변수 정의:**
```hcl
# variables.tf
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_name))
    error_message = "Cluster name must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "node_groups" {
  description = "Map of EKS managed node group definitions"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    min_size      = number
    max_size      = number
    desired_size  = number
    disk_size     = number
    ami_type      = string
    labels        = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
```

**출력 정의:**
```hcl
# outputs.tf
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = aws_eks_node_group.this
  sensitive   = true
}
```

#### 네이밍 컨벤션 및 모듈 구조 표준

##### 1. 리소스 명명 규칙

**AWS 리소스 명명:**
```hcl
# 패턴: {project}-{environment}-{resource-type}-{purpose}
# 예시:
resource "aws_vpc" "main" {
  # 리소스 이름: eks-dev-vpc
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  # 리소스 이름: eks-dev-subnet-private-1a
  tags = {
    Name = "${var.project_name}-${var.environment}-subnet-private-${substr(each.value, -2, 2)}"
  }
}

resource "aws_security_group" "eks_cluster" {
  # 리소스 이름: eks-dev-sg-cluster
  name = "${var.project_name}-${var.environment}-sg-cluster"
}
```

**Terraform 리소스 및 데이터 소스 명명:**
```hcl
# 리소스 명명 - 단수형 사용
resource "aws_instance" "web" {}           # 올바름
resource "aws_instance" "web_servers" {}  # 잘못됨

# 데이터 소스 명명 - 명확한 목적 표시
data "aws_ami" "amazon_linux" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# 로컬 값 명명 - 스네이크 케이스 사용
locals {
  cluster_name = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

##### 2. 모듈 구조 표준

**모듈 디렉토리 구조:**
```
modules/eks-cluster/
├── README.md                    # 모듈 문서
├── main.tf                      # 주요 리소스
├── variables.tf                 # 입력 변수
├── outputs.tf                   # 출력 값
├── versions.tf                  # 프로바이더 버전
├── locals.tf                    # 로컬 값 (필요시)
├── data.tf                      # 데이터 소스 (필요시)
├── examples/                    # 사용 예제
│   ├── basic/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── advanced/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── modules/                     # 서브모듈 (필요시)
    └── node-group/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

**모듈 버전 관리:**
```hcl
# 모듈 호출 시 버전 지정
module "eks_cluster" {
  source = "./modules/eks-cluster"
  # 또는 Git 태그 사용
  # source = "git::https://github.com/org/repo.git//modules/eks-cluster?ref=v1.0.0"
  
  cluster_name = var.cluster_name
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.private_subnet_ids
  
  tags = local.common_tags
}
```

##### 3. 변수 및 출력 명명 표준

**변수 명명 규칙:**
```hcl
# 스네이크 케이스 사용
variable "cluster_name" {}           # 올바름
variable "clusterName" {}            # 잘못됨
variable "cluster-name" {}           # 잘못됨

# 명확하고 설명적인 이름 사용
variable "enable_cluster_encryption" {}  # 올바름
variable "encrypt" {}                    # 잘못됨 - 너무 모호함

# 복수형은 리스트나 맵에만 사용
variable "availability_zones" {
  type = list(string)
}

variable "node_groups" {
  type = map(object({...}))
}
```

**출력 명명 규칙:**
```hcl
# 명확하고 일관된 명명
output "cluster_id" {}
output "cluster_endpoint" {}
output "cluster_security_group_id" {}

# 민감한 정보는 sensitive 표시
output "cluster_certificate_authority_data" {
  value     = aws_eks_cluster.this.certificate_authority[0].data
  sensitive = true
}
```

#### 테스트 및 문서화 요구사항

##### 1. 테스트 요구사항

**Terraform 검증:**
```bash
# 모든 모듈에 대해 다음 검사 수행
terraform fmt -check -recursive    # 포맷팅 검사
terraform validate                 # 구문 검증
terraform plan                     # 계획 검증
```

**보안 스캔:**
```bash
# tfsec을 사용한 보안 스캔
tfsec .

# Checkov를 사용한 정책 검사
checkov -d .

# Terrascan을 사용한 규정 준수 검사
terrascan scan -t terraform
```

**통합 테스트:**
```bash
# Terratest를 사용한 통합 테스트 예시
# test/eks_cluster_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestEKSCluster(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/basic",
        Vars: map[string]interface{}{
            "cluster_name": "test-cluster",
            "region":       "us-west-2",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    clusterName := terraform.Output(t, terraformOptions, "cluster_name")
    assert.Equal(t, "test-cluster", clusterName)
}
```

##### 2. 문서화 요구사항

**모듈 README.md 구조:**
```markdown
# Module Name

Brief description of what this module does.

## Usage

```hcl
module "example" {
  source = "./modules/module-name"
  
  # Required variables
  cluster_name = "my-cluster"
  vpc_id       = "vpc-12345"
  
  # Optional variables
  tags = {
    Environment = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------||
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------||
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| vpc_id | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-----------|
| cluster_id | The ID of the EKS cluster |
| cluster_endpoint | Endpoint for EKS control plane |

## Examples

- [Basic Example](examples/basic)
- [Advanced Example](examples/advanced)
```

**코드 주석 규칙:**
```hcl
# 복잡한 로직에 대한 설명 주석
locals {
  # EKS 클러스터에 필요한 IAM 역할 ARN 목록을 생성
  # 기본 역할과 추가 역할을 병합하여 중복 제거
  cluster_iam_role_arns = distinct(concat(
    [aws_iam_role.cluster.arn],
    var.additional_iam_role_arns
  ))
}

# 조건부 리소스 생성에 대한 설명
resource "aws_kms_key" "eks" {
  # KMS 암호화가 활성화된 경우에만 키 생성
  count = var.enable_cluster_encryption ? 1 : 0
  
  description = "EKS cluster encryption key for ${var.cluster_name}"
  
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-eks-encryption-key"
  })
}
```

#### 보안 및 모범 사례 가이드라인

##### 1. 보안 모범 사례

**IAM 권한 최소화:**
```hcl
# 최소 권한 원칙 적용
resource "aws_iam_role_policy" "eks_cluster" {
  name = "${var.cluster_name}-cluster-policy"
  role = aws_iam_role.cluster.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeInternetGateways"
        ]
        Resource = "*"
      }
    ]
  })
}

# 와일드카드 권한 사용 금지
# 잘못된 예시:
# "Action": "*"
# "Resource": "*"
```

**민감한 데이터 보호:**
```hcl
# 민감한 출력은 sensitive 표시
output "cluster_token" {
  description = "Token for accessing the EKS cluster"
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}

# 하드코딩된 비밀 정보 금지
# 잘못된 예시:
# password = "hardcoded-password"

# 올바른 예시:
# password = var.database_password
# 또는
# password = random_password.this.result
```

**네트워크 보안:**
```hcl
# 보안 그룹 규칙 최소화
resource "aws_security_group_rule" "cluster_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks  # 특정 CIDR만 허용
  security_group_id = aws_security_group.cluster.id
  
  # 0.0.0.0/0 사용 금지 (필요한 경우 명시적 승인 필요)
}

# 프라이빗 서브넷 사용 권장
resource "aws_eks_node_group" "this" {
  subnet_ids = var.private_subnet_ids  # 퍼블릭 서브넷 대신 프라이빗 서브넷 사용
}
```

##### 2. 리소스 관리 모범 사례

**태그 관리:**
```hcl
# 모든 리소스에 일관된 태그 적용
locals {
  common_tags = merge(var.tags, {
    ManagedBy   = "terraform"
    Project     = var.project_name
    Environment = var.environment
    Module      = "eks-cluster"
  })
}

resource "aws_eks_cluster" "this" {
  name = var.cluster_name
  
  tags = local.common_tags
}
```

**리소스 생명주기 관리:**
```hcl
# 중요한 리소스는 삭제 방지
resource "aws_eks_cluster" "this" {
  name = var.cluster_name
  
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # 자동으로 업데이트되는 속성 무시
      version,
    ]
  }
}

# 의존성 명시적 선언
resource "aws_eks_node_group" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}
```

##### 3. 성능 및 비용 최적화

**리소스 크기 최적화:**
```hcl
# 환경별 인스턴스 크기 조정
variable "node_instance_types" {
  description = "List of instance types for EKS node groups"
  type        = list(string)
  default     = ["t3.medium"]
  
  validation {
    condition = alltrue([
      for instance_type in var.node_instance_types :
      can(regex("^[tm][0-9]", instance_type))
    ])
    error_message = "Only t and m instance families are allowed for cost optimization."
  }
}

# Spot 인스턴스 활용 (개발 환경)
resource "aws_eks_node_group" "spot" {
  count = var.environment == "dev" ? 1 : 0
  
  capacity_type = "SPOT"
  instance_types = var.spot_instance_types
}
```

**자동 확장 구성:**
```hcl
# 적절한 스케일링 정책 설정
resource "aws_eks_node_group" "this" {
  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }
  
  # 업데이트 구성으로 다운타임 최소화
  update_config {
    max_unavailable_percentage = 25
  }
}
```

##### 4. 코드 품질 검사 도구

**필수 검사 도구:**
```bash
# 1. Terraform 기본 검사
terraform fmt -check -recursive
terraform validate
terraform plan

# 2. 보안 스캔
tfsec --format json --out tfsec-report.json .
checkov -d . --framework terraform --output json --output-file checkov-report.json

# 3. 정적 분석
tflint --config .tflint.hcl
terrascan scan -t terraform -o json > terrascan-report.json

# 4. 문서 검증
terraform-docs markdown table --output-file README.md .
```

**CI/CD 파이프라인 통합:**
```yaml
# .github/workflows/terraform.yml
name: Terraform CI/CD

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0
      
      - name: Terraform Format Check
        run: terraform fmt -check -recursive
      
      - name: Terraform Validate
        run: terraform validate
      
      - name: Run tfsec
        uses: aquasecurity/tfsec-action@v1.0.0
        with:
          format: sarif
          output: tfsec.sarif
      
      - name: Run Checkov
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform
```

이러한 코드 스타일과 표준을 준수함으로써 프로젝트의 일관성, 보안성, 유지보수성을 보장할 수 있습니다. 모든 기여자는 이 가이드라인을 숙지하고 준수해야 합니다.

### 코드 리뷰 가이드라인

#### 리뷰어를 위한 가이드라인

1. **기능성**: 코드가 의도한 대로 작동하는가?
2. **보안**: 보안 모범 사례를 따르고 있는가?
3. **성능**: 리소스 사용량이 최적화되어 있는가?
4. **가독성**: 코드가 이해하기 쉬운가?
5. **문서화**: 적절한 주석과 문서가 있는가?
6. **테스트**: 변경 사항이 테스트되었는가?

#### 작성자를 위한 가이드라인

1. **자체 리뷰**: PR 제출 전 자신의 코드를 먼저 리뷰
2. **작은 PR**: 가능한 한 작고 집중된 변경 사항으로 PR 작성
3. **명확한 설명**: PR 설명에 변경 이유와 방법을 명확히 기술
4. **테스트**: 변경 사항에 대한 적절한 테스트 수행
5. **문서 업데이트**: 필요시 관련 문서 업데이트

### 릴리스 프로세스

#### 버전 관리

이 프로젝트는 [Semantic Versioning](https://semver.org/)을 따릅니다:

- **MAJOR**: 호환되지 않는 API 변경
- **MINOR**: 하위 호환성을 유지하면서 기능 추가
- **PATCH**: 하위 호환성을 유지하면서 버그 수정

#### 릴리스 단계

1. **기능 완료**: 모든 기능이 개발되고 테스트됨
2. **문서 업데이트**: CHANGELOG.md 및 관련 문서 업데이트
3. **태그 생성**: Git 태그로 버전 표시
4. **릴리스 노트**: GitHub 릴리스 페이지에 릴리스 노트 작성

### 커뮤니티 가이드라인

#### 행동 강령

- **존중**: 모든 기여자를 존중하고 포용적인 환경 조성
- **건설적 피드백**: 건설적이고 도움이 되는 피드백 제공
- **협력**: 문제 해결을 위한 협력적 접근
- **학습**: 실수를 통한 학습 기회로 활용

#### 소통 채널

- **GitHub Issues**: 버그 리포트, 기능 요청, 질문
- **GitHub Discussions**: 일반적인 토론, 아이디어 공유
- **Pull Request**: 코드 리뷰 및 기술적 토론

### 기여 인정

모든 기여자는 다음과 같이 인정받습니다:

- **Contributors 섹션**: README.md의 기여자 목록에 추가
- **릴리스 노트**: 주요 기여에 대한 릴리스 노트 언급
- **GitHub 기여 그래프**: GitHub 프로필의 기여 활동 반영

### 도움이 필요한 경우

기여 과정에서 도움이 필요하면:

1. **GitHub Issues**: 질문 이슈 생성
2. **GitHub Discussions**: 일반적인 토론 참여
3. **기존 이슈 검색**: 유사한 질문이나 문제가 있는지 확인

기여해 주셔서 다시 한 번 감사드립니다! 🎉

## 📄 라이센스

이 프로젝트는 Apache License 2.0 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

<div align="center">
  <a href="#aws-eks-terraform">🔝 맨 위로 돌아가기</a>
</div>

### 라이센스 개요

**Apache License 2.0**은 다음과 같은 권한을 제공합니다:

- ✅ **상업적 사용**: 상업적 목적으로 자유롭게 사용 가능
- ✅ **수정**: 소스 코드를 수정하고 개선 가능
- ✅ **배포**: 원본 또는 수정된 버전을 자유롭게 배포 가능
- ✅ **특허 사용**: 기여자의 특허 권리에 대한 명시적 허가 포함
- ✅ **개인 사용**: 개인적 목적으로 자유롭게 사용 가능

### 사용 조건

이 프로젝트를 사용할 때 다음 조건을 준수해야 합니다:

- **라이센스 및 저작권 고지 포함**: 배포 시 원본 라이센스와 저작권 고지를 포함해야 합니다
- **변경 사항 명시**: 원본 파일을 수정한 경우 변경 사항을 명시해야 합니다
- **상표권 제한**: 라이센서의 상표, 서비스 마크 등을 무단으로 사용할 수 없습니다

### 면책 조항

이 소프트웨어는 "있는 그대로" 제공되며, 명시적이거나 묵시적인 어떠한 보증도 제공하지 않습니다. 사용으로 인해 발생하는 모든 위험은 사용자가 부담합니다.

### 오픈소스 컴포넌트 라이센스

이 프로젝트는 다음과 같은 오픈소스 컴포넌트를 사용합니다:

#### Terraform 모듈

| 컴포넌트 | 라이센스 | 설명 |
|----------|----------|------|
| [terraform-aws-modules/eks](https://github.com/terraform-aws-modules/terraform-aws-eks) | Apache 2.0 | AWS EKS 클러스터 관리를 위한 Terraform 모듈 |
| [terraform-aws-modules/vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc) | Apache 2.0 | AWS VPC 관리를 위한 Terraform 모듈 |
| [terraform-aws-modules/kms](https://github.com/terraform-aws-modules/terraform-aws-kms) | Apache 2.0 | AWS KMS 관리를 위한 Terraform 모듈 |
| [terraform-aws-modules/iam](https://github.com/terraform-aws-modules/terraform-aws-iam) | Apache 2.0 | AWS IAM 관리를 위한 Terraform 모듈 |

#### Kubernetes 애드온

| 컴포넌트 | 라이센스 | 설명 |
|----------|----------|------|
| [ArgoCD](https://github.com/argoproj/argo-cd) | Apache 2.0 | GitOps 지속적 배포 도구 |
| [Karpenter](https://github.com/aws/karpenter) | Apache 2.0 | Kubernetes 클러스터 자동 확장 도구 |
| [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) | Apache 2.0 | AWS 로드 밸런서 통합 컨트롤러 |
| [External DNS](https://github.com/kubernetes-sigs/external-dns) | Apache 2.0 | Kubernetes 서비스를 위한 DNS 관리 도구 |
| [Cert Manager](https://github.com/cert-manager/cert-manager) | Apache 2.0 | Kubernetes용 X.509 인증서 관리 도구 |
| [Kyverno](https://github.com/kyverno/kyverno) | Apache 2.0 | Kubernetes용 정책 엔진 |
| [Metrics Server](https://github.com/kubernetes-sigs/metrics-server) | Apache 2.0 | Kubernetes 리소스 메트릭 수집 도구 |

#### AWS 서비스

이 프로젝트는 다음 AWS 서비스를 사용하며, 각 서비스는 AWS 서비스 약관에 따라 제공됩니다:

- Amazon EKS (Elastic Kubernetes Service)
- Amazon EC2 (Elastic Compute Cloud)
- Amazon VPC (Virtual Private Cloud)
- Amazon S3 (Simple Storage Service)
- Amazon ECR (Elastic Container Registry)
- AWS IAM (Identity and Access Management)
- AWS KMS (Key Management Service)
- Amazon CloudWatch
- AWS Route53
- AWS Certificate Manager (ACM)
- Amazon EFS (Elastic File System)

### 기여자 라이센스

이 프로젝트에 기여하는 모든 코드는 Apache License 2.0 하에 라이센스됩니다. 기여를 제출함으로써 귀하는 다음에 동의합니다:

1. 귀하의 기여가 Apache License 2.0 하에 라이센스됨
2. 귀하가 해당 기여에 대한 저작권을 소유하거나 기여할 권한을 가지고 있음
3. 귀하의 기여가 제3자의 지적 재산권을 침해하지 않음

### 라이센스 전문

Apache License 2.0의 전문은 다음 위치에서 확인할 수 있습니다:

- 프로젝트 루트의 [LICENSE](LICENSE) 파일
- [Apache Software Foundation 웹사이트](https://www.apache.org/licenses/LICENSE-2.0)

### 문의사항

라이센스와 관련된 문의사항이 있으시면 프로젝트 이슈를 통해 연락해 주세요.

---

**참고**: 이 프로젝트를 사용하기 전에 라이센스 조건을 충분히 검토하고 이해하시기 바랍니다. 법적 조언이 필요한 경우 전문가와 상담하시기 바랍니다.