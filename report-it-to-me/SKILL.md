---
name: report-it-to-me
description: 提供 report-it-to-me 的操作流程与约束；适用于 需要将 Markdown 报告转换为 Reveal.js 幻灯片 HTML 时使用。
---

# report-it-to-me

## What this skill does
- 调用脚本生成单个 HTML 幻灯片文件
- 复用模板并保留 Markdown 结构与 Mermaid 图表

## Constraints
- 使用指定脚本与模板，不手写 HTML
- 说明 Markdown 来源、输出路径与标题选项

## Allowed commands
- `node scripts/tools/generate-reveal-slides.js`
- `npm run --prefix scripts slides:generate`
- `open`

## Steps
1. 确认 Markdown 输入文件路径与可选标题。
2. 运行脚本生成 HTML 幻灯片文件。
3. 打开并检查生成的 HTML。
4. 汇报使用的 Markdown、输出路径与标题设置。
