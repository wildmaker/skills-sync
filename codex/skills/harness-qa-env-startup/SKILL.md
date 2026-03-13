---
name: harness-qa-env-startup
description: 为 QA 自动化准备可并行的实例启动环境：基于 git worktree 创建独立运行实例，完成端口隔离、数据隔离、实例健康检查与生命周期管理（创建/使用/销毁）。
version: 0.1.0
---

# Skill: harness-qa-env-startup

## Trigger
- 用户要求“给每次改动启动独立实例进行验证”
- 需要通过 `git worktree` 为 QA/E2E 创建隔离环境
- 需要管理实例生命周期（创建 -> 使用 -> 销毁）

## What this skill does
- 基于当前分支或指定分支创建临时 `git worktree`
- 为实例分配独立端口、独立数据目录、独立日志目录
- 启动应用并执行最小可用性检查（健康检查/首页可访问）
- 结束后安全销毁实例与 worktree，避免脏状态累积

## Inputs
- `<repo-root>`: 仓库根目录（默认当前仓库）
- `<base-ref>`: worktree 基准分支/提交（默认当前 HEAD）
- `<ticket-or-tag>`: 任务标识（用于命名端口/目录）
- `<run-cmd>`: 启动命令（如 `npm run dev` / `make run`）
- `<health-url>`: 健康检查地址（如 `http://127.0.0.1:<port>/health`）

## Outputs
- 一个可驱动的临时实例（含访问 URL、PID、worktree 路径）
- 生命周期记录（创建时间、端口、数据目录、销毁状态）

## Constraints
- 必须保证端口不冲突；冲突时自动重试下一个可用端口
- 必须保证数据目录隔离，禁止复用主开发环境数据
- 未完成销毁前，不得静默丢弃实例信息

## Recommended naming
- worktree: `.worktrees/qa-<ticket-or-tag>-<timestamp>`
- data dir: `.qa-data/<ticket-or-tag>/`
- logs dir: `.qa-logs/<ticket-or-tag>/`

## Allowed commands
- `git worktree`
- `git`
- `rg`
- `lsof`
- `ss`
- `netstat`
- `mkdir`
- `cp`
- `rm`
- `sh`

## Steps
1. 解析输入并生成唯一实例 ID（`<ticket-or-tag>-<timestamp>`）。
2. 选择空闲端口（建议从约定端口段开始，例如 3100+）。
3. 创建 worktree（`.worktrees/qa-<id>`）并切到目标 ref。
4. 初始化实例级环境变量：
   - `PORT=<allocated-port>`
   - `QA_DATA_DIR=<repo-root>/.qa-data/<id>`
   - `QA_LOG_DIR=<repo-root>/.qa-logs/<id>`
5. 启动应用并记录 PID 到 `QA_LOG_DIR/pid`。
6. 执行健康检查与一次基础访问验证；失败则保留日志并标记启动失败。
7. 输出实例连接信息（URL、worktree、日志路径）供后续 E2E 或 Manual 使用。
8. 在任务结束时执行销毁：
   - 停止进程（PID 存在则先优雅停止再强制）
   - `git worktree remove` 清理目录
   - 按策略保留或删除数据目录与日志目录

## Exit criteria
- 实例可访问且健康检查通过；或明确失败原因并产生日志证据
- 生命周期闭环完成（创建与销毁均有记录）

