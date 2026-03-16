# ChatPRD MCP Setup Quick Reference

## Endpoint
- `https://app.chatprd.ai/mcp`

## Subscription Requirement
- Supported: Pro / Team / Enterprise / Trial
- Not supported: Basic

## Common Config Snippets

### Cursor (`mcpServers` JSON)
```json
{
  "mcpServers": {
    "ChatPRD": {
      "url": "https://app.chatprd.ai/mcp"
    }
  }
}
```

### Windsurf / Claude Desktop (`mcp-remote`)
```json
{
  "mcpServers": {
    "ChatPRD": {
      "command": "npx",
      "args": ["mcp-remote", "https://app.chatprd.ai/mcp"]
    }
  }
}
```

### Claude Code
```bash
claude mcp add --transport http ChatPRD https://app.chatprd.ai/mcp
```

### VS Code (`settings.json`)
```json
{
  "mcp": {
    "inputs": [],
    "servers": {
      "ChatPRD": {
        "url": "https://app.chatprd.ai/mcp"
      }
    }
  }
}
```

## Troubleshooting
- 确认已登录 ChatPRD 且会话未过期。
- 确认客户端重启后重新加载 MCP。
- 确认 URL 精确为 `https://app.chatprd.ai/mcp`。
- 若认证失败，重新登录 ChatPRD 后重试。
