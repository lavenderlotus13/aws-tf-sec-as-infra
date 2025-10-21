# security — Security OU Accounts

## Mission
Host the **control plane** for enterprise security services using **per-service delegated admin** accounts, plus **Sec-Ops** and **Log Archive** accounts.

## Accounts
- `sh-admin/` — Security Hub delegated admin (standards, central config, forwarding).
- `gd-admin/`, `macie-admin/`, `inspector-admin/`, `detective-admin/`, `access-analyzer-admin/` — service admins.
- `sec-ops/` — SOC event bus & targets.
- `audit/` — Org trails, Object Lock, Config aggregator.

## Execution
Each account is applied from its `envs/<account>/` root with separate state and provider.


## ADR: Per-Service Admin Composition

**Decision**  
Compose service admin modules per account; keep responsibilities narrowly scoped.

**Alternatives Considered**  
- Aggregating all services into one module/account

**Rationale**  
Matches AWS service boundaries; safer change management.

**Consequences**  
- Slightly more coordination; gains in safety outweigh cost

