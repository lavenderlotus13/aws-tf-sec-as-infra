variable "regions" { type = list(string) }
variable "home_region" { type = string }
variable "enable_auto_enroll_new_accounts" { type = bool, default = true }
variable "enable_fsbp" { type = bool, default = true }
variable "enable_cis"  { type = bool, default = false }
variable "forward_to_event_bus_arn" { type = string, default = "" } # optional
