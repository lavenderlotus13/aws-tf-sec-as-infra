# modules — Composable Security Service Building Blocks

## Purpose
Encapsulate narrowly-scoped infrastructure for reuse across accounts/orgs.

## Guidelines
- Single responsibility; explicit inputs/outputs.
- No hidden cross-account data sources.
- Idempotent and safe to re-apply.

## Typical Modules
- `securityhub-admin/`, `guardduty-admin/`, `macie-admin/`, `inspector-admin/`, `detective-admin/`, `access-analyzer-admin/`
- `cloudtrail-org/`, `config-org/`, `security-lake-admin/`, `eventbridge-cross-account/`


## ADR: Flat Modules with Optional Orchestration

**Decision**  
Keep modules per service; use a thin root to orchestrate if needed.

**Alternatives Considered**  
- Monolithic module covering all services

**Rationale**  
Improves testability and upgrade safety while reflecting AWS service boundaries.

**Consequences**  
- Slightly more wiring; pays off in safety and clarity

