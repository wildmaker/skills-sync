# README

## 整体设计思想
1. codex 始终保持 `skills` 与 `repo/codex/` 软链接，也就是真实的 skill 目录只存放在 repo 中
2. codex 和除了 claude 外的其他 agent 工具的 skill 也都是软链接到 `repo/codex`
3. claude 的 skills 也是软链接到 `repo/claude` 目录
4. 分别为 claude / codex 定制一个 adapter skill，用来让 claude 能用到 codex 的最新 skill
