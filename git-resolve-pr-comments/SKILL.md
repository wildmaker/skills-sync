---
name: git-resolve-pr-comments
description: 提供 git-resolve-pr-comments 的操作流程与约束；适用于 需要拉取 PR 评论并处理高/中优先级意见时使用。
---

# git-resolve-pr-comments

## What this skill does
- 切换到 PR 分支并拉取最新代码
- 使用 GitHub CLI 拉取评论并轮询最多 7 次
- 解决高/中优先级评论并给出汇总

## Constraints
- 每次轮询间隔 1 分钟，最多 7 次
- 提交前必须征得用户确认

## Allowed commands
- `git`
- `gh`
- `sleep`

## Steps
1. 切换并拉取 PR 分支；不确定分支时先询问。
2. 使用 `gh` 获取 PR 评论，每 1 分钟轮询一次，最多 7 次。
3. 处理高/中优先级评论并记录处理情况。
4. 输出已解决/未解决汇总。
5. 询问是否提交；确认后执行 `git add`、`git commit`、`git push`。
