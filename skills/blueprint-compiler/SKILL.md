---
name: blueprint-compiler
description: Compile a human-facing Design Blueprint or technical design into repo-aware execution inputs, then use implementation-plan-writer to produce the Agent-facing Implementation Plan.md. Use when a Blueprint/design doc must be mapped to concrete implementation phases, repo targets, validation, and backlog draft.
version: 0.1.0
---

# Skill: blueprint-compiler

## Trigger
@blueprint-compiler

## What this skill does
- 将人类消费的整体技术方案（Blueprint / Technical Design）“编译”为 repo-aware 的执行输入。
- 保持与 Blueprint 一致的核心思路/架构方向，但具体任务拆分、落地路径、改动位置与依赖梳理必须以 repo 现状为准。
- 最终的 `Implementation Plan.md` 必须由 `implementation-plan-writer` 的结构和质量标准统一生成。
- 若输入不是成熟技术方案，而只是需求草稿，先调用/遵循 `technical-design-writer` 补齐人类可审阅的技术方案，再进入编译。

## Inputs (recommended)
- `<blueprint-doc-path>`：Blueprint 文档在仓库内的路径（可多个；也可沿用既有命名 `<design-doc-path>`）
- `<base-branch>`：用于理解当前实现基线（默认 `main`）
- （可选）`<constraints>`：如时间/范围限制、性能/兼容性目标、不可改动区域等
- （可选）`<output-dir>`：`Implementation Plan.md` 输出目录（推荐在 Epic 工作流中使用：`docs/<epic-slug>/`）

## Outputs
- `Implementation Plan.md`：repo-aware 的 Implementation Plan（**包含已拆分的 backlog items 列表草案**，可直接用于生成/更新根目录 `BACKLOG.md` 并进入实现）
- 存储位置规则：
  - 若提供了 `<output-dir>`：输出到 `<output-dir>/Implementation Plan.md`
  - 否则：与 `<blueprint-doc-path>` 放在同一个父目录下存储

## Constraints
- 不做实现编码、不直接写入根目录 `BACKLOG.md`、不创建 Issue/分支（但必须在 `Implementation Plan.md` 中产出可落盘的 backlog items 列表）。
- 不臆测缺失需求：信息不足时，必须在 `Implementation Plan.md` 标注 TBD 与需要补充的资料清单。
- 计划必须**可执行**：避免停留在抽象架构口号；需要给出明确的执行路径与拆分策略。
- 计划必须**不背离 Blueprint**：任何偏离都必须在 `Implementation Plan.md` 明确“为何偏离 + 影响 + 替代方案”。
- 不在本 skill 内维护 `Implementation Plan.md` 的最终模板；模板和偏好统一来自 `implementation-plan-writer`。
- 不把技术方案和 `Implementation Plan.md` 合成一个文档：技术方案主要给人类审阅，`Implementation Plan.md` 主要给 Agent 执行。

## Allowed commands
- `technical-design-writer`
- `implementation-plan-writer`
- `standing-on-giants-preflight`
- `rg`
- `ls`
- `git`

## Steps
1. 阅读 Blueprint 文档
   - 提炼：目标/范围/非目标、核心架构思路、关键约束、验收标准与风险假设。
2. 扫描 repo 现状（repo-aware）
   - 用 `rg`/目录结构定位与 Blueprint 相关的模块、边界、关键入口（API、路由、服务层、数据模型、构建/部署等）。
   - 识别：可复用能力、现存约束（技术栈、模块边界、约定、测试框架）、潜在冲突点与迁移成本。
3. 将 Blueprint 映射到可落地的执行路径
   - 为每个 Blueprint 的关键构件/流程，给出“在 repo 中对应/落点在哪里（模块/文件/接口层级）”。
   - 给出分阶段交付策略，确保每阶段都可独立验证与回滚。
4. 运行 standing-on-giants-preflight（找捷径/复用）
   - 调用 `standing-on-giants-preflight` skill，检索是否已有现成方案/最佳实践/可复用代码/现成工具链可直接套用。
   - 输出结论：哪些部分可以走捷径（或必须自行实现）+ 采用/不采用的理由 + 对后续分阶段交付的影响。
5. 生成 `Implementation Plan.md`
   - 调用/遵循 `implementation-plan-writer`。
   - 必须包含 repo context、分阶段执行计划、backlog draft、validation plan、guardrails、TBD/assumptions/risks 与 Definition of Done。
   - Backlog draft 使用稳定 `<spec-name>` slug 作为 item ID，附描述、验收点、依赖、风险/TBD。

