# Workloads — Application Accounts

## Purpose
Run application and data workloads subject to central guardrails; **do not** manage org-wide security services.

## Responsibilities
- Deploy application stacks and emit telemetry/security signals.
- Respect SCPs; no ability to disable core security services.


## ADR: Controller vs. Consumer

**Decision**  
Workloads consume guardrails; security admin accounts control them.

**Alternatives Considered**  
- Allow workloads to disable central controls

**Rationale**  
Preserves global security posture.

**Consequences**  
- Requires clear runbooks and SSO role definitions

