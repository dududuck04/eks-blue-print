locals {
  nat_gateways_count = var.create_nat ? (var.use_single_nat ? 1 : length(local.selected_az)) : 0
}


resource "aws_nat_gateway" "nat_gateways" {
  count = local.nat_gateways_count

  allocation_id = aws_eip.eip_nat[count.index].id

  subnet_id = lookup(
    { for idx, subnet in aws_subnet.public_subnets : idx => subnet.id },
    count.index,
    null
  )

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name    = "${var.env}-${var.pjt}-nat-${lookup(local.az_short_names, local.selected_az[count.index])}",
    Service = "nat-${lookup(local.az_short_names, local.selected_az[count.index])}"
  }
}
