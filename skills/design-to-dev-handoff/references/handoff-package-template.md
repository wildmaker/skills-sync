# Handoff Package Template

除非用户明确要求更短或更长版本，否则使用以下结构输出。

````md
# Technical Design Summary

## Goal
- <要交付的能力>
- <成功标准 / 验收口径>

## Context Snapshot
- <业务背景 / 用户给定背景>
- <已有实现 / 当前限制>
- <为什么这次改动需要先做高阶设计>

## Repo Mapping
- <相关目录 / 模块 / 文件线索>
- <现有可复用能力>
- <可能受影响的接口、状态流、数据结构或脚本>

## Proposed Approach
- <推荐实现路径>
- <关键设计决策>
- <为什么选择这条路径而不是主要替代方案>

## Risks / TBD
- <主要风险>
- <待确认项>
- <当前采用的假设>

> 如果需要持久化的人类技术方案文档，使用 `technical-design-writer` 生成独立 `Technical Design.md`。
> 如果需要持久化的 Agent 执行计划，使用 `implementation-plan-writer` 生成独立 `Implementation Plan.md`。

# Executor Handoff Package

## Objective
- <给低阶 Agent 的一句话任务目标>

## Scope
- <本次要做什么>

## Non-goals
- <本次明确不做什么>

## Must Follow
- <必须遵守的契约 / 边界 / 顺序 / 约束>

## Flexible
- <允许根据代码现实做小幅调整的部分>

## Start Here
- <建议先读的文件 / 模块 / 文档>

## Implementation Steps
1. <第一步>
2. <第二步>
3. <第三步>

## Contracts / Data / Interfaces
- <接口、数据结构、边界行为、错误处理等>

## Validation Checklist
- <单测 / 集成测试 / 手工验证 / lint / typecheck 等>

## Guardrails
- <避免范围扩张、避免破坏现有行为、避免绕开关键约束>

## Open Questions / Assumptions
- <尚未确定但已做保守假设的点>

## Ready-to-send Prompt
```text
You are the implementation agent for this task.

Follow the handoff package below as the primary source of truth.
Do not redo the high-level design unless repo reality clearly conflicts with it.
If you find a conflict, explain the mismatch and make the smallest safe adjustment.
Prefer minimal, testable changes and verify against the provided checklist.

<粘贴上面的 Executor Handoff Package 内容>
```
````
