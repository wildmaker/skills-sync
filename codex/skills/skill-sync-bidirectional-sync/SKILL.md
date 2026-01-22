---
name: skill-sync-bidirectional-sync
description: Orchestrate bidirectional sync between local skills and the skill-sync spec repo. Use to pull specs to local skills or push local skills to the spec repo by delegating to the directional sync skills.
version: 0.0.0
---

# Skill Sync Bidirectional Sync

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- local_skills_root: string (default: /Users/wildmaker/.codex/skills)
- local_agent_name: string (default: codex)

## Auto-generate missing inputs

- local_skills_root: default to `/Users/wildmaker/.codex/skills`.
- local_agent_name: default to `codex`.

## Directional sync

- Always run both directions in order:
  1) repo → local: run the `skill-sync-repo-to-local` skill.
  2) local → repo: run the `skill-sync-local-to-repo` skill.

## Audit support (optional)

- Use the bundled script `scripts/sync_audit.sh` to pull the latest repo and produce a diff report.
- When syncing local → repo, local skills are copied into `skills-sync/<local_agent_name>/<skill_name>/` for audit and backup.

## Sync actions

- Explicitly invoke both directional skills (no skipping or reordering):
  - `skill-sync-repo-to-local`
  - `skill-sync-local-to-repo`

## Output

Return a structured response:

```
status: complete
create_skills:
  - <skill-name>
update_skills:
  - <skill-name>
```

## Invariants

- Do not modify the spec repo beyond pulling latest.
- Do not modify local skills unless explicitly instructed to sync.
- Use the script output as the single source of truth for the diff list.
