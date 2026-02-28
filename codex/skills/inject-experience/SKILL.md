---
name: inject-experience
description: 使用 Notion MCP 从给定 Notion 知识库提取经验，并将可执行经验注入当前项目 `AGENTS.md`（或 `AGENT.md`）受控区块，帮助 LLM 在执行任务时参考历史经验与约束。
version: 0.1.0
---

# inject-experience

## What this skill does
- 从用户指定的 Notion 知识库（页面/数据库）读取经验条目。
- 将经验整理成“可执行规则 + 适用场景 + 反例/风险”的结构化内容。
- 将内容注入当前项目的 `AGENTS.md`（不存在则回退 `AGENT.md`，都不存在则创建 `AGENTS.md`）。
- 使用受控区块保证幂等更新，重复执行只更新同一区块，不重复追加。

## Trigger
- 用户提到“注入经验”“从 Notion 同步经验”“把 Notion 经验写入 AGENTS.md”。
- 或用户明确点名使用 `$inject-experience`。

## Constraints
- 仅修改项目根目录的 `AGENTS.md` / `AGENT.md`。
- 不改动受控区块以外内容。
- Notion 经验必须先“去噪与归一化”：删除空洞叙述、保留可执行规则。
- 经验条目不应泄露密钥、令牌、个人敏感信息。
- 当 Notion 数据缺失关键字段时，不中断流程；在输出中标注 `TBD`。

## Input contract
最小输入建议包含：
- `knowledge_base`: Notion 页面 URL、数据库 URL 或可解析 ID
- `scope`: 可选，经验范围（例如：backend / frontend / testing / release）
- `max_items`: 可选，最多注入条数（默认 20）

## Notion extraction policy
- 优先读取“高信号字段”：标题、问题场景、决策、踩坑、行动准则、验证方式。
- 如果是数据库：按 `updated_time` 倒序，优先最新且状态为可用/已验证的条目。
- 如果是页面集合：抽取二级标题下的 checklist/规则句。
- 去重规则：标题近似 + 核心规则相同视为重复，仅保留信息更完整版本。

## AGENTS injection format
注入到以下受控区块（不存在则创建）：

```md
<!-- inject-experience:BEGIN -->
## Notion Experience Memory (Managed by inject-experience)

### EXP-001 <经验标题>
- Context: <适用场景>
- Rule: <可执行规则>
- Anti-pattern: <常见错误/禁忌>
- Check: <如何自检是否满足>
- Source: <Notion page url or id>
- Updated: <YYYY-MM-DD>

<!-- inject-experience:END -->
```

要求：
- 编号稳定（按当前区块已有编号递增，更新同标题时保留原编号）。
- 每条经验都必须可执行、可验证。
- 保持 Markdown 简洁，不写长段散文。

## Allowed commands/tools
- MCP: `list_mcp_resources`, `list_mcp_resource_templates`, `read_mcp_resource`（用于发现与读取 Notion 资源）
- Shell: `rg`, `ls`, `cat`, `sed`, `awk`, `mkdir`

## Steps
1. 校验输入：确认 `knowledge_base` 可访问，确定 `scope` 与 `max_items`。
2. 通过 MCP 枚举并读取 Notion 资源（页面或数据库条目）。
3. 归一化经验：提取 `Context / Rule / Anti-pattern / Check / Source / Updated`。
4. 过滤与去重：保留高价值、可执行、可验证经验。
5. 定位 `AGENTS.md`（或 `AGENT.md`），插入/更新受控区块 `inject-experience:BEGIN/END`。
6. 输出结果：
   - 更新了哪个文件
   - 注入/更新条目数
   - 因字段缺失而标记 `TBD` 的条目

## Failure handling
- 若 MCP 未配置 Notion：明确提示“Notion MCP 不可用”，并要求用户先完成 MCP 配置。
- 若 `knowledge_base` 无法解析：提示用户提供可访问的 Notion URL/ID。
- 若 `AGENTS.md` 不存在：自动创建并写入受控区块。

## Output checklist
- 受控区块存在且只有一份。
- 条目结构完整（至少包含 `Context`、`Rule`、`Check`）。
- 无敏感信息。
- 变更最小化（仅目标文件）。
