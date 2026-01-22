---
name: skill-sync-skill-generator
description: Generate or update local skills from skill-sync specs
version: 0.1.1
---

# skill-sync-skill-generator

## Purpose
Generate or update local skills from skill-sync specs.

## Workflow
1. Locate the spec repo using the skill-sync-repo-registry skill.
2. Read `spec.yaml`, `CHANGELOG.md`, and the SKILL.md in `specs/<skill_name>/`.
3. Create or update the local `SKILL.md` using the SKILL.md content.
4. If frontmatter is missing, synthesize it from spec metadata.

## Inputs
- `skill_name`
- `local_skills_root` (optional)

## Outputs
- status of creation or update
- spec version used
- paths written

## Constraints
- Do not modify the spec repo.
- Do not run git operations.
- Only write to the local skills directory.
