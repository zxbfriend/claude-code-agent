#!/bin/bash
# TeammateIdle Hook
# Runs when a teammate is about to go idle.
# Exit 0  → allow idle
# Exit 2  → send STDOUT as feedback and keep the teammate working
#
# Environment variables available (set by Claude Code):
#   CLAUDE_TEAMMATE_NAME  — name of the idle teammate
#   CLAUDE_TEAM_NAME      — name of the current team

set -euo pipefail

TEAM_NAME="${CLAUDE_TEAM_NAME:-}"
TEAMMATE="${CLAUDE_TEAMMATE_NAME:-unknown}"

# No team context — allow idle
if [[ -z "$TEAM_NAME" ]]; then
  exit 0
fi

TASK_DIR="${HOME}/.claude/tasks/${TEAM_NAME}"

# Count pending (unclaimed) tasks
PENDING=0
if [[ -d "$TASK_DIR" ]]; then
  if command -v jq >/dev/null 2>&1; then
    PENDING=$(find "$TASK_DIR" -maxdepth 1 -name "*.json" -print0 2>/dev/null \
      | xargs -0 jq -r 'select(.status == "pending") | .id // empty' 2>/dev/null \
      | wc -l || echo 0)
  else
    PENDING=$(find "$TASK_DIR" -maxdepth 1 -name "*.json" -print0 2>/dev/null \
      | xargs -0 grep -l '"status"[[:space:]]*:[[:space:]]*"pending"' 2>/dev/null \
      | wc -l || echo 0)
  fi
fi

if [[ "$PENDING" -gt 0 ]]; then
  echo "Teammate '${TEAMMATE}': there are ${PENDING} pending task(s) on the shared task list."
  echo "Please check the task list for work you can claim before going idle."
  exit 2
fi

# No pending tasks — safe to idle
exit 0
