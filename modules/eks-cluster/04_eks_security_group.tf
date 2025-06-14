################################################################################
# Cluster Security Group
################################################################################

module "additional_cluster_sg" {
  source = "../security_group"

  create_sg             = var.create_additional_cluster_security_group
  use_name_prefix       = var.additional_cluster_security_group_use_name_prefix

  name                  = var.additional_cluster_security_group_name
  description           = var.additional_cluster_security_group_description

  vpc_id                = local.vpc_id
  tags                  = merge(var.tags, var.cluster_security_group_tags)

  ingress_rules         = ["https-443-tcp"]
  ingress_cidr_blocks   = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = var.additional_cluster_security_group_extra_rules
  egress_rules             = []

}

module "node_cluster_sg" {
  source = "../security_group"
  for_each        = { for ng in var.eks_managed_node_groups : ng.name => ng if ng.create }

  create_sg       = each.value.create_node_security_group
  use_name_prefix = each.value.use_name_prefix

  name        = each.value.node_security_group_name
  description = var.node_security_group_description
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = each.value.additional_node_security_group_extra_rules
  ingress_with_self        = [
    {
      self        = true
      description = "Cluster API to node kubelets"
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
    },
    {
      self        = true
      description = "Node to node CoreDNS"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
    },
    {
      self        = true
      description = "Node to node CoreDNS UDP"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
    }
  ]

  egress_with_cidr_blocks  = []

  tags = merge(var.tags, var.cluster_security_group_tags, {
    "NodeGroup" = each.key
  })
}
