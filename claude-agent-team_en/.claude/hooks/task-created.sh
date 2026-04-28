#!/bin/bash
# TaskCreated Hook
# Runs when a task is about to be created.
# Exit 0  → allow creation
# Exit 2  → reject creation, send STDOUT as feedback
#
# Official Claude Code input (via stdin, JSON):
#   task_id          — system-assigned task identifier
#   task_subject     — task title / subject line
#   task_description — task description body
#   teammate_name    — name of the teammate being assigned
#   team_name        — name of the current team
#
# NOTE: Complex task schema fields (type, assignee, file_domain, flyway_version, etc.)
# are NOT present in this hook input. Those fields live in the shared TASK-LIST.md and
# are validated by pm-agent's own self-check after writing the task list.
# This hook performs only lightweight checks available from official input fields.

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  exit 0
fi

HOOK_JSON=$(cat)

set +e
VALIDATION=$(HOOK_JSON="$HOOK_JSON" python3 - 2>&1 <<'PYEOF'
import json, os, sys

data = json.loads(os.environ.get("HOOK_JSON", "{}"))

errors = []

task_subject = data.get("task_subject", "")
if not isinstance(task_subject, str) or not task_subject.strip():
    errors.append("'task_subject' is empty — every task must have a non-empty subject/title.")

task_id = data.get("task_id", "")
if not isinstance(task_id, str) or not task_id.strip():
    errors.append("'task_id' is missing — this may indicate a hook integration issue.")

teammate_name = data.get("teammate_name", "")
if not isinstance(teammate_name, str) or not teammate_name.strip():
    errors.append("'teammate_name' is empty — every task must have an assigned teammate.")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF
)
EXIT_CODE=$?
set -e

if [[ $EXIT_CODE -ne 0 ]]; then
  echo "Task creation validation failed:"
  echo "$VALIDATION"
  echo ""
  echo "Note: Complex schema fields (type, file_domain, flyway_version, etc.) are"
  echo "validated by pm-agent's self-check after writing TASK-LIST.md, not in this hook."
  exit 2
fi

exit 0
