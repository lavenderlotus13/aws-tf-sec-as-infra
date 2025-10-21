terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

# Expect aliased providers in caller for each region.
# Enable Security Hub in admin account regions and configure org auto-enroll in home region.

# Enable SH in each target region
resource "aws_securityhub_account" "this" {
  for_each = toset(var.regions)
  provider = aws.alias[each.key]
}

# Auto-enroll new accounts (org setting) in home region
resource "aws_securityhub_organization_configuration" "org_cfg" {
  provider     = aws.home
  auto_enable  = var.enable_auto_enroll_new_accounts
}

# Standards per region
locals {
  fsbp_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0" # placeholder, CIS below
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  for_each    = var.enable_fsbp ? toset(var.regions) : toset([])
  provider    = aws.alias[each.key]
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "cis" {
  for_each    = var.enable_cis ? toset(var.regions) : toset([])
  provider    = aws.alias[each.key]
  # Common CIS 1.2 ARN. Verify in your region; consider parameterizing.
  standards_arn = "arn:aws:securityhub:::standards/cis-aws-foundations-benchmark/v/1.2.0"
}

# Optional forwarding to Sec-Ops bus (home region)
resource "aws_cloudwatch_event_rule" "findings" {
  count = length(var.forward_to_event_bus_arn) > 0 ? 1 : 0
  provider = aws.home
  name        = "securityhub-findings-imported"
  description = "Forward Security Hub findings to Sec-Ops bus"
  event_pattern = jsonencode({
    "source": ["aws.securityhub"],
    "detail-type": ["Security Hub Findings - Imported"]
  })
}

resource "aws_cloudwatch_event_target" "to_bus" {
  count = length(var.forward_to_event_bus_arn) > 0 ? 1 : 0
  provider = aws.home
  rule      = aws_cloudwatch_event_rule.findings[0].name
  arn       = var.forward_to_event_bus_arn
}

# Outputs
output "enabled_regions" { value = var.regions }
output "org_auto_enroll" { value = var.enable_auto_enroll_new_accounts }

# Providers map type for aliases
provider "aws" { alias = "home" }
# The caller must pass a providers map like:
# providers = {
#   aws.home  = aws
#   aws.alias["us-east-1"] = aws.use1
#   aws.alias["us-west-2"] = aws.usw2
# }
