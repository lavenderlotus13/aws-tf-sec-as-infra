variable "regions"       { type = list(string), default = ["us-east-1","us-west-2"] }
variable "home_region"   { type = string, default = "us-east-1" }
variable "sec_ops_bus_arn" { type = string, default = "arn:aws:events:us-east-1:999999999999:event-bus/security-findings" } # REPLACE

# Provider aliases must exist in providers.tf (use1/usw2 examples already present).
module "securityhub" {
  source  = "../../modules/securityhub-admin"
  regions = var.regions
  home_region = var.home_region
  enable_auto_enroll_new_accounts = true
  enable_fsbp = true
  enable_cis  = false
  forward_to_event_bus_arn = var.sec_ops_bus_arn

  providers = {
    aws.home = aws
    aws.alias["us-east-1"] = aws.use1
    aws.alias["us-west-2"] = aws.usw2
  }
}

output "securityhub_regions" { value = module.securityhub.enabled_regions }
