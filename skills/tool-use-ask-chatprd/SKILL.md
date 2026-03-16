---
name: tool-use-ask-chatprd
description: |
  基于草稿 PRD 连接 ChatPRD MCP 进行“补漏提问 + 结构优化 + 启发式扩展”三段式增强。用于用户已写出初稿、希望系统化发现遗漏、通过 `askquesition`/`askquestion` 向用户补齐关键信息、并产出可落地改进建议与新想法时。
---

# ask-chatprd

## Goals
- 从草稿 PRD 中识别缺失信息并生成补充问题。
- 通过 ChatPRD 给出可执行优化建议。
- 通过启发式框架扩展更多产品思路。

## Inputs
- 草稿 PRD 文本，或草稿文件路径。
- 可选：目标用户、业务目标、发布时间等上下文。

## Preconditions
- ChatPRD MCP 已接入客户端。
- 账号具备 MCP 权限（Pro/Team/Enterprise 或 Trial）。
- 若连接失败，先看 [references/mcp-setup.md](references/mcp-setup.md)。

## Workflow
1. 校验 ChatPRD MCP 可用性。
2. 探测可用工具名称，优先顺序：
   - `askquesition`（按用户原始拼写）
   - `askquestion`
   - 其他语义等价的提问工具
3. 读取草稿 PRD（用户提供文本、文件内容，或通过 ChatPRD 文档检索获取）。
4. 执行 `Gap Questions` 分析，请 ChatPRD 输出“必须补齐的问题清单”，并按优先级分组：
   - High：不补齐会导致需求/范围/验收不成立
   - Medium：影响方案质量或排期准确性
   - Low：增强信息
5. 逐条向用户补问：
   - 有提问工具时，调用 `askquesition`/`askquestion`。
   - 无提问工具时，直接在对话中提问。
   - 每轮最多 5 个问题，优先 High，再 Medium。
6. 基于用户回答和草稿 PRD，执行 `Optimization` 分析，输出可落地修改建议。
7. 执行 `Heuristic Ideation`，补充增量想法（机会点、实验、风险前置）。
8. 汇总成结构化结果并回传给用户。

## Heuristic Ideation Checklist
- 用户与场景：是否覆盖核心用户、边缘用户、反例场景。
- 问题定义：现状痛点、可替代方案、失败成本。
- 范围边界：明确 In/Out of Scope。
- 价值与指标：北极星指标、守护指标、验收阈值。
- 风险与依赖：技术/合规/运营/外部依赖。
- 上线策略：灰度、回滚、监控、告警。
- 学习计划：A/B 假设、日志埋点、复盘窗口。

## Output Format
按以下四段输出：

1. `补充问题（需用户回答）`
- 按 High/Medium/Low 分组，列出问题与提问理由。

2. `PRD 优化建议`
- 每条包含：`当前问题`、`建议改写`、`预期收益`。

3. `启发式扩展想法`
- 每条包含：`想法`、`适用条件`、`验证方式`、`风险`。

4. `建议下一步`
- 给出 1-3 个可执行动作（例如先补齐 High 问题，再出 v2 PRD）。

## Guardrails
- 不臆造用户输入；缺失信息必须通过提问补齐或明确标注假设。
- 不把“建议”伪装成“已确认需求”。
- 不做与当前 PRD 无关的大范围重构建议。
- 若信息不足以判断，明确写出 `Unknown` 和影响面。
