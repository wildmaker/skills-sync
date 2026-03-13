#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  init_harness_repo_docs_skeleton.sh [repo_path] [--project "Project Name"]

Examples:
  init_harness_repo_docs_skeleton.sh
  init_harness_repo_docs_skeleton.sh /path/to/repo
  init_harness_repo_docs_skeleton.sh /path/to/repo --project "storypal"
EOF
}

repo_path="."
project_name=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --project)
      project_name="${2:-}"
      shift 2
      ;;
    *)
      repo_path="$1"
      shift
      ;;
  esac
done

repo_path="$(cd "$repo_path" && pwd)"
if [[ -z "$project_name" ]]; then
  project_name="$(basename "$repo_path")"
fi

mkdir -p "$repo_path"

create_file_if_missing() {
  local target="$1"
  local content="$2"
  if [[ -f "$target" ]]; then
    echo "[skip] $target already exists"
    return 0
  fi
  printf "%s" "$content" > "$target"
  echo "[create] $target"
}

mkdir -p "$repo_path/docs/design-docs"
mkdir -p "$repo_path/docs/exec-plans/active"
mkdir -p "$repo_path/docs/exec-plans/completed"
mkdir -p "$repo_path/docs/generated"
mkdir -p "$repo_path/docs/product-specs"
mkdir -p "$repo_path/docs/references"

agents_content=$(cat <<EOF
# AGENTS.md

This file is a map, not an encyclopedia.

## Mission
- Build and operate this repository with an agent-first workflow.
- Keep rules executable and close to the code.

## Navigation
- Architecture map: \`ARCHITECTURE.md\`
- Design principles: \`DESIGN.md\`
- Frontend conventions: \`FRONTEND.md\`
- Product intent: \`PRODUCT_SENSE.md\`
- Planning hub: \`PLANS.md\`
- Quality scoring: \`QUALITY_SCORE.md\`
- Reliability baseline: \`RELIABILITY.md\`
- Security baseline: \`SECURITY.md\`
- Domain design docs: \`docs/design-docs/\`
- Product specs: \`docs/product-specs/\`
- Active/complete plans: \`docs/exec-plans/\`

## Working model
1. Start from issue or plan.
2. Keep changes small and reviewable.
3. Update docs with code when behavior changes.
4. Prefer reusable tools over one-off instructions.

## Documentation rules
- \`docs/\` is the system of record.
- Keep AGENTS short and index-style.
- Move detail into topic documents under \`docs/\`.

## Maintenance loop
- Track debt in \`docs/exec-plans/tech-debt-tracker.md\`.
- Periodically prune stale docs and dead patterns.
EOF
)
create_file_if_missing "$repo_path/AGENTS.md" "$agents_content"

architecture_content=$(cat <<EOF
# ARCHITECTURE

## Purpose
Top-level architecture map for \`$project_name\`.

## Domains
- Define business domains and boundaries here.

## Layering
- Types -> Config -> Repo -> Service -> Runtime -> UI
- Cross-cutting concerns should enter through explicit providers/interfaces.

## Invariants
- Keep dependencies directional and testable.
- Enforce constraints with lint/tests when possible.
EOF
)
create_file_if_missing "$repo_path/ARCHITECTURE.md" "$architecture_content"

design_content=$(cat <<'EOF'
# DESIGN

## Core beliefs
- Optimize for agent readability.
- Prefer predictable abstractions over cleverness.
- Encode recurring judgment into tooling and checks.
EOF
)
create_file_if_missing "$repo_path/DESIGN.md" "$design_content"

frontend_content=$(cat <<'EOF'
# FRONTEND

## Scope
Define frontend architecture, UX constraints, and test strategy.
EOF
)
create_file_if_missing "$repo_path/FRONTEND.md" "$frontend_content"

plans_content=$(cat <<'EOF'
# PLANS

## Planning index
- Active plans: `docs/exec-plans/active/`
- Completed plans: `docs/exec-plans/completed/`
- Technical debt: `docs/exec-plans/tech-debt-tracker.md`
EOF
)
create_file_if_missing "$repo_path/PLANS.md" "$plans_content"

product_sense_content=$(cat <<'EOF'
# PRODUCT SENSE

## Product intent
Capture user value, non-goals, and acceptance criteria patterns.
EOF
)
create_file_if_missing "$repo_path/PRODUCT_SENSE.md" "$product_sense_content"

quality_content=$(cat <<'EOF'
# QUALITY SCORE

## Rubric
- Correctness
- Reliability
- Maintainability
- Observability
- Security
EOF
)
create_file_if_missing "$repo_path/QUALITY_SCORE.md" "$quality_content"

reliability_content=$(cat <<'EOF'
# RELIABILITY

## Baseline
- Define SLOs, startup budget, and critical journey latency budgets.
EOF
)
create_file_if_missing "$repo_path/RELIABILITY.md" "$reliability_content"

security_content=$(cat <<'EOF'
# SECURITY

## Baseline
- Threat model entry points
- Secret handling rules
- Dependency and CI security checks
EOF
)
create_file_if_missing "$repo_path/SECURITY.md" "$security_content"

design_index_content=$(cat <<'EOF'
# Design Docs Index

## Status
- Add docs and mark each as draft/validated/deprecated.
EOF
)
create_file_if_missing "$repo_path/docs/design-docs/index.md" "$design_index_content"

core_beliefs_content=$(cat <<'EOF'
# Core Beliefs

1. Humans steer; agents execute.
2. Repository is the source of truth.
3. Constraints and feedback loops beat manual policing.
EOF
)
create_file_if_missing "$repo_path/docs/design-docs/core-beliefs.md" "$core_beliefs_content"

product_specs_content=$(cat <<'EOF'
# Product Specs Index

List and link user-facing specifications.
EOF
)
create_file_if_missing "$repo_path/docs/product-specs/index.md" "$product_specs_content"

tech_debt_content=$(cat <<'EOF'
# Technical Debt Tracker

| ID | Area | Problem | Impact | Plan | Status |
|---|---|---|---|---|---|
EOF
)
create_file_if_missing "$repo_path/docs/exec-plans/tech-debt-tracker.md" "$tech_debt_content"

db_schema_content=$(cat <<'EOF'
# DB Schema

Generated or maintained schema summary for agent consumption.
EOF
)
create_file_if_missing "$repo_path/docs/generated/db-schema.md" "$db_schema_content"

echo ""
echo "[done] Harness repo docs skeleton bootstrap completed at: $repo_path"
