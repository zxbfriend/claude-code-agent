#!/bin/bash
# TaskCreated Hook
# Runs when a task is about to be created.
# Exit 0  → allow creation
# Exit 2  → reject creation; feedback written to stderr is returned to the model
#
# Official Claude Code input (via stdin, JSON):
#   task_id          — system-assigned task identifier
#   task_subject     — task title / subject line  (required)
#   task_description — task description body      (optional)
#   teammate_name    — name of the teammate creating this task (optional, may be absent)
#   team_name        — name of the current team                (optional)
#
# NOTE: teammate_name is the teammate who is *creating* the task, not the assignee.
# It is optional in the official spec; unassigned tasks are valid in Agent Teams.
# Assignee enforcement belongs in pm-agent's TASK-LIST.md self-check, not here.
#
# Complex schema fields (type, file_domain, flyway_version, etc.) are NOT present in
# this hook's input. They live in TASK-LIST.md and are validated by pm-agent self-check.

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

# task_subject must be non-empty
task_subject = data.get("task_subject", "")
if not isinstance(task_subject, str) or not task_subject.strip():
    errors.append("'task_subject' is empty — every task must have a non-empty subject/title.")

# task_id must be present (system-assigned; absence indicates an integration issue)
task_id = data.get("task_id", "")
if not isinstance(task_id, str) or not task_id.strip():
    errors.append("'task_id' is missing — this may indicate a hook integration issue.")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF
)
EXIT_CODE=$?
set -e

if [[ $EXIT_CODE -ne 0 ]]; then
  echo "Task creation validation failed:" >&2
  echo "$VALIDATION" >&2
  exit 2
fi

exit 0
