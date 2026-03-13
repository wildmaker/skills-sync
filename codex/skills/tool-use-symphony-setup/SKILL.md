---
name: tool-use-symphony-setup
description: Install and run the easier community Symphony setup skill (`odysseus0/symphony`, alias `symphony-setup`) in any repo, then execute "set up Symphony for my repo." Use when users ask to configure Symphony quickly, ask for the easiest setup path, or want a practical Linear-first orchestration workflow.
---

# Symphony Setup (Recommended Fork First)

## Overview
Prefer the community-maintained setup flow first because it is faster to bootstrap and includes practical improvements over upstream setup. Fall back to manual setup only when install is blocked.

## Default Path (Recommended)

From the target project root, run:

```bash
npx skills add odysseus0/symphony -s symphony-setup -y
```

Then instruct the agent in that repo:

```text
set up Symphony for my repo.
```

## Setup Workflow

1. Confirm current directory is the target project root.
2. Install the skill with `npx skills add odysseus0/symphony -s symphony-setup -y`.
3. Verify skill files were added (or updated) in local skills directory.
4. Run the instruction: `set up Symphony for my repo.`
5. Review generated changes, run project checks, and summarize diffs plus required env vars.

## First-Run Operator Guidance

After setup succeeds, operate Symphony through Linear:

1. Treat the Linear board as the control surface.
2. Move tickets to `Todo` to dispatch idle workers.
3. Move tickets to `Rework` with feedback to trigger follow-up fixes.
4. Move tickets back to `Backlog` to pause.
5. Cancel tickets when needed; workers stop on the next poll.

When a board is not ready, ask the agent to act as tech lead and decompose from a big idea first:

```text
Break this into tickets in project [slug]. Scope each ticket to one reviewable PR.
Include acceptance criteria. Set blocking relationships where order matters.
```

## Expected Worker Behavior

For each ticket, expect this lifecycle:

1. Claim ticket in Linear.
2. Post implementation plan as a Linear comment before code changes.
3. Implement in its own workspace clone.
4. Validate changes and document evidence.
5. Open PR and report completion artifacts.

If the generated plan is poor, stop and fix plan quality before allowing implementation to continue.

## Tuning Knobs

`WORKFLOW.md` is the primary behavior control plane and hot-reloads quickly.

Key parameters to tune:

1. `agent.max_concurrent_agents`: start with `2-3`, then increase gradually.
2. `agent.max_turns`: increase for complex tickets, reduce to cap spend on simple ones.

## Manual Fallback (If Install Fails)

If `npx skills add ...` cannot run (network/policy/tooling limits):

1. Tell the user install failed and why.
2. Follow the installed skill instructions manually if available locally.
3. If not available locally, use the best available Symphony docs source and apply equivalent setup steps.
4. Clearly mark any assumptions and list exact follow-ups for the user.

## Verification

After setup changes are applied in the target repo, run relevant project checks (example for Elixir repos):

```bash
mix deps.get
mix compile
mix test
```

Also run the repo's boot command when available to confirm Symphony starts without runtime errors.

## Output Requirements

When done, always provide:

1. Commands executed.
2. Files changed and rationale.
3. Env vars required and where they were documented.
4. Linear workflow guidance (how to dispatch, rework, and pause tickets).
5. Any manual steps still required by the user.

## Resource to Load

- `references/tool-use-symphony-setup-checklist.md`
