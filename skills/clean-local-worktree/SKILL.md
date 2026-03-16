---
name: clean-local-worktree
description: 清理本地 Git 工作区：先识别并写入应忽略路径，再对剩余变更逐文件审查并逐个提交，最终让工作区恢复干净。
version: 0.0.0
---

# clean-local-worktree

## What this skill does
- 检查工作区变更，识别应加入 ignore 的文件/目录并直接写入对应 ignore 文件。
- 对剩余文件逐个检查 diff，按文件或单一目的分组提交。
- 目标是让 `git status` 回到 clean state（或仅剩用户明确保留的变更）。

## Constraints
- 只处理当前仓库与用户明确提到的路径范围，不扩展需求。
- 提交前必须先审查每个文件的改动内容，不盲目全量提交。
- 不做与清理无关的重构或功能变更。
- 若发现疑似敏感文件（密钥、证书、凭据），停止提交并先提醒用户。

## Allowed commands
- `git status --porcelain=v1 -uall`
- `git rev-parse --show-toplevel`
- `git check-ignore -v`
- `git diff -- <path>`
- `git add`
- `git restore --staged`
- `git commit`

## Workflow
1. 收集状态
- 运行 `git status --porcelain=v1 -uall`，按 `M/A/D/??` 分类。
- 明确仓库根目录（`git rev-parse --show-toplevel`），避免把上层目录误当成当前仓库内容。

2. 判断 ignore 候选并写入
- 对明显应忽略的路径直接加入 ignore（优先 `.gitignore`，必要时用 `.git/info/exclude`）。
- 常见候选：编辑器元数据、系统临时文件、构建产物、缓存目录。
- 例如：`../../docs/.obsidian/` 属于 Obsidian 本地配置目录，默认应忽略。
- 写入后用 `git check-ignore -v <path>` 或再次 `git status` 验证生效。

3. 逐文件审查剩余变更
- 对每个未忽略文件执行 `git diff -- <path>`（untracked 文件查看全文）。
- 判定该文件应提交、应拆分、或暂缓。
- 拆分原则：一次 commit 只表达一个清晰目的。

4. 逐个提交
- 按文件或最小闭环分组执行：
  - `git add <path>`
  - `git commit -m "<type>: <summary>"`
- 建议优先提交文档/配置，再提交代码或脚本，保持历史可读。

5. 收尾检查
- 再次运行 `git status`。
- 结果应为 clean，或仅剩用户明确要求暂不处理的文件。

## Commit message convention
- 默认使用：`chore: <summary>`。
- 若文件属于功能交付，可用 `feat:`；若是修复，用 `fix:`。
- 保持一条提交只对应一个目的。

## Example (matches requested scenario)
输入状态（示例）：
- `modified: ../../BACKLOG.md`
- `untracked: ../../db/schema.pg.sql`
- `untracked: ../../docs/.obsidian/`
- `untracked: ../../lib/release/`

执行策略：
1. 把 `../../docs/.obsidian/` 加入 ignore 并验证不再出现在 `git status`。
2. 审查 `../../BACKLOG.md` 改动，单独提交（例如 `docs:` 或 `chore:`）。
3. 审查 `../../db/schema.pg.sql` 内容，若为本次有效变更则单独提交。
4. 审查 `../../lib/release/`：
- 若为构建产物/临时目录，加入 ignore；
- 若为应交付资源，按目录内容拆分后提交。
5. 最终确认工作区 clean。

## Output format
- Ignore 处理结果：新增了哪些规则。
- 提交结果：每个 commit 包含哪些文件、commit message 是什么。
- 最终状态：`git status` 是否 clean。
