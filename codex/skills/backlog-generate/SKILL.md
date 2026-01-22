---
name: backlog-generate
description: 提供 backlog-generate 的操作流程与约束；适用于 需要从设计文档或开发计划中拆分原子化任务，并生成 `BACKLOG.md` 时使用。
version: 0.0.0
---

# backlog-generate

## What this skill does
- 将需求拆分为可独立完成的 backlog item
- 输出包含 ID、描述、预期结果、状态的 `BACKLOG.md`

## Constraints
- 每个 backlog item 必须原子化、可独立完成
- 不添加设计文档之外的新功能

## Allowed commands
- `rg`
- `ls`
- `cat`
- `mkdir`
- `echo`

## Steps
1. 读取设计文档与 `PLAN.md`，提炼需求点与依赖。
2. 按照 `BL-001` 格式拆分原子化任务。
3. 在仓库根目录 `BACKLOG.md` 中新增一个项目分组区块，写入任务清单。
4. 如需求不明确，先向用户确认再继续拆分。
