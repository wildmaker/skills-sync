---
name: tool-use-symphony-setup
description: Install and run Symphony setup with skill overlay + capability alias mapping, so workers can keep built-in default skill names while prioritizing custom skill names like `tool-use-push`.
---

# Symphony Setup (Overlay + Capability Mapping)

## Overview
Use the community-maintained setup flow first, then harden it for custom skill naming.

Goal: keep Symphony built-in capability names unchanged (`commit`, `push`, `pull`, `linear`, etc.) while allowing user-facing prompts and workflow guidance to prefer custom skill names (`tool-use-push`, `tool-use-commit`, ...).

Core constraints:

1. Keep default `.agents/skills/*` (never delete wholesale).
2. Overlay custom skills during worktree init.
3. Prefer custom names in prompt layer (`AGENTS.md` / `WORKFLOW.md`).
4. Use capability-to-skill aliases so runtime does not depend on fixed naming.

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
2. Install the setup skill with `npx skills add odysseus0/symphony -s symphony-setup -y`.
3. Decide custom skill source strategy: `repo_local` or `central_repo`.
4. Create/update `symphony.skills.yaml` in the project root.
5. Update `WORKFLOW.md` `after_create` to project clone + custom overlay (no destructive reset of skills).
6. Update prompt layer (`AGENTS.md` + `Related skills`) to prioritize alias targets (for example `tool-use-push`).
7. Validate with one real test ticket and confirm behavior evidence points to custom skill names.
8. Push all setup changes to remote before starting Symphony workers.

## Required Mapping Defaults

When no explicit user preference is provided, apply this default alias map:

- `commit -> tool-use-commit`
- `debug -> tool-use-debug`
- `linear -> tool-use-linear`
- `push -> tool-use-push`

If a capability has no alias, fall back to the default built-in skill name.

## Add `symphony.skills.yaml`

Create this file in the user's repo root (adjust values to the actual org/repo):

```yaml
version: 1
strategy: overlay
custom_source:
  type: central_repo # central_repo or repo_local
  repo: git@github.com:your-org/agent-skills.git
  ref: main
  subpath: .agents/skills
aliases:
  push: tool-use-push
  pull: tool-use-pull
  commit: tool-use-commit
required_capabilities:
  - commit
  - push
  - pull
  - land
  - linear
```

Field behavior:

1. `strategy: overlay`: merge custom skills into `.agents/skills` without deleting defaults.
2. `aliases`: capability name -> actual skill name used in prompts/workflow guidance.
3. `required_capabilities`: checklist for minimum operational flow.
4. `custom_source.type`:
   - `repo_local`: use `.agents/skills-custom/*` from the project repo.
   - `central_repo`: clone the central skills repo and overlay from `subpath`.

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

## Cursor Agent Support

After `mix setup`, verify Cursor bridge scripts are installed:

```bash
which cursor-symphony-bridge && echo "cursor bridge OK"
which symphony-linear-cli && echo "linear CLI OK"
```

If the user wants Cursor as an agent backend, the WORKFLOW.md template already includes the multi-agent routing config. Tickets with the `use-cursor` label route to Cursor; all others go to Codex. No additional setup is needed beyond ensuring:

1. `agent` CLI is installed and authenticated.
2. `cursor-symphony-bridge` and `symphony-linear-cli` are on PATH (done by `mix setup`).
3. `LINEAR_API_KEY` is set in the shell that runs Symphony.

## Verification

After setup changes are applied in the target repo, run relevant project checks (example for Elixir repos):

```bash
mix deps.get
mix compile
mix test
```

Also run the repo's boot command when available to confirm Symphony starts without runtime errors.

Then run overlay-specific verification:

1. Confirm there is no destructive step like `rm -rf .agents/skills` in `WORKFLOW.md`.
2. Confirm worktree has both default and custom skills after `after_create`.
3. Confirm `AGENTS.md` explicitly lists custom skill names (for example `tool-use-push`).
4. Confirm `WORKFLOW.md` `Related skills` references alias targets first.
5. Run one real ticket and confirm `push` stage behavior came from aliased skill (logs/evidence).

## `WORKFLOW.md` `after_create` (Overlay Pattern)

Do not replace `.agents/skills` wholesale. Use project clone + overlay:

```yaml
hooks:
  after_create: |
    set -euo pipefail

    # 1) clone user project
    git clone --depth 1 <user-repo-url> .

    # 2) overlay custom skills
    tmp_skills_dir="$(mktemp -d)"
    git clone --depth 1 --branch <skills-ref> <skills-repo-url> "$tmp_skills_dir"

    mkdir -p .agents/skills
    if [ -d "$tmp_skills_dir/.agents/skills" ]; then
      cp -R "$tmp_skills_dir/.agents/skills/." .agents/skills/
    fi

    rm -rf "$tmp_skills_dir"

    # 3) project setup
    <project-setup-commands>
```

Requirements:

1. Keep defaults, only overlay custom files.
2. Allow same-name overwrite file-by-file.
3. If central repo fetch fails, fail fast (no silent downgrade).

## Prompt-Layer Rewrite Rules

`after_create` alone is not enough. Prompt text must point to alias targets.

1. In `AGENTS.md` "Available skills", add aliased custom names.
2. In `WORKFLOW.md` "Related skills", describe capabilities but reference aliased names first.
3. Keep default names only as temporary compatibility fallback during migration window.

Example:

```markdown
## Related skills

- `tool-use-commit`: produce clean commits during implementation.
- `tool-use-push`: keep remote branch current and publish updates.
- `tool-use-pull`: sync with `origin/main` before code edits and before handoff.
- `land`: when ticket reaches `Merging`, run the merge loop.
- `linear`: interact with Linear for state updates, comments, and uploads.
```

## Setup Skill Execution Protocol

When running `symphony-setup`, enforce this order:

1. Ask and confirm strategy (`project-local` recommended, or `central-repo`).
2. Check source availability (`git clone --depth 1 <skills-source>` must succeed non-interactively).
3. Generate/update:
   - `symphony.skills.yaml`
   - `WORKFLOW.md` `after_create`
   - `AGENTS.md` available skill list
   - `WORKFLOW.md` related skills names
4. Validate with one real test ticket and collect evidence that aliased skill path was used.

## Compatibility and Rollback

Compatibility window (1-2 iterations):

1. Keep both default names and aliased names visible.
2. Prefer aliased names in new prompt text.

Rollback path:

1. Revert `WORKFLOW.md` to clone-only `after_create`.
2. Revert `Related skills` naming to defaults.
3. Remove overlay logic blocks.

## Output Requirements

When done, always provide:

1. Commands executed.
2. Files changed and rationale.
3. Env vars required and where they were documented.
4. Linear workflow guidance (how to dispatch, rework, and pause tickets).
5. Alias mapping used (`capability -> skill`) and evidence.
6. Any manual steps still required by the user.

## Resource to Load

- `references/tool-use-symphony-setup-checklist.md`
