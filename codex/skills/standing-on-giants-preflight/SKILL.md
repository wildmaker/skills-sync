---
name: standing-on-giants-preflight
description: 将“Standing on the Shoulders of Giants”AI pre-flight checklist 封装为可复用的检索/证据/复用决策协议，用于在设计或写代码前完成 context bootstrapping。
version: 0.1.0
---

# Skill: standing-on-giants-preflight

## Trigger
@standing-on-giants-preflight

## What this skill does
- 在 AI 开始设计/写代码前，强制执行一套 **Standing-on-Giants Pre-flight Checklist**（0–7），系统性检索“是否已有成熟实践/组件/经验/内部资产可复用”
- 产出一份可落盘的 Markdown 报告，既能作为“决策依据”，也能直接作为后续 AI 的 system/planning context（可复制粘贴）
- 对每一条结论必须给出**证据链接**或明确写 **“未找到 / 无法访问 / 信息不足”**

## When to use
- 当用户准备让 AI 开始：架构设计、技术选型、写代码、拆任务、或引入外部依赖前
- 当你需要验证：是否在“造轮子”、依赖是否 AI 可闭环学习、以及是否具备进入实现阶段的条件

## Inputs (recommended)
- `<one-liner-goal>`：当前方案的一句话目标（做什么，不是怎么做）
- `<inputs-outputs>`：核心输入/输出（Input/Output）列表
- `<stack>`：使用语言 & 平台（如 Rust/Swift/Node；iOS/Linux；运行形态）
- `<non-functional-constraints>`：关键非功能约束（性能/延迟/离线/成本/许可证/合规等）
- `<not-building>`：明确哪些部分不打算自研（白名单）
- `<dependencies>`：外部依赖清单（SDK/第三方 API/服务/库），每项说明用途与边界
- （可选）`<design-doc-path>`：仓库内的设计/需求文档路径（用于确定输出报告落点）
- （可选）`<keywords>`：领域关键词/竞品名/协议名/标准名（用于检索）

## Outputs
- `GIANTS-PREFLIGHT.md`：Checklist 报告（建议落点：与 `<design-doc-path>` 同目录；若未提供则放仓库根目录）
- 报告必须包含：0️⃣–7️⃣ 全部小节 + 强制“复用决策结论” + “Go/No-Go”最终判断

## Hard constraints (must follow)
- **不允许臆测**：所有事实性陈述必须有证据链接（GitHub/官网/标准文档/论文/文章/帖子）或明确写“未找到”
- **不进入实现**：本技能只做调研/证据/结论，不写产品代码、不改业务逻辑
- **稳定链接优先**：优先使用官方文档、GitHub、标准组织站点等“稳定 URL”；短链/截图不足以作为证据
- **区分三类不可得**（必须精确写明是哪一种）：
  - 未找到（搜索后无结果）
  - 无法访问（权限/网络/未提供导出，如 Notion）
  - 信息不足（缺少关键元信息导致无法检索/判断）

## Allowed commands
- `WebSearch`
- `WebFetch`
- `rg`
- `ls`
- `git`

## Steps

### 0️⃣ 方案元信息（先决条件）
目标：如果元信息不清楚，后续“找巨人”必然失败；本节必须先写清楚再继续。

必须输出：
- 当前方案一句话目标
- 核心 Input/Output
- 语言 & 平台
- 关键非功能约束
- 明确“不自研白名单”

若用户未给齐：在报告中把缺失项标为 **信息不足**，并基于已知信息继续执行 1–4；5（本地知识库）与 6–7 的结论必须相应降置信度。

### 1️⃣ 核心目标层：是否已有成熟实践（最优先）
原则：目标层若能直接复用，下面全部不用造。

对“核心目标本身”检索并回答：
- 是否已有成熟开源项目（给：⭐️、活跃度、生产案例线索）
- 是否已有商业化产品 / SaaS / SDK
- 是否存在官方 reference implementation / starter / demo
- 是否存在行业标准/事实标准（de facto standard）

每个候选必须输出：
- 项目/产品名 + GitHub/官网链接
- 成熟度判断（维护频率、issue/PR 活跃度、release 节奏）
- 结论：**可直接用 / 需二次工程化 / 不适合**（并说明原因）

### 2️⃣ 依赖层（SDK / 第三方 API）：是否“可被 AI 消化”
目标：判断 AI 能否在 repo 内闭环学习与落地集成。

对每个外部依赖逐一检查：
- 是否有官方 SDK；是否开源
- 是否有结构化 API Reference；最小可运行示例；错误码/限流/Auth 说明
- 是否能把以下内容“收编”进 repo 供 AI 引用：
  - SDK 源码（submodule/vendor）
  - 官方文档（Markdown/OpenAPI/PDF；若为网页，给稳定入口并考虑镜像）
  - 示例代码（`examples/`）

每个依赖必须输出：
- SDK repo 链接（或明确“未找到/无官方 SDK”）
- 文档入口链接（必须稳定 URL）
- AI-first 适配结论：**是 / 勉强 / 否**
- 收编建议：submodule / docs mirror / vendor / 仅链接（并说明理由与代价）

### 3️⃣ 核心组件层（算法 / 模块 / 子系统）
原则：整体方案可能没人做过，但组件几乎一定有人做过。

对每个核心组件分别回答：
- 是否存在开源实现 / 论文+reference code / 商业 SDK/库
- 是否有多个实现可对比（避免单点依赖）
- 常见使用场景（生产/学术/demo）

每个组件必须输出：
- 至少 2–3 个候选实现（链接齐全；不足则写“未找到”）
- 技术差异点（性能/准确率/复杂度/依赖/许可证）
- 当前方案可直接复用的边界（你打算“拿来即用”的接口面）

### 4️⃣ 经验层（实践智慧）：技术社区与“坑”
目标：补齐文档里没有的工程经验。

检索范围（按可获得性从高到低）：
- 技术博客/工程文章（“Postmortem / Lessons learned / In production”）
- Hacker News / Reddit
- X.com（若可检索到）

必须回答：
- 是否有人做过类似问题
- 高频失败点/坑（至少 3 条；不足则写“未找到”）
- 被反复验证的 best practice
- 被明确否定的 anti-pattern

输出要求：
- 经验摘要（必须是你自己的归纳，不是原文堆砌）
- 原帖/文章链接（可多条）
- 对当前方案的直接启示（如何影响你的设计/选型/边界）

### 5️⃣ 本地知识库层：Notion / 内部资产 / Repo 内文档
目标：优先复用“你自己的历史巨人”。

必须先在 repo 内检索（用 `rg`）：
- 类似项目/模块（关键词：`design`/`ADR`/`postmortem`/`lessons learned`/`RFC`/`decision`/`architecture`/技术名）
- 既往踩坑记录、复盘、或明确的实践约定

对 Notion/外部内部文档：
- 若用户未提供导出/链接且你无法访问：必须标注 **无法访问**，不要编造内容

输出要求：
- 相关页面/文件标题 + repo 路径（或链接）
- 可复用的 Pattern（你可以直接复制的做法/模板/约定）
- 必须避免的历史 Anti-pattern（被推翻的决策与原因）

### 6️⃣ 复用决策结论（强制输出）
不允许“看了很多但还是自己写”的模糊状态。必须明确：
- 哪些部分：**直接复用**
- 哪些部分：**基于巨人二次封装**
- 哪些部分：**必须自研**（说明为什么：差异/约束/许可证/不可控风险等）

对每个外部依赖必须补充：
- Adapter 边界设计建议（你打算把依赖隔离在哪一层、暴露哪些接口）
- 替换预案 Plan B（可替换依赖/降级路径/自研兜底）

### 7️⃣ AI 友好性最终评分（Go / No-Go）
给出最终结论：
- Standing-on-Giants Score（0–10）
  - 目标层复用程度
  - 组件层成熟度
  - 文档/SDK 可机器消化程度
  - 经验可获得性
  - 本地知识库可复用性
- 是否建议进入实现阶段：
  - ✅ Yes（条件成熟）
  - ⚠️ Yes but（需补齐哪些巨人/资料）
  - ❌ No（先做技术调研/补齐关键输入）
- 🎯 一句话总结：用一句话概括“这个问题的本质”

## Report template (GIANTS-PREFLIGHT.md)
复制以下结构作为输出骨架（必须逐条作答，缺失则写“未找到/无法访问/信息不足”）：

---
title: Standing on the Shoulders of Giants — Pre-flight Report
date: YYYY-MM-DD
---

## 0️⃣ 方案元信息
- 目标（一句话）：
- Inputs：
- Outputs：
- 语言 & 平台：
- 非功能约束：
- 不自研白名单：

## 1️⃣ 核心目标层（成熟实践）
- 候选 A：
  - 链接：
  - 成熟度证据：
  - 结论（可直接用/需二次工程化/不适合）：
- 候选 B：

## 2️⃣ 依赖层（SDK/API 可消化性）
- 依赖 1：
  - SDK：
  - Docs：
  - 示例/错误码/限流/Auth：
  - AI-first 结论：
  - 收编建议：
- 依赖 2：

## 3️⃣ 核心组件层（算法/模块/子系统）
- 组件 1：
  - 候选实现（2–3 个）：
  - 差异点：
  - 可复用边界：
- 组件 2：

## 4️⃣ 经验层（坑 & best practices）
- 高频坑：
- Best practices：
- Anti-patterns：
- 证据链接：
- 对当前方案启示：

## 5️⃣ 本地知识库（Repo/Notion/内部资产）
- Repo 内相关资产：
- Notion/内部资产（若不可得写“无法访问”）：
- Patterns：
- Anti-patterns：

## 6️⃣ 复用决策（强制结论）
- 直接复用：
- 二次封装：
- 必须自研（原因）：
- 依赖 Adapter 边界建议：
- Plan B：

## 7️⃣ Go / No-Go（AI 友好性评分）
- Standing-on-Giants Score（0–10）：X
- 评分理由：
- 结论：✅ / ⚠️ / ❌
- 需要补齐的“巨人清单”（如有）：
- 🎯 一句话总结：

