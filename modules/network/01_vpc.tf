# vpc 생성
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                                      = "${var.env}-${var.pjt}-vpc"
    Service                                                   = "vpc",
    "kubernetes.io/cluster/${var.env}-${var.pjt}-cluster"     = "shared"
  }
}

# pod ip 할당을 위한 secondary_cidr
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.secondary_cidr
}