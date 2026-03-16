---
name: tool-use-openspec
description: |
  Operational procedures for the OpenSpec CLI: creating, validating, applying,
  and archiving spec changes. Read when executing SDD loop steps that involve
  spec change management.
---

# Tool Use OpenSpec

Operational guide for the `openspec` CLI. The `WORKFLOW.md` owns the decision
logic (when to init, when to validate, when to archive). This skill covers the
**how**.

## Prerequisites

- `openspec` CLI is installed and on PATH.
- The repo has been initialized with OpenSpec (`OpenSpec/` directory exists at repo root).

## Creating a new change

```sh
openspec new change <spec-name>
```

This creates `OpenSpec/changes/<spec-name>/` with a skeleton structure. If the
directory already exists, reuse it - do not recreate.

### Required files to populate

After creation, write minimal content into these files:

| File | Purpose | Content guidelines |
|---|---|---|
| `proposal.md` | Change motivation and scope | Motivation, scope (what it covers), non-goals (what it does NOT cover), risks |
| `tasks.md` | Implementation subtask breakdown | Checklist of tasks; can start as a skeleton and refine during implementation |
| `specs/` | Spec deltas | Only the spec files that change for this ticket. Write minimal diffs, not full rewrites. Each file in `specs/` describes one aspect of the changed behavior |

Keep content focused: one change directory = one ticket = one coherent scope.

## Validating a change

```sh
openspec validate <spec-name> --strict
```

Strict mode enforces:
- All required files present (`proposal.md`, `tasks.md`, at least one file in `specs/`)
- No referential integrity violations (referenced specs exist)
- Schema compliance for structured spec formats

### Handling validation failures

1. Read the error output carefully - it specifies which file and which rule failed.
2. Fix the content (not the validation rules).
3. Re-run `openspec validate <spec-name> --strict`.
4. Repeat until all checks pass.

**Do not proceed to implementation without a passing strict validation.**

## Applying a change

```sh
openspec apply <spec-name>
```

This merges the spec deltas from `OpenSpec/changes/<spec-name>/specs/` into
the main spec tree (`OpenSpec/specs/`). The result is the updated canonical
spec that the implementation must conform to.

After applying:
- Review the merged spec to confirm it reflects the intended changes.
- The applied spec becomes the source of truth for implementation.

## Archiving a change

```sh
openspec archive <spec-name> --yes
```

This moves the change directory from `OpenSpec/changes/<spec-name>/` to
`OpenSpec/archive/<spec-name>/` (or equivalent per the repo's OpenSpec config).

### Archive workflow

1. Create an archive branch: `chore/archive-<spec-name>` from `<epic-branch>`.
2. Run the archive command.
3. Commit: `chore(openspec): archive <spec-name>`.
4. Push and create PR to `<epic-branch>`.
5. The archive PR should go through at least a lightweight review (CI green, no High/Medium comments).

Archive is mandatory after the implementation PR merges. Do not skip it.

## Common errors

| Error | Cause | Fix |
|---|---|---|
| `Change already exists` | `OpenSpec/changes/<spec-name>/` already present | Reuse existing directory; do not delete and recreate |
| `Missing required file: proposal.md` | Skeleton not populated | Write the file with at least motivation and scope |
| `No specs found` | `specs/` directory empty | Add at least one spec delta file |
| `Referenced spec not found` | A spec delta references a base spec that doesn't exist | Check the spec name/path; create the base spec if it's new |
| `Archive target not found` | Trying to archive a non-existent change | Verify `<spec-name>` matches the directory name exactly |

## Directory structure reference

```text
OpenSpec/
|- specs/           # Canonical spec tree (source of truth)
|- changes/         # Active changes (one directory per in-flight ticket)
|  \- <spec-name>/
|     |- proposal.md
|     |- tasks.md
|     \- specs/     # Deltas to apply
\- archive/         # Completed changes (moved here after merge)
```
