##########################################################
# 1. (예) 이미 존재하는 VPC/Subnet을 data로 가져오기
##########################################################
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = [
      "poc-kkm-eks-private-subnet-an2-a",
      "poc-kkm-eks-private-subnet-an2-c"
    ]
  }
}

data "aws_caller_identity" "current" {}

##########################################################
# 2. S3 버킷 생성
##########################################################

resource "aws_s3_bucket" "config_bucket" {
  bucket = var.config_bucket_name
  force_destroy = true

  tags = {
    Name = var.config_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "config_bucket_versioning" {
  bucket = aws_s3_bucket.config_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# (a) "dev-s3fa-gis-s3" 버킷
resource "aws_s3_bucket" "main_bucket" {
  bucket = var.main_bucket_name
  force_destroy = true

  tags = {
    Name = var.main_bucket_name
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  force_destroy = true

  tags = {
    Name = var.log_bucket_name
  }
}

resource "aws_s3_bucket" "image_builder_bucket" {
  bucket = var.image_builder_bucket_name
  force_destroy = true

  tags = {
    Name = var.image_builder_bucket_name
  }
}

##########################################################
# 2-1. Sample S3 Objects
##########################################################
resource "aws_s3_object" "main_bucket_upload_object" {
  bucket = aws_s3_bucket.main_bucket.bucket
  key    = "/conf/env/${var.env}-config.json"
  source = "${path.module}/conf/env/${var.env}-config.json"
}

resource "aws_s3_object" "config_zip_object" {
  bucket = aws_s3_bucket.config_bucket.bucket
  key    = "${var.config_bucket_dir}/${var.config_bucket_config_file_name}.zip"
  source = "${path.module}/conf/env/${var.config_bucket_config_file_name}.zip"
}

#  Terraform으로 새 KeyPair 생성하려면 아래처럼:
resource "aws_key_pair" "new_key" {
  key_name   = var.key_pair_name
  public_key = file("${path.module}/mykey.pub")
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_bucket.id}"
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.log_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


##########################################################
# 4. CloudTrail
##########################################################
resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.cloud_trail_name
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  depends_on = [
    aws_s3_bucket.log_bucket,
    aws_s3_bucket_policy.cloudtrail_policy
  ]
}