---
name: harness-repo-init
description: 初始化一个新仓库以便使用 epic-auto-build-v2 全流程自动化开发：先从中央仓库同步 skills 到目标仓库 `.agents/skills/`，再依次调用 harness-repo-init-docs-skeleton、harness-repo-init-openspec-init 与 harness-repo-init-bugbot-rules-init，最后把 Autonomous 连续执行约束写入目标仓库 Agent.md 的执行清单。
version: 0.2.0
---

# Skill: harness-repo-init

## Trigger
@harness-repo-init

## What this skill does
- 为目标仓库完成 epic-auto-build-v2 自动化开发的初始化准备。
- 强制串联五个动作：
  1. 从 skills 中央仓库同步技能文件到目标仓库 `<repo>/.agents/skills/`。
  2. 调用 `harness-repo-init-docs-skeleton` 创建文档骨架与最小 AGENTS 地图。
  3. 调用 `harness-repo-init-openspec-init` 完成 OpenSpec 初始化。
  4. 调用 `harness-repo-init-bugbot-rules-init` 初始化 Bugbot 评审上下文规则（含根目录与关键大目录的 `.cursor/BUGBOT.md`）。
  5. 将“路由后不中断”的执行约束写入目标仓库 `Agent.md` 的执行清单，降低模型偏航概率。

## Inputs
- `<repo>`: 目标仓库路径（默认：当前仓库）

## Hard constraints
- 必须按顺序执行：同步中央 skills -> `harness-repo-init-docs-skeleton` -> `harness-repo-init-openspec-init` -> `harness-repo-init-bugbot-rules-init` -> 更新 `Agent.md`。
- 中央仓库地址必须取自本仓库 `origin` remote（本 repo 的 remote 即中央仓库地址）。
- `skills` 同步必须幂等：重复执行后，`<repo>/.agents/skills/` 内容与中央仓库 `skills/` 保持一致，不得重复嵌套目录。
- `Agent.md` 更新必须幂等：同一约束不得重复追加。
- 若 `Agent.md` 不存在，必须创建并写入“执行清单”段落后再追加约束。
- 未经用户明确要求，不修改 `CLAUDE.md`、`AGENTS.md` 或其他流程文件。

## Required policy block (must be inserted verbatim)
```md
请按 epic-auto-build-v2 全流程自动执行。
要求：Autonomous 模式，不要在路由选择后暂停或等待确认。
路由判定后立即进入对应后续阶段并持续推进，直到遇到真正阻塞（按 Blocked 规则处理并继续下一项）。
```

## Allowed commands
- `rg`
- `cat`
- `sed`
- `git`
- `mkdir`
- `rm`
- `rsync`

## Steps
1. 定位目标仓库
- 若提供 `<repo>`：进入该目录。
- 否则使用当前仓库根目录（可用 `git rev-parse --show-toplevel` 确认）。

2. 从中央仓库同步 `skills` 到 `<repo>/.agents/skills/`
- 先读取中央仓库地址（本 repo 的 `origin`）：
  - `CENTRAL_REPO_URL=$(git remote get-url origin)`
- 使用临时目录 clone 中央仓库（例如 `<repo>/.agents/.skills-central-tmp`）：
  - `git clone --depth 1 "$CENTRAL_REPO_URL" "<repo>/.agents/.skills-central-tmp"`
- 确保目标目录存在并同步：
  - `mkdir -p "<repo>/.agents/skills"`
  - `rsync -a --delete "<repo>/.agents/.skills-central-tmp/skills/" "<repo>/.agents/skills/"`
- 清理临时目录：
  - `rm -rf "<repo>/.agents/.skills-central-tmp"`
- 要求：同步后技能目录结构为 `<repo>/.agents/skills/<skill-name>/SKILL.md`，不得出现 `<repo>/.agents/skills/skills/...` 双层嵌套。

3. 调用 `harness-repo-init-docs-skeleton`
- 按 `skills/harness-repo-init-docs-skeleton/SKILL.md` 完成仓库文档骨架初始化。
- 确认仅创建缺失文档，不覆盖已有业务内容。

4. 调用 `harness-repo-init-openspec-init`
- 按 `skills/harness-repo-init-openspec-init/SKILL.md` 完整执行初始化流程。
- 若 OpenSpec CLI 缺失，先安装后再执行 `openspec init`。

5. 调用 `harness-repo-init-bugbot-rules-init`
- 按 `skills/harness-repo-init-bugbot-rules-init/SKILL.md` 初始化 Bugbot 规则文件。
- 至少保证以下路径按需存在：
  - `<repo>/.cursor/BUGBOT.md`
  - `<repo>/backend/.cursor/BUGBOT.md`（当 `backend/` 存在）
  - `<repo>/frontend/.cursor/BUGBOT.md`（当 `frontend/` 存在）

6. 更新目标仓库 `Agent.md` 执行清单
- 目标文件：`<repo>/Agent.md`。
- 若不存在：创建最小结构并包含 `## 执行清单` 段落。
- 在“执行清单”中加入 `Required policy block`（逐字一致）。
- 若文件中已包含该 block 的任意一行（建议用第一行作为锚点）：
  - 视为已配置，禁止重复追加。

7. 最小校验
- 校验 `<repo>/.agents/skills/` 下至少存在一个 `SKILL.md`（示例：`<repo>/.agents/skills/harness-repo-init/SKILL.md`）。
- 校验 `Agent.md` 中能检索到以下三行：
  - `请按 epic-auto-build-v2 全流程自动执行。`
  - `要求：Autonomous 模式，不要在路由选择后暂停或等待确认。`
  - `路由判定后立即进入对应后续阶段并持续推进，直到遇到真正阻塞（按 Blocked 规则处理并继续下一项）。`

## Exit criteria
- 中央仓库 `skills/` 已成功同步到 `<repo>/.agents/skills/`（目录结构正确且无 `skills/skills` 双层嵌套）。
- `harness-repo-init-docs-skeleton` 已完成文档骨架初始化（不覆盖既有内容）。
- `harness-repo-init-openspec-init` 已在目标仓库执行完成。
- `harness-repo-init-bugbot-rules-init` 已完成规则文件初始化（根目录必有，`backend/` 与 `frontend/` 存在时目录级文件也存在）。
- `Agent.md` 执行清单已包含且仅包含一份 `Required policy block`。
