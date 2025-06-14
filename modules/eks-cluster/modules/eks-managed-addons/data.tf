data "aws_subnet" "pod_subnet_info" {
  for_each = toset(var.eks_context.pod_subnet_ids)
  id       = each.key
}
