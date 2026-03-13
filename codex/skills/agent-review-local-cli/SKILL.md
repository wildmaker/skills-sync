---
name: agent-review-local-cli
description: Run local agent self-review for the current PR diff before remote review. Use when you need Codex/agent CLI to inspect architecture, tests, security, performance, and docs dimensions and push pre-review fixes.
---

# agent-review-local-cli

## What this skill does
- 在本地对当前分支 diff 做智能体自审。
- 按维度输出问题，并优先修复 High/Medium。
- 作为远程 reviewer 之前的预清洗步骤，降低往返轮次。

## Inputs
- `<dimensions>`: 默认 `architecture,tests,security,performance,docs`。
- `<base-branch>`: 用于 diff（默认从当前 PR 自动推断）。

## Allowed commands
- `git`
- `gh`
- 本地测试命令（按仓库技术栈）

## Steps
1. 确定 diff 范围（`base...HEAD`）。
2. 按 `<dimensions>` 检查：
   - architecture：层次边界、依赖方向、模块职责。
   - tests：关键路径是否有测试与回归保护。
   - security：输入校验、密钥泄露、权限/鉴权风险。
   - performance：明显 N+1、低效循环、阻塞调用。
   - docs：行为变更是否同步文档。
3. 先修复 High/Medium，再运行最小验证。
4. 若有改动，直接提交并 push（无需人工确认）。
5. 输出本轮自审摘要和剩余风险。

