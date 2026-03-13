---
name: harness-repo-init-bugbot-rules-init
description: 初始化 Bugbot 评审上下文规则文档：创建项目级与目录级 `.cursor/BUGBOT.md`，默认保持极简，仅声明评审关注业务规则与隐藏上下文，不写泛化代码规范。
version: 0.1.0
---

# Skill: harness-repo-init-bugbot-rules-init

## Trigger
@harness-repo-init-bugbot-rules-init

## What this skill does
- 为仓库初始化 Bugbot 可自动加载的规则文档。
- 默认创建项目级 `.cursor/BUGBOT.md`，并在关键大目录（如 `backend/`、`frontend/`）创建目录级 `.cursor/BUGBOT.md`。
- 保持规则极简：强调“记录业务约束/隐藏规则/评审关注点”，不写通用代码风格规范。

## Inputs
- `<repo>`: 目标仓库路径（默认：当前仓库）
- `<scopes>`: 可选，目录级规则初始化范围（默认自动探测已存在的 `backend`、`frontend`）

## Hard constraints
- 必须创建或保留根目录 `.cursor/BUGBOT.md`。
- 若存在 `backend/`、`frontend/` 目录，必须分别创建或保留：
  - `backend/.cursor/BUGBOT.md`
  - `frontend/.cursor/BUGBOT.md`
- 初始化内容必须极简，不得写入与项目无关的泛化编码规范（如命名、格式化、lint 偏好等）。
- 仅在文件缺失时创建；已存在文件不得覆盖。

## Minimal template (recommended)
```md
# BUGBOT Context

本文件用于给自动评审提供“项目特有上下文”。

请优先关注：
- 隐藏业务规则（包括跨模块约束与例外分支）
- 关键数据/状态不变量
- 容易误判为“可重构”但实际不可更改的行为约束

避免在此处写通用代码风格规范；仅记录与本目录强相关的评审事实。
```

## Allowed commands
- `mkdir`
- `test`
- `cat`
- `rg`

## Steps
1. 定位目标仓库
- 若提供 `<repo>`：进入该目录。
- 否则使用当前仓库根目录。

2. 初始化项目级规则文件
- 确保 `<repo>/.cursor/` 存在。
- 若 `<repo>/.cursor/BUGBOT.md` 不存在，按 `Minimal template` 创建。

3. 初始化目录级规则文件
- 默认探测 `backend/`、`frontend/` 两个目录。
- 对每个存在的目录，确保 `<dir>/.cursor/BUGBOT.md` 存在；缺失则按 `Minimal template` 创建。
- 若传入 `<scopes>`，在不违反默认要求的前提下，额外处理对应目录。

4. 最小校验
- 至少保证根目录 `.cursor/BUGBOT.md` 存在。
- 若存在 `backend/`、`frontend/`，对应目录级 `BUGBOT.md` 均存在。

## Exit criteria
- Bugbot 规则文件初始化完成，且未覆盖已有自定义内容。
- 规则内容保持“业务上下文优先、通用规范最小化”。
