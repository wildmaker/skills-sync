---
name: note-it
description: 提供 note-it 的操作流程与约束；适用于 需要从用户问题中提炼缺失的核心知识并写成笔记时使用。
version: 0.0.0
---

# note-it

## What this skill does
- 识别基础概念、关键逻辑、核心原理、必备前提
- 在 `docs/note` 下创建中文 Q&A 形式的 Zettelkasten 笔记

## Constraints
- 笔记必须简短精炼
- 仅基于用户提问与已有上下文

## Allowed commands
- None

## Steps
1. 从用户问题中提炼缺失的核心知识模块。
2. 按 Q&A 形式写成简短笔记。
3. 将笔记保存到 `docs/note` 目录并返回路径。
