---
name: git-commit
description: Document git-commit skill workflow and constraints
---

# git-commit

## Purpose
Define the workflow and constraints for creating a local git commit from current changes.

## Workflow
1. Review current changes and summarize in Chinese.
2. Identify changes created in the current session; stage and commit only those by default.
3. If other unrelated changes exist, after committing session changes, ask whether to create an additional commit for the remaining changes.
4. Compose a concise commit message and run `git commit`.

## Constraints
- Commit message must reflect actual changes.
- Do not run `git push` or `git commit --amend` without explicit confirmation.
- Default message format is `<type>(<backlog-id or PR-id>): <summary>`.
- If the user explicitly requests ignoring the ID, use `<type>: <summary>`.
- By default, only commit changes produced in the current conversation; do not include pre-existing or unrelated changes unless the user confirms a separate commit.

## Allowed commands
- `git status`
- `git diff`
- `git add`
- `git commit`
- `git stash`
