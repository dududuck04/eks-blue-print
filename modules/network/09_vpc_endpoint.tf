# S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  count             = var.create_s3_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.pod_route_table.id]

  tags = {
    Name    = "${var.env}-${var.pjt}-s3-vpcend"
    Service = "vpce"
    Environment = var.env
    Project     = var.pjt
  }
}

# ECR DKR VPC Endpoint
resource "aws_vpc_endpoint" "ecr_dkr_vpc_endpoint" {
  count             = var.create_ecr_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_ecr_sg.id]

  tags = {
    Name    = "${var.env}-${var.pjt}-ecr-dkr-vpcend"
    Service = "vpce"
    Environment = var.env
    Project     = var.pjt
  }
}

# ECR API VPC Endpoint
resource "aws_vpc_endpoint" "ecr_api_vpc_endpoint" {
  count             = var.create_ecr_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_ecr_sg.id]

  tags = {
    Name    = "${var.env}-${var.pjt}-ecr-api-vpcend"
    Service = "vpce"
    Environment = var.env
    Project     = var.pjt
  }
}

# EC2 VPC Endpoint
resource "aws_vpc_endpoint" "ec2_vpc_endpoint" {
  count             = var.create_ec2_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_ec2_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-ec2-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}

# STS VPC Endpoint
resource "aws_vpc_endpoint" "sts_vpc_endpoint" {
  count             = var.create_sts_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_sts_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-sts-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}

# CloudWatch Logs VPC Endpoint
resource "aws_vpc_endpoint" "cwlogs_vpc_endpoint" {
  count             = var.create_cwlogs_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_cwlogs_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-cwlogs-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}

# Elastic Load Balancing VPC Endpoint
resource "aws_vpc_endpoint" "elb_vpc_endpoint" {
  count             = var.create_elb_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_elb_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-elb-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}

# EKS VPC Endpoint
resource "aws_vpc_endpoint" "eks_vpc_endpoint" {
  count             = var.create_eks_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.eks"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_eks_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-eks-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}

# EKS Auth VPC Endpoint
resource "aws_vpc_endpoint" "eks_auth_vpc_endpoint" {
  count             = var.create_eks_vpcend ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.eks-auth"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for idx in range(length(local.selected_az)) : aws_subnet.private_subnets[idx].id]
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ep_eks_sg.id]

  tags = {
    Name = "${var.env}-${var.pjt}-eks-auth-vpcend"
    Service = "vpce"
    Environment = var.env
    Project = var.pjt
  }
}
