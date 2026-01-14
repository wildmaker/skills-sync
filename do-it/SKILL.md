---
name: do-it
description: 提供 do-it 的操作流程与约束；适用于 用户希望把选中文本变成 TODO 并执行任务时使用。
---

# do-it

## What this skill does
- 将选中文本格式化为 Markdown TODO
- 执行对应任务并更新完成状态

## Constraints
- 仅处理用户选中的文本行
- 完成后必须更新 TODO checkbox 状态

## Allowed commands
- None

## Steps
1. 将选中行转换为 Markdown TODO 格式。
2. 逐条执行对应任务。
3. 完成后更新 TODO 的 checkbox 状态。
