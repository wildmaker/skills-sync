# Spec Authoring Update

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- spec_name: string (use the skill name)
- operation: create | update
- change_type: doc | execution | behavioral | semantic
- breaking: true | false
- summary: short string
- details: multi-line list

## Auto-generate missing inputs

If any inputs are missing, infer them using these rules:

- spec_name: derive from the skill name being created or updated.
- operation: use `create` if `specs/<spec_name>/spec.yaml` is missing; otherwise `update`.
- change_type: default to `doc` when only spec text/structure changes are made; `execution` when runtime setup/commands change; `behavioral` when behavior changes without breaking; `semantic` when meaning/contract changes. If uncertain, ask for confirmation.
- breaking: default to `false` unless there is an explicit breaking change.
- summary: derive a short sentence from the change intent.
- details: list the concrete changes made or intended.

## Locate spec repo

- Treat the spec repo as the only write target.
- Resolve the spec path as `specs/<spec_name>/` relative to the current repo root.
- If the repo root is unknown, consult the skill-sync-repo-registry skill for the canonical repo location.
- If the spec repo location is outside writable roots, request escalated write permission before creating or updating files.
 - If a local skill folder exists for `spec_name`, mirror its resource subfolders (`scripts/`, `references/`, `assets/`) into the spec folder alongside `SKILL.md`.

## Validate required files

- Ensure `specs/<spec_name>/spec.yaml` and `specs/<spec_name>/CHANGELOG.md` exist for update.
- For create, create the directory and both files.
- For create, also create a spec markdown file named `SKILL.md` in the same directory.

## Versioning rules

Apply these rules strictly:

1) If `breaking == true`, bump MAJOR.
2) Else bump by `change_type`:
   - doc: PATCH
   - execution: PATCH
   - behavioral: MINOR
   - semantic: MAJOR

Use SemVer `MAJOR.MINOR.PATCH`.

## spec.yaml template

For create, write this template and fill in values:

```yaml
spec_id: <spec_name>
version: 0.1.0
change_type: <change_type>
breaking: <true|false>
summary: <summary>
details:
  - <detail item>
```

For update, overwrite the following fields in `spec.yaml`:

- version
- change_type
- breaking
- summary
- details

Do not add extra keys.

## Changelog rules

Append a new entry to `CHANGELOG.md` using this format:

```markdown
## <version> - <YYYY-MM-DD>
- change_type: <change_type>
- breaking: <true|false>
- summary: <summary>
- details:
  - <detail item>
```

Use the current date in UTC for `<YYYY-MM-DD>`.

## Output

Return a structured response:

```
spec_name: <spec_name>
old_version: <old_version or none>
new_version: <new_version>
change_type: <change_type>
breaking: <true|false>
```

## Invariants

- Do not modify any agent private skills.
- Do not skip version or change_type updates.
- Only write to the spec repo path.
