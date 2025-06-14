## template: jinja
#!/bin/bash

# EC2 Name Tag
EC2_IP="{{ ds.meta_data.local_ipv4|replace(".", "-") }}"
EC2_NAME="${name_prefix}-$EC2_IP"

# EBS Root Volume Name Tag
VOL_ID=$(aws ec2 describe-instances --instance-ids {{ v1.instance_id }} --region {{ v1.region }} --query 'Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId' --output text)
VOL_NAME="${name_prefix}-vol-$EC2_IP-root"
echo $(aws ec2 create-tags --resources {{ v1.instance_id }} --tags Key="Name",Value=$EC2_NAME --region {{ v1.region }})
echo $(aws ec2 create-tags --resources $VOL_ID --tags Key="Name",Value=$VOL_NAME --region {{ v1.region }})