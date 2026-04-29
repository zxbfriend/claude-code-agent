#!/bin/bash
# TaskCompleted Hook
# Runs when a task is about to be marked complete.
# Exit 0  → allow completion
# Exit 2  → prevent completion; feedback written to stderr is returned to the model
#
# Official Claude Code input (via stdin, JSON):
#   task_id          — system-assigned task identifier (NOT the custom TASK-YYYYMMDD-NNN)
#   task_subject     — task title / subject line
#   task_description — task description body
#   teammate_name    — name of the teammate completing the task (optional)
#   team_name        — name of the current team
#
# Branch protection strategy:
# The official task_id is a system ID that does not match the custom TASK-YYYYMMDD-NNN
# IDs in TASK-LIST.md, so TASK-LIST lookup is unreliable and is NOT used.
#
# A coding task is identified when ANY of these is true:
#   A) teammate_name is a known coding agent
#      (backend-agent, frontend-agent, dba-agent, devops-agent, doc-agent)
#   B) task_subject contains coding-task keywords (broad list covering all layers)
#
# doc-agent is included because documentation workflow requires commits to a feature
# branch, consistent with the project-wide "no direct commits to main/master" rule.

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  exit 0
fi

HOOK_JSON=$(cat)

TASK_SUBJECT=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('task_subject',''))" 2>/dev/null || echo "")
TEAMMATE_NAME=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('teammate_name',''))" 2>/dev/null || echo "")

# ── Determine if this is a coding task
IS_CODING_TASK=0

# Strategy A: teammate is a known coding agent (most reliable)
# doc-agent is included: documentation workflow requires feature branch commits
CODING_AGENTS="backend-agent frontend-agent dba-agent devops-agent doc-agent"
for agent in $CODING_AGENTS; do
  if [[ "$TEAMMATE_NAME" == "$agent" ]]; then
    IS_CODING_TASK=1
    break
  fi
done

# Strategy B: subject keyword heuristic (catches cases where teammate_name is absent/generic)
if [[ $IS_CODING_TASK -eq 0 ]]; then
  LOWER_SUBJECT=$(echo "$TASK_SUBJECT" | tr '[:upper:]' '[:lower:]')
  CODING_KEYWORDS=(
    "implement" "fix" "refactor" "migrate" "migration"
    "backend" "frontend" "dba" "database" "schema"
    "table" "column" "index" "flyway" "sql" "ddl"
    "bugfix" "bug fix" "hotfix" "patch"
    "controller" "service" "repository" "api" "endpoint"
    "component" "page" "hook" "store" "reducer"
    "docs" "documentation" "readme" "changelog" "api doc"
  )
  for kw in "${CODING_KEYWORDS[@]}"; do
    if echo "$LOWER_SUBJECT" | grep -qE "$kw"; then
      IS_CODING_TASK=1
      break
    fi
  done
fi

# ── Enforce feature branch rule for coding tasks
if [[ $IS_CODING_TASK -eq 1 ]]; then

  if ! command -v git &>/dev/null; then
    exit 0
  fi

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

  if [[ -z "$CURRENT_BRANCH" ]]; then
    echo "ERROR: Could not determine current git branch." >&2
    echo "Possible causes:" >&2
    echo "  1. No git repository found in the current directory." >&2
    echo "     → New project: notify pm-agent to run 'git init' or 'git clone' before starting coding tasks." >&2
    echo "  2. The workspace is in an unexpected git state." >&2
    echo "Notify pm-agent with a BLOCKED message and wait for resolution." >&2
    exit 2
  fi

  if [[ "$CURRENT_BRANCH" == "HEAD" ]]; then
    echo "ERROR: Repository is in detached HEAD state." >&2
    echo "Coding tasks must be completed on a named feature branch." >&2
    echo "" >&2
    echo "Solution: git checkout -b feature/TASK-{ID}" >&2
    exit 2
  fi

  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    echo "ERROR: Task '${TASK_SUBJECT}' (${TEAMMATE_NAME}) is completing on branch '$CURRENT_BRANCH'." >&2
    echo "Direct commits to main/master are prohibited for all coding and documentation tasks." >&2
    echo "" >&2
    echo "Solution:" >&2
    echo "  git checkout -b feature/TASK-{ID}" >&2
    echo "  git cherry-pick <your commits>   # if commits already exist on main" >&2
    exit 2
  fi
fi

exit 0