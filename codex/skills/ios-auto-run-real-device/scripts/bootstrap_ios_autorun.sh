#!/usr/bin/env bash
set -euo pipefail

TARGET_ROOT="$(pwd)"
WORKSPACE_OVERRIDE=""
SCHEME_OVERRIDE=""
BUNDLE_ID_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      TARGET_ROOT="${2:-}"
      shift 2
      ;;
    --workspace)
      WORKSPACE_OVERRIDE="${2:-}"
      shift 2
      ;;
    --scheme)
      SCHEME_OVERRIDE="${2:-}"
      shift 2
      ;;
    --bundle-id)
      BUNDLE_ID_OVERRIDE="${2:-}"
      shift 2
      ;;
    -h|--help)
      cat <<'EOF'
Usage:
  bootstrap_ios_autorun.sh [--project-root <path>] [--workspace <xcworkspace>] [--scheme <scheme>] [--bundle-id <bundle-id>]

Behavior:
  1) Generate scripts/ios_prepare_config.sh, scripts/ios_run.sh, scripts/auto_loop.sh
  2) Initialize .codex/ios-auto-run.local.env from repo autodetection (or overrides)
  3) Create/merge .mcp/tools.json entries for ios_run and ios_auto_loop
  4) Add local-only ignore rule via .git/info/exclude
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$TARGET_ROOT/scripts" "$TARGET_ROOT/.mcp"

PREPARE_PATH="$TARGET_ROOT/scripts/ios_prepare_config.sh"
IOS_RUN_PATH="$TARGET_ROOT/scripts/ios_run.sh"
AUTO_LOOP_PATH="$TARGET_ROOT/scripts/auto_loop.sh"
TOOLS_JSON_PATH="$TARGET_ROOT/.mcp/tools.json"
TOOLS_SNIPPET_PATH="$TARGET_ROOT/.mcp/tools.ios-auto-run-real-device.json"

cat > "$PREPARE_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

CONFIG_DIR="$PROJECT_ROOT/.codex"
CONFIG_FILE="$CONFIG_DIR/ios-auto-run.local.env"
EXCLUDE_FILE="$PROJECT_ROOT/.git/info/exclude"

WORKSPACE_OVERRIDE="${IOS_WORKSPACE_OVERRIDE:-}"
SCHEME_OVERRIDE="${IOS_SCHEME_OVERRIDE:-}"
BUNDLE_ID_OVERRIDE="${IOS_BUNDLE_ID_OVERRIDE:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      WORKSPACE_OVERRIDE="${2:-}"
      shift 2
      ;;
    --scheme)
      SCHEME_OVERRIDE="${2:-}"
      shift 2
      ;;
    --bundle-id)
      BUNDLE_ID_OVERRIDE="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

detect_workspace() {
  local found
  mapfile -t found < <(find . \
    -type d -name "*.xcworkspace" \
    -not -path "*/Pods/*" \
    -not -path "*/Carthage/*" \
    -not -path "*/.build/*" \
    -not -path "*/DerivedData/*" \
    -not -path "*/.git/*" \
    | sed 's#^\./##' \
    | sort)
  if [[ "${#found[@]}" -eq 0 ]]; then
    echo ""
    return
  fi
  echo "${found[0]}"
}

detect_scheme() {
  local workspace="$1"
  if [[ -z "$workspace" ]]; then
    echo ""
    return
  fi
  local raw
  raw="$(xcodebuild -list -json -workspace "$workspace" 2>/dev/null || true)"
  if [[ -z "$raw" ]]; then
    echo ""
    return
  fi
  python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
except Exception:
    print("")
    raise SystemExit(0)
schemes=((data.get("workspace") or {}).get("schemes") or [])
print(schemes[0] if schemes else "")' <<<"$raw"
}

detect_bundle_id() {
  local workspace="$1"
  local scheme="$2"
  if [[ -z "$workspace" || -z "$scheme" ]]; then
    echo ""
    return
  fi
  xcodebuild -showBuildSettings -workspace "$workspace" -scheme "$scheme" 2>/dev/null \
    | awk -F ' = ' '/PRODUCT_BUNDLE_IDENTIFIER/ {print $2; exit}'
}

read_existing_value() {
  local key="$1"
  local file="$2"
  if [[ -f "$file" ]]; then
    awk -F '=' -v k="$key" '$1==k{print substr($0, index($0, "=")+1); exit}' "$file"
  fi
}

ensure_local_ignore() {
  local pattern="$1"
  mkdir -p "$(dirname "$EXCLUDE_FILE")"
  touch "$EXCLUDE_FILE"
  if ! grep -Fxq "$pattern" "$EXCLUDE_FILE"; then
    printf '%s\n' "$pattern" >> "$EXCLUDE_FILE"
  fi
}

mkdir -p "$CONFIG_DIR"

existing_workspace="$(read_existing_value IOS_WORKSPACE "$CONFIG_FILE")"
existing_scheme="$(read_existing_value IOS_SCHEME "$CONFIG_FILE")"
existing_bundle_id="$(read_existing_value IOS_BUNDLE_ID "$CONFIG_FILE")"
existing_device_id="$(read_existing_value IOS_DEVICE_ID "$CONFIG_FILE")"
existing_configuration="$(read_existing_value IOS_CONFIGURATION "$CONFIG_FILE")"
existing_derived_data="$(read_existing_value IOS_DERIVED_DATA_PATH "$CONFIG_FILE")"
existing_runtime_log="$(read_existing_value IOS_ENABLE_RUNTIME_LOG "$CONFIG_FILE")"
existing_runtime_seconds="$(read_existing_value IOS_RUNTIME_LOG_SECONDS "$CONFIG_FILE")"

workspace="${WORKSPACE_OVERRIDE:-${existing_workspace:-}}"
if [[ -z "$workspace" ]]; then
  workspace="$(detect_workspace)"
fi

scheme="${SCHEME_OVERRIDE:-${existing_scheme:-}}"
if [[ -z "$scheme" ]]; then
  scheme="$(detect_scheme "$workspace")"
fi

bundle_id="${BUNDLE_ID_OVERRIDE:-${existing_bundle_id:-}}"
if [[ -z "$bundle_id" ]]; then
  bundle_id="$(detect_bundle_id "$workspace" "$scheme")"
fi

configuration="${existing_configuration:-Debug}"
derived_data_path="${existing_derived_data:-build}"
enable_runtime_log="${existing_runtime_log:-0}"
runtime_log_seconds="${existing_runtime_seconds:-15}"
device_id="${existing_device_id:-}"

cat > "$CONFIG_FILE" <<ENVEOF
# Local iOS auto-run config (do not commit)
IOS_WORKSPACE=$workspace
IOS_SCHEME=$scheme
IOS_BUNDLE_ID=$bundle_id
IOS_DEVICE_ID=$device_id
IOS_CONFIGURATION=$configuration
IOS_DERIVED_DATA_PATH=$derived_data_path
IOS_ENABLE_RUNTIME_LOG=$enable_runtime_log
IOS_RUNTIME_LOG_SECONDS=$runtime_log_seconds
ENVEOF

ensure_local_ignore ".codex/ios-auto-run.local.env"

echo "__IOS_CONFIG_START__"
cat "$CONFIG_FILE"
echo "__IOS_CONFIG_END__"

missing=()
[[ -z "$workspace" ]] && missing+=("IOS_WORKSPACE")
[[ -z "$scheme" ]] && missing+=("IOS_SCHEME")
[[ -z "$bundle_id" ]] && missing+=("IOS_BUNDLE_ID")

if [[ "${#missing[@]}" -gt 0 ]]; then
  echo "Missing required config keys: ${missing[*]}" >&2
  exit 2
fi

echo "iOS local config is ready."
EOF

cat > "$IOS_RUN_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

CONFIG_FILE="$PROJECT_ROOT/.codex/ios-auto-run.local.env"
PREPARE_SCRIPT="$PROJECT_ROOT/scripts/ios_prepare_config.sh"

if [[ ! -f "$CONFIG_FILE" ]]; then
  "$PREPARE_SCRIPT"
fi

set +u
source "$CONFIG_FILE"
set -u

if [[ -z "${IOS_WORKSPACE:-}" || -z "${IOS_SCHEME:-}" || -z "${IOS_BUNDLE_ID:-}" ]]; then
  "$PREPARE_SCRIPT"
  set +u
  source "$CONFIG_FILE"
  set -u
fi

if [[ -z "${IOS_WORKSPACE:-}" || -z "${IOS_SCHEME:-}" || -z "${IOS_BUNDLE_ID:-}" ]]; then
  echo "Required keys are still missing in .codex/ios-auto-run.local.env" >&2
  echo "Please fill IOS_WORKSPACE / IOS_SCHEME / IOS_BUNDLE_ID and retry." >&2
  exit 2
fi

BUILD_LOG="${IOS_BUILD_LOG:-ios_build.log}"
DEPLOY_LOG="${IOS_DEPLOY_LOG:-ios_deploy.log}"
RUNTIME_LOG="${IOS_RUNTIME_LOG:-ios_runtime.log}"

if [[ -n "${IOS_DEVICE_ID:-}" ]]; then
  DEVICE_ID="$IOS_DEVICE_ID"
else
  DEVICE_ID=$(xcrun xctrace list devices \
    | grep "iPhone" \
    | grep -v "Simulator" \
    | head -n1 \
    | sed -n 's/.*(\([A-Fa-f0-9-]*\)).*/\1/p')
fi

if [[ -z "$DEVICE_ID" ]]; then
  echo "No physical iPhone detected. Check: xcrun xctrace list devices" >&2
  exit 1
fi

echo "== iOS Auto Deploy Start =="
echo "Device ID: $DEVICE_ID"
echo "Workspace: ${IOS_WORKSPACE}"
echo "Scheme: ${IOS_SCHEME}"

xcodebuild \
  -workspace "${IOS_WORKSPACE}" \
  -scheme "${IOS_SCHEME}" \
  -configuration "${IOS_CONFIGURATION:-Debug}" \
  -destination "id=${DEVICE_ID}" \
  -derivedDataPath "${IOS_DERIVED_DATA_PATH:-build}" \
  build | tee "$BUILD_LOG"

APP_PATH=$(find "${IOS_DERIVED_DATA_PATH:-build}" -type d -name "*.app" \
  | grep "${IOS_CONFIGURATION:-Debug}-iphoneos" \
  | head -n1 || true)

if [[ -z "$APP_PATH" ]]; then
  echo "App bundle not found under ${IOS_DERIVED_DATA_PATH:-build}" >&2
  exit 1
fi

ios-deploy \
  --id "$DEVICE_ID" \
  --bundle "$APP_PATH" \
  --justlaunch | tee "$DEPLOY_LOG"

if [[ "${IOS_ENABLE_RUNTIME_LOG:-0}" == "1" ]]; then
  if command -v idevicesyslog >/dev/null 2>&1; then
    timeout "${IOS_RUNTIME_LOG_SECONDS:-15}" idevicesyslog | tee "$RUNTIME_LOG" || true
  else
    xcrun devicectl device process launch \
      --device "$DEVICE_ID" \
      "${IOS_BUNDLE_ID}" | tee "$RUNTIME_LOG" || true
  fi
fi

echo "__BUILD_LOG_START__"
cat "$BUILD_LOG"
echo "__BUILD_LOG_END__"

echo "__DEPLOY_LOG_START__"
cat "$DEPLOY_LOG"
echo "__DEPLOY_LOG_END__"

if [[ -f "$RUNTIME_LOG" ]]; then
  echo "__RUNTIME_LOG_START__"
  cat "$RUNTIME_LOG"
  echo "__RUNTIME_LOG_END__"
fi

echo "== Installed & Launched =="
EOF

cat > "$AUTO_LOOP_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if ! command -v fswatch >/dev/null 2>&1; then
  echo "fswatch not installed. Run: brew install fswatch" >&2
  exit 1
fi

WATCH_PATH="${IOS_WATCH_PATH:-.}"

echo "Watching ${WATCH_PATH} for changes..."
fswatch -o "$WATCH_PATH" | while read -r _; do
  echo "Change detected, running ./scripts/ios_run.sh"
  ./scripts/ios_run.sh || true
done
EOF

chmod +x "$PREPARE_PATH" "$IOS_RUN_PATH" "$AUTO_LOOP_PATH"

if [[ -f "$TOOLS_JSON_PATH" ]]; then
  cat > "$TOOLS_SNIPPET_PATH" <<'EOF'
{
  "tools": [
    {
      "name": "ios_run",
      "description": "Prepare config if needed, then build and run iOS app on real device",
      "command": "./scripts/ios_run.sh"
    },
    {
      "name": "ios_auto_loop",
      "description": "Watch files and rerun iOS deploy loop automatically",
      "command": "./scripts/auto_loop.sh"
    }
  ]
}
EOF
  echo "Existing .mcp/tools.json detected."
  echo "Merge entries from: $TOOLS_SNIPPET_PATH"
else
  cat > "$TOOLS_JSON_PATH" <<'EOF'
{
  "tools": [
    {
      "name": "ios_run",
      "description": "Prepare config if needed, then build and run iOS app on real device",
      "command": "./scripts/ios_run.sh"
    },
    {
      "name": "ios_auto_loop",
      "description": "Watch files and rerun iOS deploy loop automatically",
      "command": "./scripts/auto_loop.sh"
    }
  ]
}
EOF
  echo "Created .mcp/tools.json"
fi

# Initialize local config immediately during first bootstrap run.
IOS_WORKSPACE_OVERRIDE="$WORKSPACE_OVERRIDE" \
IOS_SCHEME_OVERRIDE="$SCHEME_OVERRIDE" \
IOS_BUNDLE_ID_OVERRIDE="$BUNDLE_ID_OVERRIDE" \
"$PREPARE_PATH" || true

cat <<EOF
Bootstrap complete.
- Generated: $PREPARE_PATH
- Generated: $IOS_RUN_PATH
- Generated: $AUTO_LOOP_PATH
- Generated: $TOOLS_JSON_PATH (or merge snippet)

First run (AI should call tool ios_run, not direct shell):
  ios_run
EOF
