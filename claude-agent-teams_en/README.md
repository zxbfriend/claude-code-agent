# Claude Code Agent Teams — Universal Software Development System

> Fully aligned with the official Claude Code Agent Teams specification.
> Autonomous planning, task-driven execution, multi-agent collaboration.

---

## System Overview

```
User request (natural language)
    ↓
pm-agent  (lead session)
    ├─ Validates project setup (placeholder guard)
    ├─ Classifies task type
    ├─ Performs preliminary decision gate check
    ├─ Assembles agent team
    ├─ Creates shared task list
    └─ Starts first task immediately
    ↓
Agent team (parallel collaboration)
    ├─ architect-agent     technical design (optional)
    ├─ backend-agent       server implementation
    ├─ frontend-agent      UI implementation
    ├─ dba-agent           database migrations (optional)
    ├─ devops-agent        CI/CD and containers (optional)
    ├─ doc-agent           documentation (optional)
    ├─ qa-agent            test validation
    ├─ reviewer-agent      code review
    └─ security-agent      security audit (optional)
    ↓
Validation and delivery
    ├─ Artifacts in outputs/{TIMESTAMP}_{PROJECT_ID}/
    ├─ Code committed to feature branch
    └─ pm-agent writes DELIVERY-REPORT.md
```

---

## File Layout

```
your-project/
├── CLAUDE.md                        ← Project guide (every agent reads this on spawn)
└── .claude/
    ├── settings.json                ← Project-level shared settings (Agent Teams + hooks + permissions)
    ├── config/
    │   └── VARIABLES.md             ← Context variable definitions and path conventions
    ├── messaging/
    │   └── PROTOCOL.md              ← Inter-agent message formats
    ├── hooks/
    │   ├── teammate-idle.sh         ← Blocks idle when claimable tasks exist
    │   ├── task-created.sh          ← Validates task subject and id on creation
    │   └── task-completed.sh        ← Blocks direct commits to main/master
    ├── agents/
    │   ├── pm-agent.md
    │   ├── architect-agent.md
    │   ├── backend-agent.md
    │   ├── frontend-agent.md
    │   ├── dba-agent.md
    │   ├── devops-agent.md
    │   ├── qa-agent.md
    │   ├── reviewer-agent.md
    │   ├── security-agent.md
    │   └── doc-agent.md
    ├── workflows/
    │   ├── new-feature.md
    │   ├── bug-fix.md
    │   ├── refactor.md
    │   ├── change-request.md
    │   ├── performance.md
    │   ├── security-audit.md
    │   ├── dependency-upgrade.md
    │   └── documentation.md
    └── templates/
        ├── tech-spec.md
        ├── decision-gate.md
        ├── task-list.md
        ├── test-report.md
        └── review-report.md
```

---

## Prerequisites

| Requirement | Details |
|---|---|
| **Claude Code** | Latest version with Agent Teams support (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set automatically by `.claude/settings.json`) |
| **Bash** | The three hook scripts require Bash to run. See platform notes below. |
| **Python 3** | Required by all hooks for JSON parsing. Verify: `python3 --version` |
| **Git** | Required by `TaskCompleted` for branch protection. Verify: `git --version` |

### Platform Notes

**macOS / Linux:** Bash and Python 3 are available by default. No extra setup needed.

**Windows:** The hook commands use `bash`. Native `cmd.exe` or PowerShell will not work. Choose one of:

- **WSL (recommended):** Run Claude Code inside a WSL terminal. All hooks work without modification.
- **Git Bash:** Install [Git for Windows](https://git-scm.com/download/win) and run Claude Code from the Git Bash terminal. Verify `bash --version` and `python3 --version` are both accessible.
- **Skip hooks:** If you cannot use Bash, remove the `hooks` block from `.claude/settings.json`. The agent team will still function; you lose the idle-prevention and branch-protection safety nets.

---

## Quick Start

### 1. Copy files to your project

```bash
cp -r agent-teams/.claude  ./your-project/
cp agent-teams/CLAUDE.md   ./your-project/
```

### 2. Fill in CLAUDE.md

Open `CLAUDE.md` and replace the four placeholders:

```
PROJECT_ID:   your-actual-project-id     # e.g. ecommerce-api
TECH_STACK:   Java 17 / Spring Boot 3 / React 18 / MySQL 8
REPO_URL:     https://github.com/yourorg/yourproject
MAIN_BRANCH:  main
```

Verify no placeholders remain:

```bash
grep -E "\{your-" CLAUDE.md && echo "UNFILLED" || echo "OK"
```

### 3. Start an agent team

Open Claude Code and say:

```
Implement user authentication with JWT. Create an agent team.
```

pm-agent will validate the project setup, classify the task, assemble the team, and start the first task immediately.

---

## 8 Task Types

| Task type | Trigger keywords | Workflow file |
|---|---|---|
| new-feature | new / add / implement / create | `.claude/workflows/new-feature.md` |
| bug-fix | bug / error / crash / broken / 500 | `.claude/workflows/bug-fix.md` |
| refactor | refactor / migrate / tech debt | `.claude/workflows/refactor.md` |
| change-request | change / adjust / modify | `.claude/workflows/change-request.md` |
| performance | slow / timeout / latency / OOM | `.claude/workflows/performance.md` |
| security-audit | security / CVE / OWASP / audit | `.claude/workflows/security-audit.md` |
| dependency-upgrade | upgrade / update / version bump | `.claude/workflows/dependency-upgrade.md` |
| documentation | docs / README / API docs | `.claude/workflows/documentation.md` |

---

## Decision Gate Mechanism

When architect-agent finds multiple valid technical options that differ significantly in cost, risk, or complexity, work pauses for a human decision.

**Triggers:**
- Two or more approaches differ by >20% in cost, timeline, risk, or operational complexity
- New external dependency introduced (Redis, MQ, payment provider, auth provider, object storage)
- DB migration requires data transformation, backfill, or split/merge
- Security-relevant architectural choice (new auth mechanism, new PII path)

**Does not trigger for:**
- Standard CRUD features
- Bug fixes with a clear root cause
- Adding endpoints that follow existing codebase patterns
- Documentation

**Flow:**
```
architect-agent detects multiple options
    ↓
Writes DECISION-GATE.md (options, comparison, recommendation)
    ↓
Sends DECISION-REQUIRED to pm-agent
    ↓
pm-agent presents decision document to human
    ↓
Human selects option
    ↓
pm-agent marks decision completed
    ↓
Dependent tasks unblock and start automatically
```

---

## Plan Approval Protocol

architect-agent sends `ARCH-PLAN-REVIEW` only for high-impact changes:

| Requires approval | Does NOT require approval |
|---|---|
| New external dependency (Redis, MQ, etc.) | Standard CRUD feature |
| Breaking API contract change | Adding non-breaking API fields |
| Security boundary change | Bug fixes |
| DB migration with data transformation | New endpoints following existing patterns |
| Deployment topology change | Documentation |

This prevents the team from stalling on plan approval for routine features.

---

## Quality Gates

```
① architect-agent — design correctness (for non-trivial features)
        ↓
② backend / frontend / dba — implementation
        ↓
③ qa-agent — P0 + P1 tests must pass
        ↓
④ reviewer-agent — code quality, architecture compliance, security baseline
        ↓
⑤ security-agent (optional) — OWASP Top 10, CVE scan
        ↓
✅ Delivery approved
```

---

## Hook Summary

| Hook | File | Purpose |
|---|---|---|
| TaskCreated | `.claude/hooks/task-created.sh` | Validates `task_subject` (non-empty) and `task_id` (present); `teammate_name` intentionally not enforced (unassigned tasks are valid) |
| TaskCompleted | `.claude/hooks/task-completed.sh` | Identifies coding/documentation tasks by teammate name (backend-agent/frontend-agent/dba-agent/devops-agent/doc-agent) or subject keywords; blocks completion on main/master |
| TeammateIdle | `.claude/hooks/teammate-idle.sh` | Reads stdin JSON for teammate_name; counts only claimable tasks (assignee match + all deps completed + not blocked) |

---

## Operational Limits

```yaml
MAX_CONCURRENT_AGENTS: 4
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

---

## Output Artifact Layout

```
outputs/
└── {TIMESTAMP}_{PROJECT_ID}/
    ├── design/
    │   ├── {MODULE}_TECH-SPEC.md
    │   └── {MODULE}_DECISION-GATE.md     (if decision gate triggered)
    ├── implement/
    │   ├── {MODULE}_backend-agent.md
    │   ├── {MODULE}_frontend-agent.md
    │   └── {MODULE}_dba-agent.md
    ├── test/
    │   └── {MODULE}_TEST-REPORT.md
    ├── review/
    │   ├── {MODULE}_REVIEW-REPORT.md
    │   └── {MODULE}_SECURITY-REPORT.md   (if security-agent ran)
    ├── deploy/
    │   └── {MODULE}_DEPLOY-PLAN.md
    ├── docs/
    │   └── {MODULE}_API-DOCS.md
    └── DELIVERY-REPORT.md
```

Each run creates a new timestamped folder. Previous run outputs are never overwritten.

---

## Prohibited Actions (All Agents)

```
❌ Direct commits to main/master
❌ SELECT * queries
❌ Hardcoded secrets or credentials
❌ Swallowing exceptions without logging
❌ Writing output files outside outputs/ (except source code in src/)
❌ Skipping an active decision gate
❌ dba-agent making schema changes without Flyway migrations
❌ Sending ARCH-PLAN-REVIEW while DECISION-REQUIRED is still open
❌ Exceeding MAX_CONCURRENT_AGENTS without explicit human approval
```

---

## Customization

Edit `CLAUDE.md` section 10 to match your tech stack:

```
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

For non-Java projects, update the agent `model` and `tools` fields in the relevant agent `.md` files, and adjust the implementation standards sections accordingly.
