#!/bin/bash
# TaskCompleted Hook
# Runs when a task is about to be marked complete.
# Exit 0  → allow completion
# Exit 2  → prevent completion, send STDOUT as feedback
#
# Official Claude Code input (via stdin, JSON):
#   task_id          — system-assigned task identifier
#   task_subject     — task title / subject line
#   task_description — task description body
#   teammate_name    — name of the completing teammate
#   team_name        — name of the current team
#
# NOTE: The official input does NOT include a 'type' field.
# Branch protection heuristic: identify coding tasks by subject keywords,
# then fall back to reading TASK-LIST.md if available.

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  exit 0
fi

HOOK_JSON=$(cat)

# ── Parse official fields
TASK_SUBJECT=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('task_subject',''))" 2>/dev/null || echo "")
TASK_ID=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('task_id',''))" 2>/dev/null || echo "")

# ── Determine if this is a coding task
# Strategy 1: heuristic from task subject keywords
IS_CODING_TASK=0
LOWER_SUBJECT=$(echo "$TASK_SUBJECT" | tr '[:upper:]' '[:lower:]')
for kw in "implement" "fix" "refactor" "backend" "frontend" "migration" "migrate" "bugfix" "bug fix"; do
  if echo "$LOWER_SUBJECT" | grep -qF "$kw"; then
    IS_CODING_TASK=1
    break
  fi
done

# Strategy 2: if TASK-LIST.md is available, look up the task type by task_id
if [[ $IS_CODING_TASK -eq 0 && -n "$TASK_ID" ]]; then
  TASK_LIST=$(find outputs -maxdepth 3 -name "TASK-LIST.md" 2>/dev/null | sort -r | head -1 || true)
  if [[ -n "$TASK_LIST" && -f "$TASK_LIST" ]]; then
    # Look for the task_id followed by implement/fix/refactor type in the JSON block
    if grep -A5 "\"$TASK_ID\"" "$TASK_LIST" 2>/dev/null \
        | grep -qE '"type"[[:space:]]*:[[:space:]]*"(implement|fix|refactor)"'; then
      IS_CODING_TASK=1
    fi
  fi
fi

# ── Enforce feature branch rule only for coding tasks
if [[ $IS_CODING_TASK -eq 1 ]]; then

  if ! command -v git &>/dev/null; then
    exit 0
  fi

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

  if [[ -z "$CURRENT_BRANCH" ]]; then
    echo "ERROR: Could not determine current git branch."
    echo "Ensure the workspace is inside a git repository."
    exit 2
  fi

  if [[ "$CURRENT_BRANCH" == "HEAD" ]]; then
    echo "ERROR: Repository is in detached HEAD state."
    echo "Coding tasks must be completed on a named feature branch."
    echo ""
    echo "Solution: git checkout -b feature/TASK-{ID}"
    exit 2
  fi

  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    echo "ERROR: Task '${TASK_SUBJECT}' is completing on branch '$CURRENT_BRANCH'."
    echo "Direct commits to main/master are prohibited for coding tasks."
    echo ""
    echo "Solution:"
    echo "  git checkout -b feature/TASK-{ID}"
    echo "  git cherry-pick <your commits>   # if commits already exist"
    exit 2
  fi
fi

exit 0
