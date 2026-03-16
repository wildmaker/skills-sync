# SDD Loop — 单条 Backlog Item 交付流程（元定义）

本文件定义 Spec-Driven Development（SDD）中**一个 backlog item** 的完整交付流程。
它位于 `workflow/meta-definitions/`，用于集中管理 workflow 元定义。

## Parameters

| 参数 | 说明 |
|---|---|
| `<epic-branch>` | 该 spec PR 的 base，格式 `epic/<epic-name>` |
| `<spec-name>` | 稳定 slug，同时用于分支 (`spec/<spec-name>`) 和 OpenSpec 目录 (`OpenSpec/changes/<spec-name>`) |
| `<issue>` | （可选）关联的 Issue 编号/链接（若已有） |

## Branch model

```text
main
 └─ epic/<epic-name>
     └─ spec/<spec-name>
```

- `spec/*` 必须基于 `epic/*`（禁止直接基于 `main`）
- 只允许 `spec/*` → `epic/*`；Epic 完成后 `epic/*` → `main`
- 禁止删除 `spec/*` 分支；若 repo 自动删除已合并分支，须从 PR head SHA 恢复：
  `git push origin <head-sha>:refs/heads/spec/<spec-name>`

## Steps

### 1. 理解需求

阅读 backlog 条目与相关 spec/变更目标，明确本次交付范围。

### 2. 创建 spec 分支

从 `<epic-branch>` 创建并切换到 `spec/<spec-name>`（若已存在则直接切换）。

### 3. 初始化 Spec Change

运行 `tool-use-openspec-init-change`（inputs: `<spec-name>`, `<branch>`）。
- 写入最小内容：`proposal.md`（motivation, scope, non-goals）、`tasks.md`（subtasks）、`specs/`（仅本次增量）

### 4. 验证 Spec（mandatory gate）

```bash
openspec validate <spec-name> --strict
```

修复至通过为止。**未通过验证不得进入实现阶段。**

### 5. 应用 Spec

```bash
openspec apply <spec-name>
```

### 6. 实现 + 本地检查

完成代码实现，并按仓库约定运行最小本地检查（lint/test/build 等）。本地通过后再提 PR。

### 7. PR 评审闭环

运行 `harness-agent-review-loop` 创建 PR 并处理评审闭环：
- PR base 必须是 `<epic-branch>`
- PR body 中引用 Spec Change 路径 (`OpenSpec/changes/<spec-name>`)；若存在 `<issue>`，一并引用
- 执行 multi-round review sweep（最多 6 轮）：
  1. **Self-review**：对 diff 做五维审查（architecture, tests, security, performance, docs）。读取 `harness-review` skill 获取维度清单。修复明显问题，单次 commit + push
  2. **等待 bot reviewers**：不跳过此步。读取 `harness-review` skill 获取 bot 检测与轮询规则
  3. **收集三个信号源**（缺任一 = 本轮不完整）：PR reviews 状态、PR review comments（inline）、PR conversation comments（top-level）
  4. **分级**：High（`CHANGES_REQUESTED` / blocker / security / crash / data loss）→ Medium（should / needs / recommend）→ Low（nit / style，不阻塞）
  5. **解决**：读取 `harness-review` skill 获取跨 reviewer 去重与批量修复流程。修复所有 High/Medium 或逐条 justified pushback。每轮单次 commit + push

### 8. 合并 gate（强制）

合并前必须同时满足：
- PR 无未解决的 High/Medium 评论
- PR 不处于 `CHANGES_REQUESTED` 状态
- CI checks 全绿（CI is green）
- 三个信号源均已检查

### 9. 合并 PR 回 Epic 分支

推荐使用 `git-merge-recent-pr`（它会执行评论闭环 gate 且默认不删除 head 分支）。
- **禁止使用** `gh pr merge --delete-branch`
- 若 `spec/*` 被自动删除，从 PR head SHA 恢复

### 10. 同步 Epic 分支

```bash
git fetch origin <epic-branch>
git checkout <epic-branch>
git merge --ff-only origin/<epic-branch>
```

### 11. 归档 Spec Change（单独 PR）

归档必须走自己的 PR + 评审闭环，不要"提交→秒合并"跳过自动 reviewer。

1. 从 `<epic-branch>` 创建归档分支：`chore/archive-<spec-name>`
2. 执行归档：`openspec archive <spec-name> --yes`
3. 提交归档变更
4. 运行 `harness-agent-review-loop` 创建 PR（base 必须是 `<epic-branch>`；PR 中引用 Spec Change，若存在 `<issue>` 则一并引用）
5. 完成 High/Medium 评论闭环 + CI green 后，用 `git-merge-recent-pr` 合并（默认不删除 head 分支）

## Guardrails

- **Spec 是权威**：当 ticket 有关联的 Spec Change 时，Spec 是设计的唯一真相源。代码必须符合 Spec。若实现中发现 Spec 问题，先更新 Spec、重新验证，再更新代码
- **一个 ticket = 一个 spec change = 一个 PR**。禁止扩大范围；发现的额外改进应创建独立 issue
- **归档不可跳过**：实现 PR 合并后必须完成归档 PR

## Referenced skills

| Skill | 用途 | 读取时机 |
|---|---|---|
| `tool-use-openspec-init-change` | 初始化并严格校验 OpenSpec 变更 | Step 3 |
| `tool-use-openspec` | 创建、验证、应用、归档 OpenSpec 变更 | Steps 4-5, 11 |
| `harness-review` | bot 检测、轮询策略、跨 reviewer 去重、批量修复 | Step 7 review sweep |
| `harness-agent-review-loop` | 创建 PR + 多轮评审闭环 | Steps 7, 11 |
| `git-merge-recent-pr` | 执行评论闭环 gate + 合并 PR | Steps 9, 11 |
| `commit` | 生成规范的 commit message | 实现与归档阶段 |
| `push` | 推送分支到远端 | 实现与归档阶段 |
| `pull` | 同步 epic 分支最新状态 | Step 10, 归档前 |
