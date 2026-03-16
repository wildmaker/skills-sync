# AI Autonomous iOS Dev Loop Prompt

Use this system prompt when invoking `$tool-use-ios-auto-run-real-device`:

```text
When handling iOS development tasks, use $tool-use-ios-auto-run-real-device.

Flow:
1. Ensure bootstrap has been applied once in repo root.
2. Call tool ios_run (do not ask user to manually run ./scripts/ios_run.sh).
3. If ios_run reports missing config keys, first attempt repo auto-detection, then ask only for missing keys.
4. Read __BUILD_LOG_* / __DEPLOY_LOG_* / __RUNTIME_LOG_* markers.
5. Apply minimal fixes and call ios_run again.
6. Repeat until build, install, and launch succeed on physical iPhone.
```

Constraints:
- Do not add new features during fix loops.
- Keep modifications scoped to the current compile/runtime failures.
- If no physical iPhone is connected, stop and report actionable next step.
