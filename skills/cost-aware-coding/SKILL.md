---
name: cost-aware-coding
description: 在完成编码任务时节约上下文窗口和推理成本：指导高阶 Agent 灵活调用 Cursor CLI 的 auto 便宜模型，以及用 subagents/低阶模型承接探索、检索、批量整理、验证等可并行子任务。
---

# cost-aware-coding

## Goal
在不牺牲交付质量的前提下，降低主对话上下文占用和高阶模型 token 消耗。高阶 Agent 仍负责意图理解、架构判断、关键编辑、风险控制和最终验收；可把低风险、可边界化、可验证的工作分配给更便宜的执行面。

## Core Instructions
- Cursor CLI 可以使用 `auto` 模型；它非常便宜，适合承担上下文消耗大但判断风险低的工作。
- 可以灵活调用 subagents，并把探索、整理、初步实现、测试补充、日志归纳等任务分配给低阶模型，从而降低主对话 token 消耗。
- 主 Agent 不要把全量文件、长日志、完整依赖树都吞进主上下文；优先让便宜执行面返回短摘要、候选文件、失败证据和推荐下一步。
- 成本优化不能替代验证。任何低阶模型或 Cursor CLI 的产出都必须由主 Agent 复核关键路径并运行合适的验证。

## When To Use
- 任务预计会产生大量检索、阅读、日志分析、重复编辑、测试迭代或多文件摸排。
- 主 Agent 需要保持上下文窗口干净，只保留决策必要信息。
- 子任务可以被清晰描述、限定文件范围，并用测试、diff、命令输出或人工检查验证。

## Cost-Aware Workflow
1. 切分任务：
   - 主 Agent 保留：需求解释、架构边界、风险判断、最终代码合并、验证结论。
   - 便宜执行面承接：repo 搜索、候选方案收集、相关文件摘要、失败日志压缩、测试覆盖建议、低风险样板改动。
2. 优先使用 Cursor CLI `auto` 模型处理大上下文探索：
   - 让它读取大量文件并返回不超过 20 行的结论。
   - 要求输出路径、行号、证据和置信度，而不是长篇解释。
   - 对实现建议要求给出最小 diff 思路，不要直接扩大范围。
3. 使用 subagents 分配独立工作：
   - `explore`/低阶模型：找文件、调用链、相似实现、配置入口。
   - `test-engineer`/低阶模型：提出或编写局部测试，定位缺口。
   - `verifier`/低阶模型：独立跑验证、压缩失败输出、列出残余风险。
   - `style-reviewer`/低阶模型：命名、格式、惯例检查。
4. 汇总与压缩：
   - 要求每个子任务返回：`Finding`、`Evidence`、`Risk`、`Recommended next step`。
   - 主 Agent 只把必要结论带回主上下文。
5. 最终复核：
   - 主 Agent 检查所有实际 diff。
   - 主 Agent 运行或确认关键验证。
   - 报告哪些工作外包给便宜模型、哪些结论由主 Agent 复核。

## Cursor CLI Auto Pattern
当本地环境有 Cursor CLI agent 入口时，可使用类似模式：

```bash
agent --model auto "<bounded task prompt>"
```

有些安装会暴露为 `cursor-agent`，可用同等参数调用。`cursor` 命令本身可能只是 IDE 启动器；如果项目或本机的 Cursor CLI 参数不同，先用 `agent --help`、`cursor-agent --help`、`agent --list-models` 或现有项目脚本确认正确调用方式。不要臆造不可用参数。

适合交给 `agent --model auto` 的 prompt 示例：

```text
Read the repository and identify the smallest set of files relevant to <task>.
Return only:
1. File paths with line references
2. Why each file matters
3. Any tests likely affected
Keep the answer under 20 lines.
```

```text
Summarize this failing test log into root-cause candidates.
Return evidence lines, likely owner files, and one recommended next command.
Do not propose broad refactors.
```

## Subagent Prompt Shape
给低阶模型或 subagent 的任务要小、硬、有验收：

```text
Task: <one bounded objective>
Scope: <files/directories allowed>
Do not edit outside scope.
Return:
- Finding:
- Evidence:
- Proposed patch or next command:
- Risk / uncertainty:
Budget: keep response concise.
```

## Guardrails
- 不把高风险架构决策、权限/安全判断、数据迁移、破坏性 Git 操作完全交给低阶模型。
- 不让多个子代理同时编辑同一文件，除非主 Agent 明确负责合并冲突。
- 不因成本优化跳过测试、类型检查、lint 或用户要求的验收步骤。
- 不把低阶模型的结论当事实；关键结论必须有文件路径、行号、命令输出或测试结果支撑。
- 如果便宜执行面输出含糊、过长或偏题，重新给更窄 prompt，而不是把噪声搬进主上下文。

## Final Report
完成后简要说明：
- 使用了哪些成本控制手段（Cursor CLI auto、subagents、压缩日志等）。
- 主 Agent 亲自复核了哪些关键 diff/结论。
- 运行了哪些验证，以及剩余风险。
