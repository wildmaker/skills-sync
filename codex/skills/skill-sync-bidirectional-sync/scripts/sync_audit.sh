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

spec_root="$repo_local/specs"
if [[ ! -d "$spec_root" ]]; then
  echo "error: spec root not found: $spec_root" >&2
  exit 1
fi

local_root="${LOCAL_SKILLS_ROOT:-/Users/wildmaker/.codex/skills}"

create_list=()
update_list=()

get_local_version() {
  local skill_md="$1"
  awk 'BEGIN{f=0}
    /^---[[:space:]]*$/{if (f==0) {f=1; next} else {exit}}
    f==1 && /^version:[[:space:]]*/{print $2; exit}
  ' "$skill_md"
}

for spec_dir in "$spec_root"/*; do
  [[ -d "$spec_dir" ]] || continue
  skill_name=$(basename "$spec_dir")
  spec_yaml="$spec_dir/spec.yaml"
  [[ -f "$spec_yaml" ]] || continue
  spec_version=$(awk -F': ' '/^version:/{print $2; exit}' "$spec_yaml")
  local_skill_md="$local_root/$skill_name/SKILL.md"

  if [[ ! -f "$local_skill_md" ]]; then
    create_list+=("$skill_name")
    continue
  fi

  local_version=$(get_local_version "$local_skill_md")
  if [[ -z "${local_version:-}" ]]; then
    local_version="0.0.0"
  fi

  if [[ "$local_version" != "$spec_version" ]]; then
    update_list+=("$skill_name (local $local_version -> spec $spec_version)")
  fi

done

echo "create_skills:"
if [[ ${#create_list[@]} -eq 0 ]]; then
  echo "- none"
else
  for s in "${create_list[@]}"; do
    echo "- $s"
  done
fi

echo "update_skills:"
if [[ ${#update_list[@]} -eq 0 ]]; then
  echo "- none"
else
  for s in "${update_list[@]}"; do
    echo "- $s"
  done
fi
