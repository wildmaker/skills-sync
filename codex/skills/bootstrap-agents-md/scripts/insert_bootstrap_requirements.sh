#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REFERENCE_FILE="$SKILL_DIR/references/project-bootstrap-requirements.md"

TARGET_REPO="${1:-$PWD}"
if [[ ! -d "$TARGET_REPO" ]]; then
  echo "ERROR: repo path not found: $TARGET_REPO" >&2
  exit 1
fi

if [[ ! -f "$REFERENCE_FILE" ]]; then
  echo "ERROR: reference file not found: $REFERENCE_FILE" >&2
  exit 1
fi

TARGET_FILE=""
if [[ -f "$TARGET_REPO/AGENTS.md" ]]; then
  TARGET_FILE="$TARGET_REPO/AGENTS.md"
elif [[ -f "$TARGET_REPO/AGENT.md" ]]; then
  TARGET_FILE="$TARGET_REPO/AGENT.md"
else
  TARGET_FILE="$TARGET_REPO/AGENTS.md"
  cat > "$TARGET_FILE" <<'FILE_HEAD'
# AGENTS

FILE_HEAD
fi

BEGIN_MARKER="<!-- bootstrap-agents-md:BEGIN -->"
END_MARKER="<!-- bootstrap-agents-md:END -->"

TMP_CLEAN="$(mktemp)"
TMP_BLOCK="$(mktemp)"
trap 'rm -f "$TMP_CLEAN" "$TMP_BLOCK"' EXIT

BEGIN_COUNT="$(grep -cF "$BEGIN_MARKER" "$TARGET_FILE" || true)"
END_COUNT="$(grep -cF "$END_MARKER" "$TARGET_FILE" || true)"
if [[ "$BEGIN_COUNT" != "$END_COUNT" ]]; then
  echo "ERROR: marker mismatch in $TARGET_FILE" >&2
  exit 1
fi

awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
  $0 == begin {skip=1; next}
  $0 == end {skip=0; next}
  !skip {print}
' "$TARGET_FILE" > "$TMP_CLEAN"

{
  echo "$BEGIN_MARKER"
  echo ""
  cat "$REFERENCE_FILE"
  echo ""
  echo "$END_MARKER"
} > "$TMP_BLOCK"

cp "$TMP_CLEAN" "$TARGET_FILE"
if [[ -s "$TARGET_FILE" ]]; then
  printf "\n" >> "$TARGET_FILE"
fi
cat "$TMP_BLOCK" >> "$TARGET_FILE"
printf "\n" >> "$TARGET_FILE"

echo "UPDATED: $TARGET_FILE"
