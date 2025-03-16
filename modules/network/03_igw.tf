# internet gateway 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.env}-${var.pjt}-internetgw-igw",
    Service = "igw"
  }
}