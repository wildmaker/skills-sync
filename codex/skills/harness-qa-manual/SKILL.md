---
name: harness-qa-manual
description: 手工 QA 验证技能：基于隔离实例执行可重复的 manual 测试清单，记录复现步骤、截图证据、结论与回归结果，支持修复前后对比。
version: 0.1.0
---

# Skill: harness-qa-manual

## Trigger
- 需要人工探索或验收关键路径
- 自动化覆盖不足，需要补充 manual 验证
- 需要沉淀可交付的 QA 记录

## What this skill does
- 生成本次测试会话的手工检查清单
- 对每个步骤记录预期、实际、证据与结论
- 支持修复前后同路径复测与截图对比

## Inputs
- `<instance-url>`: 被测实例地址
- `<test-scope>`: 本轮测试范围（功能/页面/模块）
- `<critical-flows>`: 关键主流程列表
- `<evidence-dir>`: 证据目录

## Outputs
- `manual-qa-checklist.md`
- `manual-qa-results.md`
- 关键步骤截图（按流程和步骤编号）

## Constraints
- 先测主流程，再测边界路径，避免无序探索
- 每个失败项必须含复现步骤和至少一张截图
- 不把“无法复现”当作“问题已修复”

## Allowed commands
- `open`
- `rg`
- `mkdir`
- `cp`
- `date`

## Steps
1. 准备会话
   - 确认实例 URL、版本标识、测试范围
   - 创建 `manual-qa-checklist.md`
2. 执行用例
   - 按 `critical-flows` 顺序逐项验证
   - 每项记录：步骤、预期、实际、结论（Pass/Fail/Blocked）
3. 失败项处理
   - 记录最小复现路径
   - 附截图与必要日志片段
4. 修复后复测
   - 复跑失败项
   - 标注是否通过并追加“前后对比结论”
5. 汇总输出
   - 通过率、阻塞项、遗留风险、建议下一步

## Exit criteria
- 关键流程全部有测试结论
- 所有失败项都有可复现描述与证据
- 回归结果可被他人复查

