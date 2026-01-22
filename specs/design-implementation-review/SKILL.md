# design-implementation-review

## What this skill does
- 生成当前实现的系统设计评审文档
- 对比设计目标与实现差距并输出查漏补缺清单

## Constraints
- 必须基于实际代码与文档，不臆测
- 必须输出复核报告文件

## Allowed commands
- `code-architecture-review`
- `date`
- `mkdir`
- `echo`
- `cat`

## Steps
1. 重新阅读设计文档，整理目标范围与关键需求点。
2. 运行 `code-architecture-review` 生成当前实现的系统设计文档。
3. 对比设计目标与实现文档，列出缺失或偏差点。
4. 将对比结果写入 `docs/reviews/final-review-<doc>-<timestamp>.md`。
