---
name: git-pr-summarize
description: 提供 git-pr-summarize 的操作流程与约束；适用于 需要为指定 GitHub PR 生成面向 CTO 的中文汇报 Markdown（可做 PPT）时使用。
---

# git-pr-summarize

## What this skill does
- 拉取 PR 元信息与 diff
- 生成带 Mermaid 图表的中文汇报文档
- 保存到 `docs/reviews` 并可打开预览

## Constraints
- 严禁臆测，关键结论必须有证据链接或标注【缺数据】
- 各章节必须用 `---` 分隔，每页 ≤ 7 要点
- 必须包含 Mermaid 图，且复杂流程至少 1 个图

## Allowed commands
- `gh`
- `jq`
- `cat`
- `mkdir`
- `echo`
- `open`

## Steps
1. 使用 `gh` 获取 PR JSON 与 diff。
2. 生成中文汇报 Markdown（覆盖封面、决策事项、价值、架构、核心逻辑、模块、数据流、接口、测试、风险、总结）。
3. 保存到 `docs/reviews/pr-<owner>-<repo>-<num>.md`。
4. 可选：打开生成的 Markdown 预览。
