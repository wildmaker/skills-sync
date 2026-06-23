# Implementation Plan Template

Use this template for Agent-facing `Implementation Plan.md` files. The reader is an implementation agent that needs clear execution instructions, not a long design debate.

````md
# Implementation Plan: <Feature / Epic Name>

## Agent Objective
<One paragraph telling the implementation agent exactly what to deliver and how success will be judged.>

## Source Inputs
- Design / Blueprint / PRD: `<path or summary>`
- Issue / discussion: `<path, URL, or N/A>`
- Base branch / target branch: `<branch info or TBD>`
- Constraints: <time, compatibility, security, performance, dependency, or scope constraints>

## Scope
- <In-scope capability or behavior>
- <In-scope module / surface>

## Non-goals
- <Explicitly out of scope>
- <Behavior the agent must not add>

## Repo Context
### Start Here
- `<path>`: <why this matters>
- `<path>`: <why this matters>

### Existing Contracts
- <API, data model, state flow, CLI, event, config, or persistence contract>

### Reuse / Constraints
- <Existing helper, pattern, test utility, component, workflow, or convention to reuse>
- <Constraint the agent must respect>

## Execution Strategy
<Short summary of the implementation order. Keep rationale minimal; link back to the technical design for deep reasoning.>

## Phased Implementation Plan
### Phase 1: <Name>
Objective: <phase outcome>

Steps:
1. <Concrete action tied to module/file/interface>
2. <Concrete action tied to module/file/interface>

Validation:
- <Command, test, or manual check>

Exit criteria:
- <Observable condition that proves this phase is complete>

### Phase 2: <Name>
Objective: <phase outcome>

Steps:
1. <Concrete action tied to module/file/interface>
2. <Concrete action tied to module/file/interface>

Validation:
- <Command, test, or manual check>

Exit criteria:
- <Observable condition that proves this phase is complete>

## Backlog Draft
### <stable-spec-slug> [P0|P1|P2|P3]
- title: <human-readable title>
- expected: <verifiable outcome>
- acceptance:
  - <acceptance point>
  - <acceptance point>
- dependencies: <none or item slug / external dependency>
- risk: <risk or TBD>

### <stable-spec-slug-2> [P0|P1|P2|P3]
- title: <human-readable title>
- expected: <verifiable outcome>
- acceptance:
  - <acceptance point>
- dependencies: <none or item slug / external dependency>
- risk: <risk or TBD>

## Validation Plan
- Static checks: `<command or TBD>`
- Unit tests: `<command/path or TBD>`
- Integration/E2E tests: `<command/path or TBD>`
- Build: `<command or TBD>`
- Manual/demo verification: <steps or TBD>

## Demo Plan
- Value goal: <core user/business scenario this demo proves, or N/A for narrow internal changes>
- Preconditions: <env, services, accounts, data, feature flags, or TBD>
- How to run: <install/build/start commands with working directories, or TBD>
- Demo steps:
  1. <user-visible or CLI step>
  2. <expected result>
- Fallback evidence: <screenshots, logs, test output, recording, or TBD>

## Guardrails
### Must Follow
- <Boundary, contract, or sequence that must not be violated>
- <Compatibility/security/performance constraint>

### Flexible
- <Implementation detail that can adapt to repo reality>

### Forbidden
- <Scope expansion or risky shortcut the agent must not take>

## TBD / Assumptions / Risks
- `Assumption`: <assumption and conservative fallback>
- `TBD`: <missing information and how to proceed safely for now>
- `Risk`: <risk and mitigation>

## Definition of Done
- <All in-scope behavior implemented>
- <Backlog items are independently verifiable>
- <Validation plan completed or blocked items documented with evidence>
- <No out-of-scope behavior added>
````
