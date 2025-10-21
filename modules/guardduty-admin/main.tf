terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

# Create detectors in each region
resource "aws_guardduty_detector" "this" {
  for_each = toset(var.regions)
  provider = aws.alias[each.key]
  enable   = true
}

# Organization configuration (admin account, home region)
resource "aws_guardduty_organization_configuration" "org" {
  provider = aws.home
  auto_enable = var.auto_enable
}

output "detector_ids" { value = { for r, d in aws_guardduty_detector.this : r => d.id } }

provider "aws" { alias = "home" }
