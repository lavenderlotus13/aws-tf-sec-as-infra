terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
# Default = home region (us-east-1)
provider "aws" { region = "us-east-1" }
provider "aws" { alias = "use1", region = "us-east-1" }
provider "aws" { alias = "usw2", region = "us-west-2" }
