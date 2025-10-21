# ARCHITECTURE_ADR_DECISIONS.md

Formal **Architecture Decision Records (ADRs)** for specific decisions in this repository.

---

## ADR-SEC-DA-001: Per‑Service Delegated Admin Accounts

**Status**: Accepted  
**Context**: AWS security services (Security Hub, GuardDuty, Macie, Inspector, Detective, IAM Access Analyzer) each expose organization controls via **delegated admin** APIs and have independent regional behavior and lifecycles.  
**Decision**: Create **one delegated admin account per security service**; configure org‑wide enablement from that account only.  
**Alternatives Considered**:
- Single “mega” security admin account for all services  
- Using the Organizations management account as admin  
**Rationale**:
- Mirrors AWS trust boundaries; simplifies least‑privilege IAM  
- Reduces blast radius and makes changes/rollbacks service‑scoped  
**Consequences**:
- More accounts to coordinate; mitigated by consistent module patterns and per‑account env roots

---

## ADR-SEC-SPLIT-002: SOC (Sec‑Ops) vs Audit (Log Archive) Separation

**Status**: Accepted  
**Context**: Operational detections need agility and frequent access; evidentiary logging requires immutability and minimal human access.  
**Decision**: Maintain **separate accounts**: `sec-ops` (EventBridge bus, pipelines) and `audit` (org CloudTrail, S3 Object Lock, Config aggregator).  
**Alternatives**:
- Combine SOC and Audit into one account  
**Rationale**:
- Protects evidence integrity; enables independent retention/cost models  
**Consequences**:
- Slightly larger account footprint for materially better safety

---

## ADR-TF-MODS-003: Flat, Composable Terraform Modules (No Monolith)

**Status**: Accepted  
**Context**: Large, monolithic modules impede testing, upgrades, and drift repair.  
**Decision**: Keep modules **small and per‑service** (e.g., `securityhub-admin`, `guardduty-admin`); optional thin orchestration at the root.  
**Alternatives**:
- Single monolithic “security” module managing all services  
**Rationale**:
- Improves testability, versioning, and change isolation; aligns with service boundaries  
**Consequences**:
- Slightly more wiring; outweighed by safety and clarity

---

## ADR-TF-ENVS-004: One Terraform Root per Account (State Isolation)

**Status**: Accepted  
**Context**: Cross‑account roots risk accidental changes and tangled state.  
**Decision**: Create **one `envs/*` root per AWS account** with its own backend (S3+DynamoDB) and assume‑role provider.  
**Alternatives**:
- Single root spanning multiple accounts via multiple providers  
**Rationale**:
- Clear RBAC, smaller blast radius, easier drift repair and rollbacks  
**Consequences**:
- More pipelines; templated CI makes this manageable

---

## ADR-ORG-BOOT-005: Management Account Used for Bootstrap Only

**Status**: Accepted  
**Context**: Organizations operations (trusted access, delegated admin designation) must be done by the **management account**. Day‑to‑day service configuration should not run here.  
**Decision**: Use `org-root/` (via `envs/management/`) **only** for bootstrap; all service configuration runs from delegated admin accounts.  
**Alternatives**:
- Operate Security Hub/GuardDuty from management account  
**Rationale**:
- Minimizes risk; separates governance/billing from security operations  
**Consequences**:
- Requires switching to DA roots for service ops (expected)

---

## ADR-REGIONS-006: Explicit Multi‑Region Management via Provider Aliases

**Status**: Accepted  
**Context**: Security services are regional; coverage gaps are common when regions are implicit.  
**Decision**: Manage a curated list of regions via **explicit provider aliases** and `var.regions`.  
**Alternatives**:
- Rely on defaults/implicit region handling  
**Rationale**:
- Deterministic behavior; easy to audit/extend per region  
**Consequences**:
- Slight provider boilerplate; adds clarity and safety

---

## ADR-EVENTS-007: Cross‑Account EventBridge Bus for Findings

**Status**: Accepted  
**Context**: Centralizing detections requires a controlled ingress surface for events from multiple admin accounts.  
**Decision**: Create a **custom EventBridge bus** in `sec-ops` with a **resource policy** allowing only approved admin accounts to `PutEvents`; forward Security Hub findings via regional rules.  
**Alternatives**:
- Per‑account ingestion endpoints scattered across targets  
**Rationale**:
- Single, auditable ingress point with tight access; flexible downstream targets  
**Consequences**:
- Requires disciplined policy management and testing

---

## ADR-LOGS-008: S3 Object Lock for Audit Evidence

**Status**: Accepted  
**Context**: Audit logs must be immutable for forensics and compliance.  
**Decision**: Use **S3 Object Lock (WORM)** with strict bucket/KMS policies in the `audit` account; prohibit deletions and retention changes via SCP/IAM.  
**Alternatives**:
- Mutable storage or shared buckets/keys  
**Rationale**:
- Ensures evidentiary quality and reduces insider/misconfiguration risk  
**Consequences**:
- Requires lifecycle/retention planning and tested access paths

---

## ADR-ENROLL-009: Auto‑Enroll New Org Accounts in Security Services

**Status**: Accepted  
**Context**: Manual onboarding leads to drift and blind spots.  
**Decision**: Enable **auto‑enroll** for Security Hub and GuardDuty from their delegated admin accounts; periodically audit membership.  
**Alternatives**:
- Manual onboarding per account  
**Rationale**:
- Reduces operational toil; ensures baseline coverage  
**Consequences**:
- Requires guardrails to prevent accidental unenrollment

---

## ADR-BOUND-010: No Workloads in Delegated Admin Accounts

**Status**: Accepted  
**Context**: Service admin accounts should have minimal surface and predictable IAM.  
**Decision**: Prohibit application workloads, CI/CD, and unrelated services from DA accounts.  
**Alternatives**:
- Mixed‑use admin accounts  
**Rationale**:
- Reduces attack surface and operational noise  
**Consequences**:
- Requires separate accounts for tooling/workloads (already provided)

---

## ADR-KMS-011: Key Segregation by Domain

**Status**: Accepted  
**Context**: Broad KMS policies increase risk and complicate audits.  
**Decision**: Use **dedicated CMKs per domain** (logs, findings, ci, app data) with tight key policies and no wildcard principals.  
**Alternatives**:
- Shared keys across domains  
**Rationale**:
- Stronger least‑privilege and clearer audit trails  
**Consequences**:
- Slight increase in key management; improved security posture

---

## ADR-SCP-012: Curated Guardrails (Deny Disable & Org Integrity)

**Status**: Accepted  
**Context**: Accidental or malicious deconfiguration can remove critical visibility.  
**Decision**: Maintain curated SCPs that deny disabling CloudTrail/Config/Security Hub/GuardDuty, and deny `organizations:DeregisterDelegatedAdministrator` except from pipeline roles.  
**Alternatives**:
- Generic SCPs or no guardrails  
**Rationale**:
- Prevents catastrophic posture regressions  
**Consequences**:
- Requires careful staging and exceptions (e.g., break‑glass)

---

## ADR-FWD-013: Findings Forwarding Pattern (SH → Sec‑Ops)

**Status**: Accepted  
**Context**: SOC needs near real‑time findings across regions/accounts.  
**Decision**: Use Security Hub **Imported Findings** event pattern to forward to Sec‑Ops bus; apply per region from `sh-admin`.  
**Alternatives**:
- Polling APIs or custom collectors per account  
**Rationale**:
- Native, low‑latency, scalable; simplifies ingestion  
**Consequences**:
- Requires parity in each managed region

---

## ADR-OWN-014: Clear Ownership & Pipelines per Account

**Status**: Accepted  
**Context**: Ambiguous ownership slows response and complicates audits.  
**Decision**: Each account has its own **env root**, state, and CI pipeline; security engineering owns `org-root/` & `security/*`, app teams own `workloads/*`.  
**Alternatives**:
- Centralized mega‑pipeline or mixed ownership  
**Rationale**:
- Faster, safer changes with clear auditability  
**Consequences**:
- More, smaller pipelines (templated to reduce effort)

