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
4. After setup completes, replace the installed target repo workflow file with the custom workflow from Skill Hub:
   - Source (Skill Hub): `skills-sync/workflow/WORKFLOW.md`
   - Target (installed repo): `workflow/WORKFLOW.md`
5. Verify replacement succeeded by checking target file content matches the Skill Hub custom workflow.
6. If local instructions conflict with upstream, upstream wins, except this post-setup workflow replacement is mandatory for this proxy.
7. Keep this proxy minimal; do not add or maintain duplicated setup details here.

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
cp skills-sync/workflow/WORKFLOW.md <target-repo>/workflow/WORKFLOW.md
```

If you are already inside the target repo:

```bash
cp /path/to/skills-sync/workflow/WORKFLOW.md workflow/WORKFLOW.md
```

Recommended verification:

```bash
diff -u skills-sync/workflow/WORKFLOW.md <target-repo>/workflow/WORKFLOW.md
```

`diff` should show no differences.

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
