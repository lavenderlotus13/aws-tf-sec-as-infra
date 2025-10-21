# Log Archive (Audit) Account

## Purpose
Provide **immutable logging** (CloudTrail, Config) with **S3 Object Lock** and minimal human access for forensics and audit.

## Responsibilities
- Organization-wide CloudTrail (multi-region) → S3 (Object Lock) + KMS.- AWS Config organization aggregator + delivery.- Strict bucket/KMS policies; private endpoints; SCP protections.

## Inputs/Outputs
- Inputs: bucket names, KMS settings, trail names.- Outputs: trail/bucket/KMS/aggregator ARNs.


## ADR: Immutable Evidence

**Decision**  
Configure WORM and deny destructive actions and retention changes.

**Alternatives Considered**  
- Mutable storage for convenience

**Rationale**  
Meets forensic standards and reduces insider risk.

**Consequences**  
- Requires lifecycle planning and tested access paths

