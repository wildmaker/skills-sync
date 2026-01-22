---
name: auto-build
description: 提供 auto-build 的操作流程与约束；适用于 用户明确提出 "auto build" 且提供产品/设计文档，需要自动化完成开发全流程时使用。
version: 0.0.0
---

# Skill: auto-build
## Trigger
@auto-build

## What this skill does
- 负责编排自动化开发流程
- 依次调用计划、上下文收集、BACKLOG 生成、Issue 创建、任务执行循环、最终复核

## Constraints
- 必须遵循仓库中的 `AGENTS.md` 的 Automatic Development Cycles 规则
- 未完成 BACKLOG 生成与 Issue 同步前不得开始编码
- 每次只执行一个 backlog item
- 使用仓库根目录 `BACKLOG.md`，为每个项目新增一个分组区块（不要创建子目录 BACKLOG）

## Allowed commands
- None

## Steps
1. 确认设计文档路径与项目根目录。
2. 运行 `design-plan` 生成开发计划并收集缺失上下文。
3. 运行 `backlog-generate` 在根目录 `BACKLOG.md` 中新增项目分组与任务清单。
4. 运行 `backlog-issue-sync` 在 GitHub 创建对应 issues，并回写到对应分组。
5. 逐条运行 `backlog-item-execute`，直到所有 backlog item 完成。
   - 每个 backlog item 必须创建全新的 `task/<backlog-id>` 分支；若同名分支已存在（本地或远端），需先清理后再创建新分支。
6. 每次创建 PR 后，必须每 1 分钟拉取一次 PR 评论；若 5 分钟内已获取到 Gemini 或其他代码助手评论则提前停止，否则超过 5 分钟停止。
7. 一旦获取到 Code Assist 评论，必须自行判断是否需要处理；如需处理，按评审修复流程执行并更新 PR；解决评论后自动提交并推送到对应 PR 分支。
8. 运行 `design-implementation-review` 进行最终复核并输出报告。
