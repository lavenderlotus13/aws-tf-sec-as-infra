# envs — Terraform Roots per Account

## Purpose
Provide isolated **execution roots** per account with dedicated remote state and assume-role providers.

## Pattern
- Each subdirectory maps to one AWS account.
- CI pipelines run `plan/apply` per root; no cross-account state.


## ADR: One Root per Account

**Decision**  
Operate each account from its own root and backend.

**Alternatives Considered**  
- Single cross-account root

**Rationale**  
Clear RBAC, safer changes, better audit.

**Consequences**  
- Slight increase in pipeline count; manageable with templates

