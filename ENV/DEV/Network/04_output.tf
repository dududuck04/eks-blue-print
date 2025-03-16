output "vpc_id" {
  value = module.Network.vpc_id
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {
  value = module.Network.public_subnet_ids
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value = module.Network.private_subnet_ids
  description = "The IDs of the private subnets"
}

output "secondary_cidr" {
  value = module.Network.secondary_cidr
}

output "public_subnet_cidrs" {
  value = module.Network.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.Network.private_subnet_cidrs
}

output "private_pod_subnet_ids" {
  value = module.Network.private_pod_subnet_ids
}

output "private_pod_subnet_cidrs" {
  value = module.Network.private_pod_subnet_cidrs
}

output "private_db_subnet_ids" {
  value = module.Network.private_db_subnet_ids
}

output "private_db_subnet_cidrs" {
  value = module.Network.private_db_subnet_cidrs
}

output "route_table_public_id" {
  value = module.Network.route_table_public_id
}

output "route_table_private_ids" {
  value = module.Network.route_table_private_ids
}

output "route_table_pod_id" {
  value = module.Network.route_table_pod_id
}

output "eip_bastion_id" {
  value = module.Network.eip_bastion_id
}

output "efs_filesystem" {
  value = module.Network.efs_filesystem
}

output "selected_az" {
  value = module.Network.selected_az
}

output "public_cidr_map" {
  value = module.Network.public_cidr_map
}
