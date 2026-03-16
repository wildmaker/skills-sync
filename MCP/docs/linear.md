# Linear MCP

## 作用

用于让 AI 访问和操作 Linear（项目、Issue、评论、状态流转）。

## 典型能力

- 查询项目/Issue
- 新建或更新 Issue
- 回写进度评论

## 配置参考

- 传输方式：HTTP
- Endpoint：`https://mcp.linear.app/mcp`
- 鉴权：`LINEAR_API_KEY`

## 使用边界

- 优先窄查询，避免拉取过大 JSON。
- 如工作流明确要求 `linear_graphql`，应优先遵循项目工作流。

## 仓库关联

- `WORKFLOW.md`
- `skills/linear/SKILL.md`
- `.agents/skills/symphony-setup/SKILL.md`
