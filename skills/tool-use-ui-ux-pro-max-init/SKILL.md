---
name: tool-use-ui-ux-pro-max-init
description: Check UI UX Pro Max prerequisites from README and initialize the skill in a selected project via uipro CLI. Use when setting up UI UX Pro Max for Cursor/Codex/other supported assistants.
version: 0.1.0
---

# Skill: ui-ux-pro-max-init

## Trigger
- User asks to install/init `nextlevelbuilder/ui-ux-pro-max-skill`
- User asks to run UI UX Pro Max prerequisite checks and setup in a project

## What this skill does
- Checks required tools before installation:
  - `python3` (README prerequisite for search script)
  - `node` and `npm` (needed for CLI install)
- Installs `uipro-cli` globally if missing
- Runs `uipro init --ai <platform>` in the selected project

## Inputs
- `<project_path>`: absolute path of target project
- `<ai_platform>`: one of `cursor`, `codex`, `claude`, `windsurf`, etc.
- Optional `<offline>`: add `--offline` when network download should be skipped

## Allowed commands
- `bash`
- `node`
- `npm`
- `python3`
- `uipro`

## Steps
1. Run the bundled script from repo root:
   `skills/tool-use-ui-ux-pro-max-init/scripts/check_and_init_uipro.sh --project <ABS_PROJECT_PATH> --ai <AI_PLATFORM>`
2. If needed, add `--offline`.
3. Review output and confirm `uipro init` succeeded.

## Notes
- If `uipro` is missing, the script installs `uipro-cli` with:
  `npm install -g uipro-cli`
- The script only checks prerequisites mentioned by README and performs init. It does not modify unrelated files.
