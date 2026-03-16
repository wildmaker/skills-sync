---
name: tool-use-ios-auto-run-real-device
description: "Set up and run an AI autonomous iOS real-device loop from coding to build, install, launch, log, and auto-fix without opening Xcode UI. Use when user wants AI to directly drive iPhone deployment through skill invocation, auto-detect repo settings (workspace/scheme/bundle id), create local non-committed config on first run, and execute via MCP tool ios_run."
---

# ios-auto-run-real-device

## Workflow
1. Bootstrap once in repo root:
```bash
bash skills/tool-use-ios-auto-run-real-device/scripts/bootstrap_ios_autorun.sh
```
2. Let AI call MCP tool `ios_run` (not manual `./scripts/ios_run.sh` in normal flow).
3. On first run, auto-create `.codex/ios-auto-run.local.env` by scanning repo.
4. If required fields are still missing, ask user only for missing keys.
5. Repeat `ios_run` after each iOS code change until success.

## Behavior contract
- Prioritize autonomous detection from repository:
  - `IOS_WORKSPACE`: auto-detect `*.xcworkspace`
  - `IOS_SCHEME`: auto-detect via `xcodebuild -list -json`
  - `IOS_BUNDLE_ID`: auto-detect via `xcodebuild -showBuildSettings`
- Create local config file on first setup:
  - `.codex/ios-auto-run.local.env`
- Prevent accidental commit by writing ignore rule to:
  - `.git/info/exclude`
- Keep changes minimal; do not refactor unrelated code.

## Generated repo files
- `scripts/ios_prepare_config.sh` (detect/init local config)
- `scripts/ios_run.sh` (prepare-if-needed + build/install/launch + log markers)
- `scripts/auto_loop.sh` (fswatch-triggered loop)
- `.mcp/tools.json` or `.mcp/tools.ios-auto-run-real-device.json` (merge snippet)

## Required tools
- `xcodebuild` (Xcode CLI)
- `ios-deploy`
- optional: `libimobiledevice` (`idevicesyslog`), `fswatch`

## Log markers
`ios_run` prints:
- `__BUILD_LOG_START__` / `__BUILD_LOG_END__`
- `__DEPLOY_LOG_START__` / `__DEPLOY_LOG_END__`
- `__RUNTIME_LOG_START__` / `__RUNTIME_LOG_END__` (when runtime logging enabled)

Use these blocks for automated repair loops.

## Resources
- Script: `scripts/bootstrap_ios_autorun.sh`
- Reference: `references/agent-loop-prompt.md`
