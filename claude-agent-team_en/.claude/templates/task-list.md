# Shared Task List Template

This file is created and maintained by `pm-agent`. It is the single source of truth for team execution.

## Rules

- Allowed statuses: `pending`, `in_progress`, `blocked`, `completed`
- Every task must have an explicit `assignee`
- The first runnable task should enter `in_progress` immediately unless a blocker is recorded
- If execution has not started, `pm-agent` must state the blocker clearly

## Task Set Metadata

- Task Set ID: `TASK-{YYYYMMDD}-{NNN}`
- Workflow Type: `{new-feature | bug-fix | refactor | change-request | performance | security | upgrade | docs}`
- Created At: `{timestamp}`
- Created By: `pm-agent`
- Output Base: `outputs/{TIMESTAMP}_{PROJECT_ID}/`
- Branch: `{feature/fix/refactor}/TASK-{YYYYMMDD}-{NNN}`

## Execution Snapshot

- Team status: `{planning_only | executing | blocked | completed}`
- Active task count: `{N}`
- First runnable task: `{TASK-ID or none}`
- Blocker: `{none or exact reason}`
- Lead note: `{current execution note}`

## Tasks

```json
[
  {
    "id": "TASK-20260427-001",
    "type": "design",
    "title": "Login API and authentication design",
    "description": "Define API contract, auth approach, error codes, module boundaries, and implementation guidance.",
    "assignee": "architect-agent",
    "status": "in_progress",
    "depends_on": [],
    "file_domain": [
      "outputs/{TIMESTAMP}_{PROJECT_ID}/design/"
    ],
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/design/auth_TECH-SPEC.md"
  }
]
```

## Lead Checklist

- [ ] Team created
- [ ] First runnable task assigned
- [ ] At least one task is `in_progress`, or a blocker is recorded
- [ ] User informed of the real execution state
- [ ] Dependencies updated after each completion

