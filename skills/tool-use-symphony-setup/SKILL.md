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
4. Parse `WORKFLOW.md` and extract required skills from `## Related skills` (this is intent source-of-truth).
5. Resolve the Skill Hub source with this priority:
   - Preferred: remote `skills-sync` repo (pin with `SKILL_HUB_REF`, default `main`)
   - Optional: local override via `SKILL_HUB_ROOT` (only when explicitly provided and valid)
   - If preferred source fails, report exact error and ask whether to retry with another source
6. In setup phase (not waiting for runtime hooks), sync all required skills into `<target-repo>/.agents/skills`.
7. Ensure each synced skill includes `SKILL.md` and bundled scripts/assets.
8. Create or update `<target-repo>/.agents/skills.manifest.yaml`:
   - required skills
   - source metadata
   - version strategy (recommended: pinned commit/tag)
9. Create or update `<target-repo>/.agents/skills.lock` with actual resolved revision per skill.
   - If lock already exists, update it in place; do not fail because the file exists.
10. After skill sync completes, replace the installed target repo workflow file with the custom workflow from Skill Hub:
   - Source (Skill Hub): `<SKILL_HUB_ROOT>/workflow/WORKFLOW.md`
   - Target (installed repo): `WORKFLOW.md` at repo root
11. Ensure `WORKFLOW.md` hooks run skills doctor:
   - `after_create`: run doctor once after bootstrap
   - `before_run`: run doctor and fail-fast on errors
12. Ensure CI includes strict doctor check so missing skills are detectable even when hooks are not triggered.
13. Commit these setup artifacts in target repo:
   - `.agents/skills/*`
   - `.agents/skills.manifest.yaml`
   - `.agents/skills.lock`
   - `scripts/skills-doctor.sh`
   - `WORKFLOW.md` hook updates and CI workflow changes
14. If local instructions conflict with upstream, upstream wins, except setup-time skill sync + manifest/lock + doctor + workflow replacement are mandatory for this proxy.
15. Keep this proxy minimal; do not add or maintain duplicated setup details here.

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

## Skill Hub Source Resolution (Remote-first)

This proxy must not require a local `skills-sync` folder by default.

Set these variables before post-setup override/replacement:

```bash
TARGET_REPO="<target-repo>"
SKILL_HUB_REPO="${SKILL_HUB_REPO:-https://github.com/wildmaker/skills-sync.git}"
SKILL_HUB_REF="${SKILL_HUB_REF:-main}"   # recommend pinning to a tag or commit-like ref
```

Resolve source:

```bash
set -euo pipefail

if [ -n "${SKILL_HUB_ROOT:-}" ] \
  && [ -d "$SKILL_HUB_ROOT/skills" ] \
  && [ -f "$SKILL_HUB_ROOT/workflow/WORKFLOW.md" ]; then
  echo "Using local Skill Hub: $SKILL_HUB_ROOT"
else
  TMP_HUB="$(mktemp -d)"
  trap 'rm -rf "$TMP_HUB"' EXIT
  git clone --depth 1 --branch "$SKILL_HUB_REF" "$SKILL_HUB_REPO" "$TMP_HUB/skills-sync"
  SKILL_HUB_ROOT="$TMP_HUB/skills-sync"
  echo "Using remote Skill Hub: $SKILL_HUB_ROOT ($SKILL_HUB_REF)"
fi
```

## Post-Setup Workflow Replacement

After upstream setup finishes, resolve the Skill Hub root first, then replace workflow:

```bash
SKILL_HUB_ROOT="/absolute/path/to/skills-sync"
cp "$SKILL_HUB_ROOT/workflow/WORKFLOW.md" <target-repo>/WORKFLOW.md
```

If you are already inside the target repo:

```bash
SKILL_HUB_ROOT="/absolute/path/to/skills-sync"
cp "$SKILL_HUB_ROOT/workflow/WORKFLOW.md" WORKFLOW.md
```

Recommended verification:

```bash
diff -u "$SKILL_HUB_ROOT/workflow/WORKFLOW.md" <target-repo>/WORKFLOW.md
```

`diff` should show no differences.

## Setup-time Skill Sync (Mandatory)

Do not wait for runtime hooks to fetch required skills. During setup, parse workflow intent and install required skills directly into target repo.

Apply setup-time sync after `SKILL_HUB_ROOT` is resolved:

```bash
set -euo pipefail

TARGET_REPO="<target-repo>"
SKILL_HUB="$SKILL_HUB_ROOT/skills"
WORKFLOW_FILE="$TARGET_REPO/WORKFLOW.md"
MANIFEST="$TARGET_REPO/.agents/skills.manifest.yaml"
LOCK="$TARGET_REPO/.agents/skills.lock"

parse_required_skills() {
  awk '
    /^## Related skills/ { in_section=1; next }
    /^## / && in_section { exit }
    in_section { print }
  ' "$WORKFLOW_FILE" \
  | grep -oE '`[A-Za-z0-9._-]+`' \
  | tr -d '`' \
  | sort -u
}

mapfile -t REQUIRED_SKILLS < <(parse_required_skills)
if [ "${#REQUIRED_SKILLS[@]}" -eq 0 ]; then
  echo "No required skills parsed from $WORKFLOW_FILE" >&2
  exit 1
fi

mkdir -p "$TARGET_REPO/.agents/skills" "$TARGET_REPO/scripts"

for skill in "${REQUIRED_SKILLS[@]}"; do
  src="$SKILL_HUB/$skill"
  dst="$TARGET_REPO/.agents/skills/$skill"

  if [ ! -d "$src" ]; then
    echo "Missing custom skill source: $src" >&2
    exit 1
  fi

  rm -rf "$dst"
  cp -R "$src" "$dst"
done

SKILL_HUB_COMMIT="$(git -C "$SKILL_HUB_ROOT" rev-parse HEAD)"

{
  echo "version: 1"
  echo "required_skills:"
  for skill in "${REQUIRED_SKILLS[@]}"; do
    echo "  - $skill"
  done
  echo "source:"
  echo "  mode: remote"
  echo "  repo: ${SKILL_HUB_REPO:-https://github.com/wildmaker/skills-sync.git}"
  echo "  ref: ${SKILL_HUB_REF:-main}"
  echo "version_policy:"
  echo "  strategy: pinned_commit"
} > "$MANIFEST"

# Update lock in place (rewrite file content, keep path stable if it already exists).
tmp_lock="$(mktemp)"
{
  echo "version: 1"
  echo "skill_hub:"
  echo "  repo: ${SKILL_HUB_REPO:-https://github.com/wildmaker/skills-sync.git}"
  echo "  ref: ${SKILL_HUB_REF:-main}"
  echo "  commit: $SKILL_HUB_COMMIT"
  echo "skills:"
  for skill in "${REQUIRED_SKILLS[@]}"; do
    echo "  - name: $skill"
    echo "    commit: $SKILL_HUB_COMMIT"
  done
} > "$tmp_lock"
mv "$tmp_lock" "$LOCK"
```

Verification (all required):

```bash
test -f <target-repo>/.agents/skills.manifest.yaml
test -f <target-repo>/.agents/skills.lock
while read -r s; do
  test -f "<target-repo>/.agents/skills/$s/SKILL.md"
done < <(awk '/^required_skills:/,/^[^[:space:]-]/{if($1=="-")print $2}' <target-repo>/.agents/skills.manifest.yaml)
```

## Skills Doctor (Mandatory)

Create `scripts/skills-doctor.sh` and make it executable. It must check:

- required skills in manifest all exist in `.agents/skills`
- lock and manifest skill sets are consistent
- each required skill has `SKILL.md` and non-empty content
- strict mode fails if undeclared skills are present

Example invocation:

```bash
scripts/skills-doctor.sh --strict
```

Hook policy:

- `after_create`: run doctor after bootstrap (optional sync, required verify)
- `before_run`: run doctor and fail-fast if validation fails

CI policy (mandatory):

- Add a CI step to run strict doctor even when workspace hooks are not triggered.
- Recommended workflow file: `.github/workflows/skills-doctor.yml`

```yaml
name: skills-doctor
on:
  pull_request:
  push:
    branches: [main]
jobs:
  doctor:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate required skills
        run: scripts/skills-doctor.sh --strict
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

If Skill Hub source resolution fails:

1. Report source mode attempted (`remote` or `local`) and exact error.
2. If remote failed, ask whether to retry with:
   - a pinned `SKILL_HUB_REF`, or
   - explicit local `SKILL_HUB_ROOT`.
3. If local failed, ask for corrected `SKILL_HUB_ROOT` or permission to use remote.
4. Do not continue with partial/mixed source state.

If post-setup workflow replacement fails:

1. Report source path, target path, and exact error.
2. Stop and ask whether to retry with corrected paths.
3. Do not continue with default template as final state.

If custom skill override fails:

1. Report mapping item, source path, target path, and exact error.
2. Stop and ask whether to retry with corrected paths.
3. Do not continue with mixed official/custom skills as final state.

If manifest/lock/doctor checks fail:

1. Report exact file + check that failed.
2. Stop and ask whether to auto-repair by re-syncing required skills and regenerating lock.
3. Do not continue to runtime with invalid skill state.
