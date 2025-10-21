# BOOTSTRAP: Remote State + First Run

This guide provisions a **remote Terraform state backend** (S3 + DynamoDB) and shows how to wire
each `envs/*` root to that backend.

## 1) Provision the Backend (S3 + DynamoDB)

Edit variables in `bootstrap/backend/terraform.tfvars` and then run:

```bash
cd bootstrap/backend
terraform init
terraform apply
```

Outputs will include:
- `state_bucket_name`
- `lock_table_name`

## 2) Wire the Backends in `envs/*/backend.tf`

Replace placeholders in each `envs/*/backend.tf` with the values from step 1, e.g.:

```hcl
terraform {
  backend "s3" {
    bucket         = "YOUR-STATE-BUCKET"
    key            = "aws-security-enterprise/management/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "YOUR-LOCK-TABLE"
    encrypt        = true
  }
}
```

> Tip: Keep the `key` paths unique per account/root to ensure isolated state.

## 3) Configure Providers (Assume-Role)

In each `envs/*/providers.tf`, set the appropriate assume-role for the target account.

```hcl
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/TerraformExecution"
  }
}
```

## 4) Run Order

1. `envs/management` — Organizations bootstrap (delegated admins, SCPs).  
2. `envs/sh-admin` — Security Hub org enablement.  
3. Other service admins — GuardDuty, Macie, Inspector, Detective, Access Analyzer.  
4. `envs/sec-ops` — Event bus and targets.  
5. `envs/log-archive` — Organization CloudTrail and Config aggregator.

## 5) Security Notes

- Enable MFA and short-lived credentials for all human access.
- Never grant `AdministratorAccess` to automation roles.
- Use private endpoints for S3 and DynamoDB when running from restricted networks.
