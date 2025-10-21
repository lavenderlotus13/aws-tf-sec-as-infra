variable "trail_name"        { type = string }
variable "log_bucket_name"   { type = string }   # pre-created bucket with Object Lock enabled
variable "kms_key_arn"       { type = string }
variable "is_multi_region"   { type = bool, default = true }
variable "include_global"    { type = bool, default = true }
