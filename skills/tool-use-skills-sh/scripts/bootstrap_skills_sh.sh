#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:-vercel-labs/agent-skills}"
AGENT="${2:-codex}"

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: missing required command: $cmd" >&2
    exit 1
  fi
}

echo "[1/4] Checking prerequisites..."
require_cmd node
require_cmd npm
require_cmd npx

echo "[2/4] Verifying skills CLI..."
SKILLS_VERSION="$(npx -y skills --version)"
echo "skills version: ${SKILLS_VERSION}"

echo "[3/4] Ensuring local agent skill directories..."
mkdir -p "${HOME}/.codex/skills" "${HOME}/.claude/skills" "${HOME}/.cursor/skills"

echo "[4/4] Installing skills source '${SOURCE}' for agent '${AGENT}'..."
npx -y skills add "${SOURCE}" -g -a "${AGENT}" -y

if [[ "${AGENT}" == "codex" && -d "${HOME}/.agents/skills" ]]; then
  echo "Linking ~/.agents/skills into ~/.codex/skills when missing..."
  shopt -s nullglob
  for skill_dir in "${HOME}/.agents/skills"/*; do
    [[ -d "${skill_dir}" ]] || continue
    skill_name="$(basename "${skill_dir}")"
    target="${HOME}/.codex/skills/${skill_name}"
    if [[ -e "${target}" && ! -L "${target}" ]]; then
      echo "WARN: skip existing non-symlink ${target}"
      continue
    fi
    ln -sfn "${skill_dir}" "${target}"
  done
  shopt -u nullglob
fi

echo
echo "Bootstrap complete."
echo "Verification commands:"
echo "  npx -y skills list -g -a ${AGENT}"
echo "  ls -la ${HOME}/.agents/skills 2>/dev/null || true"
echo "  ls -la ${HOME}/.${AGENT}/skills 2>/dev/null || true"
