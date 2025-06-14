# cluster-autoscaler

- [cluster-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler)


## Install / Uninstall

### Installing the chart

```sh
# env/an2-dev.hcl: s3 backend configuration file
terraform init -backend-config=env/an2-dev.hcl

# env/an2-dev.tfvars: configuration file
terraform plan -var-file=env/an2-dev.tfvars

terraform apply -var-file=env/an2-dev.tfvars -auto-approve
```

### Uninstalling the Chart

```sh
terraform destroy -var-file=env/an2-dev.tfvars -auto-approve
```


## Configuration

### Common Variables

| 파라미터            |   타입  |  기본값  |    설명                                         |
|-------------------|--------|--------|------------------------------------------------|
| project           | string |   ""   | 프로젝트 코드명                                    |
| region            | string |   ""   | AWS 리전명                                       |
| abbr_region       | string |   ""   | AWS 리전 약어                                    |
| env               | string |   ""   | 프로비전 구성 환경 (예시: dev, stg, qa, prod, ...)  |
| org               | string |   ""   | 조직명                                          |
| default_tags      | object |   {}   | AWS 리소스에 넣을 Tag                             |
| remote_backend    | object |   {}   | Terraform Backend 정보[설정 값 참조](#remote-backend) |

### Backend Variables
| 파라미터             |   타입  |  기본값  |    설명                                         |
|--------------------|--------|--------|------------------------------------------------|
| type               | string |   ""   | Backend Type (s3, remote)                      |
| workspaces.service | string |   ""   | Terraform Service (eks 지정)                    |
| workspaces.bucket  | string |   ""   | S3 Backend 시 사용, S3 Bucket 명                 |
| workspaces.key     | string |   ""   | S3 Backend 시 사용, S3 Bucket 키                 |
| workspaces.region  | string |   ""   | S3 Backend 시 사용, S3 Bucket region             |
| workspaces.org     | string |   ""   | Remote Backend 시 사용, Terraform Cloud Org      |
| workspaces.workspace_name | string |   ""   | Remote Backend 시 사용, Terraform Cloud workspace_name  |


### EKS Access Variables
| 파라미터            |   타입  |  기본값  |    설명                                         |
|-------------------|--------|--------|------------------------------------------------|
| cluster_name      | string |   ""   | EKS Cluster 명                                 |
| iam_role_name     | string |   ""   | IRSA 구성을 위한 IAM Role 이름                    |
| iam_policy_name   | string |   ""   | IRSA 구성을 위한 IAM Policy 이름                  |

### Helm Chart Variables
| 파라미터                      |   타입  |  기본값                |    설명                           |
|-----------------------------|--------|----------------------|----------------------------------|
| helm_chart.name             | string | "cluster-autoscaler" | Helm Chart 이름                   |
| helm_chart.version          | string | ""                   | Helm Chart 버전                   |
| helm_chart.repository_url   | string | "https://kubernetes.github.io/autoscaler" | Helm Chart 저장소 위치 |
| helm_chart.namespace        | object | {}                   | Helm Chart 생성 Namespace         |
| helm_chart.namespace.create | bool   | false                | Helm Chart Namespace 생성 유무     |
| helm_chart.namespace.name   | string | "kube-system"        | Helm Chart Namespace             |

### Helm Release Variables
| 파라미터                      |   타입  |  기본값                |    설명                           |
|-----------------------------|--------|----------------------|----------------------------------|
| helm_release.service_account_name    | string | "cluster-autoscaler-sa" | Service Account 이름  |
| helm_chart.replica          | number |   1                  | Cluster Autoscaler Deployment 개수|
| helm_chart.resources        | string | ""                   | Pod Resource Limit               |
| helm_chart.affinity         | string | ""                   | Deployment Affinity              |
| helm_chart.node_selector    | string | ""                   | Deployment Node Selector         |
| helm_chart.tolerations      | string | ""                   | Deployment Tolerations           |
| helm_chart.service_monitor_enabled | bool | false           | Prometheuse Monitoring 활성화 여부  |
| helm_chart.topology_spread_constraints | string | ""        | Deployment constraints 구성       |
| helm_chart.image_repo  | string | "registry.k8s.io/autoscaling/cluster-autoscaler" | Container Image Repo |
| helm_chart.image_tag        | string | "v1.27.2"            | Container Image Tag             |
| helm_chart.sets             | list(object) | []             | Helm 추가 설정                    |

## Helm Release Additional

### Resource 구성시

```yaml
requests:
  cpu: "100m"
  memory: "100Mi"
limits:
  cpu: "100m"
  memory: "100Mi"
```

### Affinity 구성시

```yaml
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: role
        operator: In
        values:
        - ops
```

### Topology Constraint 구성시

```yaml
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        <KEY>: <VALUE>
```