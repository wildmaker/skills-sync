# code-review

## What this skill does
- 获取 PR 元信息与变更
- 调用 `git-pr-summarize` 生成 PR 摘要
- 调用 `report-it-to-me` 生成评审报告并打开预览

## Constraints
- 必须基于实际 PR 数据
- 先生成 PR 摘要再生成评审报告

## Allowed commands
- `gh pr view`
- `gh pr diff`
- `git-pr-summarize`
- `report-it-to-me`
- `open`

## Steps
1. 获取 PR 元信息与文件变更。
2. 运行 `git-pr-summarize` 生成 PR 摘要。
3. 运行 `report-it-to-me` 生成评审报告。
4. 在本地打开评审报告预览。
