data "aws_partition"           "current" {}
data "aws_caller_identity"     "current" {}
data "aws_region"              "current" {}
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_vpc" "cluster" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

data "aws_subnets" "pod_subnets" {
  filter {
    name   = "tag:Name"
    values = [var.pod_subnet_name]
  }
}

data "aws_ami" "latest" {
  most_recent = true

  # Specify the AMI owners (e.g., amazon, self, or specific AWS account ID)
  owners = ["amazon"]

  # Use a regex pattern to match the AMI name
  # name_regex = "^amzn2-ami-hvm-[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+-x86_64-gp2$" # Amazon Linux 2 example
  name_regex = "^al2023-ami-2023\\.[0-9]+\\.[0-9]{8}\\.0-kernel-6\\.1-x86_64$" # Amazon Linux 2023 example

  # Apply additional filters for the AMI
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "platform-details"
    values = ["Linux/UNIX"]
  }
}

data "tls_certificate" "this" {
  # Not available on outposts
  count = var.create_cluster && !local.create_outposts_local_cluster ? 1 : 0

  url = aws_eks_cluster.this[0].identity[0].oidc[0].issuer
}
