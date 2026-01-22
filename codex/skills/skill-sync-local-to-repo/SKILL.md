---
name: skill-sync-local-to-repo
description: Sync local skills into the skill-sync spec repo by creating or updating specs from local SKILL.md and resources. Use when pushing local skill changes into the spec repository.
---

# Skill Sync Local To Repo

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- local_skills_root: string (default: /Users/wildmaker/.codex/skills)
- local_agent_name: string (default: codex)

## Auto-generate missing inputs

- local_skills_root: default to `/Users/wildmaker/.codex/skills`.
- local_agent_name: default to `codex`.

## Locate and update spec repo

- Call skill-sync-repo-registry to get repo_local/repo_remote.
- Use the bundled script `scripts/sync_local_to_repo.sh` to pull the latest repo and list sync candidates.

## Sync behavior

- Only sync when the local skill version is greater than the spec version in the repo.
- If the spec does not exist in the repo, create it from the local skill.
- For each eligible local skill, call skill-sync-spec-authoring-update using `spec_name` derived from the skill name.
- Mirror local resource folders (`scripts/`, `references/`, `assets/`) into the spec folder.
- After syncing, ensure the spec version matches the local skill version.
- Copy the local skill folder as-is into `skills-sync/<local_agent_name>/<skill_name>/` for audit and backup.
- After a successful sync, run `git status`, then `git add .`, `git commit -m "chore(skill-sync): sync local skills"`, and `git push` in the skills repo.

## Output

Return a structured response:

```
status: complete
synced_skills:
  - <skill-name>
audit_copy_root: <repo_local>/<local_agent_name>
```

## Invariants

- Do not modify local skills.
- Only write to the spec repo.
- Do not run git push unless a sync has completed successfully.
