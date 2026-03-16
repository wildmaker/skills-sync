---
name: harness-feature
description: Cursor 手动入口：对一个 backlog item 执行 SDD Loop（读取同目录 `SDD-LOOP.md` 流程定义），通过 Linear 跟踪进度。
version: 0.4.0
---

# Skill: harness-feature

## Trigger

@harness-feature

## Source of truth

- 同目录 `SDD-LOOP.md`（SDD 流程元定义；本 skill 的步骤以该文件为准）
- `skills/epic-auto-build-v2/references/epic-workflow.md`（术语与分支/合并约束）

## What this skill does

对**一个 backlog item** 执行一次完整的 SDD Loop：从 `epic/<epic-name>` 创建
`spec/<spec-name>`，初始化 Spec Change，应用变更并实现，通过评审闭环后合并回
Epic 分支，最后归档 Spec Change。

## Inputs (recommended)

- `<epic-branch>`：默认 `epic/<epic-name>`（该 spec PR 的 base）
- `<spec-name>`：稳定 slug（同时作为 Spec Change 目录名与 change ID：`OpenSpec/changes/<spec-name>`）
- （可选）`<issue>`：若任务已有 Issue（Linear/GitHub），可传入编号/链接供 PR 引用

## Outputs

- 分支：`spec/<spec-name>`（合并回 `<epic-branch>`）
- Spec Change：`OpenSpec/changes/<spec-name>`
- PR：`spec/<spec-name>` → `<epic-branch>`

## Constraints

- 一次只处理一个 backlog item。
- `spec/*` 分支必须基于且只能合并回 `<epic-branch>`；禁止直接面向 `main`。
- 以 Spec Change 为评审权威（single source of truth）。

## Allowed commands

- `tool-use-openspec-init-change`
- `harness-agent-review-loop`
- `git-merge-recent-pr`
- `tool-use-openspec`
- `openspec`
- `git`
- `rg`
- `gh`
- `sleep`

## Linear integration

本 skill 使用 Linear 跟踪 Issue 进度：
- 在 Issue 上维护 workpad comment 记录执行进度
- PR 创建后将 PR URL 关联到 Issue
- 实现与归档完成后更新 Issue 状态

## Steps

**Read `./SDD-LOOP.md` and follow its complete procedure (Steps 1–11).**

执行前先读取同目录 `SDD-LOOP.md`，按其中定义的 11 个步骤依序执行。
流程中引用的 skill（`tool-use-openspec`、`harness-review`、`harness-agent-review-loop`、`git-merge-recent-pr` 等）
在对应步骤到达时读取并遵循。
