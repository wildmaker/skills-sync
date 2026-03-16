# MCP Registry

这个目录用于集中管理仓库里的 MCP（Model Context Protocol）配置与说明，目标是让 AI Agent 和开发者都能快速知道：

- 这个 MCP 是做什么的
- 该怎么配置
- 在仓库哪里被使用
- 使用时有哪些边界与注意事项

## 目录结构

- `MCP/mcp-catalog.json`：MCP 统一配置清单（机器可读）
- `MCP/docs/*.md`：每个 MCP 的详细说明（人类可读）
- `MCP/templates/mcp-entry.template.json`：新增 MCP 时的条目模板

## 当前 MCP 一览

| ID | 名称 | 状态 | 用途 | 详情 |
| --- | --- | --- | --- | --- |
| `linear` | Linear MCP | planned | 连接 Linear 工单与项目流程 | `MCP/docs/linear.md` |
| `notion` | Notion MCP | planned | 读取 Notion 经验/知识并注入执行上下文 | `MCP/docs/notion.md` |
| `xmind` | XMind MCP | planned | 读取/生成 XMind 规划文件 | `MCP/docs/xmind.md` |
| `chatprd` | ChatPRD MCP | planned | 在 IDE 里直接访问 ChatPRD 文档并创建 PRD | `MCP/docs/chatprd.md` |

## 维护约定

1. 新增 MCP 时，先复制 `MCP/templates/mcp-entry.template.json` 并补全字段。
2. 在 `MCP/mcp-catalog.json` 的 `mcps` 数组中追加条目。
3. 在 `MCP/docs/` 下新增同名说明文档（例如 `linear.md`）。
4. 更新本 README 的汇总表。

## 设计建议（你的想法）

你的方案是正确的：

- 用 **JSON** 作为单一机器可读源（方便 AI 自动检索与校验）
- 用 **README + 每个 MCP 单文档** 做人类可读解释（方便协作与维护）

这套结构后续也可以很容易扩展到：

- 按环境区分（dev/staging/prod）
- 增加健康检查字段（可用性、最近验证时间）
- 自动脚本校验字段完整性
