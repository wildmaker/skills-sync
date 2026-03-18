# Skill Anti-Patterns Checklist

> **用途**：`skills-optimizer` 的检测数据源。每个反模式有唯一 ID，便于诊断报告引用。
> **维护方式**：发现新反模式后，在末尾追加新条目，保持 ID 递增。

---

## 条目格式说明

每个反模式条目包含以下字段：

| 字段 | 说明 |
|------|------|
| **ID** | 唯一标识，格式 `AP-NNN` |
| **名称** | 一句话概括 |
| **严重等级** | `Critical` / `Warning` / `Info` |
| **症状** | 目标 skill 中的可观测特征 |
| **检测方法** | optimizer 应如何判定命中 |
| **风险** | 不修复会导致什么问题 |
| **建议方案** | 具体的修复方法 |
| **示例** | 可选，正反示例 |

---

## AP-001: 多步编排无显式检查点

**严重等级**: Critical

**症状**:
- Skill 的 Steps 中串行调用 ≥3 个子 skill（通过"调用 `<skill-name>`"或"按 `<skill-path>` 执行"等表述）。
- Steps 中没有要求 agent 在执行前建立 todo list / 检查点清单。
- 没有在每个子 skill 完成后要求标记完成状态或做中间校验。

**检测方法**:
1. 扫描 Steps 段落，统计"调用"/"按...执行"/"读取...SKILL.md 并执行"等子 skill 调用表述的数量。
2. 若调用数 ≥ 3，检查是否存在以下任一机制：
   - 显式要求建立 todo list / 执行清单 / checkpoint。
   - 每个子 skill 完成后有标记完成状态的指令。
   - 每个子 skill 完成后有中间校验步骤。
3. 若调用数 ≥ 3 且上述机制均不存在 → `HIT`。

**风险**:
- Agent 行为是概率性的，每轮决策有偏航概率 p。N 步串行的整体成功率约为 (1-p)^N，步数越多失败率指数增长。
- 执行到后半段时，agent 可能遗忘前期约束或丢失当前进度。
- 中途失败后无法从断点恢复，只能从头重来。
- 从子 skill 返回后，agent 容易忘记自己在父 skill 的哪一步。

**建议方案**:
在 Steps 段落**最前方**插入一个"执行协议"步骤，要求 agent：

1. 在开始执行前，将后续所有 step 注册为 todo item（状态初始化为 `pending`）。
2. 开始执行某步时，将其标记为 `in_progress`。
3. 完成某步后，立即标记为 `completed`，再开始下一步。
4. 每个子 skill 调用完成后，执行该步的 exit criteria 校验（若有），校验通过再标记完成。

模板：

```markdown
## Execution protocol (must follow)
在开始执行 Steps 之前，必须先使用 agent 的任务管理能力（如 TodoWrite、
todo list 或等效机制）将下方所有 Step 注册为待办项，状态初始为 pending。
- 开始某步 → 标记 in_progress（同一时间仅一个）。
- 完成某步 → 立即标记 completed。
- 遇阻塞 → 标记 blocked + 原因，跳到下一步。
此协议确保 agent 在长链执行中始终知道"我在哪、做完了什么、下一步是什么"。
```

**示例**:

反例（命中此反模式）：
```markdown
## Steps
1. 同步 skills
2. 调用 `harness-repo-init-docs-skeleton`
3. 调用 `harness-repo-init-openspec-init`
4. 调用 `tool-use-symphony-setup`
5. 调用 `harness-repo-init-bugbot-rules-init`
6. 更新 Agent.md
```

正例（已修复）：
```markdown
## Execution protocol (must follow)
在开始执行前，将 Step 1-7 注册为 todo item（pending）。
每步完成后立即标记 completed，再开始下一步。

## Steps
1. 同步 skills
2. 调用 `harness-repo-init-docs-skeleton` → 完成后校验文档骨架存在
3. 调用 `harness-repo-init-openspec-init` → 完成后校验 OpenSpec 目录
4. 调用 `tool-use-symphony-setup` → 完成后校验 WORKFLOW.md
5. 调用 `harness-repo-init-bugbot-rules-init` → 完成后校验 BUGBOT.md
6. 更新 Agent.md → 完成后校验 policy block 存在
7. 最终校验
```

---

## AP-002: 子 skill 完成后无中间校验

**严重等级**: Warning

**症状**:
- Skill 调用了子 skill，但在调用之后没有立即校验子 skill 的 exit criteria。
- 校验被集中放在最后一步（如"最小校验"），而非分散在每步之后。

**检测方法**:
1. 识别所有子 skill 调用点。
2. 检查每个调用点之后是否紧跟校验步骤（如"确认...存在"、"校验..."、"检查..."）。
3. 若 ≥ 50% 的子 skill 调用后没有紧跟校验 → `HIT`。

**风险**:
- 子 skill 执行失败或部分完成时，错误会被后续步骤放大。
- 集中校验放在最后，当发现问题时已无法确定是哪一步出错。
- Agent 在多轮执行后可能已丢失子 skill 输出的上下文，回溯困难。

**建议方案**:
在每个子 skill 调用步骤中，内联一个简短的 exit criteria 校验。格式：
```markdown
N. 调用 `<sub-skill>` → 完成后校验：<具体条件>
```
将最终的集中校验保留为兜底（catch-all），但不依赖它作为唯一校验手段。

---

## AP-003: 嵌套深度超过两层

**严重等级**: Warning

**症状**:
- Skill A 调用 Skill B，而 Skill B 自身又调用 Skill C（形成 A → B → C 三层嵌套）。
- 越深的嵌套意味着 agent 需要维护越多层的"返回地址"状态。

**检测方法**:
1. 读取目标 skill 调用的所有子 skill。
2. 递归检查每个子 skill 是否自身又调用了其他 skill。
3. 若存在 ≥ 3 层嵌套链 → `HIT`。

**风险**:
- Agent 无调用栈，嵌套越深越容易"忘记回来"。
- 每增加一层嵌套，整体失败率近似翻倍。
- 调试困难：失败时难以定位是哪一层出了问题。

**建议方案**:
- 尽量保持 orchestrator → leaf skill 的两层结构。
- 若三层不可避免，在中间层 skill 中也加入 Execution protocol（AP-001 的建议方案）。
- 考虑将深层嵌套展平：把 Skill C 的步骤直接内联到 Skill B 中，减少一层调用。

---

## AP-004: 缺少 Exit criteria

**严重等级**: Warning

**症状**:
- SKILL.md 没有 `Exit criteria` 或 `Output` 段落。
- 或者 exit criteria 仅为模糊描述（如"完成初始化"），没有可机器判定的条件。

**检测方法**:
1. 检查 SKILL.md 中是否存在 `## Exit criteria` 或 `## Output` 段落。
2. 若存在，检查内容是否包含可验证的条件（如文件存在、命令输出、状态值）。
3. 若段落不存在，或所有条件均为模糊描述 → `HIT`。

**风险**:
- Agent 无法判断"做完了没有"，可能过早结束或无限循环。
- 父 skill 调用此 skill 后无法校验子 skill 是否真正完成。
- 不可测试、不可复现。

**建议方案**:
添加 `## Exit criteria` 段落，每个条件需满足：
- 可通过命令、文件检查或 API 调用验证（非主观判断）。
- 格式：`- <条件描述>（检查方法：<具体命令或检查步骤>）`。

---

## AP-005: Hard constraints 与 Steps 矛盾或冗余

**严重等级**: Info

**症状**:
- Hard constraints 中声明了某个约束，但 Steps 中的操作与之矛盾。
- 或者 Hard constraints 中的内容与 Steps 完全重复，没有额外约束价值。

**检测方法**:
1. 逐条读取 Hard constraints。
2. 在 Steps 中查找对应的操作，检查是否存在矛盾。
3. 检查是否存在 Hard constraints 仅仅是 Steps 的重述（无额外约束信息）。
4. 存在矛盾 → `HIT`（Critical）；仅冗余 → `HIT`（Info）。

**风险**:
- 矛盾会导致 agent 行为不确定（取决于哪段指令权重更高）。
- 冗余增加 token 消耗，挤占有限的上下文窗口。

**建议方案**:
- 矛盾：修正其中一方，确保一致性。
- 冗余：将纯操作性内容保留在 Steps 中，Hard constraints 只保留"不做什么"类型的边界约束。

---

<!-- 新反模式请追加在此处，ID 从 AP-006 开始 -->
