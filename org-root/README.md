# org-root — AWS Organizations & Bootstrap

## Mission
Manage the **organization**: OUs, curated SCPs, and per-service **delegated admin designation**. All operations run from the **management account** only.

## Components
- `organizations.tf` — Providers and (optionally) OU definitions.
- `scps/` — Curated policy library + attachments.
- `org-bootstrap/` — Delegated admin designation per security service.

## Runbook
1) Configure provider to assume the **management account** role.
2) Attach SCPs to roots/OUs (stage via non-prod first).
3) Delegate admins for SH/GD/Macie/Inspector/Detective/IAA.


## ADR: Bootstrap from Management, Operate from Delegated Admins

**Decision**  
Use the management account **only** for trusted access and delegated admin designation.

**Alternatives Considered**  
- Operating Security Hub and others from management account

**Rationale**  
Reduces blast radius; aligns with AWS guidance; separates billing/governance from security operations.

**Consequences**  
- Requires switching to delegated admin roots for service ops


## Inputs/Outputs
- Inputs: OU/root IDs, policy JSON, admin account IDs.- Outputs: Policy ARNs, DA mapping, attachments audit.
