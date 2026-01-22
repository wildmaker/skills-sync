#!/usr/bin/env bash
set -euo pipefail

registry_file="/Users/wildmaker/.codex/skills/skill-sync-repo-registry/SKILL.md"
if [[ ! -f "$registry_file" ]]; then
  echo "error: registry file not found: $registry_file" >&2
  exit 1
fi

repo_remote=$(awk -F': ' '/^repo_remote:/{print $2; exit}' "$registry_file")
repo_local=$(awk -F': ' '/^repo_local:/{print $2; exit}' "$registry_file")

if [[ -z "${repo_remote:-}" || -z "${repo_local:-}" ]]; then
  echo "error: repo_remote or repo_local missing in registry" >&2
  exit 1
fi

if [[ -d "$repo_local/.git" ]]; then
  git -C "$repo_local" fetch --prune
  git -C "$repo_local" pull --ff-only
else
  git clone "$repo_remote" "$repo_local"
fi

local_root="${LOCAL_SKILLS_ROOT:-/Users/wildmaker/.codex/skills}"
local_agent_name="${LOCAL_AGENT_NAME:-codex}"
audit_root="$repo_local/$local_agent_name"

create_list=()
update_list=()
skip_list=()
did_sync=0

get_local_version() {
  local skill_md="$1"
  awk 'BEGIN{f=0}
    /^---[[:space:]]*$/{if (f==0) {f=1; next} else {exit}}
    f==1 && /^version:[[:space:]]*/{print $2; exit}
  ' "$skill_md"
}

version_gt() {
  local a="$1"
  local b="$2"
  [[ "$(printf '%s\n%s\n' "$a" "$b" | sort -V | tail -n 1)" == "$a" ]] && [[ "$a" != "$b" ]]
}

for skill_dir in "$local_root"/*; do
  [[ -d "$skill_dir" ]] || continue
  skill_name=$(basename "$skill_dir")
  local_skill_md="$skill_dir/SKILL.md"
  [[ -f "$local_skill_md" ]] || continue

  local_version=$(get_local_version "$local_skill_md")
  if [[ -z "${local_version:-}" ]]; then
    local_version="0.0.0"
  fi

  spec_yaml="$repo_local/specs/$skill_name/spec.yaml"
  if [[ ! -f "$spec_yaml" ]]; then
    create_list+=("$skill_name (local $local_version -> spec 0.0.0)")
    continue
  fi

  spec_version=$(awk -F': ' '/^version:/{print $2; exit}' "$spec_yaml")
  if [[ -z "${spec_version:-}" ]]; then
    spec_version="0.0.0"
  fi

  if version_gt "$local_version" "$spec_version"; then
    update_list+=("$skill_name (local $local_version -> spec $spec_version)")
  else
    skip_list+=("$skill_name (local $local_version <= spec $spec_version)")
  fi
done

echo "create_specs:"
if [[ ${#create_list[@]} -eq 0 ]]; then
  echo "- none"
else
  for s in "${create_list[@]}"; do
    echo "- $s"
  done
fi

echo "update_specs:"
if [[ ${#update_list[@]} -eq 0 ]]; then
  echo "- none"
else
  for s in "${update_list[@]}"; do
    echo "- $s"
  done
fi

echo "skipped_specs:"
if [[ ${#skip_list[@]} -eq 0 ]]; then
  echo "- none"
else
  for s in "${skip_list[@]}"; do
    echo "- $s"
  done
fi

echo "audit_copy_root: $audit_root"

# Auto commit and push if repo has changes (sync actions are handled by the calling skill)
if [[ -n "$(git -C "$repo_local" status --porcelain)" ]]; then
  git -C "$repo_local" add .
  git -C "$repo_local" commit -m "chore(skill-sync): sync local skills"
  git -C "$repo_local" push
  did_sync=1
fi

echo "did_commit_push: $did_sync"
