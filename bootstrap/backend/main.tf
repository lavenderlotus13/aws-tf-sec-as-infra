locals {
  sse_rule = var.kms_sse_algorithm == "aws:kms" ? [{
    apply_server_side_encryption_by_default = {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = true
  }] : [{
    apply_server_side_encryption_by_default = {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }]
}

resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_sse_algorithm
      kms_master_key_id = var.kms_sse_algorithm == "aws:kms" ? var.kms_key_id : null
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "deny_insecure_transport" {
  bucket = aws_s3_bucket.state.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid      = "DenyInsecureTransport",
      Effect   = "Deny",
      Principal= "*",
      Action   = "s3:*",
      Resource = [
        aws_s3_bucket.state.arn,
        "${aws_s3_bucket.state.arn}/*"
      ],
      Condition = {
        Bool = { "aws:SecureTransport" = "false" }
      }
    }]
  })
}

resource "aws_dynamodb_table" "locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery { enabled = true }
}

output "state_bucket_name" { value = aws_s3_bucket.state.bucket }
output "lock_table_name"  { value = aws_dynamodb_table.locks.name }
