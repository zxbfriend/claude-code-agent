# Shared Task List

This file is created and maintained by `pm-agent`. It is the single source of truth for team execution.

---

## Rules

- Allowed statuses: `pending`, `in_progress`, `blocked`, `completed`
- Every task must have an explicit `assignee`
- The first runnable task must enter `in_progress` immediately unless a valid blocker is recorded
- If execution has not started, pm-agent must state the exact blocker in the Execution Snapshot

---

## Task Set Metadata

- **Task Set ID:** `TASK-{YYYYMMDD}-{NNN}`
- **Workflow Type:** `new-feature | bug-fix | refactor | change-request | performance | security-audit | dependency-upgrade | documentation`
- **Created At:** `{UTC timestamp}`
- **Created By:** `pm-agent`
- **Output Base:** `outputs/{TIMESTAMP}_{PROJECT_ID}/`
- **Branch:** `{feature|fix|refactor}/TASK-{YYYYMMDD}-{NNN}`
- **Context Package:** `.claude/config/VARIABLES.md`
- **Messaging Protocol:** `.claude/messaging/PROTOCOL.md`
- **Max Concurrent Agents:** `4`

---

## Execution Snapshot

- **Team status:** `planning_only | executing | blocked | completed`
- **Active task count:** `{N}`
- **In-progress tasks:** `{TASK-ID: assignee, ...}`
- **First runnable task:** `{TASK-ID or none}`
- **Blocker:** `{none | exact reason}`
- **Lead note:** `{current execution note}`

---

## Tasks

```json
[
  {
    "id": "TASK-20260427-001",
    "type": "design",
    "title": "Auth module API and data model design",
    "description": "Define API contract, auth approach, error codes, module boundaries, and implementation guidance for backend, frontend, and dba agents.",
    "assignee": "architect-agent",
    "status": "in_progress",
    "depends_on": [],
    "file_domain": [
      "outputs/{TIMESTAMP}_{PROJECT_ID}/design/"
    ],
    "shared_file_mods": [],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/design/auth_TECH-SPEC.md"
  },
  {
    "id": "TASK-20260427-002",
    "type": "implement",
    "title": "Backend: implement login and auth service",
    "description": "Implement AuthController, AuthService, AuthMapper per tech spec. Unit tests required.",
    "assignee": "backend-agent",
    "status": "pending",
    "depends_on": ["TASK-20260427-001"],
    "file_domain": [
      "src/main/java/com/example/auth/",
      "src/test/java/com/example/auth/"
    ],
    "shared_file_mods": ["pom.xml: add spring-security dependency"],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/implement/auth_backend-agent.md"
  },
  {
    "id": "TASK-20260427-003",
    "type": "implement",
    "title": "Frontend: implement login page and API integration",
    "description": "Implement LoginPage, auth API wrapper, useAuth hook per tech spec.",
    "assignee": "frontend-agent",
    "status": "pending",
    "depends_on": ["TASK-20260427-001"],
    "file_domain": [
      "src/frontend/src/pages/auth/",
      "src/frontend/src/api/"
    ],
    "shared_file_mods": [],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/implement/auth_frontend-agent.md"
  },
  {
    "id": "TASK-20260427-004",
    "type": "implement",
    "title": "DBA: create user and login_log tables",
    "description": "Write Flyway migration V4 for user table and V5 for login_log table per tech spec schema.",
    "assignee": "dba-agent",
    "status": "pending",
    "depends_on": ["TASK-20260427-001"],
    "file_domain": [
      "src/main/resources/db/migration/"
    ],
    "shared_file_mods": [],
    "flyway_version": 4,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/implement/auth_dba-agent.md"
  },
  {
    "id": "TASK-20260427-005",
    "type": "test",
    "title": "QA: validate auth feature",
    "description": "Run P0 and P1 test cases for login, lockout, and token validation flows. Report bugs through pm-agent.",
    "assignee": "qa-agent",
    "status": "pending",
    "depends_on": ["TASK-20260427-002", "TASK-20260427-003", "TASK-20260427-004"],
    "file_domain": [
      "outputs/{TIMESTAMP}_{PROJECT_ID}/test/"
    ],
    "shared_file_mods": [],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/test/auth_TEST-REPORT.md"
  },
  {
    "id": "TASK-20260427-006",
    "type": "review",
    "title": "Review: code quality and architecture compliance",
    "description": "Review backend and frontend implementation against tech spec. Check null safety, N+1, transaction boundaries, and security baseline.",
    "assignee": "reviewer-agent",
    "status": "pending",
    "depends_on": ["TASK-20260427-005"],
    "file_domain": [
      "outputs/{TIMESTAMP}_{PROJECT_ID}/review/"
    ],
    "shared_file_mods": [],
    "flyway_version": null,
    "branch": "feature/TASK-20260427-001",
    "output_path": "outputs/{TIMESTAMP}_{PROJECT_ID}/review/auth_REVIEW-REPORT.md"
  }
]
```

---

## Valid Task Types

| `type` value | Use when |
|---|---|
| `design` | architect-agent is producing a tech spec or decision gate document |
| `implement` | any agent is writing new feature code |
| `fix` | any agent is fixing a reported bug |
| `refactor` | any agent is restructuring code without changing external behavior |
| `test` | qa-agent is running test cases |
| `review` | reviewer-agent or security-agent is auditing |
| `deploy` | devops-agent is configuring CI/CD or infrastructure |
| `docs` | doc-agent is producing documentation |
| `decision-required` | work is paused pending a human architectural decision |

> **Workflow type ≠ task type.** A `refactor` workflow produces tasks with `type: refactor`. A `new-feature` workflow produces tasks with `type: design`, `implement`, `test`, `review`, etc.

---

## Shared File Ownership Rules

If multiple tasks need the same shared file:
1. Choose one owner task and list the edit in `shared_file_mods`
2. All other tasks that need the same file must `depends_on` the owner task
3. Never allow two `in_progress` tasks to share a shared file

**Shared files:** `pom.xml`, `build.gradle`, `package.json`, lockfiles, `docker-compose*.yml`, `k8s/*.yaml`, Helm charts, `.env.example`, `application.yml`, `application.properties`

---

## Flyway Version Assignment

pm-agent assigns `flyway_version` to every dba-agent task before it starts. Values must be unique, positive integers, and checked against existing migrations in `src/main/resources/db/migration/`.

dba-agent must send `BLOCKED` if `flyway_version` is missing — it must never auto-assign.

---

## Lead Checklist

- [ ] Placeholder guard passed (no `{your-` in CLAUDE.md)
- [ ] Team created
- [ ] Task list self-check passed (all types valid, no missing flyway_version, no file_domain overlap)
- [ ] First runnable task assigned and `in_progress`
- [ ] Concurrent agent count ≤ 4
- [ ] Dependencies correctly set (no circular deps)
- [ ] Shared file ownership serialized
- [ ] All dba-agent implement/fix tasks have `flyway_version` assigned
- [ ] User informed of real execution state
