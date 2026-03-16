# Symphony Setup Checklist (Fork-First)

## Quick Start (Preferred)

From target repo root:

```bash
npx skills add odysseus0/symphony -s symphony-setup -y
```

Then tell the agent:

```text
set up Symphony for my repo.
```

## Execution Checklist

- [ ] Confirm command is run from target repo root.
- [ ] Run `npx skills add odysseus0/symphony -s symphony-setup -y`.
- [ ] Confirm `symphony-setup` skill is installed locally.
- [ ] Decide workflow source mode: bundled default template or `workflow_source.type: path`.
- [ ] If using the default mode, confirm it initializes from `references/default-WORKFLOW.md` (copy of canonical `workflow/WORKFLOW.md`).
- [ ] If using `workflow_source.type: path`, verify the repo-relative source file exists and can be read before edits.
- [ ] Execute: `set up Symphony for my repo.`
- [ ] Review and validate generated repo changes.
- [ ] Confirm repo-root `WORKFLOW.md` was initialized from the selected workflow source.
- [ ] Run repo checks (for Elixir: `mix deps.get`, `mix compile`, `mix test`).
- [ ] Verify Symphony can start without runtime errors.
- [ ] Report diffs, env vars, Linear runbook, and remaining manual actions.

## Linear-First Operating Checks

- [ ] Confirm user will use Linear board as control surface.
- [ ] Explain dispatch flow: move ticket to `Todo`.
- [ ] Explain rework flow: move ticket to `Rework` with comments.
- [ ] Explain pause/stop flow: move ticket to `Backlog` or cancel ticket.

## Ticket Decomposition Prompt (When Board Is Not Ready)

- [ ] Provide this prompt to the agent:

```text
Break this into tickets in project [slug]. Scope each ticket to one reviewable PR.
Include acceptance criteria. Set blocking relationships where order matters.
```

- [ ] Confirm dependencies are captured before dispatching batch to `Todo`.

## Runtime Tuning Checks

- [ ] Confirm `WORKFLOW.md` is present and treated as behavior control plane.
- [ ] Set `agent.max_concurrent_agents` to `2-3` initially.
- [ ] Adjust `agent.max_turns` based on ticket complexity and spend constraints.

## Fallback

If install command fails:

- State the failure reason (network/tooling/policy).
- Follow the skill instructions manually when available.
- If unavailable, use official Symphony docs and proceed with explicit assumptions.
