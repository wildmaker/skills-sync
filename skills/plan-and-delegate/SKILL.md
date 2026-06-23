---
name: plan-and-delegate
description: Generate a detailed PLAN document with requirement context, repo mapping, technical approach, scope, risks, and validation, then use it to delegate implementation to a coding-focused agent. Use when the user wants to hand off a task completely, says “把这个任务交给另一个 agent 去做”, “先整理完整方案再委派”, or asks for a self-contained implementation handoff.
---

# plan-and-delegate

## What this skill does
- 先整理需求、上下文和技术方案，生成一个可持久化的 `PLAN` 文档。
- 再基于这个 `PLAN` 生成可直接转发给编码 Agent 的 handoff prompt。
- 如果当前环境支持原生 delegation，就把实现委派给专门负责编码的 Agent。
- 如果当前环境不支持 delegation，也要给出可直接发送的 prompt 和文档路径，保证信息传递完整。
- 当 `PLAN` 的目标是 Agent 执行计划时，必须遵循 `implementation-plan-writer`；当目标是人类技术方案时，必须遵循 `technical-design-writer`。

## When to use
- 用户希望“把这个任务完整交给另一个专门编码的 agent 去实施”。
- 用户希望“先产出完整方案，再让另一个 agent 开工”。
- 用户反复手写类似提示词：
  - `请先整理成详细 PLAN，再委派给另一个 agent`
  - `把这个任务交给 coding agent 做，但要把上下文讲清楚`
  - `给我一个可以直接发给实现 agent 的完整方案包`

## Hard constraints
- 必须先写 `PLAN`，再做 delegation；不要把模糊需求直接扔给下游 Agent。
- `PLAN` 必须包含需求上下文和技术方案，且要结合当前 repo 现实，不可只写抽象建议。
- 必须明确区分：
  - 已确认事实
  - 当前假设
  - 待确认问题
- 必须显式写出范围、非目标、验证方式和主要风险。
- delegate prompt 必须引用 `PLAN` 文档路径，并要求下游 Agent 以该文档为主线执行。
- 若存在真正阻塞安全实施的关键歧义，可以保守记录假设并说明缺口；不要因为小缺口就放弃交接。

## PLAN artifact
- 优先将 `PLAN` 保存到当前仓库已有的 `.omx/plans/`。
- 如果仓库没有 `.omx/plans/`，则保存到 `docs/plans/`。
- 文件名建议使用：`plan-and-delegate-<short-slug>.md`
- 除非用户明确不要写文件，否则默认落盘，不只在聊天里内联输出。

详细结构见：
- `references/plan-template.md`

## Workflow
1. 提炼目标与验收口径。
   - 明确这次真正要交付的能力、边界、非目标与完成定义。
2. 收集直接相关上下文。
   - 读取必要的 repo 模块、接口、数据结构、文档和已有约束。
   - 只收集和 handoff 直接相关的信息，避免无效扫描。
3. 写出 `PLAN` 文档。
   - 将上下文、技术方案、影响面、实施顺序、验证清单和风险整理为可复用文档。
   - 若写的是 `Implementation Plan.md` 或 Agent 执行计划，调用/遵循 `implementation-plan-writer`。
   - 若写的是人类技术方案，调用/遵循 `technical-design-writer`。
4. 生成 delegate brief。
   - 提供一个可直接发给实现 Agent 的 prompt，明确目标、边界、约束和文档路径。
5. 触发 delegation。
   - 若当前环境支持原生 subagent / delegation，则优先委派给 `executor` 这类编码 Agent。
   - 若不支持，则返回 `PLAN` 路径和 ready-to-send prompt，让用户或上层系统直接转发。
6. 保持 leader 责任。
   - 发起委派的一方仍负责最终验证与收口，不把“是否完成”的判断全部丢给下游 Agent。

## Delegate behavior
- 下游编码 Agent 应把 `PLAN` 视为主线，不要重新发散做大范围重设计。
- 若发现 repo 现实与 `PLAN` 冲突，应先说明冲突点，再做最小安全调整。
- 默认按最小可验证改动实施，避免范围膨胀。
- 完成后必须按 `PLAN` 中的验证清单自检。

## Required outputs
始终产出这三项：

1. `PLAN Document`
   - 持久化文档路径
   - 文档摘要
2. `Delegate Prompt`
   - 可直接转发给编码 Agent 的 prompt
3. `Delegation Status`
   - 已委派，或
   - 因环境限制未自动委派，但已准备好完整 handoff

## Anti-patterns
- 只给一句“建议怎么做”，没有文档、没有上下文、没有技术方案。
- 还没梳理 repo 现实就把任务甩给下游 Agent。
- delegate prompt 没有边界和验证要求，导致下游自由发挥。
- 没有把假设和待确认点写出来，导致交接信息失真。
- 把 `PLAN` 写成空泛摘要，而不是可执行的实施文档。
