#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_DIR/../../.." && pwd)"
TARGET_DIR="$REPO_ROOT/codex/skills"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "ERROR: source skills directory not found: $SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "ERROR: target skills directory not found: $TARGET_DIR" >&2
  exit 1
fi

has_conflict=0

while IFS= read -r -d '' entry; do
  name="$(basename "$entry")"
  if [[ "$name" == .* ]]; then
    continue
  fi

  # only handle directories
  if [[ ! -d "$entry" ]]; then
    continue
  fi

  # skip existing symlinks
  if [[ -L "$entry" ]]; then
    continue
  fi

  target="$TARGET_DIR/$name"
  if [[ -e "$target" ]]; then
    echo "CONFLICT: $name (repo already has $target)" >&2
    has_conflict=1
  fi
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -print0)

if [[ "$has_conflict" -ne 0 ]]; then
  echo "ERROR: conflicts detected; nothing was migrated." >&2
  exit 2
fi

moved=()
skipped=()

while IFS= read -r -d '' entry; do
  name="$(basename "$entry")"
  if [[ "$name" == .* ]]; then
    continue
  fi

  if [[ -L "$entry" ]]; then
    continue
  fi

  if [[ ! -d "$entry" ]]; then
    skipped+=("$name")
    continue
  fi

  target="$TARGET_DIR/$name"
  mv "$entry" "$target"
  ln -s "$target" "$entry"
  moved+=("$name")
  echo "MOVED: $name"
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -print0)

if [[ ${#skipped[@]} -gt 0 ]]; then
  printf 'SKIPPED: %s\n' "${skipped[@]}" >&2
fi

if [[ ${#moved[@]} -eq 0 ]]; then
  echo "NO_CHANGES"
fi
