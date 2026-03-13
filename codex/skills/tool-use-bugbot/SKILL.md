---
name: tool-use-bugbot
description: 在需要对 Pull Request 进行自动代码审查、发现缺陷/安全问题/代码质量问题时，指导 AI 正确使用 Bugbot。
---

# Tool Use: Bugbot

## Purpose
使用 Bugbot 对 Pull Request 进行审查，识别以下问题：
- 缺陷（bugs）
- 安全问题（security issues）
- 代码质量问题（code quality issues）
- 规则违规（基于 `.cursor/BUGBOT.md` 和团队规则）

Bugbot 适用于 `PR review` 场景，不是通用代码分析工具，也不是本地静态检查器的替代品。

## When to use
当满足以下任一条件时，应考虑使用 Bugbot：

1. 当前任务与 Pull Request 审查相关。
2. 需要对一个已存在的 PR 做自动 review。
3. 需要根据仓库规则检查改动是否违反约束。
4. 需要对 PR 中的改动生成审查意见或缺陷列表。
5. 需要触发一次手动 Bugbot review（例如在 PR 评论中使用 `cursor review` 或 `bugbot run`）。

## When NOT to use
以下情况不要使用 Bugbot：

1. 用户只是想理解某段代码，而不是审查 PR。
2. 当前没有 PR，上下文只是本地未提交代码。
3. 用户需要的是单元测试、构建、lint、类型检查，而不是 PR review。
4. 用户要修改功能实现，而不是对变更做审查。
5. 用户需要的是根因分析、架构设计、性能 profiling，这些不应直接交给 Bugbot。

## Preconditions
在使用 Bugbot 前，先确认：

1. 已存在目标 Pull Request。
2. 仓库已启用 Bugbot。
3. 当前用户对该仓库和 PR 有访问权限。
4. 如需自动修复（Autofix），需确认：
- 已启用按量计费。
- 已启用存储。
- 已配置默认 agent model。
5. 若仓库存在 `.cursor/BUGBOT.md`，应优先读取并将其视为 review 规则上下文的一部分。

## Inputs to gather
在调用或建议调用 Bugbot 前，尽量明确以下输入：

- PR 链接 / PR 编号
- 仓库名
- 目标分支与改动范围
- 是否只需要 review，还是还需要 autofix
- 是否存在项目级规则：
- `.cursor/BUGBOT.md`
- 团队级 Bugbot rules
- 用户关注的重点：
- 安全
- 测试覆盖
- 后端改动
- React 生命周期
- 许可证问题
- TODO/FIXME 等规范问题

## How to use
### Case 1: 用户想自动审查 PR
执行思路：
1. 确认这是一个已有 PR。
2. 检查仓库是否启用了 Bugbot。
3. 如果用户要“触发一次 review”，指导其在 PR 评论中使用：
- `cursor review`
- 或 `bugbot run`
4. 如果需要详细日志，使用：
- `cursor review verbose=true`
- 或 `bugbot run verbose=true`

### Case 2: 用户想为仓库定义 review 规则
执行思路：
1. 在仓库中创建或更新 `.cursor/BUGBOT.md`。
2. 将规则写成清晰、可执行、可判断的条件。
3. 优先写：
- 触发条件
- 检查范围
- 发现后如何报 bug
- 是否阻塞
- 是否建议 autofix
4. 如果目录有明显边界（如 frontend/backend/api），建议分层放置多个 `.cursor/BUGBOT.md`。

### Case 3: 用户想启用或配置 Bugbot
执行思路：
1. 引导到 dashboard integrations / bugbot settings。
2. 确认 GitHub/GitLab 安装完成。
3. 在目标仓库启用 Bugbot。
4. 如为团队环境，确认 allowlist/blocklist 模式及用户权限。

### Case 4: 用户想让 Bugbot 自动修复
执行思路：
1. 确认 Autofix 已启用。
2. 确认模型与计费条件满足。
3. 说明 Bugbot 会启动 Cloud Agent 修复问题。
4. 修复结果会被推送到现有分支或新分支，并在原 PR 留下评论。

## Expected outputs
使用这个 skill 时，AI 的输出应尽量是以下几类之一：

1. 是否该用 Bugbot 的判断
- 适合 / 不适合
- 原因是什么

2. 触发 Bugbot 的具体操作
- 评论命令
- 配置路径
- 启用步骤

3. 规则草案
- 帮用户生成 `.cursor/BUGBOT.md` 内容
- 按项目结构拆分规则

4. 结果解读
- Bugbot 提出的 bug 属于什么类型
- 哪些是阻塞问题
- 哪些适合 Autofix
- 哪些更适合人工处理

## Heuristics
- 如果任务中心词是 `PR / review / 审查 / 缺陷 / 安全 / 代码质量 / 规则`，优先考虑 Bugbot。
- 如果任务中心词是 `实现 / 修功能 / 写代码 / 本地调试 / 跑测试`，优先不要调用 Bugbot。
- 如果用户说“让 AI 知道怎么使用这个工具”，优先输出：
- 适用场景
- 非适用场景
- 触发方式
- 规则设计方法

## Good examples
### Example 1
用户：帮我审查这个 PR 有没有安全问题。
AI：判断应使用 Bugbot，并建议在 PR 下触发 `bugbot run`，同时提醒检查 `.cursor/BUGBOT.md` 是否定义了安全规则。

### Example 2
用户：我要给 repo 定义 review 规则。
AI：不直接“运行 Bugbot”，而是帮助用户编写 `.cursor/BUGBOT.md`，例如：
- 后端改动必须带测试
- 禁止 eval/exec
- 不允许无 issue 的 TODO/FIXME

### Example 3
用户：为什么 Bugbot 没有工作。
AI：进入 troubleshooting 模式，建议：
- 用 `verbose=true` 重新触发
- 检查安装权限
- 检查仓库是否启用
- 检查免费额度和计费条件

## Failure handling
如果 Bugbot 无法工作，按顺序排查：
1. 仓库是否启用
2. GitHub/GitLab 集成是否安装
3. 用户是否有权限
4. 是否超出免费额度
5. 是否需要 `verbose=true` 获取 request ID
6. 若是 Autofix 问题，检查模型、存储、按量计费是否启用

## Rule writing guidance
给 `.cursor/BUGBOT.md` 写规则时，遵循：
- 规则必须可判断。
- 触发条件尽量基于文件路径、diff 内容、模式匹配。
- 输出必须明确：
- bug title
- bug body
- blocking / non-blocking
- labels
- 是否建议 autofix
- 避免写抽象规则，如“代码要优雅”“注意性能”这类不可执行描述。

## Default behavior
如果用户没有说明具体目标，但提到 Bugbot：
1. 先判断他是想：
- 用 Bugbot 审 PR
- 配置 Bugbot
- 写 Bugbot 规则
- 排查 Bugbot 问题
2. 再进入对应分支处理。
3. 如果信息不足，优先问：你是要“触发 review”，还是“定义规则”，还是“排查配置”？
