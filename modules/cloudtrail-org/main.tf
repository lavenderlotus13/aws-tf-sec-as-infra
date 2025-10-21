terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

resource "aws_cloudtrail" "org" {
  name                          = var.trail_name
  s3_bucket_name                = var.log_bucket_name
  kms_key_id                    = var.kms_key_arn
  is_multi_region_trail         = var.is_multi_region
  include_global_service_events = var.include_global
  is_organization_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}

output "trail_arn" { value = aws_cloudtrail.org.arn }
