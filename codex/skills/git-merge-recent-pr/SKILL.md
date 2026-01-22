---
name: git-merge-recent-pr
description: 提供 git-merge-recent-pr 的操作流程与约束；适用于 需要合并最近的 PR 并同步本地主分支时使用。
version: 0.0.0
---

# git-merge-recent-pr

## What this skill does
- 查找最近 PR 的 ID
- 处理冲突并通过 GitHub CLI 合并
- 更新本地 main 与远端保持一致

## Constraints
- 有冲突时必须先解决再合并
- 合并后需同步本地 main

## Allowed commands
- `gh`
- `git`

## Steps
1. 从近期对话或上下文中确定 PR ID。
2. 检查是否存在冲突。
3. 无冲突则使用 `gh` 直接合并；有冲突则解决后合并。
4. 更新本地 main 分支到远端最新状态。
