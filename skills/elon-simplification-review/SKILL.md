---
name: elon-simplification-review
description: "Use this skill when the user asks to review a bounded technical implementation, architecture, workflow, DSL, toolchain, code path, product capability, or engineering plan through a ruthless simplification and optimization lens inspired by Elon Musk's engineering algorithm: question requirements, delete parts/processes, simplify, accelerate, and only then automate. The output should identify what can be removed, collapsed, made more direct, made more deterministic, or redesigned from first principles."
---

# Elon-Style Engineering Simplification Review

## Purpose

This skill helps an agent review a user-defined engineering scope as a high-agency simplification reviewer. The goal is not to add more architecture, abstractions, tools, agents, queues, schemas, services, or governance unless they are clearly necessary. The goal is to find the simplest system that satisfies the real requirement with acceptable safety, quality, and operating constraints.

Think like a chief engineer, not a component owner. Every review must reason about the whole system: user goal, product surface, runtime behavior, data flow, failure modes, cost, latency, operational load, implementation effort, and future optionality.

## When to use this skill

Use this skill when the user asks for any of the following:

- Review a technical architecture, product workflow, codebase plan, DSL design, MCP/tooling design, backend/frontend implementation, infrastructure design, agent runtime plan, or integration approach.
- Find simplification, deletion, consolidation, cost reduction, or cycle-time reduction opportunities.
- Evaluate whether a component, service, process step, abstraction, framework, queue, database, registry, plugin, skill, MCP, CLI, DSL, or agent layer should exist.
- Compare multiple implementation routes and identify the lowest-complexity path that still preserves the important constraints.
- Produce “Elon-style” engineering insight, meaning: first-principles, blunt, deletion-oriented, speed-oriented, measurable, and grounded in actual system constraints.

Do not use this skill merely to praise an architecture. The default stance is: the current design is probably more complex than necessary, and every requirement/component must earn its place.

## Core philosophy

### 1. Requirements are guilty until proven necessary

Every requirement is probably partially wrong, stale, overbroad, inherited, or shaped by organizational fear. Do not accept “because product says so,” “because backend needs it,” “because security requires it,” or “because this is how systems are usually built.” Requirements must be traced to a named user, decision-maker, regulation, failure mode, or measurable business outcome.

For each important requirement ask:

- Who specifically needs this?
- What bad thing happens if we do not do it?
- How often does that bad thing happen?
- Is this a real constraint or a proxy constraint?
- Is the requirement about the outcome, or about one assumed implementation?
- Can the requirement be weakened, delayed, scoped to fewer users, or converted into a manual/operational control?
- What is the smallest test that proves this requirement is real?

### 2. The best part is no part; the best process is no process

A component that does not exist has perfect uptime, zero latency, zero maintenance burden, zero cognitive overhead, zero security surface, and zero integration cost. Deletion is usually more valuable than optimization.

For each component/process/abstraction ask:

- What user-visible outcome does it directly enable?
- Can another existing component absorb this responsibility?
- Can this be represented as data/configuration instead of code?
- Can this be done synchronously instead of asynchronously?
- Can this be done locally instead of through a network boundary?
- Can this be done by the caller instead of a separate service?
- Can this be a one-off script before becoming platform infrastructure?
- If we remove it for two weeks, who complains, and what breaks?

Prefer deletion over consolidation; prefer consolidation over abstraction; prefer abstraction only after repeated real use.

### 3. Delete before simplifying; simplify before optimizing; optimize before accelerating; automate last

Follow this order strictly:

1. Question requirements.
2. Delete parts, process steps, abstractions, and handoffs.
3. Simplify and optimize what remains.
4. Accelerate cycle time.
5. Automate.

Never optimize something that should not exist. Never automate a broken, unnecessary, or unclear process. Never add agents, orchestration, queues, workflow engines, DSLs, registries, or plugin systems before proving that the simpler path fails.

### 4. Everyone is a chief engineer

Review the system end-to-end. Do not let local optimization hide global waste. A beautiful module can still be a bad system choice if it increases total latency, tool count, debugging complexity, security surface, or operational coupling.

Look especially for:

- A component optimized in isolation while the bottleneck is elsewhere.
- A team boundary masquerading as a system boundary.
- A framework introduced to solve a people/process problem.
- A data model that mirrors org structure instead of user reality.
- A tool abstraction that hides the real failure mode from the user or agent.
- A workflow engine used where a deterministic function call or script is enough.

### 5. First principles over analogy

Do not justify a design by saying “other systems do it this way,” “this is standard,” or “this is enterprise architecture.” Decompose the problem into primitives:

- What is the actual input?
- What is the actual output?
- What transformation is required?
- What state must be persisted?
- What latency/reliability/security constraints are real?
- What human decision is truly needed?
- What can be represented as a pure function?
- What can be a file, a table, a script, or a typed function instead of a platform?

Then rebuild the smallest sufficient system from those primitives.

### 6. Measure the software idiot index

In manufacturing, a high ratio between final part cost and raw material cost indicates hidden inefficiency. In software, estimate a similar ratio:

```
software_idiot_index = total_system_cost / intrinsic_problem_cost
```

Where:

- total_system_cost = code volume + services + infra + tool count + coordination + debugging + security review + run cost + migration cost + cognitive load.
- intrinsic_problem_cost = the simplest credible implementation that produces the same user-visible outcome under real constraints.

A high software idiot index means the design is likely bloated. Common signs:

- 5 services for what could be 1 module.
- A DSL where a typed function or JSON schema is enough.
- An async job system where request/response is enough.
- A generic plugin architecture before there are 3 real plugins.
- A workflow engine where a short deterministic script is enough.
- A vector database where structured retrieval or full-text search is enough.
- A multi-agent architecture where one agent plus tools is enough.
- A permissions model more complex than the actual collaboration model.

### 7. Move complexity to the right place

Some complexity cannot be deleted; it can only be relocated. Prefer placing complexity where it is easiest to observe, test, version, and recover from.

Useful relocation patterns:

- Move product-specific complexity out of the general runtime and into explicit product tools.
- Move one-off business logic out of shared infrastructure and into a narrow adapter.
- Move agent discretion out of execution and into proposal/planning when determinism matters.
- Move unsafe operations behind a small backend API with authorization and audit.
- Move volatile workflow definitions into versioned files, while keeping execution primitives stable.
- Move expensive runtime inference into precomputed indexes or caches only after proving the need.
- Move complexity from distributed systems into local files/scripts when scale does not yet require distribution.

### 8. Prefer hard interfaces and soft interiors

The boundary should be strict; the inside should stay simple. A good system has a small number of stable contracts and a lot of replaceable internal implementation.

Look for:

- Too many public APIs.
- Too many extension points.
- Leaky abstractions.
- Tools that expose internal implementation details.
- Agents that can bypass authorization through overly broad tool access.
- Workflows that depend on implicit hidden state.
- Runtime behavior that cannot be replayed or audited.

### 9. Speed is an engineering feature

Cycle time is not just project management. It determines learning rate. A slower loop means fewer corrections, more fear, and more overdesign.

Review:

- Time from idea to test.
- Time from code change to evidence.
- Time from user request to observable artifact.
- Time to reproduce a bug.
- Time to rollback.
- Time for a new engineer/agent to understand the system.

Improve speed after deletion and simplification. Do not go faster in the wrong direction.

### 10. Automation is a force multiplier, not a substitute for clarity

Automation should come after the target process is necessary, simple, and stable. Automating uncertainty creates fast chaos.

Before recommending automation, ask:

- Is the operation repeated enough?
- Is the success criterion objective?
- Are inputs and outputs typed or otherwise constrained?
- Are failure modes known?
- Can we replay, audit, and rollback?
- Is there a safe manual path?
- Will automation reduce cognitive load, or hide it?

## Review workflow

When applying this skill, follow the sequence below.

### Step 0: Define the review boundary

State the scope you are reviewing. If the user gave only a vague scope, infer the most likely boundary and say what you assumed.

Capture:

- User goal.
- Current proposed implementation.
- Components in scope.
- Components out of scope.
- Non-negotiable constraints.
- Unknowns that materially affect the review.

Do not stall the review just because some information is missing. Make reasonable assumptions and label them.

### Step 1: Restate the system in primitives

Convert the implementation into primitive operations:

- Inputs.
- Outputs.
- State.
- Transformations.
- External side effects.
- Human approvals.
- Security boundaries.
- Failure recovery paths.

This often reveals unnecessary structure.

### Step 2: Requirement interrogation

List the major requirements and classify them:

- Real: directly tied to user outcome, legal/security requirement, or proven operational need.
- Suspicious: plausible but not yet proven.
- Accidental: created by a chosen implementation rather than the real problem.
- Premature: may be needed later, but not needed for the current stage.

For suspicious, accidental, and premature requirements, propose a weaker alternative.

### Step 3: Deletion pass

Create a deletion table:

| Candidate | Why it may not need to exist | What replaces it | Risk if deleted | Re-add trigger |
|---|---|---|---|---|

Deletion candidates can include:

- Service.
- Agent.
- MCP server.
- Skill.
- CLI.
- Queue.
- Workflow engine.
- DSL construct.
- Database table.
- Cache.
- Registry.
- Plugin system.
- Human approval step.
- Meeting/process.
- Monitoring dimension.
- Abstraction layer.

A good deletion recommendation includes a safe fallback and a clear re-add trigger.

### Step 4: Simplify and consolidate

For what remains, propose simplifications:

- Collapse two interfaces into one.
- Replace generic abstraction with explicit narrow function.
- Replace dynamic runtime behavior with versioned configuration.
- Replace multi-step workflow with direct call.
- Replace distributed state with local state.
- Replace custom infrastructure with existing database, file, or object storage.
- Replace agent discretion with deterministic execution where correctness matters.
- Replace broad permissions with scoped backend-mediated operations.

### Step 5: Optimize the remaining bottleneck

Only optimize components that survived deletion and simplification.

Identify the actual bottleneck category:

- Latency.
- Cost.
- Reliability.
- Safety/security.
- Developer cycle time.
- Agent context quality.
- User experience.
- Maintainability.
- Observability.

Then propose the smallest optimization that moves the bottleneck.

### Step 6: Accelerate cycle time

Recommend changes that increase learning rate:

- Shorter feedback loops.
- Better local dev harness.
- Golden test cases.
- Replayable traces.
- Scripted E2E paths.
- Smaller deploy units.
- Feature flags.
- Better fixtures.
- Better failure evidence.
- Simpler onboarding docs for agents and humans.

Do not recommend acceleration before the deletion/simplification passes.

### Step 7: Automate last

Only recommend automation for stable, repeated, objective operations.

Classify automation opportunities:

- Automate now: repeated, deterministic, low-risk, clear success criterion.
- Semi-automate: agent proposes; deterministic tool executes; human approves high-risk actions.
- Do not automate yet: requirement unclear, low frequency, high ambiguity, or unsafe.

### Step 8: Produce the final review

Use the output format below.

## Output format

The final answer should be direct and opinionated, while clearly separating fact, inference, and assumption.

### 1. Verdict

Give a one-paragraph judgment:

- Is the current design overbuilt, underbuilt, or directionally right?
- What is the highest-leverage simplification?
- What should the user do first?

### 2. System primitive restatement

Restate the reviewed scope as primitives:

```
Input → transformation → state → side effects → output
```

### 3. Elon-style insight

Give 3–7 sharp insights. Each insight should have this shape:

```
Insight: [blunt diagnosis]
Why: [first-principles reasoning]
Change: [specific deletion/simplification]
Proof: [how to validate quickly]
```

Examples of acceptable insight style:

- “This registry is trying to be a platform before you have platform pressure.”
- “The workflow engine is compensating for unclear product primitives.”
- “You are optimizing the agent layer, but the actual bottleneck is context freshness.”
- “This should be a backend capability, not an agent capability.”
- “The DSL is useful as a proposal language, but dangerous as an execution authority.”
- “You do not need an MCP server here; you need three typed functions and an audit log.”

### 4. Deletion table

Provide a concrete deletion/consolidation table.

| Delete / Collapse | Replacement | Benefit | Risk | Re-add trigger |
|---|---|---|---|---|

### 5. Simplified target design

Describe the simplest credible architecture after deletion.

Include:

- Components that remain.
- Components removed.
- Critical interfaces.
- Data ownership.
- Execution path.
- Safety boundary.
- Observability/replay path.

### 6. Automation decision

State what should be automated now, what should be semi-automated, and what should not be automated yet.

### 7. Next actions

Give a short, ordered action list. Each action should be implementable.

Prefer:

- Delete this.
- Merge these two.
- Replace this with a direct function.
- Add this single test.
- Create this small adapter.
- Measure this metric for 3 days.

Avoid vague actions like “improve architecture,” “increase scalability,” or “enhance observability.”

## Scoring rubric

Score each reviewed design from 1 to 5 on the following dimensions:

| Dimension | 1 | 5 |
|---|---|---|
| Requirement clarity | Anonymous, inherited, vague | Named owner, measurable outcome |
| Deletability | Everything feels mandatory | Many safe deletion candidates identified |
| Component count | Many moving parts | Few necessary parts |
| Interface hardness | Leaky, implicit, broad | Typed, narrow, auditable |
| Determinism | Hidden state, hard to replay | Replayable, testable, predictable |
| Cycle time | Slow feedback | Fast local/prod feedback |
| Automation maturity | Automating chaos | Automating stable repeated work |
| Software idiot index | Cost far exceeds intrinsic problem | Cost close to intrinsic problem |

Then summarize:

```
Overall simplification score: X/5
Primary complexity source: [requirement / component / interface / runtime / data / people-process]
Best next deletion: [one concrete deletion]
Best next proof: [one test or measurement]
```

## Common software translations of Musk-style principles

### “Best part is no part” in software

- Best microservice is no microservice.
- Best queue is no queue.
- Best plugin system is no plugin system.
- Best schema migration is no schema migration.
- Best cache invalidation is no cache.
- Best workflow step is no workflow step.
- Best permission exception is no exception.
- Best agent tool is no tool.
- Best DSL construct is no construct.
- Best UI setting is no setting.

### “Question requirements” in software

- Who asked for this field?
- Who asked for this status?
- Who asked for this role?
- Who asked for this approval step?
- Who asked for this async behavior?
- Who asked for multi-tenancy now?
- Who asked for arbitrary extensibility now?
- Who asked for user-editable workflows now?
- Who asked for real-time updates now?
- Who asked for a separate service now?

### “Delete then add back” in software

Temporary deletion is a valid experiment. The goal is not reckless removal; the goal is to reveal which parts are truly load-bearing.

Safe deletion patterns:

- Feature flag off.
- Shadow mode.
- Read-only mode.
- Manual fallback.
- Stub implementation.
- One customer cohort.
- One workflow path.
- One environment.
- One-week trial.

### “Factory is the product” in software

The delivery system is part of the product. Review not just the app, but the machine that produces the app:

- Local dev setup.
- Test harness.
- Seed data.
- CI/CD.
- Preview environments.
- E2E scripts.
- Debug traces.
- Release process.
- Rollback process.
- Agent workspace instructions.

A system that is elegant in production but painful to change is not actually simple.

### “Everyone is a chief engineer” in software

Every engineer/agent should understand:

- The end-to-end user journey.
- The canonical data source.
- The execution authority.
- The safety boundary.
- The rollback path.
- The highest-cost failure mode.
- The bottleneck metric.

Narrow local ownership is useful for delivery, but dangerous for architecture.

## Special guidance for agentic systems

When reviewing agent systems, be especially skeptical of giving agents broad execution authority.

### Prefer this pattern

```
Agent proposes → deterministic backend validates → narrow tool executes → event log records → user can inspect/replay
```

### Be skeptical of this pattern

```
Agent decides → agent calls broad tool → tool mutates state → unclear audit/replay → hard-to-debug failure
```

### Agent simplification questions

- Does this need an agent, or just a deterministic function?
- Does this need MCP, or just a backend endpoint?
- Does this need a Skill, or just a README/AGENTS.md instruction?
- Does this need a DSL, or just typed JSON plus schema validation?
- Does this need a workflow engine, or just a job table and worker?
- Does this need long-term memory, or just current workspace context?
- Does this need autonomous execution, or proposal + approval?
- Does this need generic tools, or narrow product tools?
- Does the agent have access to secrets or user IDs it should not control?
- Can every tool call be authorized server-side using the real authenticated user, not agent-supplied identity?

## Special guidance for workflow / DSL systems

A DSL is justified only when it reduces total system complexity. It is not justified merely because the product has workflows.

Good reasons for a DSL:

- Users or agents need to compose known safe primitives.
- Workflows must be versioned, audited, replayed, diffed, or approved.
- The execution engine has stable primitives and variable compositions.
- The DSL prevents unsafe operations by construction.

Bad reasons for a DSL:

- The team has not clarified backend APIs.
- The agent needs a place to put arbitrary logic.
- The product wants future extensibility but has no repeated cases yet.
- The workflow engine is being used to avoid writing straightforward code.
- The DSL mirrors UI steps instead of domain primitives.

DSL review rule:

```
If an action cannot be mapped to a small, authorized, deterministic primitive, it should not be executable DSL.
```

## Special guidance for backend/platform systems

Be suspicious of premature platformization.

A platform is justified when:

- There are multiple real consumers.
- The repeated use cases are known.
- The primitives are stable.
- The cost of duplication is already painful.
- The interface can be kept small.

Before that, prefer:

- One backend module.
- One job worker.
- One adapter.
- One table.
- One typed API.
- One script.
- One explicit configuration file.

## Special guidance for security and authorization

Do not delete real safety boundaries. Simplification is not permission weakening.

Prefer deleting unsafe flexibility rather than adding complex policy machinery.

Security simplification patterns:

- Server derives user identity; agent never supplies it.
- Tools accept resource IDs, not arbitrary SQL/URLs/paths.
- Use allowlists before general policy engines.
- Use narrow service accounts before broad cloud credentials.
- Use short-lived tokens before persistent secrets in workspaces.
- Log every mutation with actor, resource, input, output, and correlation ID.
- Put dangerous operations behind explicit approval.

## What not to do

Do not:

- Roleplay Elon Musk or imitate his personal speaking style.
- Use aggression as a substitute for engineering reasoning.
- Recommend deletion without naming the risk and re-add trigger.
- Ignore security, compliance, correctness, or user trust in the name of speed.
- Add a new abstraction as the first recommendation.
- Automate a process before questioning and simplifying it.
- Optimize a component without checking whether the component should exist.
- Treat “standard architecture” as proof.
- Treat “future scalability” as proof without concrete scale assumptions.
- Treat “agent can do it” as proof that agent should do it.

## Mini prompt template

When invoking this skill internally, use this frame:

```
Review the following scope as an Elon-style simplification reviewer.

Scope:
[bounded system/component/workflow]

Current design:
[implementation details]

Known constraints:
[security, compliance, latency, cost, team, existing systems]

Please:
1. Restate the system as primitives.
2. Question the requirements.
3. Identify deletion candidates.
4. Propose the simplest credible target design.
5. Separate automate-now vs semi-automate vs do-not-automate-yet.
6. Give concrete next actions.
```

## Example output skeleton

```
## Verdict

The design is directionally right but overbuilt at the runtime/tooling layer. The highest-leverage simplification is to remove the generic plugin/agent execution layer from the first version and expose three narrow backend-authorized tools instead.

## System primitives

User intent + project context → select safe capability → validate parameters → execute deterministic backend action → persist event/artifact → return inspectable result

## Elon-style insights

### 1. This plugin layer is a platform before there is platform pressure
Why: You have one product and three real actions. A generic plugin registry creates more surface area than value.
Change: Replace the plugin registry with a static tool manifest and typed backend endpoints.
Proof: Implement the three actions directly; if the fourth and fifth actions duplicate 80% of the pattern, reconsider a registry.

### 2. The DSL should propose, not execute authority
Why: Agent-generated DSL is useful for composition but dangerous as an execution authority.
Change: Treat DSL as a plan/proposal. Backend maps each action to a narrow allowlisted primitive.
Proof: Every executable DSL action must resolve to one backend function with schema validation and audit.

## Deletion table

| Delete / Collapse | Replacement | Benefit | Risk | Re-add trigger |
|---|---|---|---|---|
| Generic plugin registry | Static manifest | Less indirection | Less third-party extensibility | 3+ external plugin authors |
| Agent-supplied user ID | Server-derived identity | Removes privilege escalation path | Requires auth plumbing | Never re-add |

## Simplified target design

[...]

## Automation decision

Automate now: schema validation, audit logging, replay fixture generation.
Semi-automate: agent proposes workflow; user approves high-risk actions.
Do not automate yet: arbitrary workflow execution and plugin installation.

## Next actions

1. Replace plugin registry with static tool manifest.
2. Create three backend endpoints with server-side auth.
3. Add event log table.
4. Add one replayable E2E fixture.
```
