data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  region         = data.aws_region.current.name
  az_short_names = {
    for az in data.aws_availability_zones.available.names :
    az => join("", [
      substr(local.region, 0, 1),
      substr(local.region, 3, 1),
      substr(local.region, length(local.region) - 1, 1),
      "-",
      substr(az, length(az) - 1, 1)
    ])
  }
  selected_az    = tolist(var.selected_az != [] ? var.selected_az : data.aws_availability_zones.available.names)

  # Optional CIDRs
  public_cidr_map = {
    for az, cidr in zipmap(data.aws_availability_zones.available.names, [var.puba_cidr, var.pubb_cidr, var.pubc_cidr, var.pubd_cidr]) :
    az => cidr if contains(local.selected_az, az)
  }

  private_cidr_map = {
    for az, cidr in zipmap(data.aws_availability_zones.available.names, [var.pria_cidr, var.prib_cidr, var.pric_cidr, var.prid_cidr]) :
    az => cidr if contains(local.selected_az, az)
  }

  pod_cidr_map = {
    for az, cidr in zipmap(data.aws_availability_zones.available.names, [var.pria_pod_cidr, var.prib_pod_cidr, var.pric_pod_cidr, var.prid_pod_cidr]) :
    az => cidr if contains(local.selected_az, az)
  }

  db_cidr_map = {
    for az, cidr in zipmap(data.aws_availability_zones.available.names, [var.pria_db_cidr, var.prib_db_cidr, var.pric_db_cidr, var.prid_db_cidr]) :
    az => cidr if contains(local.selected_az, az)
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(local.selected_az != [] ? local.selected_az : data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = local.selected_az[count.index]
  cidr_block              = lookup(local.public_cidr_map, local.selected_az[count.index], null)

  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = merge(
    {
      Name = "${var.env}-${var.pjt}-public-subnet-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      Service = "public",
      "kubernetes.io/cluster/${var.env}-${var.pjt}-cluster" = "shared",
      "kubernetes.io/role/elb" = "1"
    },
    var.public_subnet_tags
  )
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count = length(local.selected_az != [] ? local.selected_az : data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = local.selected_az[count.index]
  cidr_block              = lookup(local.private_cidr_map, local.selected_az[count.index], null)

  map_public_ip_on_launch = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = merge(
    {
      Name = "${var.env}-${var.pjt}-eks-private-subnet-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      Service = "private-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      "kubernetes.io/cluster/${var.env}-${var.pjt}-cluster" = "shared",
      "kubernetes.io/role/internal-elb" = 1,
    },
    var.private_subnet_tags
  )
}


# Secondary_cidr 용 Private subnet 2개
resource "aws_subnet" "private_pod_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]
  count = length(local.selected_az != [] ? local.selected_az : data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = local.selected_az[count.index]
  cidr_block              = lookup(local.pod_cidr_map, local.selected_az[count.index], null)
  map_public_ip_on_launch = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = merge(
    {
      Name    = "${var.env}-${var.pjt}-pod-private-subnet-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      Service = "pod-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      "kubernetes.io/cluster/${var.env}-${var.pjt}-cluster" = "shared",
      "kubernetes.io/role/internal-elb"                    = 0
    },
    var.private_subnet_tags
  )
}

# DB용 Private subnet 2개추가
resource "aws_subnet" "private_db_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]
  count = length(local.selected_az != [] ? local.selected_az : data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = local.selected_az[count.index]
  cidr_block              = lookup(local.db_cidr_map, local.selected_az[count.index], null)
  map_public_ip_on_launch = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = merge(
    {
      Name    = "${var.env}-${var.pjt}-db-private-subnet-${lookup(local.az_short_names, local.selected_az[count.index], null)}",
      Service = "db-${lookup(local.az_short_names, local.selected_az[count.index], null)}"
    },
    var.private_subnet_tags
  )
}