---
name: auto-build
description: 提供 auto-build 的操作流程与约束；适用于 用户明确提出 "auto build" 且提供产品/设计文档，需要自动化完成开发全流程时使用。
version: 0.1.0
---

# Skill: auto-build
## Trigger
@auto-build

## What this skill does
- 作为“编排器（orchestrator）”串联多个子 skill，完成一次 auto build 项目的端到端交付
- 目标是把复杂流程拆成可独立复用、可逐步审阅的阶段：bootstrap -> backlog sync -> item execution loop -> final review

## Constraints
- 必须遵循仓库 `AGENTS.md` 的 Automatic Development Cycles 规则（仅在用户明确提出 "auto build" 时启用）
- 未完成 backlog 生成与 issue 同步前不得开始编码
- 每次只执行一个 backlog item
- 必须使用仓库根目录 `BACKLOG.md`（不要创建子目录/独立 BACKLOG）
- 本期项目必须先创建 `project/<document-name>` 分支作为承载分支；所有 task PR 的 base 必须为该 project 分支（不是 main）

## Allowed commands
- `auto-build-bootstrap`
- `auto-build-backlog-sync`
- `auto-build-execute-item`
- `auto-build-final-review`
- `git`
- `gh`
- `cat`
- `rg`

## Steps
1. 调用 `auto-build-bootstrap`：确认设计文档与项目根目录，创建 `project/<document-name>` 分支，并明确后续 task PR base 规则。
2. 调用 `auto-build-backlog-sync`：执行 `blueprint-compiler` -> `backlog-generate` -> `backlog-issue-sync`，产出可执行 backlog。
3. 进入执行循环：逐条调用 `auto-build-execute-item` 完成 backlog item（一次只做一个）。
4. 全部完成后调用 `auto-build-final-review`：在 project 分支上输出最终复核报告，留待人工集中检查与测试（除非用户明确要求再合并到 main）。
