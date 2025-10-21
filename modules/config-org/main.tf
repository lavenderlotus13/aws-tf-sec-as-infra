terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

resource "aws_config_configuration_aggregator" "org" {
  name = var.aggregator_name
  organization_aggregation_source {
    all_regions = true
  }
}

output "aggregator_arn" { value = aws_config_configuration_aggregator.org.arn }
