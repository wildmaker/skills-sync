---
name: sync-local-skills
description: Bidirectional sync between ~/.codex/skills and this repo's codex/skills, plus syncing repo skills to ~/.cursor/skills and ~/.claude/skills. Use when migrating local Codex skills into the repo, linking repo skills back into local clients, or updating Cursor/Claude skills from the repo.
---

# Sync Local Skills

## Workflow

### A. Local -> Repo (migrate new local skills into repo)

1. Run the migration script:

```bash
codex/skills/sync-local-skills/scripts/migrate_local_to_repo.sh
```

- It moves non-symlink skill directories (excluding dot-prefixed directories) from `~/.codex/skills` into `codex/skills` and replaces them with symlinks.
- It prints `MOVED: <name>` for each migrated entry and `NO_CHANGES` when nothing moved.
- If it prints `CONFLICT:` for any name, stop and ask the user how to proceed before making changes.

2. If new skills were moved, commit and push from the repo root following the repo's commit conventions.

3. Sync Cursor skills:

```bash
codex/skills/sync-local-skills/scripts/ensure_cursor_skills_sync.sh
```

### B. Repo -> Local (link repo skills into ~/.codex/skills)

1. Run the linking script:

```bash
codex/skills/sync-local-skills/scripts/link_repo_to_codex.sh
```

- It creates symlinks in `~/.codex/skills` pointing to `codex/skills` in the repo.
- It prints `LINKED: <name>` for each new link and `NO_CHANGES` when everything is already linked.
- If it prints `CONFLICT:` for any name, stop and ask the user how to proceed before making changes.

2. Sync Cursor skills:

```bash
codex/skills/sync-local-skills/scripts/ensure_cursor_skills_sync.sh
```

### C. Repo -> Cursor (sync repo skills into ~/.cursor/skills)

Run the sync script any time the repo changes:

```bash
codex/skills/sync-local-skills/scripts/ensure_cursor_skills_sync.sh
```

- It mirrors `codex/skills` into `~/.cursor/skills` using `rsync` and excludes dot-prefixed directories.
- If it reports missing `rsync`, install it before continuing.

### D. Repo -> Claude (link repo skills into ~/.claude/skills)

1. Run the linking script:

```bash
codex/skills/sync-local-skills/scripts/link_repo_to_claude.sh
```

- It creates symlinks in `~/.claude/skills` pointing to `codex/skills` in the repo.
- It prints `LINKED: <name>` for each new link and `NO_CHANGES` when everything is already linked.
- If it prints `CONFLICT:` for any name, stop and ask the user how to proceed before making changes.
