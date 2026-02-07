---
name: gh-backlog-issue
description: Create GitHub Issues from backlog items using GitHub CLI. Use when asked to add issues in the current repo for entries in `BACKLOG.md` or similar task lists.
version: 0.1.0
---

# Gh Backlog Issue

## Overview

Create GitHub Issues from backlog items and keep the creation flow consistent and traceable using `gh`.

## Default labels (recommended)
- **Type (required)**: `type/spec`, `type/bug`, `type/chore`
- **Priority (required)**: `priority/P0`, `priority/P1`, `priority/P2`, `priority/P3`
  - For **spec**: priority is based on how important the item is to the Epic (Demo/MVP/core happy path)
  - For **bug**: priority is based on severity (crash/data loss/security/core flow blocker)
- **Epic (optional but recommended)**: `epic/<epic-name>`

## Workflow

1. Confirm the target repo and backlog file.
   - Use `gh repo view` or `git remote -v` if the repo is unclear.
   - Locate `BACKLOG.md` (or the user-specified backlog file) in the repo.
2. Identify backlog items to publish.
   - Ensure each item has a stable ID and a concise description.
   - Ask if the user wants all items or a subset created.
   - Derive labels per item (type + priority; optionally epic).
3. Create issues with `gh`.
   - Prefer **stable slug titles** (no `BL-xxx` prefix):
     - Default: `title = <spec-name>` (or equivalent stable slug from the backlog item)
     - Fallback: `title = <clean title>` (strip `BL-xxx` / status markers)
   - Use `gh issue create -t "<title>" -b "<body>"`
   - Include the project document or backlog reference in the issue body.
   - Ensure required labels exist before applying them:
      - `gh label list`
      - `gh label create ...` (only for missing ones)
   - Add labels (type + priority; optionally epic). If issue already exists, do not recreate it—add missing labels via `gh issue edit --add-label`.
   - If `gh` reports the issue already exists (same title or ID), do NOT delete it. Avoid changing title/body; label-only edits are allowed. If you still need a new issue, create a safe suffix:
     - Title: `<title>-<n>` (increment `n` until unique)
     - Body: add a line `Original ID: <ID>` to preserve traceability.
4. Capture issue URLs/IDs and report results.
   - If requested, update `BACKLOG.md` to include issue numbers.
5. Summarize created issues and any items skipped.

## Issue Body Template

Use a simple, consistent body:

```text
Source: <path/to/BACKLOG.md>
Backlog item: <ID> - <description>
Original ID: <ID> (only if a suffix was added)
```
