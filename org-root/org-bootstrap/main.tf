terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
provider "aws" { region = var.home_region }
variable "home_region" { type = string, default = "us-east-1" }
variable "sh_admin_account_id" { type = string }
variable "gd_admin_account_id" { type = string }
variable "macie_admin_account_id" { type = string }
variable "inspector_admin_account_id" { type = string }
variable "detective_admin_account_id" { type = string }
variable "access_analyzer_admin_account_id" { type = string }
# Delegate admins here with aws_organizations_delegated_administrator (service principals).
output "delegated_admins" {
  value = {
    securityhub     = var.sh_admin_account_id
    guardduty       = var.gd_admin_account_id
    macie           = var.macie_admin_account_id
    inspector       = var.inspector_admin_account_id
    detective       = var.detective_admin_account_id
    access_analyzer = var.access_analyzer_admin_account_id
  }
}
