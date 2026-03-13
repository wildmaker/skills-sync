# Agent-First Repo Initialization Methodology

## Goals
- Make repository context legible to agents.
- Keep intent, constraints, and progress in versioned artifacts.
- Reduce dependence on chat memory and ad-hoc instructions.

## Operating principles
1. Keep `AGENTS.md` short and index-like.
2. Treat `docs/` as system of record.
3. Encode constraints in executable checks where possible.
4. Prefer small, reversible changes and short-lived PRs.
5. Run continuous cleanup to prevent drift and stale docs.

## Repository conventions
- Root docs define stable guardrails (`ARCHITECTURE.md`, `QUALITY_SCORE.md`, `SECURITY.md`).
- `docs/design-docs/` captures architecture and decision rationale.
- `docs/exec-plans/` captures active/completed plans and debt.
- `docs/product-specs/` captures user-facing behavior specs.
- `docs/generated/` stores generated references for agent consumption.

## Initialization boundary
- Create missing scaffolding only.
- Do not overwrite existing project-specific content.
- If `AGENTS.md` exists, merge manually toward map-style structure.
