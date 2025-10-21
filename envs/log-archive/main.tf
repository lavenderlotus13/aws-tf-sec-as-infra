variable "trail_name"      { type = string, default = "org-trail" }
variable "log_bucket_name" { type = string, default = "REPLACE-ME-object-lock-bucket" } # must exist with Object Lock
variable "kms_key_arn"     { type = string, default = "arn:aws:kms:us-east-1:123456789012:key/REPLACE-ME" } # REPLACE

module "org_trail" {
  source          = "../../modules/cloudtrail-org"
  trail_name      = var.trail_name
  log_bucket_name = var.log_bucket_name
  kms_key_arn     = var.kms_key_arn
}

module "config_org" {
  source = "../../modules/config-org"
}

output "trail_arn"      { value = module.org_trail.trail_arn }
output "aggregator_arn" { value = module.config_org.aggregator_arn }
