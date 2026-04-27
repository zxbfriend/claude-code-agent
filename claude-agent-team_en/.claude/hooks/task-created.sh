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
set +e
VALIDATION=$(TASK_JSON="$TASK_JSON" python3 - 2>&1 <<'PYEOF'
import json, os, sys

data = json.loads(os.environ.get("TASK_JSON", "{}"))

required_fields = ["id", "title", "description", "type", "assignee", "status", "depends_on", "file_domain", "branch", "output_path"]
valid_types = {"design", "implement", "fix", "test", "review", "deploy", "docs", "decision-required"}
valid_statuses = {"pending", "in_progress", "blocked", "completed"}

errors = []
for field in required_fields:
    value = data.get(field)
    if value is None or (isinstance(value, str) and not value.strip()):
        errors.append(f"Missing required field: '{field}'")

task_type = data.get("type", "")
if task_type and task_type not in valid_types:
    errors.append(f"Invalid type '{task_type}'. Must be one of: {', '.join(sorted(valid_types))}")

status = data.get("status", "")
if status and status not in valid_statuses:
    errors.append(f"Invalid status '{status}'. Must be one of: {', '.join(sorted(valid_statuses))}")

if not isinstance(data.get("depends_on"), list):
    errors.append("'depends_on' must be a JSON array")

file_domain = data.get("file_domain")
if not isinstance(file_domain, list) or not all(isinstance(item, str) and item.strip() for item in file_domain):
    errors.append("'file_domain' must be a non-empty JSON array of path strings")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF
)
EXIT_CODE=$?
set -e
if [[ $EXIT_CODE -ne 0 ]]; then
  echo "Task validation failed:"
  echo "$VALIDATION"
  echo ""
  echo "Required: id, title, description, type, assignee, status, depends_on, file_domain, branch, output_path"
  echo "Valid types: design, implement, fix, test, review, deploy, docs, decision-required"
  echo "Valid statuses: pending, in_progress, blocked, completed"
  exit 2
fi

exit 0
