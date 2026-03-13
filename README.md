# README

## 整体设计思想

1. codex 始终保持 `skills` 与 `repo/codex/` 软链接，也就是真实的 skill 目录只存放在 repo 中
2. 使用 `codex/skills/sync-codex-skills-to-cloud/scripts` 下的脚本将文件复制到 `~/.cursor/skills`
3. 除了 claude 外的其他 agent 工具的 skill 也软链接到 `repo/codex`

## Skills 目录总览

所有 skills 的目录统一存放在 `codex/skills`。当前一级目录如下（按字母排序）：

- `codex/skills/ai-learn`
- `codex/skills/assign-a-task-to-the-codex`
- `codex/skills/auto-build`
- `codex/skills/auto-build-backlog-sync`
- `codex/skills/auto-build-bootstrap`
- `codex/skills/auto-build-execute-item`
- `codex/skills/auto-build-final-review`
- `codex/skills/auto-build-v2`
- `codex/skills/backlog-generate`
- `codex/skills/backlog-issue-sync`
- `codex/skills/backlog-item-execute`
- `codex/skills/backlog-write-back`
- `codex/skills/blueprint-compiler`
- `codex/skills/check-env`
- `codex/skills/code-architecture-review`
- `codex/skills/code-review`
- `codex/skills/create-a-pending-task`
- `codex/skills/deploy-cloudbase-function`
- `codex/skills/design-implementation-review`
- `codex/skills/distill-specs-from-user-requirements`
- `codex/skills/do-it`
- `codex/skills/engineering-sign-off`
- `codex/skills/epic-auto-build-v2`
- `codex/skills/epic-breakdown`
- `codex/skills/epic-engineering-sign-off`
- `codex/skills/epic-fix-stabilization`
- `codex/skills/epic-issue-triage`
- `codex/skills/epic-merge-to-main`
- `codex/skills/epic-review-demo`
- `codex/skills/epic-sdd-loop`
- `codex/skills/epic-stabilization`
- `codex/skills/fix-bug`
- `codex/skills/gh-backlog-issue`
- `codex/skills/git-add-pr`
- `codex/skills/git-commit`
- `codex/skills/git-create-pr`
- `codex/skills/git-merge-recent-pr`
- `codex/skills/git-pr-review`
- `codex/skills/git-pr-summarize`
- `codex/skills/git-rebase`
- `codex/skills/git-resolve-pr-comments`
- `codex/skills/git-status`
- `codex/skills/json-canvas`
- `codex/skills/learning-by-doing`
- `codex/skills/merge-to-main`
- `codex/skills/note-it`
- `codex/skills/obsidian-bases`
- `codex/skills/obsidian-markdown`
- `codex/skills/openspec-init`
- `codex/skills/openspec-init-change`
- `codex/skills/pre-merge-regression-audit`
- `codex/skills/prepare-for-test`
- `codex/skills/report-it-to-me`
- `codex/skills/sdd-loop`
- `codex/skills/standing-on-giants-preflight`
- `codex/skills/sync-codex-skills-to-cloud`
- `codex/skills/sync-env-values`
- `codex/skills/vercel-static-deploy`
- `codex/skills/visualize-it`
- `codex/skills/xmind`
