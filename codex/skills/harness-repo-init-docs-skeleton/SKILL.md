---
name: harness-repo-init-docs-skeleton
description: Initialize the repository documentation skeleton for harness-repo-init. Use when bootstrapping a repo to create map-style AGENTS.md and the minimum docs-as-system-of-record structure without touching business code.
---

# harness-repo-init-docs-skeleton

## Trigger
@harness-repo-init-docs-skeleton

## What this skill does
- 初始化“智能体优先”仓库骨架，重点是可读性、可导航性、可持续演进。
- 建立“短 AGENTS.md + 结构化 docs/”模式，避免把所有规则堆进单文件。
- 通过脚本创建目录与最小必需文档，默认不覆盖已有文件。

## Inputs
- `<repo_path>`: 目标仓库路径，默认当前目录。
- `<project_name>`: 可选，默认使用仓库目录名。

## Constraints
- 不覆盖已有业务代码或已有文档内容。
- 仅在缺失时创建文件；已存在文件保持不变。
- 若仓库已有 `AGENTS.md`，仅提示人工合并，不自动重写。

## Allowed commands
- `codex/skills/harness-repo-init-docs-skeleton/scripts/init_harness_repo_docs_skeleton.sh`
- `python3 /Users/wildmaker/.codex/skills/.system/skill-creator/scripts/quick_validate.py`（用于验证 skill 结构）

## Steps
1. 进入目标仓库根目录，确认是 Git 仓库（推荐但非强制）。
2. 执行初始化脚本：
   `codex/skills/harness-repo-init-docs-skeleton/scripts/init_harness_repo_docs_skeleton.sh <repo_path> --project "<project_name>"`
3. 检查输出：
   - 是否创建 `docs/` 结构化目录
   - 是否生成最小引导文档（`ARCHITECTURE.md`、`DESIGN.md`、`QUALITY_SCORE.md` 等）
   - 是否创建短版 `AGENTS.md`（仅当原文件不存在）
4. 如仓库已存在 `AGENTS.md`，基于 `references/agents-map-template.md` 手工合并为“目录式地图”。
5. 可选：补充 `docs/references/` 下的外部依赖说明（给智能体可读版本）。

## Expected layout (created if missing)
```text
AGENTS.md
ARCHITECTURE.md
docs/
  design-docs/
    index.md
    core-beliefs.md
  exec-plans/
    active/
    completed/
    tech-debt-tracker.md
  generated/
    db-schema.md
  product-specs/
    index.md
  references/
DESIGN.md
FRONTEND.md
PLANS.md
PRODUCT_SENSE.md
QUALITY_SCORE.md
RELIABILITY.md
SECURITY.md
```

## References
- `references/methodology.md`: 方法论摘要与初始化边界说明。
- `references/agents-map-template.md`: 短版 AGENTS.md 模板（地图式目录，不做百科全书）。
