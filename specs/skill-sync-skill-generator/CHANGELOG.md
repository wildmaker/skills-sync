## 0.1.1 - 2026-01-22
- change_type: doc
- breaking: false
- summary: Standardize spec markdown filename to SKILL.md
- details:
  - Read SKILL.md instead of skill-name markdown

## 0.1.0 - 2026-01-22
- change_type: doc
- breaking: false
- summary: Generate or update local skills from skill-sync specs
- details:
  - Resolve spec repo location via registry
  - Read spec.yaml, CHANGELOG.md, and spec markdown
  - Generate or update local SKILL.md from spec markdown
  - Preserve or synthesize frontmatter based on spec metadata
