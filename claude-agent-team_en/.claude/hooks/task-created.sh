#!/bin/bash
# TaskCreated Hook
# Runs when a task is about to be created.
# Exit 0  → allow creation
# Exit 2  → reject creation, send STDOUT as feedback
#
# Task data is passed as JSON on stdin.

set -euo pipefail

# Read task JSON from stdin
TASK_JSON=$(cat)

# Require python3 for JSON parsing
if ! command -v python3 &>/dev/null; then
  exit 0  # Can't validate without python3 — allow through
fi

# Validate required fields
VALIDATION=$(python3 - <<'PYEOF'
import json, sys

data = json.loads(sys.stdin.read())

required_fields = ["title", "description", "type"]
valid_types = {"design", "implement", "fix", "test", "review", "deploy", "docs", "decision-required"}

errors = []
for field in required_fields:
    if not data.get(field, "").strip():
        errors.append(f"Missing required field: '{field}'")

task_type = data.get("type", "")
if task_type and task_type not in valid_types:
    errors.append(f"Invalid type '{task_type}'. Must be one of: {', '.join(sorted(valid_types))}")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF
echo "$TASK_JSON" | python3 - 2>&1)

EXIT_CODE=$?
if [[ $EXIT_CODE -ne 0 ]]; then
  echo "Task validation failed:"
  echo "$VALIDATION"
  echo ""
  echo "Required: title, description, type"
  echo "Valid types: design, implement, fix, test, review, deploy, docs, decision-required"
  exit 2
fi

exit 0
