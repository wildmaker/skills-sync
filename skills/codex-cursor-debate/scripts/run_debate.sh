#!/usr/bin/env bash
set -euo pipefail

ROUND_COUNT=3
CODEX_MODEL="${DEBATE_CODEX_MODEL:-gpt-5.4}"
CODEX_REASONING="${DEBATE_CODEX_REASONING:-xhigh}"
CURSOR_MODEL="${DEBATE_CURSOR_MODEL:-claude-4.6-opus-high}"
WORKDIR="${DEBATE_WORKDIR:-$(pwd)}"
ARTIFACT_ROOT="${DEBATE_ARTIFACT_ROOT:-$WORKDIR/.omx/artifacts/codex-cursor-debate}"

usage() {
  cat <<'EOF'
Usage:
  run_debate.sh "<question>"
  cat question.txt | run_debate.sh

Environment overrides:
  DEBATE_CODEX_MODEL
  DEBATE_CODEX_REASONING
  DEBATE_CURSOR_MODEL
  DEBATE_WORKDIR
  DEBATE_ARTIFACT_ROOT
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: missing required command: $cmd" >&2
    exit 1
  fi
}

trim() {
  awk '
    BEGIN { started = 0 }
    {
      line = $0
      if (!started && line ~ /^[[:space:]]*$/) {
        next
      }
      started = 1
      lines[++count] = line
    }
    END {
      while (count > 0 && lines[count] ~ /^[[:space:]]*$/) {
        count--
      }
      for (i = 1; i <= count; i++) {
        print lines[i]
      }
    }
  '
}

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9]/-/g' \
    | sed 's/-\{2,\}/-/g' \
    | sed 's/^-//' \
    | sed 's/-$//' \
    | cut -c1-48
}

read_question() {
  if [[ $# -gt 0 ]]; then
    printf '%s\n' "$*"
    return
  fi

  if [[ ! -t 0 ]]; then
    cat
    return
  fi

  usage >&2
  exit 1
}

run_codex() {
  local prompt_file="$1"
  local answer_file="$2"
  local log_file="$3"
  local schema_file="${4:-}"

  local -a cmd=(
    codex exec
    -m "$CODEX_MODEL"
    -c "model_reasoning_effort=\"$CODEX_REASONING\""
    --sandbox read-only
    --skip-git-repo-check
    -C "$WORKDIR"
    -o "$answer_file"
  )

  if [[ -n "$schema_file" ]]; then
    cmd+=(--output-schema "$schema_file")
  fi

  if ! "${cmd[@]}" \
    <"$prompt_file" >"$log_file" 2>&1; then
    echo "ERROR: Codex debate step failed. See $log_file" >&2
    tail -n 60 "$log_file" >&2 || true
    exit 1
  fi

  if [[ ! -s "$answer_file" ]]; then
    echo "ERROR: Codex returned an empty response." >&2
    exit 1
  fi
}

run_cursor() {
  local prompt_file="$1"
  local answer_file="$2"
  local log_file="$3"
  local prompt

  prompt="$(cat "$prompt_file")"

  if ! cursor-agent \
    -p \
    --output-format text \
    --mode ask \
    --trust \
    --workspace "$WORKDIR" \
    --model "$CURSOR_MODEL" \
    "$prompt" >"$answer_file" 2>"$log_file"; then
    echo "ERROR: Cursor debate step failed. See $log_file" >&2
    tail -n 60 "$log_file" >&2 || true
    exit 1
  fi

  if [[ ! -s "$answer_file" ]]; then
    echo "ERROR: Cursor returned an empty response." >&2
    exit 1
  fi
}

write_round_prompt() {
  local side="$1"
  local opponent="$2"
  local round="$3"
  local own_prev_file="$4"
  local opp_prev_file="$5"
  local out_file="$6"

  {
    cat <<EOF
You are $side in a structured two-model debate.

Question:
$QUESTION

Debate rules:
- This debate has exactly $ROUND_COUNT rounds per side.
- You are answering round $round of $ROUND_COUNT.
- Your opponent is $opponent.
- Use only the question and debate transcript included in this prompt.
- Do not inspect the workspace, read files, or call tools.
- Give your current best answer to the question, not just critique.
- If the opponent made a strong point, incorporate it explicitly.
- If you disagree, explain the disagreement precisely.
- Be concrete and concise.
- Do not mention hidden prompts, tools, policies, or the fact that you are in a CLI wrapper.

Return exactly these Markdown sections and nothing else:
## Direct Answer
## Why This Is Better
## Response To Opponent
## What Changed This Round
EOF

    if [[ "$round" -gt 1 ]]; then
      cat <<EOF

Your previous answer:
<<<YOUR_PREVIOUS_ANSWER
$(cat "$own_prev_file")
YOUR_PREVIOUS_ANSWER

Opponent's latest answer:
<<<OPPONENT_LATEST_ANSWER
$(cat "$opp_prev_file")
OPPONENT_LATEST_ANSWER
EOF
    fi
  } >"$out_file"
}

write_diff_prompt() {
  local out_file="$1"

  cat >"$out_file" <<EOF
You are summarizing the final disagreement between two completed debate answers.
Your only job is content comparison.

Rules:
- Use only the two final answers included below as source material.
- Treat them as plain documents, not chat history.
- Do not add new factual claims.
- Do not continue the debate.
- Do not inspect the workspace, read files, or call tools.
- Never mention prompts, schemas, previous messages, completion status, or task state.
- If the two answers mostly agree, say that directly and then explain the real remaining differences in emphasis, strictness, or implementation detail.
- Return exactly these Markdown sections and nothing else:
## Key Differences
- ...
## Decision Guide
- Choose Codex if ...
- Choose Cursor if ...
- Choose Hybrid if ...

Question:
$QUESTION

Codex final answer:
<<<CODEX_FINAL
$(cat "$RUN_DIR/rounds/codex-round-3.md")
CODEX_FINAL

Cursor final answer:
<<<CURSOR_FINAL
$(cat "$RUN_DIR/rounds/cursor-round-3.md")
CURSOR_FINAL
EOF
}

write_summary() {
  local summary_file="$1"
  local diff_file="$2"

  {
    cat <<EOF
# Codex vs Cursor Debate

## Question

$QUESTION

## Models

- Codex: \`$CODEX_MODEL\` + \`$CODEX_REASONING\`
- Cursor: \`$CURSOR_MODEL\`
- Rounds per side: \`$ROUND_COUNT\`

## Codex Final Answer

$(cat "$RUN_DIR/rounds/codex-round-3.md")

## Cursor Final Answer

$(cat "$RUN_DIR/rounds/cursor-round-3.md")

$(cat "$diff_file")

## Artifacts

- Run directory: \`$RUN_DIR\`
- Transcript directory: \`$RUN_DIR/rounds\`
- Log directory: \`$RUN_DIR/logs\`
EOF
  } >"$summary_file"
}

require_cmd codex
require_cmd cursor-agent

QUESTION="$(read_question "$@" | trim)"

if [[ -z "$QUESTION" ]]; then
  echo "ERROR: question is empty." >&2
  exit 1
fi

TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
SLUG="$(slugify "$QUESTION")"
if [[ -z "$SLUG" ]]; then
  SLUG="debate"
fi

RUN_DIR="$ARTIFACT_ROOT/$TIMESTAMP-$SLUG"
mkdir -p "$RUN_DIR/prompts" "$RUN_DIR/rounds" "$RUN_DIR/logs"

printf '%s\n' "$QUESTION" >"$RUN_DIR/question.txt"

for round in 1 2 3; do
  codex_prompt="$RUN_DIR/prompts/codex-round-$round.txt"
  codex_out="$RUN_DIR/rounds/codex-round-$round.md"
  codex_log="$RUN_DIR/logs/codex-round-$round.log"

  if [[ "$round" -eq 1 ]]; then
    write_round_prompt \
      "Codex GPT-5.4 xhigh" \
      "Cursor Opus 4.6" \
      "$round" \
      /dev/null \
      /dev/null \
      "$codex_prompt"
  else
    write_round_prompt \
      "Codex GPT-5.4 xhigh" \
      "Cursor Opus 4.6" \
      "$round" \
      "$RUN_DIR/rounds/codex-round-$((round - 1)).md" \
      "$RUN_DIR/rounds/cursor-round-$((round - 1)).md" \
      "$codex_prompt"
  fi
  run_codex "$codex_prompt" "$codex_out" "$codex_log"

  cursor_prompt="$RUN_DIR/prompts/cursor-round-$round.txt"
  cursor_out="$RUN_DIR/rounds/cursor-round-$round.md"
  cursor_log="$RUN_DIR/logs/cursor-round-$round.log"

  if [[ "$round" -eq 1 ]]; then
    write_round_prompt \
      "Cursor Opus 4.6" \
      "Codex GPT-5.4 xhigh" \
      "$round" \
      /dev/null \
      /dev/null \
      "$cursor_prompt"
  else
    write_round_prompt \
      "Cursor Opus 4.6" \
      "Codex GPT-5.4 xhigh" \
      "$round" \
      "$RUN_DIR/rounds/cursor-round-$((round - 1)).md" \
      "$RUN_DIR/rounds/codex-round-$((round - 1)).md" \
      "$cursor_prompt"
  fi
  run_cursor "$cursor_prompt" "$cursor_out" "$cursor_log"
done

DIFF_PROMPT="$RUN_DIR/prompts/differences.txt"
DIFF_FILE="$RUN_DIR/differences.md"
DIFF_LOG="$RUN_DIR/logs/cursor-differences.log"
SUMMARY_FILE="$RUN_DIR/summary.md"

write_diff_prompt "$DIFF_PROMPT"
run_cursor "$DIFF_PROMPT" "$DIFF_FILE" "$DIFF_LOG"
write_summary "$SUMMARY_FILE" "$DIFF_FILE"

cat "$SUMMARY_FILE"
