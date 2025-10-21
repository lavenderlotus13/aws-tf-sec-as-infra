# Sec-Ops (SOC) Account

## Purpose
Centralize **detection and response** using EventBridge. Accept only events from approved delegated admin accounts and route to queues/streams/functions for SOC tooling.

## Responsibilities
- EventBridge **custom bus** with strict resource policy.
- Targets for ingestion, analytics, and automation; DLQs/logging.
- Optional: Security Lake or external SIEM integrations.

## Inputs/Outputs
- Inputs: allowed principals, region(s), target ARNs.- Outputs: bus ARN, target ARNs, policy IDs.


## ADR: Operational Sink Separate from Evidence Store

**Decision**  
Keep SOC pipelines independent from immutable audit logging.

**Alternatives Considered**  
- Merge SOC and audit into one account

**Rationale**  
Protects evidentiary integrity while enabling agile SOC changes.

**Consequences**  
- Slight account overhead; large safety gain

