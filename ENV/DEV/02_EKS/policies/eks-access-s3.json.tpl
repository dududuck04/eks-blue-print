{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListAndGetObjectFromS3",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": ["*"]
    }
  ]
}
