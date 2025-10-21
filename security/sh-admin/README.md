# Security Hub Delegated Admin

## Purpose
Enable Security Hub org-wide, configure central policies/standards, and forward findings to Sec-Ops.

## Responsibilities
- Execute from `envs/sh-admin/` root with least-privilege assume-role.
- Apply in explicit **regions** via provider aliases.
- Maintain idempotent org settings: current members + auto-enroll for new accounts.

## Inputs
- `regions` list; `home_region` string
- Service-specific toggles (e.g., standards for Security Hub)

## Outputs
- Admin/configuration resource ARNs
- Coverage audit (regions/members)
- Optional cross-account destinations (e.g., Sec-Ops bus ARN)


## ADR: Operate from Delegated Admin Accounts

**Decision**  
Use a dedicated admin account per service to apply org-wide settings.

**Alternatives Considered**  
- Execute from management account or from workload accounts

**Rationale**  
Reduces blast radius; mirrors AWS Organizations trust boundaries.

**Consequences**  
- More accounts to coordinate; improved safety and clarity

