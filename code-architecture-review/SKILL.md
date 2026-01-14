---
name: code-architecture-review
description: 提供 code-architecture-review 的操作流程与约束；适用于 需要对代码实现逻辑做架构分析，并生成可视化文档时使用。
---

# code-architecture-review

## What this skill does
- 基于实际代码分析架构、时序与组件交互
- 生成包含 Mermaid 图表的 Markdown 文档并保存到 `docs/reviews`

## Constraints
- 必须基于实际代码，不臆测
- 每个复杂流程至少 1 个 Mermaid 图，图后附 2-3 句解读
- 仅输出 Markdown，章节用 `---` 分隔

## Allowed commands
- `date`
- `sed`
- `tr`
- `cut`
- `mkdir`
- `echo`
- `open`

## Steps
1. 确认分析目标（代码路径、模块或问题领域）。
2. 生成结构化 Markdown（封面、问题领域、架构图、时序图、组件交互、关键模块、技术实现、总结）。
3. 生成文件名并写入 `docs/reviews/architecture-review-<target>-<timestamp>.md`。
4. 可选：打开生成文档进行查看。
