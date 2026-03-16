---
name: symphony-workflow-customizer
description: 根据需求文档定制可运行的 Symphony `WORKFLOW.md`。当用户要求“自定义 workflow / 生成 WORKFLOW.md / 按文档约束定义 Symphony workflow”时使用；会依据 `workflow/customizing-workflow.md` 生成或修订包含 YAML front matter 与 prompt body 的完整工作流。
version: 0.1.0
---

# symphony-workflow-customizer

## Trigger
- 用户要求“新建/修改 Symphony WORKFLOW.md”
- 用户提供产品或流程文档，并要求按文档约束定义 agent workflow
- 用户提到“workflow/customizing-workflow.md”并要求落地为可运行配置

## What this skill does
- 将文档要求转成可执行的 `WORKFLOW.md`（YAML front matter + Markdown body）
- 明确“inline 决策逻辑 vs skill 操作细节”的边界，避免 prompt 过重或缺失关键约束
- 输出可运行、可热更新、可审查的 workflow 草案，并标注假设与待确认项

## Inputs
- `<source_doc>`: 约束来源文档，默认 `workflow/customizing-workflow.md`
- `<target_workflow_path>`: 输出路径，默认 `workflow/WORKFLOW.md`
- `<tracker_info>`: tracker 类型与项目信息（如 Linear project slug）
- `<runtime_info>`: workspace root、agent command、hooks、并发与回合上限

## Constraints
- 严格遵守“`What/When/Whether` inline，`How` 放 skill”原则
- front matter 必须可解析且字段语义完整；无效 YAML 视为失败
- body 必须包含技能触发条件，不允许只列技能名
- 不引入与文档无关的新流程/新状态；不删除已有必要安全护栏
- 信息缺失时以 `TBD` 标注并继续产出，不因小缺口中断

## Allowed commands
- `cat`
- `rg`
- `sed`
- `ls`

## Steps
1. 读取 `<source_doc>`，提取硬性约束：front matter 必填项、status map、guardrails、quality gates、skills 触发规则。
2. 检查现有 `<target_workflow_path>`（若存在），保留可复用段落并定位冲突。
3. 生成或更新 front matter：至少包含 `tracker`、`workspace`、`hooks`、`agent/codex`（或 `agents/routing`）字段。
4. 生成或更新 prompt body，至少包含：
   - issue context 注入块（含 retry/attempt 处理）
   - operating rules
   - related skills（技能 + 触发条件）
   - status map（状态定义 + 转移条件）
   - quality gates / guardrails
   - progress tracking 模板
5. 自检：
   - YAML 边界 `---` 成对
   - 状态机与 terminal states 一致
   - 没有把“操作细节”塞进 inline 规则
   - 所有外部流程都指向对应 skill
6. 输出结果：写入 `workflow/WORKFLOW.md`，并汇总假设、TBD、需要用户补充的最小信息。

## Output requirements
- 变更文件路径与核心差异
- 最终 workflow 中的状态机摘要
- 关键 routing 与 hooks 摘要
- `TBD` 与风险清单（若有）

## References
- `references/workflow-skeleton.md`: 快速起草模板
- `workflow/customizing-workflow.md`: 规范来源
