---
name: harness-qa-e2e-web
description: 面向 Web 应用的 E2E 子技能：通过 Chrome DevTools Protocol 执行导航、DOM 快照、截图与关键行为验证，用于缺陷复现与修复回归对比。
version: 0.1.0
---

# Skill: harness-qa-e2e-web

## Trigger
- `harness-qa-e2e` 且 `<platform>=web`
- 需要基于 Chrome DevTools Protocol 获取高可信页面证据
- 需要自动执行页面导航并采集 DOM/截图

## What this skill does
- 使用 CDP 驱动浏览器完成页面导航与交互
- 采集 DOM 快照（节点结构/关键属性/文本）
- 采集修复前后截图用于对比
- 产出可复跑的 Web E2E 证据清单

## Inputs
- `<base-url>`: Web 实例地址（建议来自 worktree 环境）
- `<route-list>`: 需要验证的页面路径列表
- `<selectors>`: 关键元素选择器与断言规则
- `<artifacts-dir>`: 证据输出目录

## Outputs
- `dom-before.json` / `dom-after.json`
- `before-*.png` / `after-*.png`
- `e2e-web-summary.md`

## Constraints
- DOM 快照与截图必须在同一测试步骤时点采集
- 每个关键路径至少包含一次“导航 -> 断言 -> 截图”
- 失败时必须保留原始报错与网络/控制台摘要

## Allowed commands
- `node`
- `npm`
- `npx`
- `playwright`
- `chromium`
- `rg`
- `mkdir`
- `cp`

## Steps
1. 准备浏览器会话并连接 CDP（headless 默认开启，必要时可切 headed）。
2. 遍历 `<route-list>`：
   - 导航到目标页面并等待稳定状态（`networkidle` 或等效条件）
   - 执行断言（基于 `<selectors>`）
   - 采集 DOM 快照与页面截图（按 before/after 语义命名）
3. 若为缺陷复现阶段，命名为 `before-*`；修复回归阶段命名为 `after-*`。
4. 对同一路径生成对比结论（通过/失败 + 差异摘要）。
5. 写出 `e2e-web-summary.md`，列出：
   - 访问路径
   - 断言结果
   - 证据文件路径

## Example artifact layout
```text
artifacts/
  web/
    route-home/
      dom-before.json
      dom-after.json
      before-home.png
      after-home.png
    e2e-web-summary.md
```

## Exit criteria
- 所有关键路径均产出可读证据
- 失败路径具备可定位信息（路径、选择器、截图、报错）

