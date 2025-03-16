output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "secondary_cidr" {
  value = aws_vpc_ipv4_cidr_block_association.secondary_cidr.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public_subnets[*].cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnets[*].cidr_block
}

output "private_pod_subnet_ids" {
  value = aws_subnet.private_pod_subnets[*].id
}

output "private_pod_subnet_cidrs" {
  value = aws_subnet.private_pod_subnets[*].cidr_block
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db_subnets[*].id
}

output "private_db_subnet_cidrs" {
  value = aws_subnet.private_db_subnets[*].cidr_block
}

output "route_table_public_id" {
  value = aws_route_table.public_route_table.id
}

output "route_table_private_ids" {
  value = aws_route_table.private_route_tables[*].id
}

output "route_table_pod_id" {
  value = aws_route_table.pod_route_table.id
}

output "eip_bastion_id" {
  value = var.create_bastion ? aws_eip.eip_bastion[0].id : null
}

output "efs_filesystem" {
  value = var.create_efs ? aws_efs_file_system.efs[0].id : null
}

output "selected_az" {
  value = local.selected_az
}

output "public_cidr_map" {
  value = local.public_cidr_map
}
