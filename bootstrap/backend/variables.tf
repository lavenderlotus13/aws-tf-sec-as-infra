variable "region" {
  description = "AWS region for the state bucket and lock table."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "kms_sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)."
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "Optional KMS key ID/ARN when using aws:kms."
  type        = string
  default     = null
}

variable "lock_table_name" {
  description = "DynamoDB lock table name for Terraform state locking."
  type        = string
  default     = "terraform-locks"
}
