## ClusterRole과 ClusterRoleBinding
> 쿠버네티스에서 생성할 Cluster Role은 Admin, Operator, Viewer로 생성예정.

| ClusterRole | Description                                                     |
| ----------- | ----------------------------------------------------------------|
| admin       | System: masters에 준하는 권한                                      |
| operator    | Secrets X, RBAC은 조회만 가능                                      |
| viewer      | Secrets X, RBAC은 조회만 가능, verbs: get, list, watch만 가능        |



> 각 ClusterRole에 맵핑될 okta group은 admin, operator, developer, viewer

| okta-group  | Description                                                     |
| ----------- | ----------------------------------------------------------------|
| admin       | DevSecOps팀, 개발PM?                                              |
| operator    | 운영팀?                                                           |
| developer   | 개발사? 개발자가 secrets 값 제대로 들어가 있는지 확인 필요?                 |
| viewer      | 보기만 할 사람, 참고 할 사람 등                                        |

<br>

## 환경별 okta Group과 Cluster Role 맵핑
### 개발환경
| okta-group | ClusterRole |
| ---------- | ----------- |
| admin      | Admin       |
| operator   | operator    |
| developer  | operator    |
| viewer     | viewer      |

### 검수환경
| okta-group | ClusterRole |
| ---------- | ----------- |
| admin      | Admin       |
| operator   | operator    |
| developer  | operator    |
| viewer     | viewer      |

### 검수환경
| okta-group | ClusterRole |
| ---------- | ----------- |
| admin      | Admin       |
| operator   | operator    |
| developer  | viewr       |
| viewer     | viewer      |

<br>


## NOTE!
```
apiVersion: rbac.authorization.k8s.io/v1
```
apiVersion도 value로 받을 필요가 있는지

```
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "false"
```
위의 autoupodate 값을 true로 두게 되면 argocd에서 outOfSync로 나오는데 확인 필요



## TODO 
각 환경별로 ENV-values.yaml로 받아올 수 있도록 변경 필요