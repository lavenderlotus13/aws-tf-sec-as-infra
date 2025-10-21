# REPO_STRUCTURE.md
Static repository documentation tree — pure Markdown (no links), with descriptions for every directory and key file.

## Legend
- 📁 Directory
- 📄 File

```text
aws-security-enterprise-terraform/                     # Root of the security-as-infrastructure repo
├── 📄 .gitignore                                      # Standard ignores, TF state, lock files, plans, env files
├── 📄 README.md                                       # Root overview, run order, and ADR-style architecture summary
├── 📄 ARCHITECTURE.md                                 # Linked (GitHub-ready) architecture tree without ADRs
├── 📄 ARCHITECTURE_ADR.md                             # ADRs per major layer (org-root, security, envs, modules, workloads)
├── 📄 ARCHITECTURE_ADR_DECISIONS.md                   # ADRs per specific decision (DA per service, SOC vs Audit, etc.)
│
├── 📁 org-root                                        # Management account: Organizations, OUs, SCPs, bootstrap
│   ├── 📄 README.md                                   # Purpose, responsibilities, and bootstrap runbook
│   ├── 📄 organizations.tf                            # Provider and (optional) OU definitions
│   ├── 📁 org-bootstrap                               # Bootstrap unit: delegated admin designation per service
│   │   └── 📄 main.tf                                 # Variables and outputs for DA mapping (placeholder)
│   └── 📁 scps                                        # Service Control Policies library & attachments
│       ├── 📄 attach.tf                               # Attaches curated SCPs to OUs/roots
│       └── 📁 library                                 # Versioned SCP JSON documents
│           └── 📄 deny_disable_security_services.json # Deny disabling CloudTrail/Config/SH/GD; block DA deregistration
│
├── 📁 security                                        # Security OU: delegated admins, Sec-Ops, Log Archive
│   ├── 📄 README.md                                   # Security account roles and composition approach
│   ├── 📁 sh-admin                                    # Security Hub delegated admin account
│   │   ├── 📄 README.md                               # Responsibilities, inputs/outputs, ADR notes
│   │   ├── 📄 providers.tf                            # Default + regional alias providers for multi-region enablement
│   │   ├── 📄 securityhub-admin.tf                    # Org auto-enroll, standards toggles (skeleton)
│   │   ├── 📄 findings-forwarding.tf                  # EventBridge rule → Sec-Ops bus (skeleton)
│   │   └── 📄 outputs.tf                              # Outputs (enabled regions, etc.)
│   ├── 📁 gd-admin                                    # GuardDuty delegated admin account
│   │   ├── 📄 README.md                               # Purpose and usage
│   │   └── 📄 main.tf                                 # Detectors per region + org auto-enable (skeleton)
│   ├── 📁 macie-admin                                 # Macie delegated admin account
│   │   ├── 📄 README.md                               # Purpose and usage
│   │   └── 📄 main.tf                                 # Macie org settings (skeleton)
│   ├── 📁 inspector-admin                             # Inspector delegated admin account
│   │   ├── 📄 README.md                               # Purpose and usage
│   │   └── 📄 main.tf                                 # Inspector org enablement (skeleton)
│   ├── 📁 detective-admin                             # Detective delegated admin account
│   │   ├── 📄 README.md                               # Purpose and usage
│   │   └── 📄 main.tf                                 # Detective org graph (skeleton)
│   ├── 📁 access-analyzer-admin                       # IAM Access Analyzer delegated admin account
│   │   ├── 📄 README.md                               # Purpose and usage
│   │   └── 📄 main.tf                                 # Organization analyzers (skeleton)
│   ├── 📁 sec-ops                                     # SOC sink account: EventBridge bus & targets
│   │   ├── 📄 README.md                               # Operational sink rationale and controls
│   │   ├── 📄 event-bus.tf                            # Custom bus + resource policy (allow PutEvents from admins)
│   │   ├── 📄 targets.tf                              # Downstream targets (SQS/Kinesis/Lambda/SIEM) — placeholder
│   │   └── 📄 dqlogs.tf                               # Dead-letter queues/access logs — placeholder
│   └── 📁 audit                                       # Log Archive (immutable evidence)
│       ├── 📄 README.md                               # Evidence store hardening and runbook
│       ├── 📄 cloudtrail-org.tf                       # Org-level, multi-region CloudTrail (module placeholder)
│       ├── 📄 s3-object-lock.tf                       # S3 Object Lock bucket and KMS (to be created with Object Lock)
│       └── 📄 config-aggregator.tf                    # AWS Config org aggregator and delivery channel
│
├── 📁 workloads                                       # Application/business accounts (guardrail consumers)
│   └── 📄 README.md                                   # Scope, responsibilities, and non-goals for app teams
│
├── 📁 envs                                            # Terraform execution roots (state/provider isolation per account)
│   ├── 📄 README.md                                   # Philosophy: one root per account
│   ├── 📁 management                                  # Management account root
│   │   ├── 📄 README.md                               # Operator checklist for bootstrap root
│   │   ├── 📄 backend.tf                              # Remote state (S3+DDB) for management root
│   │   ├── 📄 providers.tf                            # Provider for management account role
│   │   └── 📄 main.tf                                 # Calls org bootstrap (placeholder for safety)
│   ├── 📁 sh-admin                                    # Security Hub admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state for SH admin
│   │   ├── 📄 providers.tf                            # Default + us-east-1/us-west-2 alias providers
│   │   └── 📄 main.tf                                 # Calls securityhub-admin module + forwarding wiring
│   ├── 📁 gd-admin                                    # GuardDuty admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state for GD admin
│   │   ├── 📄 providers.tf                            # Default + region aliases for detectors
│   │   └── 📄 main.tf                                 # Calls guardduty-admin module (detectors + org config)
│   ├── 📁 macie-admin                                 # Macie admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state
│   │   ├── 📄 providers.tf                            # Provider setup
│   │   └── 📄 main.tf                                 # Calls macie-admin module (placeholder)
│   ├── 📁 inspector-admin                             # Inspector admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state
│   │   ├── 📄 providers.tf                            # Provider setup
│   │   └── 📄 main.tf                                 # Calls inspector-admin module (placeholder)
│   ├── 📁 detective-admin                             # Detective admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state
│   │   ├── 📄 providers.tf                            # Provider setup
│   │   └── 📄 main.tf                                 # Calls detective-admin module (placeholder)
│   ├── 📁 access-analyzer-admin                       # IAM Access Analyzer admin root
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state
│   │   ├── 📄 providers.tf                            # Provider setup
│   │   └── 📄 main.tf                                 # Calls access-analyzer-admin module (placeholder)
│   ├── 📁 sec-ops                                     # Sec-Ops root (event bus & targets)
│   │   ├── 📄 README.md                               # Operator checklist
│   │   ├── 📄 backend.tf                              # Remote state
│   │   ├── 📄 providers.tf                            # Provider setup
│   │   └── 📄 main.tf                                 # Calls EventBridge cross-account module, outputs bus ARN
│   └── 📁 log-archive                                 # Log Archive root (org trail + config)
│       ├── 📄 README.md                               # Operator checklist
│       ├── 📄 backend.tf                              # Remote state
│       ├── 📄 providers.tf                            # Provider setup
│       └── 📄 main.tf                                 # Calls org CloudTrail and Config aggregator modules
│
└── 📁 modules                                         # Small, composable building blocks
    ├── 📄 README.md                                   # Module philosophy and usage guidelines
    ├── 📁 organizations-bootstrap                     # Org bootstrap (DA designation)
    │   ├── 📄 main.tf                                 # Module skeleton (replace with real resources)
    │   ├── 📄 variables.tf                            # Strict inputs for org bootstrap
    │   └── 📄 outputs.tf                              # Stable outputs (e.g., admin mapping)
    ├── 📁 securityhub-admin                           # Security Hub (delegated admin) org configuration
    │   ├── 📄 main.tf                                 # Enable per region, auto-enroll, standards, optional forwarding
    │   ├── 📄 variables.tf                            # Regions, flags, bus ARN
    │   └── 📄 outputs.tf                              # Enabled regions, auto-enroll status
    ├── 📁 guardduty-admin                             # GuardDuty (delegated admin) org configuration
    │   ├── 📄 main.tf                                 # Detectors per region + org auto-enable
    │   ├── 📄 variables.tf                            # Regions, home region, auto_enable
    │   └── 📄 outputs.tf                              # Detector IDs per region
    ├── 📁 macie-admin                                 # Macie admin module (placeholder)
    │   ├── 📄 main.tf                                 # Future: org Macie enablement
    │   ├── 📄 variables.tf                            # Inputs placeholder
    │   └── 📄 outputs.tf                              # Outputs placeholder
    ├── 📁 inspector-admin                             # Inspector admin module (placeholder)
    │   ├── 📄 main.tf                                 # Future: Inspector coverage config
    │   ├── 📄 variables.tf                            # Inputs placeholder
    │   └── 📄 outputs.tf                              # Outputs placeholder
    ├── 📁 access-analyzer-admin                       # IAM Access Analyzer admin module (placeholder)
    │   ├── 📄 main.tf                                 # Future: org analyzers
    │   ├── 📄 variables.tf                            # Inputs placeholder
    │   └── 📄 outputs.tf                              # Outputs placeholder
    ├── 📁 detective-admin                             # Detective admin module (placeholder)
    │   ├── 📄 main.tf                                 # Future: Detective graph + members
    │   ├── 📄 variables.tf                            # Inputs placeholder
    │   └── 📄 outputs.tf                              # Outputs placeholder
    ├── 📁 cloudtrail-org                              # Organization-level CloudTrail module
    │   ├── 📄 main.tf                                 # Org multi-region trail using existing Object Lock bucket + KMS
    │   ├── 📄 variables.tf                            # Trail name, bucket, KMS, flags
    │   └── 📄 outputs.tf                              # Trail ARN
    ├── 📁 config-org                                  # AWS Config organization aggregator
    │   ├── 📄 main.tf                                 # Aggregates all regions/org accounts
    │   ├── 📄 variables.tf                            # Aggregator name
    │   └── 📄 outputs.tf                              # Aggregator ARN
    ├── 📁 security-lake-admin                         # Security Lake admin (placeholder)
    │   ├── 📄 main.tf                                 # Future: sources + rollup configurations
    │   ├── 📄 variables.tf                            # Inputs placeholder
    │   └── 📄 outputs.tf                              # Outputs placeholder
    └── 📁 eventbridge-cross-account                   # Cross-account EventBridge bus policy
        ├── 📄 main.tf                                 # Bus + resource policy allowing approved accounts to PutEvents
        ├── 📄 variables.tf                            # Bus name, allowed principal accounts
        └── 📄 outputs.tf                              # Event bus ARN
```
