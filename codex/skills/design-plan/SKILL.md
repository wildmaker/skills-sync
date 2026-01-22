---
name: design-plan
description: 提供 design-plan 的操作流程与约束；适用于 需要基于产品/设计文档输出开发计划，并识别缺失上下文信息时使用。
version: 0.0.0
---

# design-plan

## What this skill does
- 阅读设计文档并生成开发计划
- 列出必要的上下文资料清单（API 文档、第三方文档、协议等）
- 必要时请求用户将文档放入代码库

## Constraints
- 不做编码或 BACKLOG 拆分
- 不臆测缺失需求

## Allowed commands
- `rg`
- `ls`
- `cat`
- `mkdir`
- `echo`

## Steps
1. 阅读设计文档，提炼目标、范围、关键流程与依赖。
2. 生成开发计划（阶段/模块/里程碑）并输出到 `PLAN.md`。
3. 列出缺失的上下文资料，并请求用户补充到代码库。
4. 若用户补充了资料，更新 `PLAN.md` 的依赖与风险说明。
