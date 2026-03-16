---
name: tool-use-skills-sh
description: Bootstrap and use the skills.sh ecosystem from terminal. Use when the user wants to discover, install, update, or remove skills via `npx skills`, or initialize local agent skill directories (Codex/Claude/Cursor).
---

# Skills.sh Bootstrap

Use this skill when the user wants to work with the `skills.sh` ecosystem.

## 1) One-shot local bootstrap

Run:

```bash
skills/tool-use-skills-sh/scripts/bootstrap_skills_sh.sh
```

This script:

- checks `node`, `npm`, `npx`
- verifies `skills` CLI via `npx -y skills --version`
- ensures `~/.codex/skills`, `~/.claude/skills`, `~/.cursor/skills` exist
- installs official `vercel-labs/agent-skills` globally to Codex by default
- for Codex, links installed entries from `~/.agents/skills` into `~/.codex/skills` (skips non-symlink conflicts)
- prints post-check commands

## 2) Install from a specific source

```bash
skills/tool-use-skills-sh/scripts/bootstrap_skills_sh.sh <source> <agent>
```

Example:

```bash
skills/tool-use-skills-sh/scripts/bootstrap_skills_sh.sh vercel-labs/agent-skills codex
```

`<source>` supports GitHub shorthand (`owner/repo`) or repo URL.

## 3) Daily operations (skills CLI)

```bash
npx -y skills find
npx -y skills add <source> -g -a codex -y
npx -y skills list -g -a codex
npx -y skills check
npx -y skills update
npx -y skills remove <skill-name> -g -a codex -y
```

## 4) Notes

- `skills.sh` current official workflow is based on `npx skills ...`.
- Prefer `-g` for machine-level setup, and omit it for project-local installs.
- For non-interactive automation, always include `-y`.
