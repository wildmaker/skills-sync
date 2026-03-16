---
name: agent-review-loop-fetch-bot-reviews
description: Collect PR review signals for the current push from multiple external bots (Cursor Bugbot and Gemini Code Assist) in one pass. Use inside harness-agent-review-loop to wait, detect, and normalize bot feedback before comment resolution.
---

# agent-review-loop-fetch-bot-reviews

## What this skill does
- 统一拉取外部 reviewer bot 的评审信号，不再拆成多个 skill。
- 默认覆盖两个来源：
  - Cursor Bugbot
  - Gemini Code Assist
- 把不同来源的 reviews/comments 标准化后输出给主循环。

## Inputs
- `<pr-number>`: 目标 PR 编号。
- `<bots>`: reviewer bot 列表，默认 `cursor-bugbot,gemini-code-assist`。
- `<wait-minutes-per-bot>`: 每个 bot 的最长等待时间，默认 `cursor-bugbot=10,gemini-code-assist=15`。

## Allowed commands
- `gh`
- `sleep`

## Steps
1. 校验 PR 可访问：`gh pr view <pr-number> --json ...`。
2. 对 `<bots>` 逐个轮询（每分钟一次）：
   - 检查 PR reviews、inline comments、conversation comments。
   - 判断该 bot 是否已在本轮 push 后给出反馈。
3. 到达停止条件即结束：
   - 所有 bot 都已返回信号；或
   - 对应 bot 达到等待上限。
4. 输出统一结果：
   - `received_by_bot`: 各 bot 是否收到反馈
   - `review_states`: APPROVED/COMMENTED/CHANGES_REQUESTED/none
   - `findings`: 可执行问题列表（含优先级）
   - `unknown_source_signals`: 无法稳定识别来源但需要处理的有效评论

## Detection hints
- Cursor Bugbot 识别：author/reviewer 包含 `cursor`、`bugbot`、`cursor[bot]`。
- Gemini 识别：author/reviewer 包含 `gemini-code-assist`、`gemini`、`google`（结合上下文）。
- 来源无法确定时，不丢弃评论，标记 `unknown-source` 并交由主循环统一分流。

