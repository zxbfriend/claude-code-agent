#!/bin/bash
# TaskCompleted Hook
# Runs when a task is about to be marked complete.
# Exit 0  → allow completion
# Exit 2  → prevent completion, send STDOUT as feedback
#
# Task data is passed as JSON on stdin.

set -euo pipefail

TASK_JSON=$(cat)

# Parse task type
TASK_TYPE=$(echo "$TASK_JSON" | python3 -c "import json,sys; print(json.load(sys.stdin).get('type',''))" 2>/dev/null || echo "")

# For implement/fix/refactor tasks, verify they were done on a feature branch (not main/master)
if [[ "$TASK_TYPE" =~ ^(implement|fix|refactor)$ ]]; then
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
  
  if [[ -z "$CURRENT_BRANCH" ]]; then
    echo "ERROR: Could not determine current git branch."
    echo "Implementation tasks must be completed on a feature branch (not detached HEAD)."
    exit 2
  fi
  
  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    echo "ERROR: Attempting to complete implementation task on branch '$CURRENT_BRANCH'."
    echo "Feature branches are required to prevent direct commits to main/master."
    echo ""
    echo "Solution: Create and work on a feature branch:"
    echo "  git checkout -b feature/TASK-{ID}"
    exit 2
  fi
fi

exit 0
