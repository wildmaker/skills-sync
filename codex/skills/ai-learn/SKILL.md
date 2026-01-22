---
name: ai-learn
description: 提供 ai-learn 的操作流程与约束；适用于 需要在 `docs/ai-lesson` 下记录 AI 编程中的错误复盘笔记时使用。
version: 0.0.0
---

# ai-learn

## What this skill does
- 基于提供的上下文整理错误复盘
- 输出精简笔记，包含犯错场景、错误动作、避免方法

## Constraints
- 不写细节代码
- 不臆测未提供的事实

## Allowed commands
- None

## Steps
1. 读取用户提供的上下文与错误信息。
2. 用极简要点写出：犯错场景、错误动作、下次避免方法。
3. 将笔记写入 `docs/ai-lesson` 目录并给出路径。
