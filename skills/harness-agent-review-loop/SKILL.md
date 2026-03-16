---
name: harness-agent-review-loop
description: |
  Execute a multi-round autonomous PR review loop: self-review, wait for bot
  reviewers, collect and resolve comments, repeat until gates pass or max rounds
  reached. Use for manual/human-triggered review on any PR branch - this is the
  standalone entry point. Symphony agents use the inline protocol in WORKFLOW.md
  instead.
---

# Harness Agent Review Loop (standalone)

Autonomous multi-round PR review loop. This skill is a self-contained entry
point for manual invocation (e.g. from Cursor or CLI). It embeds the full
decision logic and references the `harness-review` skill for operational procedures.

## When to use

- You have a branch with a PR (or are about to create one) and want autonomous
  agent-driven review before human review.
- You are NOT inside a Symphony WORKFLOW.md session (Symphony agents use the
  inline review sweep protocol instead).

## Inputs

- `<base-branch>`: PR target branch (e.g. `epic/user-search` or `main`).
- `<issue>` (optional): issue reference to link in the PR.
- `<dimensions>`: review dimensions list. Default:
  `architecture,tests,security,performance,docs`.
- `<max-rounds>`: maximum review loop iterations. Default: `6`.
- `<merge-policy>`: `auto-merge` | `human-escalation`. Default: `human-escalation`.

## Steps

### 1. Ensure PR exists

- If the current branch has no open PR, create one:
  - Target: `<base-branch>`
  - Title: clear description of the change
  - Body: reference `<issue>` if provided
  - Label: `symphony` (if in a Symphony-enabled repo)
- If a PR already exists, confirm the branch is pushed and PR is queryable.

### 2. Run review loop (max `<max-rounds>` rounds)

For each round:

#### 2a. Local self-review

- Review the diff (`<base-branch>...HEAD`) against `<dimensions>`.
- If `<dimensions>` is omitted, use:
  architecture, tests, security, performance, docs.
- Read the `harness-review` skill for the dimension checklists.
- Fix any High/Medium findings. Commit and push (single commit per round).

#### 2b. Wait for bot reviewers

- Read the `harness-review` skill for bot detection heuristics and polling strategy.
- Poll for Cursor Bugbot and Gemini Code Assist signals.
- Do not proceed until bots have responded or timed out.
- Optional reference: `agent-review-loop-fetch-bot-reviews` can be used as a
  reusable implementation of this step.

#### 2c. Collect signals from all three sources

Gather from ALL of these (missing any = incomplete round):

1. **PR reviews**: `gh pr view <pr> --json reviews`
   - Check for `APPROVED`, `CHANGES_REQUESTED`, `COMMENTED` states.
2. **PR inline comments**: `gh api repos/{owner}/{repo}/pulls/<pr>/comments`
3. **PR conversation comments**: `gh api repos/{owner}/{repo}/issues/<pr>/comments`

#### 2d. Classify priority

Use deterministic rules (do not guess):

| Priority | Triggers |
|---|---|
| **High** | Review state `CHANGES_REQUESTED`; comment contains: `blocker`, `security`, `crash`, `data loss`, `P0`, `High`, `必须`, `阻塞` |
| **Medium** | Comment contains: `should`, `needs`, `recommend`, `P1`, `Medium`, `建议`, `推荐` |
| **Low** | Everything else (style, nit, spelling). Does not block. |

#### 2e. Dedup and resolve

- Read the `harness-review` skill for cross-reviewer dedup algorithm and batch
  resolution procedure.
- Fix all High/Medium or post explicit justified pushback on each.
- Single commit + push per round.
- Optional reference: `agent-review-loop-resolve-pr-comments` can be used as a
  reusable implementation of signal collection + dedup + resolution.

#### 2f. Gate check

Pass requires ALL of:
- No unresolved High/Medium comments.
- PR is not in `CHANGES_REQUESTED` state (or all such reviews have been
  addressed and re-requested).
- All three signal sources have been checked.

If **pass** -> exit loop, proceed to exit strategy.
If **fail** -> next round.

### 3. Exit strategy

| Condition | Action |
|---|---|
| Gate passed + `auto-merge` | Merge: `gh pr merge --squash` (or repo default) |
| Gate passed + `human-escalation` | Post summary comment, mark ready for human review |
| Max rounds reached, gate not passed | Output remaining blockers, do NOT merge |

### 4. Output

Per round:
- `Round N`: new findings (High/Medium/Low), fixes pushed, remaining blockers.

Final:
- `Decision`: `auto-merged` | `escalated-to-human` | `blocked`
- `Rationale`: summary of what passed/failed and why.

## Constraints

- Never do infinite loops. Hard stop at `<max-rounds>`.
- Every round must re-fetch all three signal sources. Do not cache across rounds.
- High/Medium comments must be resolved (fixed or explicitly declined with
  rationale). Low comments are optional but should be logged.
- Prefer single commit + push per round to minimize re-review churn.
- This skill remains a standalone protocol. References to other skills are
  optional implementation aids, not required hard dependencies.
