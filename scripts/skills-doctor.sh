#!/usr/bin/env bash
set -euo pipefail

STRICT=0
if [ "${1:-}" = "--strict" ]; then
  STRICT=1
fi

MANIFEST=".agents/skills.manifest.yaml"
LOCK=".agents/skills.lock"
SKILLS_DIR=".agents/skills"

fail() {
  echo "[skills-doctor] $*" >&2
  exit 1
}

require_file() {
  local f="$1"
  [ -f "$f" ] || fail "Missing required file: $f"
}

parse_manifest_skills() {
  awk '
    /^required_skills:/ {in_section=1; next}
    in_section && /^[^[:space:]-]/ {exit}
    in_section && $1 == "-" {print $2}
  ' "$MANIFEST"
}

parse_lock_skills() {
  sed -n 's/^  - name: //p' "$LOCK"
}

lock_commit_for_skill() {
  local target="$1"
  awk -v target="$target" '
    /^  - name: / {
      current = $0
      sub(/^  - name: /, "", current)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", current)
      next
    }
    /^    commit: / && current == target {
      commit = $0
      sub(/^    commit: /, "", commit)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", commit)
      print commit
      exit
    }
  ' "$LOCK"
}

require_file "$MANIFEST"
require_file "$LOCK"
[ -d "$SKILLS_DIR" ] || fail "Missing skills directory: $SKILLS_DIR"

manifest_tmp="$(mktemp)"
lock_tmp="$(mktemp)"
installed_tmp="$(mktemp)"
trap 'rm -f "$manifest_tmp" "$lock_tmp" "$installed_tmp"' EXIT

parse_manifest_skills | sort -u > "$manifest_tmp"
parse_lock_skills | sort -u > "$lock_tmp"
find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort -u > "$installed_tmp"

if [ ! -s "$manifest_tmp" ]; then
  fail "No required_skills found in $MANIFEST"
fi

missing_in_lock="$(comm -23 "$manifest_tmp" "$lock_tmp" || true)"
if [ -n "$missing_in_lock" ]; then
  fail "Manifest skills missing in lock: $(echo "$missing_in_lock" | tr '\n' ' ')"
fi

extra_in_lock="$(comm -13 "$manifest_tmp" "$lock_tmp" || true)"
if [ -n "$extra_in_lock" ]; then
  fail "Lock contains undeclared skills: $(echo "$extra_in_lock" | tr '\n' ' ')"
fi

while IFS= read -r skill; do
  [ -n "$skill" ] || continue
  dir="$SKILLS_DIR/$skill"
  [ -d "$dir" ] || fail "Missing required skill directory: $dir"
  [ -f "$dir/SKILL.md" ] || fail "Missing SKILL.md for required skill: $dir/SKILL.md"
  find "$dir" -mindepth 1 -maxdepth 2 -type f | grep -q . || fail "Skill directory is empty: $dir"

  commit="$(lock_commit_for_skill "$skill" || true)"
  [ -n "$commit" ] || fail "Missing commit in $LOCK for skill: $skill"
  echo "$commit" | grep -Eq '^[0-9a-f]{7,40}$' || fail "Invalid commit hash for $skill: $commit"
done < "$manifest_tmp"

if [ "$STRICT" -eq 1 ]; then
  missing_on_disk="$(comm -23 "$manifest_tmp" "$installed_tmp" || true)"
  [ -z "$missing_on_disk" ] || fail "Required skills missing on disk: $(echo "$missing_on_disk" | tr '\n' ' ')"

  undeclared_on_disk="$(comm -13 "$manifest_tmp" "$installed_tmp" || true)"
  [ -z "$undeclared_on_disk" ] || fail "Undeclared skills present on disk: $(echo "$undeclared_on_disk" | tr '\n' ' ')"
fi

echo "[skills-doctor] OK"
