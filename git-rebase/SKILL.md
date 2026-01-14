---
name: git-rebase
description: 提供 git-rebase 的操作流程与约束；适用于 需要将当前分支 rebase 到目标分支时使用。
---

# git-rebase

## What this skill does
- 执行 rebase 并处理冲突
- 通过提交意图判断保留哪一侧代码

## Constraints
- 编码意图不明确时必须询问用户
- 不做未经确认的破坏性操作

## Allowed commands
- `git rebase`
- `git log`
- `git show`
- `git status`

## Steps
1. 执行将当前分支 rebase 到目标分支的操作。
2. 出现冲突时，分别查看冲突两侧提交记录并总结意图。
3. 根据意图选择保留版本；不明确时询问用户。
4. 完成 rebase 后汇报结果。
