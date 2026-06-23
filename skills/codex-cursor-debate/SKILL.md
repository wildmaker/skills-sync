---
name: codex-cursor-debate
description: Run a 3-round debate on the same question between local Codex GPT-5.4 xhigh and Cursor Opus 4.6, then return both final answers and the key differences for the user to choose from. Use when the user asks to debate a question, wants Codex and Cursor to answer the same problem and critique each other, or asks for side-by-side final positions from both models.
---

# Codex Cursor Debate

Use this skill when the user wants one question debated by two local agent CLIs:

- Codex: `gpt-5.4` with `model_reasoning_effort="xhigh"`
- Cursor: `claude-4.6-opus-high`

The debate always runs for exactly 3 rounds per side.

## What To Do

1. Extract the user's question.
2. Run the orchestration script:

```bash
skills/codex-cursor-debate/scripts/run_debate.sh "<question>"
```

You can also pipe a longer prompt:

```bash
cat question.txt | skills/codex-cursor-debate/scripts/run_debate.sh
```

3. Read the generated summary and present the result back to the user.

## Behavior Contract

- Do not shorten the debate to fewer than 3 rounds.
- Do not keep debating after both sides finish round 3.
- The summary must show:
  - Codex final answer
  - Cursor final answer
  - Key differences
  - A simple choice guide (`Codex`, `Cursor`, or `Hybrid`)

## Defaults

- Codex model: `gpt-5.4`
- Codex reasoning: `xhigh`
- Cursor model: `claude-4.6-opus-high`
- Artifact root: `<workdir>/.omx/artifacts/codex-cursor-debate`

Optional overrides:

- `DEBATE_CODEX_MODEL`
- `DEBATE_CODEX_REASONING`
- `DEBATE_CURSOR_MODEL`
- `DEBATE_WORKDIR`
- `DEBATE_ARTIFACT_ROOT`

## Preconditions

Before running, ensure both binaries exist:

```bash
command -v codex
command -v cursor-agent
```

If either binary is missing, stop and explain the missing dependency.
If Cursor is not logged in, stop and ask the user to run:

```bash
cursor-agent whoami
```

## Output Files

The script writes a timestamped run folder containing:

- `summary.md` - final user-facing result
- `differences.md` - extracted disagreement summary
- `rounds/` - raw outputs for each round
- `logs/` - CLI logs for Codex and Cursor calls

Prefer reading `summary.md` unless debugging is needed.
