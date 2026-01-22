# Ensure Spec Up To Date

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- skill_id: string
- spec_name: string (use the skill name)
- local_spec_version: string (SemVer)

## Auto-generate missing inputs

If any inputs are missing, infer them using these rules:

- skill_id: derive from the invoking skill identifier.
- spec_name: derive from the skill name being checked.
- local_spec_version: default to `0.0.0` if unknown.

## Use the spec-version-check skill

- Call the spec-version-check skill to fetch the latest spec version, change_type, and breaking flag.
- Do not modify any spec files.
- If the spec repo location is needed, consult the skill-sync-repo-registry skill.

## Decision logic

Apply this logic exactly:

```
if breaking == true:
    status = blocked
    action_taken = acknowledge-required
    stop
elif change_type in [doc, execution]:
    status = synced
    action_taken = auto-sync
    update local_spec_version
elif change_type == behavioral:
    status = synced
    action_taken = regenerate
    update local_spec_version
elif change_type == semantic:
    status = synced
    action_taken = regenerate
    update local_spec_version
else:
    status = noop
    action_taken = auto-sync
```

## Output

Return a structured response:

```
status: synced | blocked | noop
action_taken: auto-sync | regenerate | acknowledge-required
new_spec_version: <latest_version or local_spec_version>
```

## Invariants

- Do not execute any business action.
- Do not modify any spec.
- Only decide whether execution may continue.
