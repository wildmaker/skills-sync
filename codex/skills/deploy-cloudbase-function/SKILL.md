---
name: deploy-cloudbase-function
description: 提供 deploy-cloudbase-function 的操作流程与约束；适用于 需要部署云开发（CloudBase）函数时使用。
version: 0.0.0
---

# deploy-cloudbase-function

## What this skill does
- 优先使用已有 deploy 脚本完成部署
- 无脚本时使用 `tcb` CLI 进行部署

## Constraints
- 优先使用项目内现有部署脚本
- 未确认函数名时需先询问

## Allowed commands
- `tcb functions deploy`

## Steps
1. 查找并优先使用项目内的 deploy 脚本执行部署。
2. 如无脚本，使用 `tcb functions deploy [function]` 部署。
3. 汇报部署结果或错误信息。
