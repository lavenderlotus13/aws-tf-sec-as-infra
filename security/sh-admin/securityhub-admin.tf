variable "enable_auto_enroll_new_accounts" { type = bool, default = true }
variable "standards" {
  type = object({ aws_foundational_security_best_practices = optional(bool, true), cis_1_2 = optional(bool, false) })
  default = {}
}
output "securityhub_admin_enabled" { value = true }
