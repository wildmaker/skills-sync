---
name: harness-qa-e2e
description: 生成并执行智能体可用的 E2E QA 闭环：复现 bug -> 采集证据（截图/录制/DOM）-> 修复 -> 重新验证 -> 证据对比；Web 场景调用 harness-qa-e2e-web 子技能。
version: 0.1.0
---

# Skill: harness-qa-e2e

## Trigger
- 需要把一个缺陷做成可复现、可验证的 E2E 闭环
- 需要在修复前后自动生成截图/日志证据
- 需要将 QA 步骤标准化给智能体执行

## What this skill does
- 定义 E2E 场景和验收断言
- 复现缺陷并采集基线证据
- 驱动修复后的回归验证与证据对比
- 输出可审计的 QA 结果摘要

## Inputs
- `<instance-url>`: 被测实例地址（推荐来自 `harness-qa-env-startup`）
- `<bug-scenario>`: 缺陷复现路径（步骤、预期、实际）
- `<assertions>`: 关键断言（文本、状态、交互结果）
- `<platform>`: `web | mobile | desktop`

## Outputs
- 结构化 QA 报告（复现结果、修复验证、剩余风险）
- 修复前后对比证据（截图/日志/关键 DOM 信息）

## Constraints
- 必须先复现再修复，禁止跳过基线采集
- 每次回归必须复用同一断言集合，避免“换标准通过”
- 不引入与当前缺陷无关的额外功能验证

## Allowed commands
- `git`
- `rg`
- `npm`
- `pnpm`
- `yarn`
- `pytest`
- `playwright`
- `jest`
- `detox`

## Workflow
1. 定义测试边界：明确本次只验证一个缺陷闭环与其直接回归范围。
2. 运行复现阶段：
   - 执行复现步骤并记录失败点
   - 保存“修复前”证据（截图、日志、错误堆栈）
3. 若 `<platform>=web`：
   - 调用 `harness-qa-e2e-web` 执行浏览器自动化（导航/DOM 快照/截图）
4. 执行修复后回归：
   - 按同一脚本、同一路径重跑
   - 采集“修复后”证据
5. 对比结果：
   - 断言是否全部通过
   - 修复前后截图与关键页面状态是否一致达到预期
6. 输出总结：
   - Reproduced: Yes/No
   - Fixed: Yes/No
   - Regressions: None/Found
   - Evidence paths

## Exit criteria
- 有完整复现证据 + 修复后回归证据 + 对比结论
- 若失败，提供可直接复跑的最小步骤与日志路径

