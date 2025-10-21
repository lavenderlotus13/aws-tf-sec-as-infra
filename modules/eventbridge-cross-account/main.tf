terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

resource "aws_cloudwatch_event_bus" "bus" {
  name = var.bus_name
}

data "aws_caller_identity" "this" {}

# Build policy allowing PutEvents from specified principals (by account ID)
locals {
  statements = [
    for acct in var.allowed_principal_accounts : {
      "Sid": "AllowPutEventsFromAccount${acct}",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${acct}:root" },
      "Action": "events:PutEvents",
      "Resource": "arn:aws:events:${data.aws_caller_identity.this.account_id}:event-bus/${var.bus_name}"
    }
  ]
}

resource "aws_cloudwatch_event_bus_policy" "policy" {
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": local.statements
  })
}

output "event_bus_arn" { value = aws_cloudwatch_event_bus.bus.arn }
