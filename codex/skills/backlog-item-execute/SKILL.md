---
name: backlog-item-execute
description: 提供 backlog-item-execute 的操作流程与约束；适用于 需要执行单个 backlog item 的端到端开发流程时使用。
version: 0.0.0
---

# backlog-item-execute

## What this skill does
- 按 Automatic Development Cycles 完成单个 backlog item
- 创建任务分支、编码、提交 PR、处理评审、合并

## Constraints
- 必须只处理一个 backlog item
- 禁止直接提交到 project 分支或 main
- 未获得评审通过不得合并

## Allowed commands
- `git`
- `gh`
- `cat`
- `rg`
- `git-create-pr`
- `git-resolve-pr-comments`
- `git-merge-recent-pr`

## Steps
1. 确认 backlog item（ID、描述、期望结果）与对应 issue。
2. 基于 project 分支创建 `task/<backlog-id>` 分支并开始编码。
3. 完成编码后提交本地变更，提交信息遵循 `<type>(<backlog-id>): <summary>`。
4. 运行 `git-create-pr` 创建 PR，确保 PR 关联对应 issue。
5. 等待远程评审完成，使用 `git-resolve-pr-comments` 拉取评论并处理高/中优先级问题。
6. 评审问题修复并提交后，使用 `git-merge-recent-pr` 合并到 project 分支。
7. 更新根目录 `BACKLOG.md` 中对应项目分组的该项状态为完成，并记录 PR/issue 关联信息。
