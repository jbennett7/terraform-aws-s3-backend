variable "account_id" {
  type        = string
  description = "The AWS account id."
}

variable "application" {
  type        = string
  description = "Name of the application."
}

variable "attach_policy" {
  type        = bool
  default     = true
  description = "Whether or not to attach a bucket policy."
}

variable "bucket_policy_template_file_path" {
  type        = string
  description = "Path to the bucket policy template file."
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "environment" {
  type        = string
  description = "Name of the environment."
}

variable "kms_key_deletion_window_in_days" {
  type    = number
  default = 7
}

variable "kms_key_description" {
  type    = string
  default = "KMS Key"
}

variable "kms_key_policy_template_file_path" {
  type        = string
  description = "Path to the kms key poicy template file."
}

variable "policy" {
  type        = string
  default     = ""
  description = "Bucket policy to attach to the bucket."
}

variable "profile" {
  type        = string
  default     = "default"
  description = "The profile to use when deploying the resources."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region to deploy the resources in."
}

variable "trusted_role_arns" {
  type        = list(string)
  description = "List of ARNs that can access the bucket."
}
