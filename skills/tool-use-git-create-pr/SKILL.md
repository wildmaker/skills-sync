---
name: tool-use-git-create-pr
description: Deprecated. Use `tool-use-push` skill in `skills/push` for branch-safe push + PR creation.
version: 0.2.0
---

# git-create-pr

## Status
- 已废弃，不再作为主流程入口。
- 请改用 `tool-use-push` 技能：`skills/tool-use-push/SKILL.md`。

## Why deprecated
- `tool-use-push` 已整合本技能能力，并增加 base 分支护栏：
  - 先确定 `base`
  - 读取 `current`
  - 若 `current == base`，强制新建 `head`
  - 再执行 push + PR（`head -> base`）
  - 若 `current != base`，按原流程直接发布当前分支

## Migration
- 旧调用：`git-create-pr`
- 新调用：`tool-use-push`

## Backward compatibility
- 若历史文档仍提到 `git-create-pr`，应在执行时自动跳转到 `tool-use-push` 流程理解，不再维护独立实现。
