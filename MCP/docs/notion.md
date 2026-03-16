# Notion MCP

## 作用

用于让 AI 从 Notion 拉取经验与知识，转为可执行上下文（如注入到 `AGENTS.md`）。

## 典型能力

- 列出可访问资源
- 读取页面/数据库内容
- 提炼结构化经验

## 配置参考

- 传输方式：按客户端实现（`stdio` 或 `http`）
- 鉴权：`NOTION_API_KEY`
- Endpoint/启动命令：按实际 MCP 实现补充

## 使用边界

- 默认只读权限，最小化授权范围。
- MCP 不可用时应快速失败并提示先完成配置。

## 仓库关联

- `skills/inject-experience/SKILL.md`
