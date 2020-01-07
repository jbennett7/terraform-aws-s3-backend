{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Terraform-Bucket-Policy",
      "Effect": "Allow",
      "Principal": {"AWS": ["${bucket_access_principal_arn}"]},
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${bucket_name}/*"
    },
    {
      "Sid": "Deny-Non-SecureTransport",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": "arn:aws:s3:::${bucket_name}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
