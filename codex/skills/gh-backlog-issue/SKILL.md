---
name: gh-backlog-issue
description: Create GitHub Issues from backlog items using GitHub CLI. Use when asked to add issues in the current repo for entries in `BACKLOG.md` or similar task lists.
version: 0.0.0
---

# Gh Backlog Issue

## Overview

Create GitHub Issues from backlog items and keep the creation flow consistent and traceable using `gh`.

## Workflow

1. Confirm the target repo and backlog file.
   - Use `gh repo view` or `git remote -v` if the repo is unclear.
   - Locate `BACKLOG.md` (or the user-specified backlog file) in the repo.
2. Identify backlog items to publish.
   - Ensure each item has a stable ID and a concise description.
   - Ask if the user wants all items or a subset created.
3. Create issues with `gh`.
   - Use `gh issue create -t "<ID>: <title>" -b "<body>"`
   - Include the project document or backlog reference in the issue body.
   - Add labels if provided by the user (e.g., `-l backlog`).
   - If `gh` reports the issue already exists (same title or ID), do NOT delete or edit existing issues. Create a new issue with a safe suffix:
     - Title: `<ID>-<n>: <title>` (increment `n` until unique)
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
