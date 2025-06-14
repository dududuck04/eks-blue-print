locals {
  bastion_role_arn = aws_iam_role.bastion_role.arn
  eks_admin_role_arn = aws_iam_role.eks_admin_role.arn
}

# EKS 배포 Admin 역할 생성
resource "aws_iam_role" "eks_admin_role" {
  name = "${var.env}-${var.pjt}-eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = local.bastion_role_arn
        },
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    Name    = "${var.env}-${var.pjt}-eks-admin-role"
    Service = "role"
  }

}


# IAM Role for Bastion Host
resource "aws_iam_role" "bastion_role" {
  name = "${var.env}-${var.pjt}-bastion-role"

  tags = {
    Name    = "${var.env}-${var.pjt}-bastion-role"
    Service = "role"
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

# Bastion 역할에 eks_admin_role을 AssumeRole할 수 있는 권한 부여를 위한 정책 생성
resource "aws_iam_policy" "bastion_assume_eks_admin_policy" {
  name = "${var.env}-${var.pjt}-bastion-assume-eks-admin-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = local.eks_admin_role_arn
      },
    ]
  })
}

# Bastion 역할에 정책 부착
resource "aws_iam_role_policy_attachment" "bastion_assume_eks_admin_role" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_assume_eks_admin_policy.arn
}


# AdministratorAccess 정책을 eks_admin_role에 연결
resource "aws_iam_role_policy_attachment" "eks_admin_role_admin_access" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach SSM policy to the Bastion Host Role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_role.name
}

# Create an Instance Profile for Bastion Host
resource "aws_iam_instance_profile" "bastion_profile" {
  role = aws_iam_role.bastion_role.name

  tags = {
    Name    = "${var.env}-${var.pjt}-bastion-profile"
    Service = "instance-profile"
  }
}

# Bastion Host with SSM
resource "aws_instance" "bastion_ec2" {
  count                       = var.create_bastion ? 1 : 0
  ami                         = "ami-0f1e61a80c7ab943e" # 최신 AMI를 사용하도록 관리 필요
  instance_type               = "t3.small"
  # subnet_id                   = aws_subnet.public_subnets[local.selected_az[0]].id
  # subnet_id                   = element(aws_subnet.public_subnets.*.id, 0)
  # subnet_id                   = lookup({for subnet in aws_subnet.public_subnets : subnet.id => subnet.availability_zone}, local.selected_az[0])
  subnet_id                   = lookup({for subnet in aws_subnet.public_subnets : subnet.availability_zone => subnet.id}, local.selected_az[0])


  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/userdata.sh.tftpl", { username = var.bastion_username })

  # ✅ 루트 볼륨 크기 지정
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  private_dns_name_options {
    enable_resource_name_dns_aaaa_record = false  # IPv6 비활성화
    enable_resource_name_dns_a_record    = true   # IPv4 DNS 활성화
    hostname_type                        = "ip-name"  # 인스턴스의 IPv4 주소 기반 DNS 사용
  }

  tags = {
    Name    = "${var.env}-${var.pjt}-bastion-ec2-${lookup(local.az_short_names, local.selected_az[0])}"
    Service = "bastion-ec2"
  }
}

