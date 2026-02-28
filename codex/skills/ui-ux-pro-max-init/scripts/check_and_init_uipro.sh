#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH=""
AI_PLATFORM=""
OFFLINE=0
SKIP_CLI_INSTALL=0

usage() {
  cat <<'EOF'
Usage:
  check_and_init_uipro.sh --project <ABS_PROJECT_PATH> --ai <AI_PLATFORM> [--offline] [--skip-cli-install]

Examples:
  check_and_init_uipro.sh --project /path/to/repo --ai cursor
  check_and_init_uipro.sh --project /path/to/repo --ai codex --offline
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_PATH="${2:-}"
      shift 2
      ;;
    --ai)
      AI_PLATFORM="${2:-}"
      shift 2
      ;;
    --offline)
      OFFLINE=1
      shift
      ;;
    --skip-cli-install)
      SKIP_CLI_INSTALL=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$PROJECT_PATH" || -z "$AI_PLATFORM" ]]; then
  echo "Missing required arguments." >&2
  usage
  exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "Project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi

if [[ "$PROJECT_PATH" != /* ]]; then
  echo "--project must be an absolute path." >&2
  exit 1
fi

echo "==> Pre-requirement checks"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Missing python3 (required by UI UX Pro Max search script)." >&2
  exit 1
fi
python3 --version

if ! command -v node >/dev/null 2>&1; then
  echo "Missing node. Install Node.js first." >&2
  exit 1
fi
node --version

if ! command -v npm >/dev/null 2>&1; then
  echo "Missing npm. Install npm first." >&2
  exit 1
fi
npm --version

if ! command -v uipro >/dev/null 2>&1; then
  if [[ "$SKIP_CLI_INSTALL" -eq 1 ]]; then
    echo "uipro CLI missing and --skip-cli-install is set." >&2
    exit 1
  fi
  echo "==> Installing uipro-cli globally"
  npm install -g uipro-cli
fi

echo "==> uipro version"
uipro --version

echo "==> Initializing UI UX Pro Max in: $PROJECT_PATH"
cd "$PROJECT_PATH"

INIT_CMD=(uipro init --ai "$AI_PLATFORM")
if [[ "$OFFLINE" -eq 1 ]]; then
  INIT_CMD+=(--offline)
fi

echo "+ ${INIT_CMD[*]}"
"${INIT_CMD[@]}"

echo "✅ UI UX Pro Max init completed for AI platform: $AI_PLATFORM"
