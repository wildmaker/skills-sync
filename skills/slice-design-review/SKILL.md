---
name: slice-design-review
description: Review a specified project slice, feature area, module, or workflow by explaining the current implementation, comparing it against the latest architecture/design baseline, checking engineering quality such as tests and maintainability, and producing an evidence-based review checklist with optimization recommendations. Use when the user asks to review a slice, understand a feature's system design, audit implementation logic against architecture docs, inspect whether code violates current project baselines, or summarize risks and improvements for a bounded part of a codebase.
---

# Slice Design Review

## Goal

Review one bounded slice of the current project from both system-design and engineering-implementation angles. Ground the review in actual repository evidence, identify whether the slice matches the current architecture baseline, and return a prioritized checklist plus concrete improvement plan.

## Scope Contract

- Treat the slice as bounded by the user's named feature, path, module, workflow, ticket, or behavior.
- If the slice is under-specified, infer a reasonable working scope from repository search and state the assumption. Ask only when multiple materially different slices would be reviewed.
- Preserve the user's working tree. Do not refactor, format, or edit code unless the user explicitly asks for implementation after the review.
- Review the current repository state, not an idealized design. Call out stale or missing docs as findings.

## Review Workflow

1. Establish the review target.
   - Restate the slice in one sentence.
   - Identify likely entry points, public APIs, user flows, jobs, data models, tests, and docs.
   - Check `AGENTS.md` files that govern the target paths before drawing conclusions.

2. Find the latest architecture/design baseline.
   - Search for relevant docs in locations such as `docs/`, `specs/`, `.omx/plans/`, `architecture`, `design`, `ADR`, `README`, issue references, and nearby module docs.
   - Prefer newer, more specific, and project-authoritative docs over broad or stale notes.
   - If baselines conflict, list the conflict and use the most local or newest baseline as the comparison anchor.
   - If no baseline exists, review against the repo's observable conventions and mark the baseline as inferred.

3. Describe the current implementation logic.
   - Trace the main flow from entry point to side effects and outputs.
   - Name the key modules and responsibilities.
   - Explain important data contracts, state transitions, integration boundaries, and error paths.
   - Include compact Mermaid diagrams when they clarify component or sequence relationships.

4. Compare implementation against the baseline.
   - Identify matches, partial matches, gaps, and explicit violations.
   - Separate architecture drift from normal implementation detail.
   - Support every non-trivial claim with file paths, symbols, docs, command output, or tests.

5. Review engineering quality.
   - Tests: coverage for the slice's critical paths, boundary cases, regressions, mocks vs live integration, fixture quality, and whether tests prove the architecture contract.
   - Maintainability: ownership boundaries, duplication, naming, module size, coupling, dependency direction, dead code, and abstraction fit.
   - Reliability: error handling, retries/timeouts, idempotency, concurrency, cleanup, observability, and failure visibility.
   - Security/privacy when applicable: trust boundaries, secrets, permissions, user input, persistence, and logging.
   - Operations/developer experience: setup assumptions, scripts, env vars, migrations, feature flags, and debuggability.

6. Produce recommendations.
   - Prioritize by risk and leverage: P0 blocks correctness/security, P1 likely causes regressions or architecture drift, P2 improves maintainability/test confidence, P3 optional polish.
   - Prefer small reversible improvements before broad rewrites.
   - Include test additions or verification steps for each material recommendation.

## Evidence Rules

- Use `rg`/`rg --files` first for repository lookup.
- Cite local files with paths and line numbers where possible.
- Distinguish confirmed facts, inferred behavior, and open questions.
- Do not claim tests pass unless you ran them and read the output.
- If you cannot run a relevant verification command, explain why and state the residual risk.
- For unfamiliar external SDKs or APIs that affect the review, check official documentation before making claims.

## Report Shape

Use this structure by default:

````markdown
## Review Target
- Slice:
- Scope assumption:
- Baseline source:

## Current Implementation Logic
[Plain-language flow summary]

```mermaid
[Optional component or sequence diagram]
```

## Baseline Alignment
| Area | Status | Evidence | Notes |
| --- | --- | --- | --- |
| ... | Match / Partial / Drift / Violation / Unknown | file:line or doc | ... |

## Engineering Review Checklist
| Check | Status | Evidence | Risk |
| --- | --- | --- | --- |
| Tests cover critical paths | Pass / Gap / Unknown | ... | ... |

## Findings
### P1: [Title]
- Evidence:
- Why it matters:
- Recommendation:
- Verification:

## Suggested Optimization Plan
1. [Smallest safe next step]
2. [Follow-up]

## Residual Risks
- [What remains unknown or unverified]
````

For small slices, keep the same order but compress the tables into bullets.

## Completion Criteria

Before finalizing, confirm that:

- The selected slice and baseline are named.
- The current implementation logic is explained from real code.
- Baseline alignment is assessed with evidence.
- Tests and engineering quality are reviewed, including gaps.
- Recommendations include priority, rationale, and verification.
- Unknowns and unrun checks are explicit.
