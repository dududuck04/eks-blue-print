################################################################################
# Cluster Security Group
################################################################################

# 자동으로 생성하지 않았을 경우 name으로 조회 한 후 사용
data "aws_security_group" "primary_cluster_security_group_id" {
  count  = local.create_primary_cluster_sg ? 0 : 1
  filter {
    name   = "tag:Name"
    values = [var.primary_cluster_security_group_name]
  }
}

data "aws_security_group" "additional_cluster_security_group_id" {
  count = local.create_additional_cluster_sg ? 0 : 1
  filter {
    name   = "tag:Name"
    values = [var.additional_cluster_security_group_name]
  }
}

data "aws_security_group" "node_cluster_security_group_id" {
  count = local.create_node_cluster_sg ? 0 : 1
  filter {
    name   = "tag:Name"
    values = [var.node_cluster_security_group_name]
  }
}

data "aws_vpc" "cluster_vpc_name" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

locals {

  # 생성 설정
  create_primary_cluster_sg    = var.create_cluster && var.create_primary_cluster_security_group
  create_additional_cluster_sg = var.create_cluster && var.create_additional_security_group
  create_node_cluster_sg = var.create_cluster && var.create_node_security_group

  vpc_id = data.aws_vpc.cluster_vpc_name.id


  # 이름 설정
  cluster_primary_sg_name = coalesce(var.primary_cluster_security_group_name, "${var.cluster_name}-sg")
  cluster_additional_sg_name = coalesce(var.additional_cluster_security_group_name, "${var.cluster_name}-add-sg")
  cluster_node_sg_name = coalesce(var.node_cluster_security_group_name, "${var.cluster_name}-node-sg")

  primary_cluster_sg_id = local.create_primary_cluster_sg ? aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id : data.aws_security_group.primary_cluster_security_group_id[0].id
  additional_cluster_sg_id = local.create_additional_cluster_sg ? aws_security_group.additional_cluster_security_group[0].id : data.aws_security_group.additional_cluster_security_group_id[0].id
  node_cluster_sg_id       = local.create_node_cluster_sg ? aws_security_group.node_cluster_security_group[0].id : data.aws_security_group.node_cluster_security_group_id[0].id

  cluster_security_group_ids = concat(
    [local.additional_cluster_sg_id],
    [local.node_cluster_sg_id]
  )

  # 추가 보안 그룹 규칙 설정
  additional_cluster_security_group_rules = {
    ingress_nodes_443 = {
      description       = "Node groups to cluster API"
      type              = "ingress"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443

      use_source_id     = false
      cidr_blocks       = ["0.0.0.0/0"]
    }
  }


  node_cluster_security_group_rules = {
    ingress_cluster_443 = {
      description                   = "Cluster API to node groups"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "ingress"

      use_source_id                 = false
      cidr_blocks                   = ["0.0.0.0/0"]

    }
    ingress_cluster_kubelet = {
      description                   = "Cluster API to node kubelets"
      protocol                      = "tcp"
      from_port                     = 10250
      to_port                       = 10250
      type                          = "ingress"

      use_source_id                 = false
      self                          = true
    }
    ingress_self_coredns_tcp = {
      description                   = "Node to node CoreDNS"
      protocol                      = "tcp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"

      use_source_id                 = false
      self                          = true
    }
    ingress_self_coredns_udp = {
      description                   = "Node to node CoreDNS UDP"
      protocol                      = "udp"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"

      use_source_id                 = false
      self                          = true
    }
  }

  node_security_group_recommended_rules = { for k, v in {
    ingress_nodes_ephemeral = {
      description = "Node to node ingress on ephemeral ports"
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535
      type        = "ingress"

      use_source_id                 = false
      self        = true
    }
    # metrics-server
    ingress_cluster_4443_webhook = {
      description                   = "Cluster API to node 4443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 4443
      to_port                       = 4443
      type                          = "ingress"

      use_source_id                 = false
      cidr_blocks                   = ["0.0.0.0/0"]
    }
    # prometheus-adapter
    ingress_cluster_6443_webhook = {
      description                   = "Cluster API to node 6443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 6443
      to_port                       = 6443
      type                          = "ingress"

      use_source_id                 = false
      cidr_blocks                   = ["0.0.0.0/0"]
    }
    # Karpenter
    ingress_cluster_8443_webhook = {
      description                   = "Cluster API to node 8443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"

      use_source_id                 = false
      cidr_blocks                   = ["0.0.0.0/0"]
    }
    # ALB controller, NGINX
    ingress_cluster_9443_webhook = {
      description                   = "Cluster API to node 9443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"

      use_source_id                 = false
      cidr_blocks                   = ["0.0.0.0/0"]
    }
    egress_all = {
      description      = "Allow all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"

      use_source_id                 = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = var.cluster_ip_family == "ipv6" ? ["::/0"] : null
    }
  } : k => v if var.node_security_group_enable_recommended_rules }

}

# 기본 보안 그룹 생성 (조건적)
resource "aws_security_group" "primary_cluster_security_group" {
  count = local.create_primary_cluster_sg ? 0 : 1

  description = var.cluster_security_group_description
  vpc_id      = local.vpc_id

  tags = merge(
    var.tags,
    var.cluster_security_group_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 추가 보안 그룹 생성 (조건적)
resource "aws_security_group" "additional_cluster_security_group" {
  count = local.create_additional_cluster_sg ? 1 : 0

  name        = var.cluster_security_group_use_name_prefix ? null : var.additional_cluster_security_group_name
  name_prefix = var.cluster_security_group_use_name_prefix ? "${var.cluster_name}-add${var.prefix_separator}" : null
  description = var.cluster_security_group_description
  vpc_id      = local.vpc_id

  tags = merge(
    var.tags,
    var.cluster_security_group_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 추가 보안 그룹 규칙 적용
resource "aws_security_group_rule" "additional_cluster_security_group_rules" {
  for_each = { for k, v in merge(
    local.additional_cluster_security_group_rules,
    var.cluster_security_group_additional_rules
  ) : k => v }

  # Required
  security_group_id        = local.additional_cluster_sg_id
  type                     = each.value.type
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = try(each.value.use_source_id ? null : lookup(each.value, "cidr_blocks", null))
  ipv6_cidr_blocks         = try(each.value.use_source_id ? null : lookup(each.value, "ipv6_cidr_blocks", null))
  prefix_list_ids          = try(each.value.use_source_id ? null : lookup(each.value, "prefix_list_ids", null))
  self                     = try(each.value.use_source_id ? null : lookup(each.value, "self", null))
  source_security_group_id = try(each.value.use_source_id ? try(local.primary_cluster_sg_id, null) : lookup(each.value, "source_security_group_id", null))
}

resource "aws_security_group" "node_cluster_security_group" {
  count = local.create_node_cluster_sg ? 1 : 0

  name        = var.node_security_group_use_name_prefix ? null : local.cluster_node_sg_name
  name_prefix = var.node_security_group_use_name_prefix ? "${var.cluster_name}-node${var.prefix_separator}" : null
  description = var.node_security_group_description
  vpc_id      = local.vpc_id

  tags = merge(
    var.tags,
    var.node_security_group_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cluster_node_security_group_rules" {
  for_each = { for k, v in merge(
    local.node_cluster_security_group_rules,
    local.node_security_group_recommended_rules,
    var.node_security_group_additional_rules
  ) : k => v }

  # Required
  security_group_id        = local.node_cluster_sg_id
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = try(each.value.use_source_id ? null : lookup(each.value, "cidr_blocks", null))
  ipv6_cidr_blocks         = try(each.value.use_source_id ? null : lookup(each.value, "ipv6_cidr_blocks", null))
  prefix_list_ids          = try(each.value.use_source_id ? null : lookup(each.value, "prefix_list_ids", null))
  self                     = try(each.value.use_source_id ? null : lookup(each.value, "self", null))
  source_security_group_id = try(each.value.use_source_id ? try(local.primary_cluster_sg_id, null) : lookup(each.value, "source_security_group_id", null))
}
