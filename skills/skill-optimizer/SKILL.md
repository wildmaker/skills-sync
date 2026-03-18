---
name: skill-optimizer
description: >
  审查并优化一个已有的 SKILL.md：对照反模式检查表逐项扫描，输出诊断报告与改写建议；
  反模式检查表随实践经验持续积累。
version: 0.1.0
---

# Skill: skill-optimizer

## Trigger
@skill-optimizer `<skill-path>`

## What this skill does
- 读取目标 skill 文件，逐项对照 `references/anti-patterns.md` 中的反模式检查表进行扫描。
- 对每个命中的反模式，输出：问题描述、严重等级、具体位置、建议修复方案。
- 生成一份诊断报告（Markdown），并给出优化后的 SKILL.md 草稿供用户确认。

## Inputs
- `<skill-path>`: 目标 SKILL.md 的路径（相对或绝对均可）。
  - 若省略，提示用户提供。

## Hard constraints
- 只读分析：不直接修改目标 SKILL.md，仅输出诊断报告与改写建议。
- 用户明确确认后才写入改动。
- 反模式检查表必须从 `references/anti-patterns.md` 加载，不得硬编码在 steps 中。
- 报告中对每个反模式必须给出"命中 / 未命中 / 不适用"三态判定。

## Steps

1. **加载检查表**
   - 读取 `skills/skill-optimizer/references/anti-patterns.md`。
   - 解析所有反模式条目（ID、名称、检测方法、建议方案）。

2. **读取目标 skill**
   - 读取 `<skill-path>` 的完整内容。
   - 提取结构化信息：front-matter、sections（Trigger / What / Inputs / Constraints / Steps / Exit criteria）。

3. **逐项扫描**
   - 对检查表中的每个反模式，按其"检测方法"对目标 skill 进行判定。
   - 标记：`HIT`（命中）/ `PASS`（未命中）/ `N/A`（不适用）。
   - 对 `HIT` 项，定位到具体行或段落，记录上下文。

4. **生成诊断报告**
   - 格式：

     ```
     # Skill Optimization Report: <skill-name>

     ## Summary
     - 扫描项数: N
     - 命中: X (严重: a, 建议: b)
     - 未命中: Y
     - 不适用: Z

     ## Findings

     ### [HIT] AP-001: <反模式名称>
     - **严重等级**: Critical / Warning / Info
     - **位置**: Steps 3-6
     - **问题**: ...
     - **建议**: ...

     ### [PASS] AP-002: <反模式名称>
     ...
     ```

   - 按严重等级排序：Critical > Warning > Info。

5. **生成改写建议**
   - 对所有 `HIT` 项，生成修改后的 SKILL.md 片段。
   - 用 diff 或 before/after 格式呈现，方便用户审阅。

6. **等待用户确认**
   - 展示报告与建议。
   - 用户确认后才写入目标文件。

## Output
- 诊断报告（Markdown 格式，输出到终端 / 聊天窗口）。
- 可选：优化后的 SKILL.md 草稿（用户确认后写入）。

## Exit criteria
- 检查表中所有条目均已逐项判定（无遗漏）。
- 每个 `HIT` 项都附带了具体的改写建议。
- 未经用户确认，未修改目标文件。
