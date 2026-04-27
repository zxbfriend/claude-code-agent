# Project Guide for Agent Teams

> This file is loaded automatically by every agent (lead + all teammates).
> Keep it up to date. Every teammate reads this on spawn — it is the single source of truth.

---

## 1. Project Context

<!-- CUSTOMIZE: Fill in your project details below -->
```
PROJECT_ID:     {your-project-id}          # e.g. ecommerce-api, crm-frontend
TECH_STACK:     {your-stack}               # e.g. Java 17 / Spring Boot 3 / React 18 / MySQL 8
REPO_URL:       {your-repo}
MAIN_BRANCH:    main
```
<!-- END CUSTOMIZE -->

---

## 2. How to Start the Agent Team

Tell the lead (pm-agent) what you need in natural language. Examples:

```
# New feature
Implement user authentication with JWT. Create an agent team.

# Bug fix
Users can't log in — getting 500 errors. Create a team to investigate.

# Refactor
Refactor the payment module to use the strategy pattern. Create an agent team.

# Performance
The order list API is slow (>3s). Create a team to diagnose and fix.
```

pm-agent will:
1. Classify the task type
2. Determine which agents are needed (dba-agent is optional, only if DB changes required)
3. Check if a human decision gate is needed (multiple valid approaches → pause for human)
4. Create the shared task list
5. Spawn the appropriate teammates

---

## 3. Agent Roles (Quick Reference)

| Agent | Role | When Used |
|---|---|---|
| **pm-agent** | Team lead, orchestrator | Always (lead) |
| **architect-agent** | API/data model design | New feature, refactor, major change |
| **backend-agent** | Server-side implementation | When backend changes needed |
| **frontend-agent** | UI/component implementation | When frontend changes needed |
| **dba-agent** | DB schema, migrations | **Optional** — only when DB schema changes |
| **devops-agent** | CI/CD, Docker, K8s | Deployment tasks |
| **qa-agent** | Testing, validation | All workflows |
| **reviewer-agent** | Code quality gate | All workflows |
| **security-agent** | Security audit | Security workflow, or on-demand |
| **doc-agent** | Documentation | Documentation workflow, or post-feature |

---

## 4. Output Artifact Convention

`pm-agent` must initialize and pass the shared context package from `.claude/config/VARIABLES.md` to every teammate before work starts. Teammates must not guess `OUTPUT_BASE`, `BRANCH`, `MODULE`, or derived artifact paths.

All agents MUST write output files to this path:

```
outputs/{TIMESTAMP}_{PROJECT_ID}/{STAGE}/{MODULE}_ARTIFACT.md
```

**Examples:**
```
outputs/20260426T143000_ecommerce-api/design/auth_TECH-SPEC.md
outputs/20260426T143000_ecommerce-api/test/auth_TEST-REPORT.md
outputs/20260426T143000_ecommerce-api/review/auth_REVIEW-REPORT.md
```

**Stage values:** `design` · `implement` · `test` · `review` · `deploy` · `docs`

Get the timestamp at task start with: `date -u +%Y%m%dT%H%M%S`

Each run creates a new timestamped folder — historical outputs are never overwritten.

---

## 5. Git Branch Convention

Every coding task (implement / fix / refactor) MUST:

1. Create a new branch before making any changes:
   ```bash
   git checkout -b {type}/{TASK-ID}
   # Examples:
   # feature/TASK-20260426-001
   # fix/TASK-20260426-002
   # refactor/TASK-20260426-003
   ```

2. Commit all changes when done (do NOT push):
   ```bash
   git add -A
   git commit -m "{type}({scope}): {summary}

   Task: {TASK-ID}
   Agent: {agent-name}"
   ```

3. Report the branch name in the delivery report.

Agents working on the same feature MUST work on the same branch (lead coordinates this).
Never commit directly to `main` or `master`.

---

## 6. Human Decision Gate Protocol

**Trigger conditions — architect-agent MUST pause for human confirmation when any condition applies:**
- Two or more technically valid approaches exist and cost, timeline, operational complexity, or risk differs by more than 20%
- DB migration includes data transformation, backfill, split/merge, or estimated work greater than 16 hours
- Architecture affects two or more layers, such as backend + dba + devops
- A new external dependency introduces cost, SLA, data residency, or breaking-change risk
- A security-relevant architectural decision needs to be made

Do not trigger a gate for standard CRUD, root-cause-clear bug fixes, or documentation-only work.

**Mechanism:**
1. architect-agent creates a `decision-required` task on the shared task list
2. All implementation tasks declare a dependency on this task
3. pm-agent detects the blocked state and presents options to the human
4. Human selects an option → pm-agent marks the decision task `completed` with the chosen path
5. Dependent tasks unblock automatically

**Decision output format:** See `.claude/templates/decision-gate.md`

---

## 7. Task List Format

Tasks on the shared list use this structure:

```json
{
  "id": "TASK-{YYYYMMDD}-{NNN}",
  "type": "design|implement|fix|test|review|deploy|docs|decision-required",
  "title": "Short task title",
  "description": "What needs to be done",
  "assignee": "agent-name or unassigned",
  "status": "pending|in_progress|completed",
  "depends_on": ["TASK-ID-1", "TASK-ID-2"],
  "file_domain": ["src/auth/", "tests/auth/"],
  "branch": "feature/TASK-20260426-001",
  "output_path": "outputs/{TS}_{PID}/design/auth_TECH-SPEC.md"
}
```

**File domain isolation is mandatory for concurrent tasks** — no two in-progress tasks may share the same `file_domain` entries.

All inter-agent messages must follow `.claude/messaging/PROTOCOL.md`.

---

## 8. Quality Gates (Non-Negotiable)

| Gate | Who | Condition |
|---|---|---|
| Design review | Human | When `decision-required` task exists |
| Test pass | qa-agent | All P0 tests must pass before review |
| Code review | reviewer-agent | Must pass before deploy |
| Security scan | security-agent | Required for auth/payment/data-access changes |
| No direct main commits | Hook | TaskCompleted hook rejects implementation on main |

---

## 9. Tech Constraints

```
# Customize for your project:
JAVA_VERSION:     17+
FRAMEWORK:        Spring Boot 3.x
ORM:              MyBatis-Plus 3.x
DB_MIGRATION:     Flyway
TEST_FRAMEWORK:   JUnit 5 + Mockito
FRONTEND:         React 18+ or Vue 3+
STYLE:            TailwindCSS
API_STYLE:        RESTful /api/v{n}/{resource}
DB_CHARSET:       utf8mb4
CONTAINER:        Docker + Kubernetes
```

---

## 10. Prohibited Actions (All Agents)

```
❌ Direct commits to main/master
❌ SELECT * queries
❌ Hardcoded secrets / credentials
❌ Swallowing exceptions without logging
❌ Writing output files outside outputs/ directory (except source code)
❌ Skipping the human decision gate when triggered
❌ db-agent making schema changes without Flyway migrations
```
