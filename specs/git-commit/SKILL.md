# git-commit

## Purpose
Define the workflow and constraints for creating a local git commit from current changes.

## Workflow
1. Review current changes and summarize in Chinese.
2. Compose a concise commit message and run `git commit`.

## Constraints
- Commit message must reflect actual changes.
- Do not run `git push` or `git commit --amend` without explicit confirmation.
- Default message format is `<type>(<backlog-id or PR-id>): <summary>`.
- If the user explicitly requests ignoring the ID, use `<type>: <summary>`.

## Allowed commands
- `git status`
- `git diff`
- `git add`
- `git commit`
