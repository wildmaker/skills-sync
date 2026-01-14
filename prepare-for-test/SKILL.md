---
name: prepare-for-test
description: 提供 prepare-for-test 的操作流程与约束；适用于 需要为指定功能准备测试条件时使用。
---

# prepare-for-test

## What this skill does
- 先理解功能现有实现逻辑
- 汇总测试准备要点并检查环境变量

## Constraints
- 先理解实现再开始测试准备
- 必须通过 `check-env` 检查环境变量

## Allowed commands
- `check-env`

## Steps
1. 阅读相关代码，理解功能实现逻辑。
2. 汇总测试准备要点（环境变量、依赖服务、依赖包、推荐环境、注意事项）。
3. 运行 `check-env` 检查环境变量是否齐全。
