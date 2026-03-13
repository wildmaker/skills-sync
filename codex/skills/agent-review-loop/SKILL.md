---
name: agent-review-loop
description: "Execute a full agent-to-agent PR review loop: open/update PR, run local self-review, request extra agent reviewers, resolve comments, and repeat until reviewer gates pass. Use when you need multi-round autonomous review with merge/escalation decisions and configurable dimensions (architecture, tests, security, performance, docs)."
---

# agent-review-loop

## What this skill does
- 将单轮 PR 评审升级为多轮闭环：`开 PR -> 自审 -> 外部 agent 审查 -> 修复/回复 -> 再审 -> 通过后合并或升级人工`。
- 支持可配置审查维度：
  - `architecture`
  - `tests`
  - `security`
  - `performance`
  - `docs`
- 复用现有 `git-create-pr` 与 `agent-review-loop-resolve-pr-comments`，并编排 3 个反馈来源子 skill。

## Inputs
- `<base-branch>`: PR 目标分支。
- `<issue>`: 关联 Issue（可选但强烈建议）。
- `<dimensions>`: 审查维度列表，默认 `architecture,tests,security,performance,docs`。
- `<merge-policy>`: `auto-merge` 或 `human-escalation`，默认 `auto-merge`。
- `<max-rounds>`: 最大循环轮数，默认 `6`。

## Constraints
- 不做无限循环；达到 `<max-rounds>` 后必须输出阻塞项并停止自动合并。
- 每一轮都必须重新拉取 3 类信号：PR reviews、inline comments、conversation comments。
- High/Medium 评论必须处理或明确拒绝理由；Low 可延后但需记录。

## Allowed commands
- `git-create-pr`
- `agent-review-loop-resolve-pr-comments`
- `git`
- `gh`
- `sleep`

## Sub-skills to call
- `agent-review-local-cli`
- `agent-review-loop-fetch-bot-reviews`

## Loop workflow
1. 准备 PR：
   - 若当前分支尚无 PR：调用 `git-create-pr` 创建 PR，并在描述中写明 `<issue>` 与 `<dimensions>`。
   - 若已有 PR：确保分支已 push 且 PR 状态可查询。
2. 本地自审（调用 `agent-review-local-cli`）：
   - 按 `<dimensions>` 对当前 diff 做 agent 自审并先修复明显问题。
   - 有改动则直接提交并 push。
3. 获取外部 bot 审查信号：
   - 触发 `agent-review-loop-fetch-bot-reviews`，统一收集 Cursor Bugbot 与 Gemini Code Assist 的本轮反馈。
   - 等待所有已配置 reviewer 反馈到达（可配置每个 bot 的 `<wait-minutes>`；任一超时则以已收到反馈继续）。
4. 统一收集 + 去重 + 批量修复：
   - 使用 `agent-review-loop-resolve-pr-comments` 拉取所有信号源的评论。
   - 对来自不同 reviewer 但指向同一文件同一代码区域的意见做归并去重，保留最高优先级与最具体的修复建议。
   - 按去重后的统一清单一次性修复 → 一次 commit + push（避免多次 push 触发多余的 re-review 循环）。
5. Gate 判定（每轮末）：
   - 通过条件：
     - 无未处理 High/Medium 评论；
     - 未处于 `CHANGES_REQUESTED`；
     - 三个来源的关键信号都已覆盖（无“未检查”）。
   - 未通过：进入下一轮，直到达到 `<max-rounds>`。
6. 退出策略：
   - 若通过且 `<merge-policy>=auto-merge`：执行自动合并（如 `gh pr merge --auto --squash` 或仓库默认策略）。
   - 若通过且 `<merge-policy>=human-escalation`：标记 ready-for-human。
   - 若未通过且达到上限：输出阻塞清单并升级人工。

## Output format
- 每轮输出：
  - `Round N`
  - `New findings (High/Medium/Low)`
  - `Fixes pushed`
  - `Remaining blockers`
- 结束输出：
  - `Decision: auto-merged | escalated-to-human | blocked`
  - `Rationale`
