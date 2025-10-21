variable "target_ids" { type = list(string), default = [] }
resource "aws_organizations_policy" "deny_disable_security_services" {
  name        = "Deny-Disable-Core-Security-Services"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/library/deny_disable_security_services.json")
}
resource "aws_organizations_policy_attachment" "attach" {
  for_each  = toset(var.target_ids)
  policy_id = aws_organizations_policy.deny_disable_security_services.id
  target_id = each.value
}
