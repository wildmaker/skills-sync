---
name: implementation-plan-writer
description: Write an agent-facing Implementation Plan.md from a technical design, Blueprint, PRD, or repo analysis. Use when producing or standardizing Implementation Plan.md, Agent execution plans, backlog drafts, implementation steps, guardrails, validation commands, or plans meant primarily for coding agents.
version: 0.1.0
---

# Skill: implementation-plan-writer

## What this skill does
- 产出主要给 Agent 执行的 `Implementation Plan.md`。
- 将技术方案、Blueprint 或 repo 分析结果转成确定、可验证、低歧义的执行计划。
- 统一 `Implementation Plan.md` 的结构、粒度、guardrails、backlog draft 和验证口径。

## When to use
- 用户要求生成、重写、规范化或审查 `Implementation Plan.md` / `plan.md`。
- 上游 skill 已完成技术方案、Blueprint 编译或 repo 分析，需要写成 Agent 执行计划。
- 需要把复杂变更拆成阶段、模块级步骤、backlog 草案或验证清单。

## Inputs
- 技术方案文档、Blueprint、PRD、Issue、需求描述或上游分析结果。
- repo reality：相关模块/文件/接口/数据模型/测试框架/构建命令。
- 约束：不可改动区域、兼容性、安全、性能、时间范围、是否允许新增依赖。
- 可选输出路径：默认使用 `<epic-docs-dir>/Implementation Plan.md` 或与源设计文档同目录。

## Output contract
- 输出文件名默认是 `Implementation Plan.md`。
- 主要消费者是 Agent，不是人类评审者。
- 文档必须能直接指导实现 Agent 开工，尽量减少重新推演设计的空间。
- 不重复长篇解释技术方案合理性；必要设计背景只保留执行所需摘要。
- 若缺少信息，不要编造；在 `TBD / Assumptions / Risks` 中标注，并给出保守执行策略。

## Relationship to technical design
- 技术方案回答“为什么这样做、取舍是什么、架构是否合理”，由 `technical-design-writer` 负责。
- `Implementation Plan.md` 回答“Agent 按什么顺序做、改哪里、做到什么算完成”，由本 skill 负责。
- 当两者都需要时，先写技术方案，再把已确认设计输入给本 skill。

## Workflow
1. 归纳上游设计意图。
   - 保留目标、范围、非目标、关键约束和验收口径。
2. 映射 repo reality。
   - 标出实现入口、相关目录/模块/文件线索、现有可复用能力和测试位置。
3. 拆分阶段。
   - 每个阶段都要有目标、具体步骤、产物和验证方式。
4. 写 Agent guardrails。
   - 明确 must follow、禁止事项、允许灵活调整的边界。
5. 生成 backlog draft。
   - 用稳定 slug 作为 item ID；每项包含 expected、acceptance、dependencies、risk/TBD。
6. 写验证计划。
   - 给出 lint/typecheck/test/build/manual demo 等命令或步骤；未知命令标注 TBD。

## Required structure
除非用户明确要求其他格式，否则使用：

- `Agent Objective`
- `Source Inputs`
- `Scope`
- `Non-goals`
- `Repo Context`
- `Execution Strategy`
- `Phased Implementation Plan`
- `Backlog Draft`
- `Validation Plan`
- `Demo Plan`（复杂变更 / Epic 工作流需要时）
- `Guardrails`
- `TBD / Assumptions / Risks`
- `Definition of Done`

详细模板见：
- `references/implementation-plan-template.md`

## Quality bar
- 面向 Agent：短句、确定性、可执行、少解释背景。
- 每个实施步骤必须能映射到模块/文件/接口/测试之一；未知时写清楚如何定位。
- Backlog item 必须原子化，避免一个 item 同时跨多个无法独立验证的目标。
- Validation 必须具体到命令、测试路径或手工验证步骤；不知道就标注 TBD。
- 不把人类决策讨论塞进执行步骤；未决问题进入 `TBD / Assumptions / Risks`。

## Anti-patterns
- 把 `Implementation Plan.md` 写成人类技术方案，长篇解释取舍但不能执行。
- 缺少 start-here 路径，导致 Agent 重新全仓搜索。
- 任务粒度过大，无法拆 PR 或独立验证。
- 只写“添加测试 / 修复 bug / 更新 UI”这类不可执行泛化步骤。
- 在 Plan 中引入上游技术方案没有确认的新功能。
