#!/usr/bin/env bash
set -euo pipefail

#######################################
# 配置区（按需修改）
#######################################

# Codex 本地 skills 目录
CODEX_SKILLS_DIR="$HOME/.codex/skills"

# repo 根目录（不是 skills 目录）
REPO_ROOT="/Users/wildmaker/Documents/Projects/skills-sync"

# repo 中 codex skills 的最终位置
REPO_CODEX_SKILLS_DIR="$REPO_ROOT/codex/skills"

#######################################
# 预检查
#######################################

echo "Codex skills dir      : $CODEX_SKILLS_DIR"
echo "Repo codex skills dir : $REPO_CODEX_SKILLS_DIR"
echo

if [[ ! -d "$CODEX_SKILLS_DIR" ]]; then
  echo "❌ Codex skills 目录不存在"
  exit 1
fi

mkdir -p "$REPO_CODEX_SKILLS_DIR"

echo "即将执行以下操作："
echo "1. 将 $CODEX_SKILLS_DIR 下的所有子目录移动到 repo/codex/skills/"
echo "2. 在原位置创建同名软链接"
echo
read -p "确认继续？(yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
  echo "已取消"
  exit 0
fi

#######################################
# 主逻辑
#######################################

for SKILL_PATH in "$CODEX_SKILLS_DIR"/*; do
  SKILL_NAME="$(basename "$SKILL_PATH")"
  TARGET_PATH="$REPO_CODEX_SKILLS_DIR/$SKILL_NAME"

  # 只处理目录
  [[ -d "$SKILL_PATH" ]] || continue

  # 如果已经是软链接，跳过
  if [[ -L "$SKILL_PATH" ]]; then
    echo "↪ 跳过（已是软链接）: $SKILL_NAME"
    continue
  fi

  # repo 中已存在同名目录，跳过（避免覆盖）
  if [[ -e "$TARGET_PATH" ]]; then
    echo "⚠️  跳过（repo 中已存在）: $SKILL_NAME"
    continue
  fi

  echo "➡️  迁移 $SKILL_NAME"

  # 移动实体目录到 repo
  mv "$SKILL_PATH" "$TARGET_PATH"

  # 在原位置创建软链接
  ln -s "$TARGET_PATH" "$SKILL_PATH"

done

echo
echo "✅ 完成"
