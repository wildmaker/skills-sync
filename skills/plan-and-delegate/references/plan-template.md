# PLAN Template

除非用户明确要求别的格式，否则按以下结构生成 `PLAN` 文档。

````md
# PLAN

## Task
- <一句话任务定义>

## Goal / Done Criteria
- <要交付的能力>
- <成功标准 / 验收口径>

## Requirement Context
- <用户需求原文摘要>
- <业务背景 / 使用场景>
- <为什么这次需要委派给编码 Agent>

## Repo Context
- <相关目录 / 模块 / 文件线索>
- <已有实现 / 可复用能力>
- <受影响的接口、状态流、数据结构或脚本>

## Constraints
- <时间 / 范围 / 性能 / 安全 / 兼容性 / 依赖限制>
- <不可改动区域>

## Proposed Technical Plan
- <推荐实现路径>
- <关键设计决策>
- <为何选择此方案而非主要替代方案>

## Scope
- <本次要做什么>

## Non-goals
- <本次明确不做什么>

## Implementation Steps
1. <第一步>
2. <第二步>
3. <第三步>

## Validation Plan
- <lint / typecheck / unit / integration / manual / build 等>

## Risks / Assumptions / Open Questions
- <主要风险>
- <当前假设>
- <仍待确认的问题>

## Delegate Instructions
- <给下游编码 Agent 的执行边界>
- <哪些地方必须严格遵守>
- <哪些地方允许根据代码现实微调>

## Ready-to-send Prompt
```text
You are the coding agent for this task.

Follow the PLAN document below as the primary source of truth.
Do not redo the high-level design unless repo reality clearly conflicts with it.
If you find a conflict, explain the mismatch and make the smallest safe adjustment.
Prefer minimal, testable changes and verify against the validation plan.

PLAN path: <absolute-or-repo-relative-plan-path>

Task summary:
<一句话任务目标>
```
````
