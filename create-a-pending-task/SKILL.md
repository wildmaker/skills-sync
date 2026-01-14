---
name: create-a-pending-task
description: 提供 create-a-pending-task 的操作流程与约束；适用于 需要把讨论中的问题整理为研发待办任务时使用。
---

# create-a-pending-task

## What this skill does
- 汇总问题现状、原因、影响与建议方案
- 生成任务文档 `docs/tasks/task-<name>.md`

## Constraints
- 文档必须包含四个要点：现状、原因、影响、解决方案
- 不添加与讨论无关的内容

## Allowed commands
- None

## Steps
1. 汇总问题现状、问题原因、问题影响与建议方案。
2. 以 `docs/tasks/task-<name>.md` 创建任务文档。
3. 返回创建的文档路径。
