# Spec Version Check

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- spec_name: string (use the skill name)
- local_spec_version: string (SemVer)

## Auto-generate missing inputs

If any inputs are missing, infer them using these rules:

- spec_name: derive from the skill name being checked.
- local_spec_version: default to `0.0.0` if unknown.

## Procedure

- Read `specs/<spec_name>/spec.yaml`.
- Extract `version`, `change_type`, and `breaking`.
- Compare `local_spec_version` with `version` using SemVer ordering.
- Do not modify any files.
- If the spec repo location is needed, consult the skill-sync-repo-registry skill.

## Output

Return a structured response:

```
up_to_date: true | false
latest_version: <version>
change_type: <change_type>
breaking: <true|false>
```

## Invariants

- Do not modify any files.
- Do not produce side effects.
- Only return facts from the spec repo.
