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
3. Run the upstream `symphony-setup` flow first to complete setup in the target repo.
4. After setup completes, apply the custom skill override mapping from Skill Hub to the target repo `.agents/skills` directory.
5. After skill overrides complete, replace the installed target repo workflow file with the custom workflow from Skill Hub:
   - Source (Skill Hub): `skills-sync/workflow/WORKFLOW.md`
   - Target (installed repo): `WORKFLOW.md` at repo root
6. Verify skill overrides and workflow replacement succeeded.
7. If local instructions conflict with upstream, upstream wins, except custom skill overrides and post-setup workflow replacement are mandatory for this proxy.
8. Keep this proxy minimal; do not add or maintain duplicated setup details here.

Runtime consistency requirement for this proxy:

- Follow upstream's global singleton strategy for Symphony itself (one `SYMPHONY_HOME` checkout reused by multiple runtimes), not per-repo local Symphony clones.

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

## Post-Setup Workflow Replacement

After upstream setup finishes, run replacement in the workspace that contains `skills-sync` and the target repo:

```bash
cp skills-sync/workflow/WORKFLOW.md <target-repo>/WORKFLOW.md
```

If you are already inside the target repo:

```bash
cp /path/to/skills-sync/workflow/WORKFLOW.md WORKFLOW.md
```

Recommended verification:

```bash
diff -u skills-sync/workflow/WORKFLOW.md <target-repo>/WORKFLOW.md
```

`diff` should show no differences.

## Post-Setup Custom Skill Overrides (Mandatory)

After upstream setup installs skills into the target repo, override by replacing full target folders with custom Skill Hub folders (folder name + contents together).

| Target folder (`<target-repo>/.agents/skills/<name>`) | Skill Hub source folder (`skills-sync/skills/<name>`) |
|---|---|
| `tool-use-commit` | `tool-use-commit` |
| `tool-use-push` | `tool-use-push` |
| `tool-use-pull` | `tool-use-pull` |
| `tool-use-land` | `tool-use-land` |

Apply overrides from a workspace that contains both `skills-sync` and `<target-repo>`:

```bash
set -euo pipefail

TARGET_REPO="<target-repo>"
SKILL_HUB="skills-sync/skills"

declare -a MAP=(
  "tool-use-commit:tool-use-commit"
  "tool-use-push:tool-use-push"
  "tool-use-pull:tool-use-pull"
  "tool-use-land:tool-use-land"
)

for pair in "${MAP[@]}"; do
  target_name="${pair%%:*}"
  custom="${pair##*:}"
  src="$SKILL_HUB/$custom"
  dst="$TARGET_REPO/.agents/skills/$target_name"

  if [ ! -d "$src" ]; then
    echo "Missing custom skill source: $src" >&2
    exit 1
  fi

  rm -rf "$dst"
  cp -R "$src" "$dst"
done

# Remove legacy official folder names to avoid accidental fallback.
rm -rf \
  "$TARGET_REPO/.agents/skills/commit" \
  "$TARGET_REPO/.agents/skills/push" \
  "$TARGET_REPO/.agents/skills/pull" \
  "$TARGET_REPO/.agents/skills/land"
```

Verification (all required):

```bash
test -f <target-repo>/.agents/skills/tool-use-commit/SKILL.md
test -f <target-repo>/.agents/skills/tool-use-push/SKILL.md
test -f <target-repo>/.agents/skills/tool-use-pull/SKILL.md
test -f <target-repo>/.agents/skills/tool-use-land/SKILL.md
test -f <target-repo>/.agents/skills/tool-use-land/land_watch.py

rg -n '^name:\\s*tool-use-commit$' <target-repo>/.agents/skills/tool-use-commit/SKILL.md
rg -n '^name:\\s*tool-use-push$' <target-repo>/.agents/skills/tool-use-push/SKILL.md
rg -n '^name:\\s*tool-use-pull$' <target-repo>/.agents/skills/tool-use-pull/SKILL.md
rg -n '^name:\\s*tool-use-land$' <target-repo>/.agents/skills/tool-use-land/SKILL.md
```

## Multi-runtime isolation recommendations

When operating multiple runtimes from one Symphony binary source, apply all of these:

- Use a different `--port` per runtime.
- Use a different `--logs-root` per runtime.
- Use a different `workspace.root` per runtime.
- Do not let multiple runtimes poll the same ticket pool. Split by `project_slug`, `assignee`, or state strategy to avoid contention.

Reference example:

```bash
# runtime A
~/.local/share/symphony/elixir/bin/symphony /repoA/WORKFLOW.md --port 4111 --logs-root ~/.cache/symphony/a --i-understand-that-this-will-be-running-without-the-usual-guardrails

# runtime B
~/.local/share/symphony/elixir/bin/symphony /repoB/WORKFLOW.md --port 4112 --logs-root ~/.cache/symphony/b --i-understand-that-this-will-be-running-without-the-usual-guardrails
```

## Failure Handling

If upstream cannot be fetched (network/auth/rate limit):

1. Report the blocker and exact error.
2. Stop and ask whether to retry or use a pinned commit URL as temporary fallback.
3. Do not silently fall back to stale local copies.

If post-setup workflow replacement fails:

1. Report source path, target path, and exact error.
2. Stop and ask whether to retry with corrected paths.
3. Do not continue with default template as final state.

If custom skill override fails:

1. Report mapping item, source path, target path, and exact error.
2. Stop and ask whether to retry with corrected paths.
3. Do not continue with mixed official/custom skills as final state.
