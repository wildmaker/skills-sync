# WORKFLOW.md Skeleton (Symphony)

> 用于快速起草，字段名与结构需按项目实际值替换。

```markdown
---
tracker:
  kind: linear
  project_slug: "<your-project-slug>"
  active_states:
    - Todo
    - In Progress
    - In Review
  terminal_states:
    - Done
    - Closed
    - Cancelled
workspace:
  root: <absolute-workspace-root>
hooks:
  after_create: |
    <clone/install commands>
  before_run: |
    <preflight commands>
agent:
  max_concurrent_agents: 3
  max_turns: 20
codex:
  command: codex app-server
# 可选：多 agent + label 路由
# agents:
#   codex:
#     command: codex --model gpt-5.3-codex app-server
#   cursor:
#     command: cursor-symphony-bridge --model opus-4.6
# routing:
#   default_agent: codex
#   by_label:
#     use-cursor: cursor
---

You are working on a Linear ticket `{{ issue.identifier }}`.

{% if attempt %}
This is retry attempt #{{ attempt }}. Resume from current state and avoid repeating completed work.
{% endif %}

Issue context:
Identifier: {{ issue.identifier }}
Title: {{ issue.title }}
State: {{ issue.state }}
Labels: {{ issue.labels }}
URL: {{ issue.url }}

Description:
{% if issue.description %}
{{ issue.description }}
{% else %}
No description provided.
{% endif %}

## Operating rules
- Plan before coding; keep one clear implementation path.
- Keep scope limited to ticket acceptance criteria.
- Run relevant checks before state transition.

## Related skills
- `commit`: when code changes are complete and ready to checkpoint.
- `push`: when branch must be published or PR needs updates.
- `pull`: before coding and before handoff when branch drift may exist.
- `land`: when issue reaches merging stage and checks/reviews must be closed.
- `linear`: when updating issue state/comments/attachments in Linear.

## Status map
- `Todo`: understand context, confirm plan, and prepare execution checklist.
- `In Progress`: implement minimal scoped changes with evidence.
- `In Review`: complete validation, open/update PR, summarize diffs.
- `Done`: all gates passed and artifacts linked back to tracker.

## Quality gates
- Acceptance criteria mapped to concrete verification.
- Relevant tests/checks executed with explicit results.
- PR/issue linkage complete and reviewable.

## Guardrails
- Do not introduce unrelated refactors or features.
- Do not force-push or rewrite shared history without explicit instruction.
- Stop and mark `TBD` when critical runtime info is missing.

## Progress tracking
- Plan:
- Current step:
- Completed:
- Risks/TBD:
- Next action:
```
