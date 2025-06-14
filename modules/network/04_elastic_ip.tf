# NAT Gateway용 EIP 생성
resource "aws_eip" "eip_nat" {
  count = var.use_single_nat ? 1 : length(local.selected_az)

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name    = "${var.env}-${var.pjt}-nat-eip-${lookup(local.az_short_names, local.selected_az[count.index])}",
    Service = "nat-eip-${lookup(local.az_short_names, local.selected_az[count.index])}"
  }
}

# Bastion 용 EIP 생성 (선택적)
resource "aws_eip" "eip_bastion" {
  count      = var.create_bastion ? 1 : 0
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"

  tags = {
    Name    = "${var.env}-${var.pjt}-bastion-eip-${lookup(local.az_short_names, local.selected_az[0])}",
    Service = "bastion-eip"
  }
}