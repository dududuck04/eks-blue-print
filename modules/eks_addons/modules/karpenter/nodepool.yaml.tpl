apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default

      expireAfter: ${expire_after}
      terminationGracePeriod: ${termination_grace_period}

      requirements:
        %{ if length(instance_family_values) > 0 }
          - key: "karpenter.k8s.aws/instance-family"
            operator: In
            values: ${jsonencode(instance_family_values)}
        %{ endif }

        %{ if length(instance_cpu_values) > 0 }
          - key: "karpenter.k8s.aws/instance-cpu"
            operator: In
            values: ${jsonencode(instance_cpu_values)}
        %{ endif }

        %{ if length(instance_hypervisor_values) > 0 }
          - key: "karpenter.k8s.aws/instance-hypervisor"
            operator: In
            values: ${jsonencode(instance_hypervisor_values)}
        %{ endif }

        %{ if length(instance_generation_threshold) > 0 }
          - key: "karpenter.k8s.aws/instance-generation"
            operator: Gt
            values: ${jsonencode(instance_generation_threshold)}
        %{ endif }

        %{ if length(zone_values) > 0 }
          - key: "topology.kubernetes.io/zone"
            operator: In
            values: ${jsonencode(zone_values)}
        %{ endif }

        %{ if length(kubernetes_arch_values) > 0 }
          - key: "kubernetes.io/arch"
            operator: In
            values: ${jsonencode(kubernetes_arch_values)}
        %{ endif }

        %{ if length(capacity_type_values) > 0 }
          - key: "karpenter.sh/capacity-type"
            operator: In
            values: ${jsonencode(capacity_type_values)}
        %{ endif }

  disruption:
    consolidationPolicy: ${consolidation_policy}
    consolidateAfter: ${consolidate_after}

    budgets: ${jsonencode(disruption_budgets)}

  limits:
    cpu: ${nodepool_cpu_limit}
    memory: ${nodepool_memory_limit}

  weight: ${nodepool_weight}
