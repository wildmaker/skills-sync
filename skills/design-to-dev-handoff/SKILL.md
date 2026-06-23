---
name: design-to-dev-handoff
description: 让高阶 Agent 先完成 repo-aware 技术设计、上下文整理，并输出可直接交给低阶 Agent 的 handoff package。适用于用户希望先用高阶模型定方案，再交给低阶 agent 开发；需要持久化技术方案时使用 technical-design-writer，需要 Agent 执行计划时使用 implementation-plan-writer。
version: 0.1.0
---

# Skill: design-to-dev-handoff

## What this skill does
- 先由高阶 Agent 完成需求理解、上下文归纳与技术设计。
- 将高阶思考结果压缩为一个可直接交给低阶 Agent 的 handoff package。
- 让下游执行者少走“重新理解需求 / 重新推演方案”的高 token 路径，尽量直接进入实现。
- 通过明确边界、改动点、验证方式与 guardrails，降低低阶 Agent 偏离方案的概率。
- 若需要落盘文档：人类消费的技术方案交给 `technical-design-writer`，Agent 消费的 `Implementation Plan.md` 交给 `implementation-plan-writer`。

## When to use
- 用户希望“先做技术设计，再把开发交给其他 Agent”。
- 用户反复输入类似提示：
  - “给出技术实现方案，而且要包含这个技术需求的相关上下文。”
  - “开始做技术设计，我后面要交给低阶 agent 开发。”
  - “请整理成其他 agent 可直接执行的方案包。”
- 目标是节省后续实现阶段的 token 成本，而不是让多个 Agent 各自重新思考一遍。

## Inputs
- 用户需求描述。
- 与需求相关的 repo 上下文、文档路径、Issue、设计草稿或已有约束。
- 可选限制：
  - 时间 / 范围限制
  - 性能、兼容性、安全约束
  - 不可改动区域
  - 是否允许新增依赖

## Hard constraints
- 默认只做技术设计与交接包输出，不直接实现代码，除非用户明确要求同回合继续开发。
- 方案必须结合当前 repo 现实或用户给定上下文，不能只给抽象口号。
- 必须显式标注假设、TBD、风险与非目标，不能把不确定内容伪装成定论。
- 技术方案与 `Implementation Plan.md` 是两个不同产物：
  - 技术方案主要给人类消费，说明背景、取舍、架构和风险。
  - `Implementation Plan.md` 主要给 Agent 消费，说明执行顺序、改动点、guardrails 和验证。
- 不在本 skill 中自定义 `Implementation Plan.md` 结构；需要计划文件时必须遵循 `implementation-plan-writer`。
- 必须区分：
  - `Must follow`：低阶 Agent 应严格遵守的边界、契约、顺序或限制。
  - `Flexible`：允许根据代码现实做微调的部分。
- 输出必须足够自包含，让低阶 Agent 不依赖额外口头补充也能开工。

## Workflow
1. 提炼任务目标。
   - 明确真正要交付的能力、验收口径、边界与非目标。
2. 补齐关键上下文。
   - 优先读取与当前需求直接相关的 repo 模块、现有实现、接口、数据结构与约束。
   - 只拉取必要上下文，避免为了“显得全面”而过度扫描。
3. 完成技术设计。
   - 若需要持久化技术方案，调用/遵循 `technical-design-writer`。
   - 在聊天或交接包中只保留低阶 Agent 必须知道的设计摘要。
4. 压缩为交接包。
   - 把高阶分析结果整理成低阶 Agent 可直接执行的 handoff package。
5. 按需生成 `Implementation Plan.md`。
   - 只有当用户明确需要 Agent 执行计划或持久化 Plan 时，调用/遵循 `implementation-plan-writer`。
6. 提供可直接转发的 executor prompt。
   - 让用户能把输出整体或其中的 prompt 直接丢给低阶 Agent。

## Required outputs
始终输出以下两部分：

1. `Technical Design Summary`
   - 给人类阅读的技术方案摘要；若需要落盘，使用 `technical-design-writer` 的模板生成独立技术方案文档。
2. `Executor Handoff Package`
   - 说明低阶 Agent 应该怎么做、先看哪里、不能偏离什么、如何验证完成。

可选输出：

3. `Implementation Plan.md`
   - 仅在用户要求持久化 Agent 执行计划时生成，并必须遵循 `implementation-plan-writer`。

详细模板见：
- `references/handoff-package-template.md`

## Output quality bar
- 优先输出“能执行”的方案，而不是“看起来很聪明”的方案。
- 尽量给出 repo 中可能涉及的目录、模块、接口或文件线索。
- 如果上下文不足，不要停在空泛建议；要明确写出缺口、当前假设与保守落地方案。
- 默认假设下游执行者能力较弱、上下文较少，因此输出要密而不散。

## Output format
除非用户明确要求其他格式，否则按 `references/handoff-package-template.md` 的结构输出。

## Recommended phrasing for the executor prompt
在交接 prompt 中应明确要求下游 Agent：
- 以 handoff package 为主线执行，不要重新发散做大范围方案重写。
- 若发现 repo 现实与方案冲突，先局部修正并说明冲突点，不要静默偏航。
- 优先按最小可验证改动落地。
- 完成后按 handoff package 中的验证清单自检。

## Anti-patterns
- 只给一句“建议怎么做”，没有 repo 上下文、模块落点和验证方式。
- 输出过于抽象，导致低阶 Agent 仍需重新做技术设计。
- 把所有不确定内容都留给下游 Agent 自己判断。
- 没有明确 guardrails，导致执行中随意扩展范围。
- 把“开始设计”和“开始编码”混在一起，破坏高阶规划、低阶执行的分层目标。
