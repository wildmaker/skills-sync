---
name: peer-rethink
description: Re-evaluate a question using another engineer's or AI's reply as new input. Use when the user says things like “这是另一个工程师的回复，你怎么看”, “另一个 AI 是这么说的，你再想想”, or pastes an external answer and wants a stronger updated judgment instead of a defensive restatement.
---

# Peer Rethink

Use this skill when the user provides another engineer's or AI's answer and wants a deeper second pass.

## Goal

- Treat the external reply as serious input, not authority.
- Re-think from first principles and update the answer if needed.
- Make the delta explicit so the user can see whether the outside reply actually changes the conclusion.

## Workflow

1. Recover the original question and your prior answer from thread context if available.
2. Read the external reply carefully and extract its concrete claims, assumptions, and evidence.
3. Re-evaluate the problem from first principles instead of defending the earlier answer.
4. Compare your updated view with the external reply:
   - what is correct
   - what is incomplete or mistaken
   - what changes your mind
   - what still needs verification
5. Give an updated answer, not just a critique.

## Response shape

Prefer this structure when it helps:

- `我同意的部分`
- `我不同意或保留意见的部分`
- `这份回复改变了我什么判断`
- `我的更新结论`
- `仍需确认的点`

## Rules

- Do not defend your earlier answer out of consistency.
- If the other reply is better, say so plainly and absorb it.
- If the other reply is weak or incorrect, explain why with specifics.
- Avoid vague "both sides have merit" language unless the evidence truly is mixed.
- Do not repeat the pasted reply in full; summarize the key claims instead.
- If the original question is missing, say what you can infer and continue with a best-effort critique plus updated recommendation.

## Good trigger patterns

- `这是另一个工程师的回复，你怎么看`
- `另一个 AI 是这么说的，你再想想`
- `结合这段回复重新判断`
- `我把别人的答复贴给你，你更新一下结论`
