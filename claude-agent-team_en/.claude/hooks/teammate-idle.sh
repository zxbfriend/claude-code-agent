#!/bin/bash
# TeammateIdle Hook
# Runs when a teammate is about to go idle.
# Exit 0  → allow idle
# Exit 2  → send STDOUT as feedback and keep the teammate working
#
# Official Claude Code input (via stdin, JSON):
#   teammate_name  — name of the idle teammate
#   team_name      — name of the current team
#
# NOTE: Input arrives via stdin JSON, NOT as environment variables.

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  exit 0
fi

HOOK_JSON=$(cat)

TEAMMATE=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; print(json.load(sys.stdin).get('teammate_name','unknown'))" 2>/dev/null || echo "unknown")
TEAM_NAME=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; print(json.load(sys.stdin).get('team_name',''))" 2>/dev/null || echo "")

# No team context — allow idle
if [[ -z "$TEAM_NAME" ]]; then
  exit 0
fi

PENDING=0

# ── Strategy 1: Claude Code internal task store (~/.claude/tasks/{team})
TASK_DIR="${HOME}/.claude/tasks/${TEAM_NAME}"
if [[ -d "$TASK_DIR" ]]; then
  if command -v jq >/dev/null 2>&1; then
    PENDING=$(find "$TASK_DIR" -maxdepth 1 -name "*.json" -print0 2>/dev/null \
      | xargs -0 jq -r 'select(.status == "pending") | .id // empty' 2>/dev/null \
      | wc -l | tr -d ' ' || echo 0)
  else
    PENDING=$(find "$TASK_DIR" -maxdepth 1 -name "*.json" -print0 2>/dev/null \
      | xargs -0 python3 -c "
import json, sys
count = 0
for path in sys.argv[1:]:
    try:
        with open(path) as f:
            d = json.load(f)
        if d.get('status') == 'pending':
            count += 1
    except Exception:
        pass
print(count)
" 2>/dev/null || echo 0)
  fi
fi

# ── Strategy 2: scan latest TASK-LIST.md in outputs/
if [[ "$PENDING" -eq 0 && -d "outputs" ]]; then
  LATEST_TASK_LIST=$(find outputs -maxdepth 3 -name "TASK-LIST.md" 2>/dev/null \
    | sort -r | head -1 || true)
  if [[ -n "$LATEST_TASK_LIST" && -f "$LATEST_TASK_LIST" ]]; then
    PENDING=$(grep -c '"status".*"pending"' "$LATEST_TASK_LIST" 2>/dev/null || echo 0)
  fi
fi

if [[ "$PENDING" -gt 0 ]]; then
  echo "Teammate '${TEAMMATE}': ${PENDING} pending task(s) remain on the shared task list."
  echo "Check the task list for work you can claim before going idle."
  exit 2
fi

exit 0
