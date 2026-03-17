---
name: tool-use-symphony-setup
description: Thin proxy for Symphony setup. Always fetch and follow the upstream setup skill at runtime from the Symphony repo.
---

# Symphony Setup Proxy (Runtime Upstream)

## Purpose
This skill is a thin proxy.

Rule: always fetch and follow the latest upstream setup skill from Symphony at runtime, instead of using local copied setup steps.

## Upstream Source of Truth

- Web: `https://github.com/wildmaker/symphony/blob/main/.agents/skills/symphony-setup/SKILL.md`
- Raw: `https://raw.githubusercontent.com/wildmaker/symphony/main/.agents/skills/symphony-setup/SKILL.md`

## Required Execution Flow

1. Fetch upstream skill text at runtime.
2. Read and execute the upstream instructions as the primary authority.
3. If local instructions conflict with upstream, upstream wins.
4. Keep this proxy minimal; do not add or maintain duplicated setup details here.

## Runtime Fetch Commands

Use one of these in the target repo environment:

```bash
curl -fsSL https://raw.githubusercontent.com/wildmaker/symphony/main/.agents/skills/symphony-setup/SKILL.md
```

or

```bash
gh api repos/wildmaker/symphony/contents/.agents/skills/symphony-setup/SKILL.md \
  -H "Accept: application/vnd.github.raw"
```

## Failure Handling

If upstream cannot be fetched (network/auth/rate limit):

1. Report the blocker and exact error.
2. Stop and ask whether to retry or use a pinned commit URL as temporary fallback.
3. Do not silently fall back to stale local copies.
