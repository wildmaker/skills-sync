---
name: tool-use-sync-env-values
description: Run a script to copy values from a source .env into a target .env. Use when asked to sync env values between files without overwriting non-empty target values.
---

# sync-env-values

## What this skill does
- Sync values from a source env file into a target env file
- Preserve target file structure, comments, and ordering
- Only fill empty values in target (no overwrite)

## Constraints
- Do not overwrite non-empty target values
- Keep comments and formatting intact
- Require explicit source/target paths

## Allowed commands
- `node`
- `cat`
- `rg`

## Script
- `scripts/sync-env-values.js`

## Steps
1. Confirm source and target env file paths with the user.
2. Run the script:

```bash
node scripts/sync-env-values.js --source <source.env> --target <target.env>
```

3. Report updated keys printed by the script.
4. If the user wants overwrite behavior, stop and ask before changing the script.

