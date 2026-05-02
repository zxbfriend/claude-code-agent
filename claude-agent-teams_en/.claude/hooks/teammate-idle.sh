#!/bin/bash
# TeammateIdle Hook
# Runs when a teammate is about to go idle.
# Exit 0  → allow idle
# Exit 2  → prevent idle; feedback written to stderr is returned to the teammate
#
# Official Claude Code input (via stdin, JSON):
#   teammate_name  — name of the idle teammate
#   team_name      — name of the current team
#
# A task is "claimable" by this teammate only when ALL of:
#   1. status == "pending"  (not blocked, in_progress, or completed)
#   2. assignee == teammate_name  OR  assignee is unassigned/empty
#   3. all task IDs listed in depends_on are completed in the same task list

set -euo pipefail

if ! command -v python3 &>/dev/null; then
  exit 0
fi

HOOK_JSON=$(cat)

TEAMMATE=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; print(json.load(sys.stdin).get('teammate_name',''))" 2>/dev/null || echo "")
TEAM_NAME=$(echo "$HOOK_JSON" | python3 -c \
  "import json,sys; print(json.load(sys.stdin).get('team_name',''))" 2>/dev/null || echo "")

# No team or teammate context — allow idle
if [[ -z "$TEAM_NAME" || -z "$TEAMMATE" ]]; then
  exit 0
fi

# ── Find the latest TASK-LIST.md produced by pm-agent
TASK_LIST=""
if [[ -d "outputs" ]]; then
  TASK_LIST=$(find outputs -maxdepth 3 -name "TASK-LIST.md" 2>/dev/null \
    | sort -r | head -1 || true)
fi

if [[ -z "$TASK_LIST" || ! -f "$TASK_LIST" ]]; then
  # No task list found — cannot determine claimable tasks, allow idle
  exit 0
fi

# ── Count claimable tasks for this specific teammate
CLAIMABLE=$(TASK_LIST="$TASK_LIST" TEAMMATE="$TEAMMATE" python3 - 2>/dev/null <<'PYEOF'
import json, os, re, sys

task_list_path = os.environ.get("TASK_LIST", "")
teammate = os.environ.get("TEAMMATE", "")

try:
    with open(task_list_path) as f:
        content = f.read()
except Exception:
    print(0)
    sys.exit(0)

# Extract the largest JSON array from a ```json ... ``` code fence
blocks = re.findall(r'```json\s*(\[.*?\])\s*```', content, re.DOTALL)
if not blocks:
    print(0)
    sys.exit(0)

tasks = []
for block in blocks:
    try:
        parsed = json.loads(block)
        if isinstance(parsed, list) and len(parsed) > len(tasks):
            tasks = parsed
    except Exception:
        continue

if not tasks:
    print(0)
    sys.exit(0)

# Build a set of completed task IDs for dependency checking
completed_ids = {t.get("id") for t in tasks if t.get("status") == "completed"}

claimable = 0
for task in tasks:
    status   = task.get("status", "")
    assignee = task.get("assignee", "")
    depends_on = task.get("depends_on", [])

    # Must be pending (not blocked, in_progress, or completed)
    if status != "pending":
        continue

    # Must be assigned to this teammate or genuinely unassigned
    if assignee and assignee not in (teammate, "unassigned", ""):
        continue

    # All dependencies must be completed
    if not all(dep in completed_ids for dep in depends_on):
        continue

    claimable += 1

print(claimable)
PYEOF
)

CLAIMABLE="${CLAIMABLE:-0}"

if [[ "$CLAIMABLE" -gt 0 ]]; then
  echo "Teammate '${TEAMMATE}': ${CLAIMABLE} claimable task(s) available in the task list." >&2
  echo "Check TASK-LIST.md for tasks assigned to you or unassigned tasks whose dependencies are complete." >&2
  exit 2
fi

exit 0
