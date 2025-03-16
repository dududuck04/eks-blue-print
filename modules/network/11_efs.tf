# EFS 파일 시스템
resource "aws_efs_file_system" "efs" {
  count                 = var.create_efs ? 1 : 0
  creation_token        = "${var.env}-${var.pjt}-efs"
  performance_mode      = "generalPurpose"
  throughput_mode       = "elastic"
  encrypted             = true

  lifecycle_policy {
    transition_to_archive = "AFTER_90_DAYS"
  }

  tags = {
    Name    = "${var.env}-${var.pjt}-efs"
    Service = "efs"
  }
}

# EFS 마운트 타겟 (AZ별로 생성)
resource "aws_efs_mount_target" "efs_mount_targets" {
  depends_on            = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]
  count                 = var.create_efs ? length(local.selected_az) : 0

  file_system_id        = aws_efs_file_system.efs[0].id
  subnet_id             = aws_subnet.private_subnets[count.index].id
  security_groups       = [aws_security_group.efs_sg.id]
}