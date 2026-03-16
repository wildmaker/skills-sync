# ChatPRD MCP

## 作用

让 IDE 或 AI 客户端直接连接 ChatPRD，在开发环境中访问文档、创建 PRD，并调用 ChatPRD 工具。

## 典型能力

- 读取 ChatPRD 中的需求文档与上下文
- 新建或补充 PRD 草稿
- 在不离开 IDE 的情况下使用 ChatPRD 相关能力

## 配置参考

- 集成状态：Pro Only
- 传输方式：HTTP
- MCP Server URL：`https://app.chatprd.ai/mcp`
- 接入步骤：
  1. 在 ChatPRD Integrations 页面选择对应 IDE/AI client
  2. 复制配置或使用 deeplink
  3. 粘贴到客户端 MCP 设置中

## 使用边界

- 需要确认当前 ChatPRD 账号具备 Pro 权限。
- 鉴权方式以 ChatPRD 客户端集成为准（如 token/session）。
- 涉及敏感需求文档时，遵循最小权限与最小暴露原则。

## 仓库关联

- 当前尚未在仓库工作流中显式引用，后续可在相关 skill/workflow 中补充。
