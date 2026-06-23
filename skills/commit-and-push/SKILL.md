---
name: commit-and-push
description: Summarize only the changes related to the current chat session, create a well-formed git commit for those changes, and push to a branch. Use when the user asks for quick commit, commit and push, summarize changes then commit, or to push committed work. If the user has not clearly specified the target branch, push to the current local branch by default.
---

# Commit And Push

## Goal

Turn only the current chat session's related changes into one clean commit, then
push it to the user-specified branch, or to the current local branch when the
user did not specify a branch.

## Branch Selection

- Optional target branch name.

If the user clearly specified the target branch, use that branch.

If the user did not clearly specify the target branch, infer the target from the
current local branch with `git branch --show-current`. Do not infer `main`,
`master`, or any other branch name.

If `git branch --show-current` returns an empty value because the repository is
in detached HEAD state, stop and ask which branch to push to. Do not create,
guess, or switch branches as part of this skill.

## Default Scope

The default commit scope is not "everything dirty in the working tree." It is
only the changes that are attributable to the chat session in which this skill
is invoked:

- files created or edited by the agent in the current conversation;
- files explicitly discussed as part of the current conversation's task;
- follow-up edits that are clearly part of the current conversation's requested
  work.

Do not ask the user to choose between broad working-tree buckets just because
the repo has many unrelated changes. Leave unrelated dirty files unstaged.

If the current session-related files cannot be identified with confidence, ask a
narrow clarification such as: "I can only commit changes from this chat session,
but I cannot reliably identify them. Which files from this session should be
included?" Do not offer "commit all working tree changes" unless the user
explicitly asks for it.

## Workflow

1. Identify the target branch:
   - use the branch named in the user's request when present;
   - otherwise use the current local branch from `git branch --show-current`;
   - if no current local branch exists, stop and ask for a target branch.
2. Identify the session-related file set before staging anything. Use the
   conversation context, tool/edit history, and files explicitly discussed in
   this chat. Treat this file set as the default commit boundary.
3. Inspect current repo state:
   - `git branch --show-current`
   - `git status --short`
   - `git diff -- <session-related-files>`
   - `git diff --staged -- <session-related-files>`
   - `git log -5 --oneline`
4. Summarize the session intent and the scoped diff. Treat the scoped diff as
   the source of truth when session context and files disagree.
5. Stage only session-related changes. Include untracked files only when they
   were created or explicitly requested in this chat session.
6. If `git status --short` shows unrelated dirty files, mention that they were
   left unstaged. Do not ask the user whether to include them.
7. Before committing, stop and ask only if a session-related file looks
   generated, secret-bearing, or too broad for one commit.
8. If no session-related changes exist, stop and report that there is nothing
   from this chat session to commit.
9. Create one commit with a concise conventional subject and a body containing:
   - Summary
   - Rationale
   - Tests or validation run, or `not run` with a reason
10. Push the commit to the selected target branch:
   - If already on the target branch, use `git push -u origin HEAD`.
   - If on a different branch, push the current HEAD to the target branch with
     `git push -u origin HEAD:<target-branch>`.
11. If the push is rejected because the remote moved, stop and report the exact
   rejection. Do not force push unless the user explicitly approves
   `--force-with-lease`.
12. Reply with:
   - Commit hash and subject
   - Target branch pushed
   - Validation performed
   - Any unrelated dirty files left unstaged, summarized briefly

## Safety Rules

- Never commit secrets such as `.env`, credentials, private keys, or tokens.
- Never run `git reset --hard`, `git checkout --`, or other destructive cleanup
  commands as part of this skill.
- Never push directly to `main`, `master`, or any non-current branch unless the
  user named that branch in the request or answered the branch clarification
  question.
- When the user did not name a branch, push only to the current local branch
  discovered with `git branch --show-current`.
- Never use `git push --force`; use `--force-with-lease` only after explicit
  user approval.
- Do not create or update a pull request. This skill is only for commit and push.
- Never stage or commit unrelated pre-existing working-tree changes merely
  because they are present.
- Never present "commit all current working tree changes" as a default option.
  Only do that when the user explicitly asks to include everything.

## Commit Message Template

```text
<type>(<scope>): <short summary>

Summary:
- <what changed>

Rationale:
- <why it changed>

Tests:
- <command or "not run (reason)">
```

## Example Triggers

- "用快捷提交流程提交并推到 main"
- "用快捷提交流程提交并推送"
- "summarize changes in this chat session and commit and push to main"
- "commit and push this session"
- "commit and push this session to feature/foo"
- "快速提交并 push 到 develop"
