---
name: git-create-pr
description: 提供 git-create-pr 的操作流程与约束；适用于 需要基于当前改动创建分支并提交 PR 时使用。
version: 0.0.0
---

# git-create-pr

## What this skill does
- 确保本地变更已提交
- 创建新分支并推送到远端
- 使用 GitHub CLI 创建 PR 并返回 PR 信息

## Constraints
- 未确认 PR 目标分支、标题或描述时必须先询问
- 未经确认不执行 `--amend`

## Allowed commands
- `git-commit`
- `git`
- `gh`

## Steps
1. 确认目标分支、PR 标题与描述信息。
2. 若本地变更未提交，先运行 `git-commit`。
3. 创建新分支并推送到远端。
4. 使用 `gh` 创建 PR 并输出链接与编号。
