---
name: sync-codex-skills-to-cloud
description: Bidirectional sync between ~/.codex/skills and the skills-sync repo. Use when asked to migrate local skills into the repo or to link repo skills back into ~/.codex/skills.
---

# Sync Codex Skills To Cloud

## Workflow

### A. Local -> Repo (migrate new skills into repo)

1. Run the migration script:

```bash
codex/skills/sync-codex-skills-to-cloud/scripts/migrate_local_skills.sh
```

- It moves non-symlink entries (excluding dot-prefixed directories) from `~/.codex/skills` into `codex/skills` and replaces them with symlinks.
- It prints `MOVED: <name>` for each migrated entry and `NO_CHANGES` when nothing moved.
- If it prints `CONFLICT:` for any name, stop and ask the user how to proceed before making changes.

2. If new skills were moved, commit and push from the repo root following the repo's commit conventions.

3. Run the cursor sync script to keep `.cursor/skills` aligned:

```bash
codex/skills/sync-with-cloud/scripts/ensure_cursor_skills_sync.sh
```

### B. Repo -> Local (link repo skills into ~/.codex/skills)

1. Run the linking script:

```bash
codex/skills/sync-codex-skills-to-cloud/scripts/link_repo_skills_to_codex.sh
```

- It creates symlinks in `~/.codex/skills` pointing to `codex/skills` in the repo.
- It prints `LINKED: <name>` for each new link and `NO_CHANGES` when everything is already linked.
- If it prints `CONFLICT:` for any name, stop and ask the user how to proceed before making changes.
