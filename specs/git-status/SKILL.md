# git-status

## What this skill does
- 运行 `git status` 并总结 not staged 变更
- 询问是否继续执行 `git commit`

## Constraints
- 未经确认不执行提交

## Allowed commands
- `git status`
- `git diff`

## Steps
1. 运行 `git status` 查看工作区状态。
2. 总结 not staged 变更内容。
3. 询问是否需要执行 `git commit`。
