provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = "> 0.12.0"
}

locals {
  bucket_name      = "terraform-${var.application}-${var.environment}"
  access_principal = "access-${local.bucket_name}"
}

resource "aws_kms_key" "s3_bucket_kms_encryption_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy = templatefile(var.kms_key_policy_template_file_path,
    { key_access_principal_arn = module.s3_access_service_role.this_iam_role_arn,
  account_id = var.account_id })
}

module "s3_access_service_role" {
  source            = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-assumable-role"
  trusted_role_arns = var.trusted_role_arns
  create_role       = true
  role_name         = local.access_principal
  role_requires_mfa = false
}

module "s3_backend" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket"
  bucket = local.bucket_name
  acl    = "log-delivery-write"
  # logging = {
  #   target_bucket = local.bucket_name
  #   target_prefix = "access-logs/"
  # }
  attach_policy = var.attach_policy
  policy = templatefile(var.bucket_policy_template_file_path,
    { bucket_access_principal_arn = module.s3_access_service_role.this_iam_role_arn,
      bucket_name                 = local.bucket_name
  })
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_bucket_kms_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
