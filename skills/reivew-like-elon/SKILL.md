---
name: reivew-like-elon
description: Use when reviewing any feature architecture or design proposal to prevent over-engineering. Enforce Elon Musk's 5-Step Algorithm in strict order (question requirements, delete, simplify, accelerate, automate) before giving final recommendations.
version: 0.1.0
---

# Skill: Reivew Like Elon

## Purpose
AI coding agent 在 review 某个功能的技术方案（architecture / design proposal）时，必须严格避免 **over-engineering**。
本 skill 以 **Elon Musk 的 5-Step Algorithm** 为核心，强制 agent 先质疑、删减、再简化，最后才考虑优化和自动化。
目标：产出最简、可快速迭代、真正解决当前需求的方案，而不是“聪明工程师最常犯的错误——优化一个本不该存在的东西”。

## Core Framework: Elon Musk's 5-Step Algorithm
**必须严格按顺序执行**，绝不允许跳步或反序：

1. **Make Requirements Less Dumb（让需求变得不蠢）**
   - 每一条需求都要质疑：这是真实用户现在需要，还是“以防万一”“企业级”“未来可扩展”？
   - 特别危险：聪明人给的需求，最容易不质疑。
   - 用 First Principles 拆解：这个功能本质上只需要解决什么问题？把所有假设剥掉。

2. **Delete the Part or Process（大力删减）**
   - “The best part is no part.”
   - 问自己：能不能删掉 10%+ 的组件/层/抽象/服务？如果删得不够，就继续删。
   - 常见 over-engineering 红旗：
     - 多余的 microservice / event bus / cache layer
     - 过度抽象（Repository / Service / DTO / Facade 等层层包装）
     - “just in case”的配置、fallback、logging、monitoring
     - 还没上线就考虑分布式事务、CQRS、Event Sourcing

3. **Simplify or Optimize（简化 & 优化）**
   - **只有前两步完成后才能做这一步**。
   - 先简化（用更少的代码、更简单的技术栈、更少的依赖），再优化。
   - 经典错误：直接跳到这一步优化一个本该删除的东西。

4. **Accelerate Cycle Time（加速迭代周期）**
   - 方案必须支持快速 build → test → deploy → feedback。
   - 优先选择本地可跑、单机可测、CI 简单、rollback 容易的方案。

5. **Automate（最后才自动化）**
   - 只有前面四步都做完，才考虑自动化。
   - 自动化一个已经删减、简化后的流程，才有意义。

## Review Checklist（每次 review 必须逐条过）
- [ ] 需求是否被过度解读或 future-proof 过度？
- [ ] 是否存在任何“本不该存在”的部分？（删减后还能满足核心需求吗？）
- [ ] 技术选型是否最简？（能用 stdlib / 内置功能就不要引入新框架）
- [ ] 是否有 premature optimization / scalability / extensibility？
- [ ] 数据流 / 调用链是否能再砍一层？
- [ ] 整个方案是否让 feature 能在 1-2 天内 MVP 上线并迭代？
- [ ] 如果我把这个方案删掉 30% 的代码/组件，它还能工作吗？

## Review Output Format（必须严格遵守）
1. **Overall Verdict**
   （简单一句话：Over-engineered / Acceptable / Under-engineered）

2. **Musk Algorithm Breakdown**
   - Step 1: Requirements issues...
   - Step 2: What I would delete...
   - Step 3: Simplification suggestions...
   - Step 4 & 5: ...

3. **Concrete Recommendations**
   （列出具体可删的组件、推荐的更简架构、替代技术选型）

4. **Revised Simple Design**（如果必要）
   直接给出删减简化后的架构图（文字版）或伪代码骨架。

5. **Risk & Trade-off**
   明确说明简化后短期/长期的 trade-off。

## Additional Principles (永远适用)
- YAGNI + KISS 是 Musk 算法的自然延伸
- “If a design is taking too long, the design is wrong.”
- 删代码比加代码更重要
- 始终从用户真实价值和交付速度出发，而不是工程师的“优雅”或“完美”

## Agent 使用指令
收到任何 feature 的技术方案后，**必须先激活本 skill**，严格按以上框架 review，再给出最终反馈。绝不允许直接赞同或小修小补。
