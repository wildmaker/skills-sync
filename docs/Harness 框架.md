本篇文档记录的是我搭建自动化开发基础设施的需求和想法。

# 目标
自动化的开发、测试功能，提升写代码交付的效率

# Happy Path

1. 我于 agent 在工具内对话，确定 Plan。
2. 根据 Plan 的复杂程度，拆分为 1 个或多个 story。
3. 通过 linear 创建 story 的 Task。
4. linear 通过Symphony 安排指定的 agent 开工。
5. 每个 agent 执行 SDD 工作流。

# 功能清单
* 根据 label 自动指定对应的 agent 
* 支持 amp 等多 agent
* 根据任务的 label 选择不同的工作流，比如 feature ,bugfix 


# 路线图

1. 能在本地完成# Happy Path
2. 开发机能始终在线接活，我在远程创建 linear 可以自动接活、开工

# Skills 分发与版本治理（并入 Harness PRD）

## 背景

在多开发机、多开发者协作下，如果仅依赖全局目录（如 `~/.codex`、`~/.cursor`）安装 skills，会出现以下问题：

- 新机器无法开箱即用，必须先做额外全局配置
- 不同开发者 skill 版本不一致，导致行为漂移
- 历史分支难以复现当时的 agent 行为

## 目标

- 同一仓库在任意开发机上可复现
- 团队关键流程一致、可审计、可回滚
- 允许个人在不破坏团队一致性的前提下做效率扩展

## 推荐方案：双层技能模型

### 1) 团队基线 skills（仓库内，受版本控制）

将“影响协作结果”的 skills 放入仓库并提交到 Git：

- 路径建议：`.agents/skills/`（或 `.codex/skills/`，团队统一即可）
- 典型基线：`linear`、`commit`、`push`、`pull`、`land`、`debug`、`launch-app`
- 所有变更走 PR 审查

效果：开发机只需 `git pull` 即可获得一致 skill 版本。

### 2) 个人扩展 skills（全局目录，不作为项目依赖）

开发者的实验型、偏好型 skills 放在全局目录：

- `~/.codex`
- `~/.cursor`

规则：个人 skills 只能提升效率，不能作为项目必需依赖，也不能改变团队必经流程。

## 与 Symphony 的一致性

`WORKFLOW.md` 与文档设计本身偏向 repo-local 可复现实践：

- `WORKFLOW.md` 是团队流程契约
- 可选将关键 skills 复制到项目内
- 工作流可直接引用仓库内的 skill 路径

这与“团队基线 skills 随仓库版本管理”的策略一致。

## 更新 Symphony 后如何处理

建议优先重建 `WORKFLOW.md`，skills 做覆盖更新：

1. 更新并重建 Symphony 本体
2. 删除并重建项目内 `WORKFLOW.md`
3. 重新安装/同步项目基线 skills（覆盖同名文件）
4. 检查并清理已废弃、改名后的旧 skill 目录

说明：通常不必整目录删除 `.agents/skills/`，但若上游发生重命名或拆分，需手动清理残留。

## 可选方案：初始化时拉取 skills（不入库）

可行，但需要额外治理，否则不可复现：

- 使用项目 bootstrap 脚本，不依赖本地 Git hook
- 必须锁定 skills 仓库的 tag/commit，禁止直接跟随 `main`
- 维护 `skills.lock`（记录来源与版本）
- CI 校验本地 skills 与 lock 一致

该方案适合“集中维护 + 减少主仓库体积”的团队；若优先开箱即用与可复现，仍建议基线 skills 入库。

## 团队落地规范（建议）

1. 明确基线清单：哪些 skills 属于项目强依赖。
2. 统一目录与命名：如团队前缀 `team-*`、个人前缀 `user-*`。
3. 升级流程固定化：由维护者从 skills 中心同步到仓库并发 PR。
4. 在 `WORKFLOW.md` 中声明：任务执行仅依赖仓库内基线 skills。
5. 个人全局 skills 允许存在，但不写入项目必需路径与规则。

## 结论

最稳妥实践是：

- 团队基线 skills：入仓库、随代码版本走
- 个人扩展 skills：放全局、可自由演进

这样既能保证协作一致性和历史可复现，也不会限制个人效率优化。
