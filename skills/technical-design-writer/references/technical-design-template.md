# Technical Design Template

Use this template for human-facing technical design documents. Keep the writing reviewable by a human decision maker; do not turn it into an execution checklist.

````md
# <Feature / Change Name> Technical Design

## Summary
<One short paragraph: what problem this solves, the recommended direction, and the expected outcome.>

## Background / Context
- <Business or product context>
- <Relevant user requirement / PRD / issue / blueprint>
- <Existing repo reality that matters for this design>

## Goals
- <Goal 1 with human-verifiable success criteria>
- <Goal 2>

## Non-goals
- <Explicitly out-of-scope behavior, platform, migration, or feature>

## Current State
- <Current architecture / module behavior>
- <Important files, modules, APIs, data structures, jobs, configs, or flows>
- <Known limitations or constraints>

## Proposed Design
### Architecture
<Describe the recommended architecture or flow. Use diagrams if helpful.>

### Key Decisions
- <Decision>: <rationale>
- <Decision>: <rationale>

### Data / API / Interface Changes
- <Contract-level change, if any>
- <Compatibility note, if any>

## Alternatives Considered
- <Alternative A>: <why not chosen>
- <Alternative B>: <why not chosen>

## Impact and Compatibility
- <User-facing impact>
- <Backward compatibility / migration impact>
- <Operational, performance, security, or privacy impact>

## Risks and Open Questions
- `Risk`: <risk and mitigation>
- `Assumption`: <assumption currently used by the design>
- `TBD`: <decision or information that still needs confirmation>

## Validation Strategy
- <How humans and agents should know the design worked>
- <High-level tests, demos, observability, rollout, or rollback approach>

## Next Step: Implementation Plan
If the design is accepted, generate `Implementation Plan.md` with `implementation-plan-writer`.
The Implementation Plan is for Agent execution and must contain concrete steps, guardrails, file/module targets, and validation commands.
````
