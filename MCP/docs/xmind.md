# XMind MCP

## 作用

用于让 AI 读取、检索、生成 `.xmind` 思维导图，支持规划与汇报流程。

## 典型能力

- 将结构化 JSON 生成为 `.xmind`
- 按路径/关键词检索节点
- 提取导图结构用于文档输出

## 配置参考

- 传输方式：常见为 `stdio`
- 启动命令：按本地 MCP server 实现补充
- 文件安全：限制在 allowed directories 内操作

## 使用边界

- 先准备结构化 JSON，再调用生成工具。
- 严格限制导图读写路径。

## 仓库关联

- `skills/xmind/SKILL.md`
- `skills/report-it-to-me/SKILL.md`
