---
name: pre-merge-regression-audit
description: Audit a feature branch before merge to detect unintended side effects, lost capabilities, and base-branch drift. Use when comparing current branch vs main for merge safety, especially after long-running feature work, rebase/cherry-pick, or when core user flows may have regressed.
---

# Pre-Merge Regression Audit

## Overview
Run a diff-driven pre-merge audit that answers three questions with evidence: what changed, what might be broken, and whether rebase-to-main is sufficient.

## Workflow

### 1. Establish comparison baseline
1. Confirm branch and cleanliness.
2. Fetch latest `main`.
3. Record merge base and divergence counts.

Use:
```bash
git rev-parse --abbrev-ref HEAD
git fetch origin --quiet
git merge-base main HEAD
git rev-list --left-right --count main...HEAD
```

Interpretation:
- `left(main) > 0`: branch is behind main; drift risk exists.
- Large `right(HEAD)`: long-lived branch; side-effect risk increases.

### 2. Identify impact surface first
List changed files and isolate critical feature paths.

Use:
```bash
git diff --name-status main..HEAD
```

Then narrow to business-critical modules (for example: add-book page, OCR service, upload/create APIs, persistence path).

### 3. Trace the core user flow end-to-end
For each high-risk flow, verify call chain continuity instead of single-file checks.

Recommended chain:
1. UI trigger
2. Recognition/extraction pipeline
3. Network endpoint/model
4. Create/save API
5. Failure fallback

Use code search + targeted diffs:
```bash
git diff main..HEAD -- <key-file>
grep -RIn "<function-or-endpoint-keyword>" <paths>
```

### 4. Detect unintended side effects
Classify findings by severity:
- High: capability removed, endpoint/model removed, save path broken.
- Medium: duplicate submission risk, fallback behavior weakened, silent failure.
- Low: UX-only or logging-only changes.

Always include file+line evidence for each finding.

### 5. Determine if issue is branch-drift or branch-introduced
Check whether suspicious files changed on the feature branch since merge base.

Use:
```bash
git diff --name-status $(git merge-base main HEAD)..HEAD -- <suspect-files>
git log --oneline $(git merge-base main HEAD)..main -- <suspect-files>
```

Decision rule:
- File unchanged on feature branch but changed on main: likely base drift.
- File changed on feature branch after merge base: likely branch-introduced regression.

### 6. Validate rebase recoverability
If drift is likely, run a dry-run rebase check in a clean worktree.

Use:
```bash
tmp=$(mktemp -d /tmp/rebase-check-XXXXXX)
git worktree add "$tmp" HEAD
cd "$tmp"
git rebase main
```

Evaluate:
- No conflicts: rebase likely sufficient.
- Conflicts in critical files: manual merge required; re-check core flow after merge.

Abort and clean:
```bash
git rebase --abort || true
cd -
git worktree remove -f "$tmp"
```

### 7. Produce merge-safety verdict
Return one of:
- Safe to merge
- Conditionally safe (after listed fixes)
- Not safe to merge

Include:
1. Findings ordered by severity
2. Whether each is drift-caused or branch-caused
3. Exact remediation (rebase only vs manual conflict merge vs code fix)
4. Verification evidence (build/test/diff checks run)

## Output Template
Use this concise structure:

```markdown
结论: [Safe / Conditional / Not Safe]

High:
- [issue] (`/abs/path/file.swift:line`)

Medium:
- [issue] (`/abs/path/file.swift:line`)

Drift 判断:
- [yes/no + evidence]

Rebase 可解性:
- [auto / conflict in <file>]

建议:
1. [next action]
2. [next action]
```

## Guardrails
- Do not infer flow integrity without file-level evidence.
- Do not ignore `main` updates when branch is behind.
- Do not conclude “safe” before checking create/save path and failure fallback.
- Keep unrelated local workspace files out of commits (for example editor/workspace artifacts).
