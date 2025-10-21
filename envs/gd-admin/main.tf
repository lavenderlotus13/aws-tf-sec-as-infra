variable "regions"     { type = list(string), default = ["us-east-1","us-west-2"] }
variable "home_region" { type = string, default = "us-east-1" }

module "guardduty" {
  source  = "../../modules/guardduty-admin"
  regions = var.regions
  home_region = var.home_region

  providers = {
    aws.home = aws
    aws.alias["us-east-1"] = aws.use1
    aws.alias["us-west-2"] = aws.usw2
  }
}

output "detector_ids" { value = module.guardduty.detector_ids }
