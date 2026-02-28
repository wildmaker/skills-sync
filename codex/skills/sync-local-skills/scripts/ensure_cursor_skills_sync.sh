#!/usr/bin/env bash
set -euo pipefail

#######################################
# 配置区（按需修改）
#######################################

# repo 根目录（不是 skills 目录）
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"

# repo 中 codex skills 的最终位置
REPO_CODEX_SKILLS_DIR="$REPO_ROOT/codex/skills"

# Cursor 本地 skills 目录
CURSOR_SKILLS_DIR="$HOME/.cursor/skills"

#######################################
# 预检查
#######################################

echo "Repo codex skills dir : $REPO_CODEX_SKILLS_DIR"
echo "Cursor skills dir     : $CURSOR_SKILLS_DIR"
echo

if [[ ! -d "$REPO_CODEX_SKILLS_DIR" ]]; then
  echo "❌ Repo codex skills 目录不存在"
  exit 1
fi

mkdir -p "$CURSOR_SKILLS_DIR"

#######################################
# 主逻辑（rsync 镜像同步）
#######################################

if ! command -v rsync >/dev/null 2>&1; then
  echo "❌ 未找到 rsync，请先安装"
  exit 1
fi

echo "🔄 开始 rsync 镜像同步（排除隐藏/系统目录）"

rsync -a --delete \
  --exclude '.*' \
  "$REPO_CODEX_SKILLS_DIR"/ \
  "$CURSOR_SKILLS_DIR"/

echo "✅ 同步完成"
