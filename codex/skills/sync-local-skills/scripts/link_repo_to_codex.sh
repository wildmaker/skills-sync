#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_DIR/../../.." && pwd)"
REPO_CODEX_SKILLS_DIR="$REPO_ROOT/codex/skills"

if [[ ! -d "$REPO_CODEX_SKILLS_DIR" ]]; then
  echo "ERROR: repo codex skills directory not found: $REPO_CODEX_SKILLS_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

has_conflict=0

while IFS= read -r -d '' repo_skill_dir; do
  name="$(basename "$repo_skill_dir")"

  # Skip hidden/system directories (e.g. .system)
  if [[ "$name" == .* ]]; then
    continue
  fi

  dest_path="$DEST_DIR/$name"

  if [[ -L "$dest_path" ]]; then
    current_target="$(readlink "$dest_path" || true)"
    if [[ "$current_target" != "$repo_skill_dir" ]]; then
      echo "CONFLICT: $name (symlink points to $current_target, expected $repo_skill_dir)" >&2
      has_conflict=1
    fi
    continue
  fi

  if [[ -e "$dest_path" ]]; then
    echo "CONFLICT: $name (path exists and is not a symlink: $dest_path)" >&2
    has_conflict=1
  fi
done < <(find "$REPO_CODEX_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ "$has_conflict" -ne 0 ]]; then
  echo "ERROR: conflicts detected; no symlinks were created." >&2
  exit 2
fi

linked=()

while IFS= read -r -d '' repo_skill_dir; do
  name="$(basename "$repo_skill_dir")"

  if [[ "$name" == .* ]]; then
    continue
  fi

  dest_path="$DEST_DIR/$name"

  # Already linked correctly
  if [[ -L "$dest_path" ]]; then
    current_target="$(readlink "$dest_path" || true)"
    if [[ "$current_target" == "$repo_skill_dir" ]]; then
      echo "OK: $name"
      continue
    fi
  fi

  # Missing: create symlink
  if [[ ! -e "$dest_path" ]]; then
    ln -s "$repo_skill_dir" "$dest_path"
    linked+=("$name")
    echo "LINKED: $name"
  fi
done < <(find "$REPO_CODEX_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ ${#linked[@]} -eq 0 ]]; then
  echo "NO_CHANGES"
fi
