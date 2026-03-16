---
name: distill-specs-from-user-requirements
description: Review user requirement descriptions and add structured inline comments that distill true UI/UX requirements and business rules, flagging unclear items as TBD for confirmation. Use when asked to annotate requirement documents with categorized comments after each key paragraph.
---

# Distill Specs From User Requirements

## Goal

Produce an annotated requirements review where each key paragraph is followed by clearly categorized comments that translate intent into actionable UI/UX requirements and business rules, while marking uncertainties for confirmation.

## Workflow

1) Confirm input
- If no requirement document is provided, ask for the source text or file.
- If a format is required (e.g., Markdown), confirm it.

2) Preserve original text
- Keep the original paragraph verbatim and in order.
- Do not rewrite, summarize, or reorder the original content.

3) Add comments after each key paragraph
- Insert a comment block immediately after each key paragraph.
- Only comment on paragraphs that include requirements, constraints, or behaviors.

4) Categorize every comment
- Use only these labels unless the user asks for more:
  - COMMENT:UI/UX
  - COMMENT:Business Rule
  - COMMENT:TBD

5) Respect user intent
- Do not invent requirements; infer only when it is clearly implied.
- If intent is ambiguous, mark it as COMMENT:TBD with a question.

## Output Format (default)

Use this layout for each key paragraph:

[ORIGINAL]
<original paragraph>
[/ORIGINAL]

[COMMENT:UI/UX]
- <ui/ux requirement or note>
[/COMMENT]

[COMMENT:Business Rule]
- <business rule or constraint>
[/COMMENT]

[COMMENT:TBD]
- <question to confirm ambiguity>
[/COMMENT]

Guidance:
- If a category has no applicable notes, omit that block.
- Keep comments short and action-ready.
- Use the same language as the source document.

## Review Heuristics

- UI/UX: screen flow, information hierarchy, states, interactions, feedback, accessibility, responsive behavior.
- Business Rule: eligibility, calculations, validation, data retention, audit/logging, access control, timing/SLAs.
- TBD: missing thresholds, unclear ownership, undefined edge cases, conflicting statements.

## Quality Checklist

- Every key paragraph has at least one relevant comment or a TBD question.
- Comments are clearly distinguished from source text.
- No extra features or assumptions beyond the source.
- Ambiguities are explicitly surfaced as TBD.
