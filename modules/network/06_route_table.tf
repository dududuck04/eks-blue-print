# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.env}-${var.pjt}-pub-rt",
    Service = "rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_associations" {
  count = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_tables" {
  count = var.use_single_nat ? 1 : length(local.selected_az)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.env}-${var.pjt}-pri-rt-${lookup(local.az_short_names, local.selected_az[count.index])}",
    Service = "rt"
  }

  dynamic "route" {
    for_each = local.nat_gateways_count > 0 ? [1] : []  # NAT Gateway가 있을 때만 route 생성
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateways[var.use_single_nat ? 0 : count.index].id
    }
  }
}


resource "aws_route_table_association" "private_route_associations" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[var.use_single_nat ? 0 : count.index].id

}

# Pod Route Table
resource "aws_route_table" "pod_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.env}-${var.pjt}-pod-rt",
    Service = "rt"
  }
}

resource "aws_route_table_association" "pod_route_associations" {
  count = length(aws_subnet.private_pod_subnets)
  subnet_id      = aws_subnet.private_pod_subnets[count.index].id
  route_table_id = aws_route_table.pod_route_table.id
}

# DB Route Table Associations
resource "aws_route_table_association" "db_route_associations" {
  count = length(aws_subnet.private_db_subnets)

  subnet_id      = aws_subnet.private_db_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[var.use_single_nat ? 0 : count.index].id
}
