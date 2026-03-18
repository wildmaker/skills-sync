---
name: tool-use-push
description:
  Push changes to origin and create or update a pull request with base-branch
  guardrails. If current branch equals base branch, create a new head branch
  first; otherwise publish the current branch directly.
---

# Push

## Prerequisites

- `gh` CLI is installed and available in `PATH`.
- `gh auth status` succeeds for GitHub operations in this repo.

## Goals

- Push current branch changes to `origin` safely.
- Create a PR if none exists for the branch, otherwise update the existing PR.
- Keep branch history clean when remote has moved.
- Prevent direct PR work from `base` branch by creating a dedicated head branch
  when `current == base`.

## Related Skills

- `tool-use-pull`: use this when push is rejected or sync is not clean (non-fast-forward,
  merge conflict risk, or stale branch).

## Steps

1. Determine base branch (`base`) from explicit input/context (for example:
   `main`, `epic/*`, `project/*`).
2. Identify current branch (`current`) and confirm remote state.
3. If `current == base`, create and switch to a new head branch before push
   (for example `task/<slug>` or `chore/<slug>`), then continue with that head.
4. Run local validation (`make -C elixir all`) before pushing.
5. Push head branch to `origin` with upstream tracking if needed, using whatever
   remote URL is already configured.
6. If push is not clean/rejected:
   - If the failure is a non-fast-forward or sync problem, run the `tool-use-pull`
     skill to merge `origin/main`, resolve conflicts, and rerun validation.
   - Push again; use `--force-with-lease` only when history was rewritten.
   - If the failure is due to auth, permissions, or workflow restrictions on
     the configured remote, stop and surface the exact error instead of
     rewriting remotes or switching protocols as a workaround.

7. Ensure a PR exists for the head branch:
   - If no PR exists, create one.
   - If a PR exists and is open, update it.
   - If branch is tied to a closed/merged PR, create a new branch + PR.
   - Write a proper PR title that clearly describes the change outcome
   - For branch updates, explicitly reconsider whether current PR title still
     matches the latest scope; update it if it no longer does.
   - PR direction must be `head -> base` (never `base -> base`).
8. Write/update PR body explicitly using `.github/pull_request_template.md`:
   - Fill every section with concrete content for this change.
   - Replace all placeholder comments (`<!-- ... -->`).
   - Keep bullets/checkboxes where template expects them.
   - If PR already exists, refresh body content so it reflects the total PR
     scope (all intended work on the branch), not just the newest commits,
     including newly added work, removed work, or changed approach.
   - Do not reuse stale description text from earlier iterations.
9. Validate PR body with `mix pr_body.check` and fix all reported issues.
10. Reply with the PR URL from `gh pr view`.

## Commands

```sh
# Determine base branch (input/context)
base="${BASE_BRANCH:-main}"

# Identify current branch
current=$(git branch --show-current)

# If current == base, create a dedicated head branch first
if [ "$current" = "$base" ]; then
  head="task/$(date +%Y%m%d-%H%M%S)"
  git switch -c "$head"
else
  head="$current"
fi

# Minimal validation gate
make -C elixir all

# Initial push: publish head branch
git push -u origin HEAD

# If that failed because the remote moved, use the tool-use-pull skill. After
# pull-skill resolution and re-validation, retry the normal push:
git push -u origin HEAD

# If the configured remote rejects the push for auth, permissions, or workflow
# restrictions, stop and surface the exact error.

# Only if history was rewritten locally:
git push --force-with-lease origin HEAD

# Ensure a PR exists (create only if missing), direction: head -> base
pr_state=$(gh pr view --json state -q .state 2>/dev/null || true)
if [ "$pr_state" = "MERGED" ] || [ "$pr_state" = "CLOSED" ]; then
  echo "Current branch is tied to a closed PR; create a new branch + PR." >&2
  exit 1
fi

# Write a clear, human-friendly title that summarizes the shipped change.
pr_title="<clear PR title written for this change>"
if [ -z "$pr_state" ]; then
  gh pr create --base "$base" --head "$head" --title "$pr_title"
else
  # Reconsider title on every branch update; edit if scope shifted.
  gh pr edit --base "$base" --title "$pr_title"
fi

# Write/edit PR body to match .github/pull_request_template.md before validation.
# Example workflow:
# 1) open the template and draft body content for this PR
# 2) gh pr edit --body-file /tmp/pr_body.md
# 3) for branch updates, re-check that title/body still match current diff

tmp_pr_body=$(mktemp)
gh pr view --json body -q .body > "$tmp_pr_body"
(cd elixir && mix pr_body.check --file "$tmp_pr_body")
rm -f "$tmp_pr_body"

# Show PR URL for the reply
gh pr view --json url -q .url
```

## Notes

- Do not use `--force`; only use `--force-with-lease` as the last resort.
- Distinguish sync problems from remote auth/permission problems:
  - Use the `tool-use-pull` skill for non-fast-forward or stale-branch issues.
  - Surface auth, permissions, or workflow restrictions directly instead of
    changing remotes or protocols.
