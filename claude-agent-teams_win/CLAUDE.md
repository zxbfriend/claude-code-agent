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

> **Before running any agent team**, verify placeholders are filled:
> ```bash
> grep -E "\{your-" CLAUDE.md && echo "ERROR: unfilled placeholders found — fill them before proceeding" && exit 1 || echo "OK"
> ```
> If this prints ERROR, stop and update the fields above.

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
3. Pre-check if a human decision gate may be needed; architect-agent makes the final gate decision during design
4. Create the shared task list
5. Spawn the appropriate teammates

### New Project Setup (no git repository yet)

If the project directory has no `.git` folder, pm-agent will detect this in Step 1 and ask
you to confirm one of the following before proceeding:

```
# Option A — you have already created a remote repository
This is a new project. Clone it from https://github.com/yourorg/yourproject,
then implement user authentication.

# Option B — brand-new project, nothing exists yet
This is a brand-new project with no git repository.
Initialize it locally, then implement user authentication.
```

pm-agent will create an `init` task first, set up the repository, and then proceed with the
normal workflow. For Option B, you will be prompted to create a remote repository and add
the remote manually — pm-agent does not push to remotes automatically.

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

## 4. File Layout

```
your-project/
├── CLAUDE.md                        ← Project guide (read by every agent)
└── .claude/
    ├── settings.json                ← Project-level shared settings (Agent Teams + hooks + permissions)
    ├── config/
    │   └── VARIABLES.md             ← Context variable definitions
    ├── messaging/
    │   └── PROTOCOL.md              ← Inter-agent message formats
    ├── hooks/
    │   ├── teammate-idle.sh         ← Prevents idle when claimable tasks exist
    │   ├── task-created.sh          ← Validates task subject and id on creation
    │   └── task-completed.sh        ← Blocks direct commits to main/master
    ├── agents/
    │   └── *.md                     ← Agent definitions
    ├── workflows/
    │   └── *.md                     ← Workflow step guides
    └── templates/
        └── *.md                     ← Output document templates
```

---

## 5. Output Artifact Convention

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

## 6. Git Branch Convention

Every coding task (implement / fix / refactor) MUST:

1. Create a new branch before making any changes:
   ```bash
   git checkout -b {type}/{TASK-ID}
   # Examples:
   # feature/TASK-20260426-001
   # fix/TASK-20260426-002
   # refactor/TASK-20260426-003
   ```

2. Sync the branch before starting work:
   ```bash
   git fetch origin
   git pull origin "${BRANCH}"
   # If a merge conflict occurs → send BLOCKED to pm-agent immediately.
   # Do NOT attempt to resolve conflicts manually.
   ```

3. Commit all changes when done (do NOT push):
   ```bash
   git add -A
   git commit -m "{type}({scope}): {summary}

   Task: {TASK-ID}
   Agent: {agent-name}"
   ```

4. Report the branch name in the delivery report.

Agents working on the same feature MUST work on the same branch (lead coordinates this).
Never commit directly to `main` or `master`.

### New Project Repository Setup

When no `.git` directory exists, pm-agent handles repository initialization as an `init` task
**before** any other task starts. Two scenarios:

| Scenario | Action |
|---|---|
| Remote repo exists (REPO_URL provided) | `git clone {REPO_URL} .` |
| Brand-new local project | `git init` → initial commit of `CLAUDE.md` and `.claude/` → prompt user to add remote |

After the `init` task completes, all subsequent tasks follow the normal branch convention above.
Pushing to remotes always requires human action — agents never run `git push`.

---

## 7. Human Decision Gate Protocol

**Trigger conditions — architect-agent MUST pause for human confirmation when any condition applies:**
- Two or more technically valid approaches exist and cost, timeline, operational complexity, or risk differs by more than 20%
- DB migration includes data transformation, backfill, split/merge, or estimated work greater than 16 hours
- A new external dependency introduces cost, SLA, data residency, or breaking-change risk (e.g. Redis cluster, payment provider, auth provider)
- A security-relevant architectural decision must be made

Do not trigger a gate for: standard CRUD features, root-cause-clear bug fixes, documentation-only work, or adding new endpoints that follow established patterns.

**Decision Gate + Plan Review ordering:**
1. If architect finds multiple options during design → send `DECISION-REQUIRED` to pm-agent **first**
2. Wait for human decision
3. Resume design with the chosen option
4. If plan review is also required → send `ARCH-PLAN-REVIEW`
5. Wait for `ARCH-PLAN-APPROVED`
6. Write the final tech spec

Never send `ARCH-PLAN-REVIEW` before a pending `DECISION-REQUIRED` is resolved.

**Decision output format:** See `.claude/templates/decision-gate.md`

## 7.1 Plan Approval Protocol

architect-agent must request plan approval before writing the final tech spec **only when** one or more of these apply:
- A new external dependency is introduced (Redis, MQ, object storage, payment provider, auth provider)
- An existing API contract changes in a breaking way (field removal, type change, removed endpoint)
- A security boundary changes (new auth mechanism, new PII handling path)
- A DB migration involves data transformation, backfill, or table split/merge
- Deployment topology changes (new service, new infrastructure component)

Standard cases that do **not** require plan approval:
- Standard CRUD feature (even if it touches backend + frontend + dba)
- Adding new non-breaking API fields or endpoints following existing patterns
- Bug fixes
- Documentation

Message formats: `ARCH-PLAN-REVIEW` and `ARCH-PLAN-APPROVED` in `.claude/messaging/PROTOCOL.md`.

---

## 8. Task List Format

Tasks on the shared list use this structure:

```json
{
  "id": "TASK-{YYYYMMDD}-{NNN}",
  "type": "init|design|implement|fix|refactor|test|review|deploy|docs|decision-required",
  "title": "Short task title",
  "description": "What needs to be done",
  "assignee": "agent-name or unassigned",
  "status": "pending|in_progress|blocked|completed",
  "depends_on": ["TASK-ID-1", "TASK-ID-2"],
  "file_domain": ["src/auth/", "tests/auth/"],
  "shared_file_mods": ["pom.xml: add redis dependency"],
  "flyway_version": 4,
  "branch": "feature/TASK-20260426-001",
  "output_path": "outputs/{TS}_{PID}/design/auth_TECH-SPEC.md"
}
```

**File domain isolation is mandatory for concurrent tasks** — no two in-progress tasks may share the same `file_domain` entries.

All inter-agent messages must follow `.claude/messaging/PROTOCOL.md`.

Shared file edits must be serialized. If multiple agents need the same shared file, pm-agent chooses one owner and adds `depends_on` edges for all other tasks.

Flyway versions are allocated by pm-agent in the task list. dba-agent must use the assigned `flyway_version` and must send `BLOCKED` if it is missing.

> **Workflow type ≠ task type.** The workflow (new-feature, bug-fix, refactor, …) is the routing label pm-agent uses to select the correct `.claude/workflows/*.md` file. The task `type` field is the per-task action label stored in the task list JSON. Example: a `refactor` workflow produces tasks with `type: refactor`; a `new-feature` workflow produces tasks with `type: design`, `implement`, `test`, `review`, etc.

---

## 9. Quality Gates (Non-Negotiable)

| Gate | Who | Condition |
|---|---|---|
| Design review | Human | When `decision-required` task exists |
| Test pass | qa-agent | All P0 tests must pass before review |
| Code review | reviewer-agent | Must pass before deploy |
| Security scan | security-agent | Required for auth/payment/data-access changes |
| No direct main commits | Hook | TaskCompleted hook rejects implementation and documentation tasks on main |

---

## 10. Tech Constraints

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

## 11. Prohibited Actions (All Agents)

```
❌ Direct commits to main/master
❌ SELECT * queries
❌ Hardcoded secrets / credentials
❌ Swallowing exceptions without logging
❌ Writing output files outside outputs/ directory (except source code)
❌ Skipping the human decision gate when triggered
❌ dba-agent making schema changes without Flyway migrations
❌ Sending ARCH-PLAN-REVIEW while a DECISION-REQUIRED is still open
```

---

## 12. Operational Limits

```yaml
MAX_CONCURRENT_AGENTS: 4   # pm-agent enforces this during task activation
TASK_TIMEOUTS:
  design:    4h
  implement: 8h
  fix:       8h
  refactor:  8h
  test:      4h
  review:    2h
  security:  2h
  deploy:    4h
  docs:      4h
```

Rollback policy:
- Prefer forward fixes and `git revert`.
- Do not use destructive reset/delete/drop operations without explicit human approval.
- For Flyway mistakes, create a new corrective migration rather than editing an already applied migration.