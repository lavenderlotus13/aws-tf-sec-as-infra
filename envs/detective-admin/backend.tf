terraform {
  backend "s3" {
    bucket         = "REPLACE-ME-tfstate-bucket"
    key            = "aws-security-enterprise/detective-admin/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE-ME-tf-locks"
    encrypt        = true
  }
}
