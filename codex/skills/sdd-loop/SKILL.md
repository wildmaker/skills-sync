---
name: epic-sdd-loop
description: Epic 工作流的 SDD Loop：将根目录 `SDD-LOOP.md` 封装为可复用的单条 backlog item 交付流程（Issue ↔ Spec Change ↔ spec/* PR）。
version: 0.2.0
---

# Skill: epic-sdd-loop

## Trigger
@epic-sdd-loop

## Source of truth
- 根目录 `SDD-LOOP.md`
- 根目录 `epic-workflow.md`（术语与分支/合并约束）

## What this skill does
- 对**一个 backlog item**执行一次完整的 SDD Loop：从 `epic/<epic-name>` 创建 `spec/<spec-name>`，初始化 Issue + Spec Change，应用变更并实现，通过本地最小检查后创建/评审 PR，CI 全绿后合并回 Epic 分支，最后归档 Spec Change

## Inputs (recommended)
- `<epic-branch>`：默认 `epic/<epic-name>`（该 spec PR 的 base）
- `<spec-name>`：稳定 slug（同时作为 Spec Change 目录名与 change ID：`OpenSpec/changes/<spec-name>`）
- `<issue-title>`：用于创建/对齐 Issue（交给 `openspec-init-change`）
- （可选）`<issue>`：若 Issue 已存在，传入编号/链接供 PR 引用

## Outputs
- 分支：`spec/<spec-name>`（合并回 `<epic-branch>`）
- Issue：与该 spec 一一对应
- Spec Change：`OpenSpec/changes/<spec-name>`
- PR：`spec/<spec-name>` → `<epic-branch>`

## Constraints
- 一次只处理一个 backlog item。
- `spec/*` 分支必须基于且只能合并回 `<epic-branch>`；禁止直接面向 `main`。
- 以 Spec Change 为评审权威（single source of truth）。

## Allowed commands
- `openspec-init-change`
- `git-pr-review`
- `openspec`
- `git`
- `rg`

## Steps (mirrors `SDD-LOOP.md`)
1. 理解需求：阅读 backlog 条目与相关 spec/变更目标
2. 从 `<epic-branch>` 创建并切换到 `spec/<spec-name>`
3. 运行 `openspec-init-change` 初始化 Spec Change + Issue（inputs: `<spec-name>`, `<issue-title>`, `<branch>`；若 Issue 已存在则传入 `<issue>` 以避免重复创建）
4. 应用变更：`/openspec:apply <spec-name>`
5. 完成实现，并跑最小本地检查（lint/test/build 等，按仓库约定）
6. 运行 `git-pr-review` 创建 PR 并处理评审闭环（base 必须是 `<epic-branch>`；PR 中引用 Issue 与 Spec Change）
7. CI 全绿后合并 PR 回 `<epic-branch>`，并同步本地
8. 通过单独 PR 归档变更：`openspec archive <spec-name> --yes`

