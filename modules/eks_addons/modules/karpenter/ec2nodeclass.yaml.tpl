---
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiSelectorTerms:
    - alias: al2023@latest
  role: ${node_iam_role_name}
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${cluster_name}
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${cluster_name}
  tags:
    karpenter.sh/discovery: ${cluster_name}
    Name: "Karpenter-Managed-Node"