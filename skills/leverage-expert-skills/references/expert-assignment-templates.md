# Expert Assignment Templates

## 1) Expert Matching Result

```markdown
### Expert Matching
| Skill | Score | Role | Why it matches |
|---|---:|---|---|
| <skill-a> | <0.0-5.0> | Core expert | <reason> |
| <skill-b> | <0.0-5.0> | Optional expert | <reason> |
```

## 2) Expert-Assigned Plan

```markdown
### Execution Plan (Expert Assigned)
1. <step description> [Primary Expert: <$skill-a>]
2. <step description> [Primary Expert: <$skill-b>]
3. <step description> [Primary Expert: <$skill-c>; Secondary: <$skill-d>]
```

## 3) AGENTS Section Snippet

Use this section title exactly for idempotent updates.

```markdown
## Recommended Expert Skills

- <$skill-name>: <one-line applicability in this repo>
- <$skill-name>: <one-line applicability in this repo>
```

## 4) Repo Bootstrap Summary

```markdown
### Repo Domain Summary
- <domain-1>
- <domain-2>
- <domain-3>

### Recommended Experts Added
- <$skill-1>
- <$skill-2>

Updated file: <AGENTS.md|AGENT.md>
```
