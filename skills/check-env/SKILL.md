---
name: check-env
description: 初始化/更新 env.example，基于 env.example 安全重建 .env，并检查 .env 必填变量完整性。
version: 0.1.0
---

# check-env

## What this skill does

- Initialize or update `env.example` from the actual codebase requirements.
- Rebuild `.env` from `env.example` while preserving existing non-empty values
  from a timestamped backup.
- Check `.env` completeness and report required keys that are missing or empty.

## Safety Rules

- Never directly edit a real environment file such as `.env`, `.env.local`,
  `.env.production`, or `.env.test` with the editor, patch tools, heredocs,
  shell redirection, or `cp`.
- All operations that read/write an existing real `.env*` file must be performed
  by a script. If the needed script is missing, create or copy the script first,
  review it, then run it.
- Always back up the target `.env*` file before replacing it.
- Never print secret values. Report key names, backup paths, counts, and
  warnings only.
- Never place real secrets in `env.example`; use an empty value plus a
  `# required:` comment for secrets or values the user must provide.
- Do not overwrite non-empty existing `.env*` values unless the user explicitly
  asks for overwrite behavior.

## Required Key Convention

- In `env.example`, a required key is any key with an empty value or placeholder
  value, unless its inline comment contains `optional`.
- Prefer explicit inline comments:
  - `JWT_SECRET= # required: generate a strong secret`
  - `SENTRY_DSN= # optional: enables error reporting`
- Keys with safe recommended defaults, such as `PORT=3000`, are not considered
  missing by the completeness checker.

## Bundled Scripts

Resolve `<check-env-skill-dir>` to the directory containing this `SKILL.md`.
Use the bundled scripts from that directory, or create equivalent project-local
scripts when the environment cannot run the bundled ones.

- `scripts/update-env-from-example.js`
  - Backs up the target `.env*`.
  - Copies the structure from `env.example`.
  - Restores non-empty values from the backup for matching keys.
  - Reports restored keys and old keys omitted because they are no longer in
    `env.example`.
- `scripts/check-env-completeness.js`
  - Reads `env.example` to determine required keys.
  - Checks the target `.env*` for missing, empty, or still-placeholder values.
  - Exits non-zero and prints the missing key names when incomplete.

## Allowed Commands

- `rg` for codebase discovery.
- `node <check-env-skill-dir>/scripts/update-env-from-example.js ...`
- `node <check-env-skill-dir>/scripts/check-env-completeness.js ...`
- Existing project env tooling, if it follows the same backup/no-secret-output
  safety rules.

## Subflow A: Initialize Or Update `env.example`

1. Inspect the project before editing. Search source code, config files, server
   setup, package scripts, Docker/compose files, CI, deployment config, and test
   setup for environment reads such as `process.env.*`, `import.meta.env.*`,
   `Deno.env.get`, `os.Getenv`, `env::var`, `getenv`, `$_ENV`, and framework
   config helpers.
2. For each env key, determine:
   - where it is used;
   - whether it is required or optional;
   - whether code already provides a default;
   - whether it is a secret;
   - a safe suggested value if one is obvious.
3. Group `env.example` by feature or runtime area, using only groups that apply
   to the project, for example:
   - App/runtime
   - Database/cache
   - Auth/secrets
   - Third-party integrations
   - Storage
   - Observability
   - Feature flags
   - Tests
4. Initialize safe non-secret defaults directly, for example `PORT=3000`,
   `HOST=127.0.0.1`, `NODE_ENV=development`, or local service hosts when the
   project already implies them.
5. Leave secrets and user-specific values blank with `# required:` comments.
6. Remove keys from `env.example` only when code/config evidence shows they are
   no longer used. If unsure, keep the key and add a `# TODO:` comment instead
   of silently deleting it.

## Subflow B: Rebuild `.env` From `env.example`

1. Ensure `env.example` is up to date first.
2. Run the script; do not manually edit or copy the `.env` file:

```bash
node <check-env-skill-dir>/scripts/update-env-from-example.js --example env.example --env .env
```

3. If the project uses `.env.example` instead of `env.example`, pass that path
   explicitly:

```bash
node <check-env-skill-dir>/scripts/update-env-from-example.js --example .env.example --env .env
```

4. Report the backup path, restored key names, and omitted old key names. Do not
   print values.

## Subflow C: Check `.env` Completeness

1. Ensure the target `.env*` exists. If it does not, run Subflow B first.
2. Run the completeness script:

```bash
node <check-env-skill-dir>/scripts/check-env-completeness.js --example env.example --env .env
```

3. If the script reports missing keys, summarize the missing key names and ask
   the user to fill them in. Do not invent secret values.
4. If all required keys are present, report success and note any non-blocking
   warnings printed by the script.

## Output

- For `env.example` updates: summarize added, changed, grouped, and removed
  keys by name only.
- For `.env` rebuilds: include the backup path and restored key names.
- For completeness checks: include either "complete" or the missing key list.
