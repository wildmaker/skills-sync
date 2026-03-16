---
name: tool-use-openspec-init-change
description: 将 SDD Loop 中“初始化 OpenSpec 变更 + 严格校验 + 准备实现分支”封装成可复用流程（不依赖 GitHub Issue）。
version: 0.3.0
---

# Skill: tool-use-openspec-init-change

## Trigger
@tool-use-openspec-init-change

## What this skill does
- 初始化一个 OpenSpec 变更（change）
- 严格校验该变更（strict validate）
- 确保实现分支就绪（`spec/<id>`）：为后续 `/openspec:apply <id>` 与编码准备（是否执行 apply 由调用方决定）

## Inputs
- `<id>`: OpenSpec change ID（例如：`add-user-search`）
- `<branch>`: spec 开头的 Git 分支名（默认建议：`spec/<id>`）

## Constraints
- change 内容必须最小化且聚焦（只包含本次需求的 spec deltas）
- 必须通过 `openspec validate <id> --strict` 后，才进入实现分支开始写代码
- 本流程不创建、不校验、也不依赖 GitHub Issue

## Allowed commands
- `tool-use-openspec`
- `openspec`
- `git`

## Steps
### 0) 准备实现分支（必须）
- 确保当前在 `<branch>`（建议 `spec/<id>`）：
  - 若分支不存在：从正确的基座分支创建（由调用方保证 base，例如 `epic/<epic-name>`）
  - 若分支存在：切换到该分支并拉取最新

### 1) 创建或复用 OpenSpec 变更
- 若 `OpenSpec/changes/<id>` 已存在：复用（不要重复创建）
- 否则执行：
  - `openspec new change <id>`
- 在变更目录内补全最小内容（先保证可校验，可在实现过程中迭代完善）：
  - `proposal.md`：变更动机 / 范围 / 非目标 / 风险
  - `tasks.md`：实现子任务拆分（允许先写骨架）
  - `OpenSpec/changes/<id>/specs/`：本次 spec deltas（只写与该变更相关的最小差异）

### 2) 严格校验 OpenSpec 变更（强制）
- 执行：
  - `openspec validate <id> --strict`
- 若失败：修正 change 内容直到 strict validate 通过（不得跳过）

### 3) 输出结果（供调用方继续）
- 返回/记录：
  - `<id>`（change ID）
  - `<branch>`（实现分支）
- 说明：是否执行 `/openspec:apply <id>` 由调用方决定（例如 `harness-feature` 的下一步）
