---
name: git-add-pr
description: 提供 git-add-pr 的操作流程与约束；适用于 需要基于近期改动创建 PR 并推进评审流程时使用。
---

# git-add-pr

## What this skill does
- 编排 PR 创建、评论处理与合并流程
- 汇总已解决与未解决的评论（带优先级标签）

## Constraints
- 必须等待 5 分钟后再处理评审
- 需依次执行：创建 PR → 处理评论 → 合并

## Allowed commands
- `git-create-pr`
- `sleep`
- `git-resolve-pr-comments`
- `git-merge-recent-pr`

## Steps
1. 运行 `git-create-pr` 完成分支创建与 PR 提交。
2. 等待 5 分钟后运行 `git-resolve-pr-comments`。
3. 运行 `git-merge-recent-pr` 完成合并。
4. 输出已解决/未解决评论清单，并标注优先级。
