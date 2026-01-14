---
name: git-commit
description: 提供 git-commit 的操作流程与约束；适用于 需要在当前分支提交本地变更时使用。
---

# git-commit

## What this skill does
- 用中文总结本次变更
- 生成并提交本地 commit

## Constraints
- 提交信息必须基于实际变更
- 未经确认不执行 `git push` 或 `--amend`

## Allowed commands
- `git status`
- `git diff`
- `git add`
- `git commit`

## Steps
1. 查看当前变更并用中文总结要点。
2. 组织简洁提交信息并执行 `git commit`。
