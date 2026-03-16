---
name: harness-review
description: |
  Operational procedures for the multi-round autonomous PR review sweep:
  bot detection, polling, cross-reviewer dedup, local self-review dimensions,
  and batch resolution. Read when executing review sweep rounds in WORKFLOW.md
  or when manually running harness-agent-review-loop.
---

# Harness Review

Operational guide for executing review sweep rounds. The WORKFLOW.md (or the
standalone `harness-agent-review-loop` skill) owns the loop structure and gate
conditions. This skill covers the **how**.

## Local self-review dimensions

Review the current diff (`<base>...HEAD`) against these five dimensions. For
each, check the listed signals and fix High/Medium issues before pushing.

### Architecture
- Layer boundaries respected (no domain logic in presentation, no DB in API handlers).
- Dependency direction correct (inner layers do not import outer).
- Module responsibilities clear and single-purpose.

### Tests
- Critical paths have test coverage or regression protection.
- Changed behavior has at least one targeted test proving the new behavior.
- No tests removed without justification.

### Security
- User inputs validated and sanitized at boundaries.
- No secrets, keys, or credentials committed.
- Auth and authz checks present where needed.

### Performance
- No obvious N+1 queries or unbounded loops.
- No blocking calls on hot paths.
- Resource cleanup present (file handles, connections).

### Docs
- Behavior changes reflected in relevant documentation.
- API changes reflected in OpenAPI/spec docs if applicable.
- README or usage docs updated if public interface changed.

## Bot detection and polling

### Identifying bot reviewers

| Bot | Author pattern match (case-insensitive) |
|---|---|
| Cursor Bugbot | `cursor`, `bugbot`, `cursor[bot]` |
| Gemini Code Assist | `gemini-code-assist`, `gemini`, `google` (with code-review context) |

When a comment's author cannot be matched to a known bot, tag it
`unknown-source`. Do not discard it - include it in the unified findings list
for the main loop to process.

### Polling strategy

- Poll every **60 seconds** using `gh` CLI commands.
- Per-bot timeout: Cursor Bugbot **10 minutes**, Gemini Code Assist **15 minutes**.
- Stop conditions (whichever comes first):
  - All configured bots have returned at least one signal (review, inline comment, or conversation comment) **after the latest push**.
  - The per-bot timeout is reached for each bot.
- If a bot times out without responding, proceed with whatever signals are available. Note the timeout in the workpad.

### Detecting "after the latest push"

Compare comment `createdAt` timestamps against the latest push timestamp
(`git log -1 --format=%cI`). Only count bot signals created after that
timestamp.

## Cross-reviewer dedup

When multiple reviewers (local self-review, Bugbot, Gemini, human) comment on
the same code area, merge them before fixing:

1. Group all comments by `file path + line range` (exact line or overlapping ranges within 5 lines).
2. For each group:
   - Priority: take the **highest** across all comments (High > Medium > Low).
   - Fix suggestion: take the **most specific** actionable suggestion.
   - Source attribution: list all contributing reviewers.
3. Output a unified todo list. Each entry has: file, line range, priority, merged description, source reviewers.

## Batch resolution procedure

After dedup, resolve all findings in a single batch:

1. Fix all High/Medium items in code (or post explicit, justified pushback as an inline reply on the original comment).
2. For each fix that addresses multiple reviewers' comments, reply on **each** original comment thread noting the fix.
3. Reply format: short explanation of what was fixed, or why it was declined with rationale.
4. Stage all changes: `git add -A`.
5. Single commit: `fix(review): address PR review comments` (include spec/issue reference if available).
6. Single push: `git push`. Avoid multiple pushes per round to prevent redundant re-review cycles.
7. For Low-priority items: optionally fix, but always note them in the workpad as acknowledged.

## Collecting signals (gh commands)

```sh
# PR review states (APPROVED, CHANGES_REQUESTED, COMMENTED)
gh pr view <pr-number> --json reviews --jq '.reviews[] | {author: .author.login, state: .state, body: .body}'

# Inline review comments
gh api repos/{owner}/{repo}/pulls/<pr-number>/comments --jq '.[] | {id: .id, author: .user.login, path: .path, line: .line, body: .body, created_at: .created_at}'

# Top-level conversation comments
gh api repos/{owner}/{repo}/issues/<pr-number>/comments --jq '.[] | {id: .id, author: .user.login, body: .body, created_at: .created_at}'
```

## Replying to comments

```sh
# Reply to an inline review comment
gh api -X POST /repos/{owner}/{repo}/pulls/<pr-number>/comments \
  -f body='[codex] <response>' -F in_reply_to=<comment_id>

# Post a top-level PR comment
gh pr comment <pr-number> --body '[codex] <response>'
```

All agent-generated comments must be prefixed with `[codex]`.
