# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.env}-${var.pjt}-bastion-sg"
  description = "Security group for Bastion host in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.pjt}-bastion-sg"
    Service = "sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ep_ecr_sg" {
  name        = "${var.env}-${var.pjt}-ep-ecr-sg"
  description = "Security group for ECR VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.env}-${var.pjt}-ep-ecr-sg"
    Service = "sg"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr, var.secondary_cidr]
    description     = "Allow HTTPS traffic from VPC and secondary CIDR"
  }
}

# Security Group for IAM VPC Endpoint
resource "aws_security_group" "ep_iam_sg" {
  name        = "${var.env}-${var.pjt}-ep-iam-sg"
  description = "Security group for IAM VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.pjt}-ep-iam-sg"
    Service = "sg"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.secondary_cidr]
    description = "Allow HTTPS traffic from VPC and secondary CIDR for IAM API"
  }

}

resource "aws_security_group" "ep_ec2_sg" {
  name        = "${var.env}-${var.pjt}-ep-ec2-sg"
  description = "Security group for EC2 VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.pjt}-ep-ec2-sg"
    Service = "sg"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.secondary_cidr]
  }
}

resource "aws_security_group" "ep_sts_sg" {
  name        = "${var.env}-${var.pjt}-ep-sts-sg"
  description = "Security group for STS VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.pjt}-ep-sts-sg"
    Service = "sg"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.secondary_cidr]
  }
}

resource "aws_security_group" "ep_cwlogs_sg" {
  name        = "${var.env}-${var.pjt}-ep-cwlogs-sg"
  description = "Security group for CWLogs VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.env}-${var.pjt}-ep-cwlogs-sg"
    Service = "sg"
  }
}

resource "aws_security_group" "ep_elb_sg" {
  name        = "${var.env}-${var.pjt}-ep-elb-sg"
  description = "Security group for ELB VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.secondary_cidr]
  }

  tags = {
    Name = "${var.env}-${var.pjt}-ep-elb-sg"
    Service = "sg"
  }
}

resource "aws_security_group" "ep_eks_sg" {
  name        = "${var.env}-${var.pjt}-ep-eks-auth-sg"
  description = "Security group for EKS VPC Endpoint in ${var.env}"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.pjt}-ep-eks-auth-sg"
    Service = "sg"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.env}-${var.pjt}-efs-sg"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.secondary_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.pjt}-efs-sg"
    Service = "sg"
  }
}




