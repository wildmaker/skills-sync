---
name: technical-design-writer
description: Write a human-facing technical design document for a feature, architecture change, or complex implementation decision. Use when the user asks for 技术方案, technical design, design doc, architecture proposal, or a document meant primarily for human review and decision-making.
version: 0.1.0
---

# Skill: technical-design-writer

## What this skill does
- 产出主要给人类阅读和决策的技术方案文档。
- 解释“为什么这样设计”：背景、现状、目标、取舍、架构、风险和待确认决策。
- 为后续 `implementation-plan-writer` 提供可信上游输入，但不把自己写成 Agent 执行清单。

## When to use
- 用户要求“写技术方案 / 技术设计 / architecture proposal / design doc”。
- 需要先让人类理解方案合理性、取舍和风险，再决定是否进入实现。
- 已有需求、PRD、Blueprint 或讨论记录，需要整理成人类可审阅的技术方案。

## Inputs
- 用户需求、PRD、Issue、Blueprint、草稿或口头讨论。
- 与方案相关的 repo 上下文、现有模块、接口、数据模型、测试和部署约束。
- 可选：目标读者、决策范围、不可改动区域、兼容性/性能/安全要求。

## Output contract
- 默认输出一个独立文档，建议命名为 `Technical Design.md` 或 `<feature-slug>-Technical Design.md`。
- 文档的主要消费者是人类；Agent 可以读，但不能依赖它直接执行。
- 不要在技术方案里展开低阶逐文件 TODO、命令清单或 backlog item；这些属于 `Implementation Plan.md`。
- 若用户还需要 Agent 执行计划，完成技术方案后再调用 `implementation-plan-writer`。

## Workflow
1. 明确目标与非目标。
   - 写清楚用户价值、验收口径、边界和不做什么。
2. 收集必要 repo 现实。
   - 只读取与设计决策直接相关的代码、文档和约束。
3. 分析现状与问题。
   - 说明当前实现、缺口、约束和为什么需要这次改动。
4. 提出推荐方案与替代方案。
   - 解释关键设计决策、取舍依据和被放弃方案。
5. 写出风险、兼容性和待确认点。
   - 不确定内容必须标注为 TBD / Assumption / Decision needed。
6. 如需交给 Agent 执行，明确下一步应生成 `Implementation Plan.md`。

## Required structure
除非用户明确要求其他格式，否则使用：

- `Summary`
- `Background / Context`
- `Goals`
- `Non-goals`
- `Current State`
- `Proposed Design`
- `Alternatives Considered`
- `Impact and Compatibility`
- `Risks and Open Questions`
- `Validation Strategy`
- `Next Step: Implementation Plan`

详细模板见：
- `references/technical-design-template.md`

## Quality bar
- 面向人类：优先清晰解释判断依据，而不是堆执行细节。
- 方案必须 repo-aware：至少给出相关模块/接口/数据流/约束的定位。
- 取舍要诚实：说明为什么推荐方案优于主要替代方案。
- 不把未确认事项伪装成定论。
- 不与 `Implementation Plan.md` 混写；技术方案回答“为什么和做什么”，Implementation Plan 回答“Agent 怎么一步步做”。

## Anti-patterns
- 把技术方案写成任务列表，缺少背景、取舍和风险。
- 只写抽象架构口号，没有 repo 现实。
- 过早拆成 backlog item，导致人类无法先评审方案。
- 把 Agent guardrails、验证命令和逐文件修改步骤塞进技术方案主体。
