---
name: harness-build-to-green
description: 在当前仓库执行“build失败->定位错误->最小修复->重试build”的自动循环，直到 build 成功（或达到安全停止条件）。当用户要求“自动编译修复直到成功 / build to green”时使用。
---

# harness-build-to-green

## Goal
让项目达到可构建状态：`build` 最终成功（exit code 0）。

## Trigger
当用户明确要求以下意图时使用：
- 自动 build 并修复错误
- 编译失败后持续修复直到成功
- build to green / compile to green

## Workflow
1. 识别项目构建命令（优先使用仓库文档/脚本）
- Node: `npm run build` / `pnpm build` / `yarn build`
- Python: `pytest` 不是 build；若是打包项目用 `python -m build` 或仓库约定命令
- 其他语言按仓库说明执行

2. 先执行一次 build，完整记录报错
- 保留首个关键报错（通常最上游 error）
- 不并行修多个无关错误，按“最小可行修复”推进

3. 针对当前阻塞错误做最小修复
- 只改与报错直接相关的文件
- 禁止顺手重构/扩展功能
- 若错误由缺失依赖导致，按仓库约定安装依赖并记录变更

4. 重新执行 build
- 若失败：回到步骤 2
- 若成功：结束循环并汇报

## Stop Conditions
出现以下任一情况必须停止并向用户报告：
- 连续多轮后同一错误无实质进展
- 需要高风险决策（大版本升级、迁移、删除核心模块）
- 错误来自外部系统或缺失凭据（如私有 registry/token）
- 用户仓库当前变更与修复目标明显冲突，无法安全继续

## Output Contract
结束时必须给出：
- 使用的 build 命令
- 主要修复点（文件级）
- 最终 build 结果（成功/失败）
- 若失败：卡点与下一步建议

## Guardrails
- 目标是“build 成功”，不是“所有测试全绿”（除非仓库把测试纳入 build）
- 保持变更最小、可回滚
- 不修改无关文件
