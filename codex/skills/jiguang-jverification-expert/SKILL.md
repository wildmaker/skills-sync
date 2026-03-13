---
name: jiguang-jverification-expert
description: Expert skill for Jiguang JVerification iOS documentation lookup and integration support. Use when Codex needs to answer questions about JVerification iOS setup, SDK import, API usage, error codes, or best practices, and when answers should be grounded in local snapshots of official docs that can be refreshed from docs.jiguang.cn.
---

# Jiguang JVerification Expert

## Overview

Use this skill as a lightweight knowledge base for JVerification iOS.
Focus on accurate answers with clear sources, while keeping full flexibility in how you search and reason.

## Available Resources

- `references/official_sources.txt`: official doc URLs.
- `references/official_docs/index.md`: local snapshot index with timestamps.
- `references/official_docs/*.md`: local text copies of official pages.
- `scripts/fetch_official_docs.py`: refresh local snapshots from official URLs.
- `scripts/query_docs.py`: optional local keyword query helper.

## Working Principles

- Prefer local snapshots for speed and reproducibility.
- Refresh snapshots when freshness matters (for example, "latest", version updates, changelog questions).
- Keep answers source-grounded: include official URL and snapshot time when relevant.
- If refresh fails, continue with the latest local snapshot and clearly mark it as potentially stale.
