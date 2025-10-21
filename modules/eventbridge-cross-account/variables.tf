variable "bus_name" { type = string, default = "security-findings" }
variable "allowed_principal_accounts" { type = list(string) } # account IDs allowed to PutEvents
