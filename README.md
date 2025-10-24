# Security-as-Infrastructure (SAI) AWS Terraform Patterns for Mature, Large Organizations

## Purpose
Production-grade, **security-as-infrastructure** blueprint for a large enterprise on AWS. Implements AWS Organizations with **per-service delegated admins**, separates **evidentiary logging** and **operational detections**, and uses **Terraform** with strong isolation.

## Scope
- Management account: organizations, OUs, curated SCPs, and **bootstrap** (trusted access + delegated admin designation).
- Per-service delegated admin accounts: **org-wide enablement** and configuration for Security Hub, GuardDuty, Macie, Inspector, Detective, IAM Access Analyzer.
- Sec-Ops account: EventBridge bus and targets for findings ingestion, correlation, and response.
- Log Archive account: Org CloudTrail, Config aggregator, **S3 Object Lock (WORM)**, for legal purposes.
- Workload accounts: application runtime; inherit guardrails; no org control-plane privileges.

## Repository Layout
- `org-root/` — Organizations, OUs, SCPs, and org bootstrap.- `security/` — Security OU accounts (delegated admins, sec-ops, log-archive).- `workloads/` — Application/business accounts.- `envs/` — Terraform **execution roots** per account (state/provider isolation).- `modules/` — Small, **composable** modules.

## Run Order
1) `envs/management` → delegate admins.  
2) `envs/sh-admin` → Security Hub org enablement + standards + forwarding.  
3) Other delegated admin envs → GuardDuty, Macie, Inspector, Detective, Access Analyzer.  
4) `envs/sec-ops` → event bus + targets.  
5) `envs/log-archive` → org CloudTrail + Object Lock + Config aggregator.

## Operating Model
- CI pipelines execute per `envs/*` root with dedicated assume-role and remote state.
- Changes are **scoped** to one account/service at a time; plans do not span accounts.
- Regions are explicit via provider aliases; region lists are inputs.


## ADR: Flat, Composable Security Service Admin Modules

**Decision**  
Keep modules **flat and per-service**. If desired, use a thin orchestration root to call them together without coupling.

**Alternatives Considered**  
- Single monolithic module for all security services

**Rationale**  
Aligns with AWS delegated admin boundaries and Terraform composition guidance; reduces blast radius and eases upgrades.

**Consequences**  
- Slightly more boilerplate; mitigated by templates and CI


## ADR: Separate Sec-Ops (SOC) and Log Archive (Audit) Accounts

**Decision**  
Operate SOC pipelines independently of immutable evidence storage.

**Alternatives Considered**  
- Combine SOC and Audit in one account

**Rationale**  
Different access patterns/retention; separation protects evidentiary integrity and reduces risk.

**Consequences**  
- Additional accounts; gains in safety and clarity justify it


## ADR: Terraform Roots per Account

**Decision**  
Create one **env root per account** with isolated state and provider.

**Alternatives Considered**  
- Cross-account single root with many providers

**Rationale**  
Improves RBAC, auditability, rollbacks, and drift repair.

**Consequences**  
- More pipelines; manageable with templates

## Next Steps
- Configure remote state buckets and DynamoDB locks.
- Create `TerraformExecution` roles with least privilege.
- Populate account IDs and regions; apply in run order above.
