variable "sh_admin_account_id" { type = string, default = "111111111111" } # REPLACE
variable "gd_admin_account_id" { type = string, default = "222222222222" } # REPLACE

module "event_bus" {
  source = "../../modules/eventbridge-cross-account"
  allowed_principal_accounts = [var.sh_admin_account_id, var.gd_admin_account_id]
  bus_name = "security-findings"
}

output "event_bus_arn" { value = module.event_bus.event_bus_arn }
