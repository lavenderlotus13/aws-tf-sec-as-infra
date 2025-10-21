terraform { required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } } }
provider "aws" { region = var.home_region }
variable "home_region" { type = string, default = "us-east-1" }
variable "regions" { type = list(string), default = ["us-east-1","us-west-2"] }
# TODO: Add gd-admin org resources here.
