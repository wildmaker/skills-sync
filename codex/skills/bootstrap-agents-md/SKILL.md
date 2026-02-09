---
name: bootstrap-agents-md
description: 将可复用的项目初始化要求从 `references/` 注入目标仓库 `AGENTS.md`（或 `AGENT.md`）并保持幂等；适用于把个人方法论与经验快速落地到新项目。
version: 0.0.0
---

# bootstrap-agents-md

## What this skill does
- 读取目标仓库的 `AGENTS.md`（若不存在则回退 `AGENT.md`，再不存在则创建 `AGENTS.md`）
- 从 `references/project-bootstrap-requirements.md` 读取初始化要求
- 将要求以受控区块插入目标文件，重复执行只会更新同一区块，不会重复追加

## Constraints
- 仅允许修改目标仓库的 `AGENTS.md` 或 `AGENT.md`
- 不重写既有内容；只管理标记区块 `bootstrap-agents-md:BEGIN/END`
- 若用户要求新增/调整初始化规范，先更新 `references/project-bootstrap-requirements.md` 再执行注入

## Allowed commands
- `codex/skills/bootstrap-agents-md/scripts/insert_bootstrap_requirements.sh`

## Steps
1. 确认目标仓库路径（默认当前目录）。
2. 如需定制要求，先编辑 `references/project-bootstrap-requirements.md`。
3. 运行：
   `codex/skills/bootstrap-agents-md/scripts/insert_bootstrap_requirements.sh <repo_path>`
4. 检查 `AGENTS.md`（或 `AGENT.md`）是否出现受控区块与要求内容。
5. 向用户汇报插入结果与变更文件路径。

## Notes
- 本 skill 默认写入“自分形 & 自描述”方法论要求。
- 如果目标仓库同时存在 `AGENTS.md` 与 `AGENT.md`，优先更新 `AGENTS.md`。
