# Skill Sync Repo To Local

## Inputs

Accept a structured input block with these fields, but allow omission and infer automatically when missing:

- local_skills_root: string (default: /Users/wildmaker/.codex/skills)

## Auto-generate missing inputs

- local_skills_root: default to `/Users/wildmaker/.codex/skills`.

## Steps

- Run skill-sync-bidirectional-sync's audit script to pull the repo and compute the diff list.
- For each missing skill, call skill-sync-skill-generator.
- For each outdated skill, call skill-sync-skill-generator to update.

## Output

Return a structured response:

```
status: complete
created:
  - <skill-name>
updated:
  - <skill-name>
```

## Invariants

- Do not modify the spec repo beyond pulling latest.
- Only write to the local skills directory.
- Do not run git push.
