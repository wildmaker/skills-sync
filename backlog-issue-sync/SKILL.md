---
name: backlog-issue-sync
description: 提供 backlog-issue-sync 的操作流程与约束；适用于 需要根据 `BACKLOG.md` 在 GitHub 上创建对应 issues 时使用。
---

# backlog-issue-sync

## What this skill does
- 为每个 backlog item 创建 GitHub Issue
- 必要时将 issue 编号回写到 `BACKLOG.md`

## Constraints
- 不能重复创建已存在的 issue
- issue 标题必须与 backlog item 一致

## Allowed commands
- `cat`
- `rg`
- `gh issue list`
- `gh issue create`

## Steps
1. 读取 `BACKLOG.md` 并整理待创建的 backlog items。
2. 使用 `gh issue list` 检查是否已有对应 issue。
3. 为缺失的 items 创建 issue，标题与描述保持一致，并在正文引用设计文档路径与 backlog item。
4. 如需要，将 issue 编号回写到 `BACKLOG.md`。
