#!/bin/bash
set -e

# EC2 네임/볼륨 태깅
EC2_NAME_PREFIX=${ec2_name_prefix}
VOL_NAME_PREFIX=${volume_name_prefix}

EKS_CLUSTER_NAME=${eks_cluster_name}
EKS_REGION=${aws_region}