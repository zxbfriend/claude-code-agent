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
- Context Package: `.claude/config/VARIABLES.md`
- Messaging Protocol: `.claude/messaging/PROTOCOL.md`
- Max Concurrent Agents: `4`

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
    "shared_file_mods": [],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/design/auth_TECH-SPEC.md",
    "context": {
      "task_id": "TASK-20260427-001",
      "output_base": "outputs/{TIMESTAMP}_{PROJECT_ID}",
      "module": "auth",
      "tech_spec_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/design/auth_TECH-SPEC.md"
    }
  }
]
```

## Shared File Rules

Shared files include `pom.xml`, `build.gradle`, `package.json`, lockfiles, `docker-compose.yml`, `k8s/*.yaml`, Helm charts, `.env.example`, `application.yml`, and `application.properties`.

If multiple tasks need the same shared file:

1. choose one owner task for the edit
2. list the intended edit in `shared_file_mods`
3. add `depends_on` edges so only one shared-file owner runs at a time

## Flyway Version Rules

`pm-agent` assigns `flyway_version` to every dba-agent migration task before it starts. dba-agent must use the assigned value and block if it is missing.

## Lead Checklist

- [ ] Team created
- [ ] First runnable task assigned
- [ ] At least one task is `in_progress`, or a blocker is recorded
- [ ] User informed of the real execution state
- [ ] Dependencies updated after each completion
