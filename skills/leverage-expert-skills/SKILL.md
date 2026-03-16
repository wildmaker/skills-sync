---
name: leverage-expert-skills
description: Mimic expert-led human execution by matching local skills as domain experts before starting implementation, then assigning selected experts into the task plan. Use when planning a new task/project, decomposing requirements, or initializing a repo-level AGENTS.md/AGENT.md with recommended expert skills based on the repository domain.
---

# Leverage Expert Skills

## Overview

Identify which local skills should act as "experts" for the current problem, and make that assignment explicit in the execution plan.
When requested, run a repo-level initialization pass: summarize repository domains and write recommended expert skills into `AGENTS.md` (or `AGENT.md`).

## Inputs

- Problem statement or target objective.
- Optional constraints (time, quality bar, tools, forbidden changes).
- Local skill inventory source:
  - Preferred: `AGENTS.md` "Available skills" section.
  - Fallback: scan `skills/*/SKILL.md` frontmatter.
- Optional repo bootstrap target: `AGENTS.md` or `AGENT.md`.

## Workflow

1. Clarify the task intent.
   - Convert user request into a short "problem profile": goal, scope, constraints, expected output.
2. Build candidate expert list from local skills.
   - Read the skill name + description.
   - Remove obviously irrelevant skills.
3. Score candidate experts.
   - Score each skill on 0-5 for:
     - Domain fit
     - Workflow fit
     - Tooling/environment fit
     - Risk-control fit
   - Use weighted score:
     - `total = 0.4*domain + 0.3*workflow + 0.2*tooling + 0.1*risk`
4. Select experts.
   - `Core experts`: top matches required to execute safely.
   - `Optional experts`: useful but non-blocking.
   - Skip low-signal skills and explain why briefly.
5. Inject experts into the execution plan.
   - For each plan step, assign exactly one primary expert skill.
   - Add optional secondary experts only when there is a clear handoff.
6. Emit explicit plan annotations.
   - Use a stable format so downstream executors can follow without guesswork.
   - Reference template: `references/expert-assignment-templates.md`.

## Required Outputs

Always output both sections:

1. Expert matching result
   - Include matched skills, score, rationale, and assignment role.
2. Expert-assigned execution plan
   - Show step-by-step plan with `[Primary Expert: <skill-name>]`.

If no strong match exists:
- State "No strong expert skill match found".
- Continue with best-effort generic execution plan.
- Add the top 1-2 near matches with "low confidence".

## Repo Bootstrap Mode

Use this mode only when user asks to initialize the repo-level expert recommendations.

1. Summarize repository problem domains.
   - Read top-level docs (`README.md`, `docs/`, architecture notes, backend/frontend folders).
   - Produce 3-7 domain bullets (e.g., API backend, mobile app, CI/CD, cloud deploy).
2. Match domains to local skills.
   - Pick skills with direct operational relevance.
   - Keep list concise (usually 5-12).
3. Write recommendations into `AGENTS.md` or `AGENT.md`.
   - If file has an existing "Recommended Expert Skills" section, update in place.
   - Otherwise append a new section at end.
   - Keep idempotent: avoid duplicate entries.
4. Output a short summary:
   - What domains were identified.
   - Which expert skills were recommended.
   - Which file was updated.

## Constraints

- Do not invent non-existent skills.
- Do not assign more than one primary expert per step.
- Do not force expert usage when confidence is low; mark uncertainty explicitly.
- Do not rewrite unrelated sections in `AGENTS.md`/`AGENT.md`.

## Quality Bar

- Recommendations must be traceable to concrete task demands.
- Plan annotations must be explicit enough for another agent to execute directly.
- Repo bootstrap edits must be minimal diff and repeat-safe.

## Resource

Use `references/expert-assignment-templates.md` for output templates and AGENTS section formatting.
