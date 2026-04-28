# New Feature Workflow

Use this workflow for new capabilities, new pages, new APIs, or new data structures.

---

## Default Behavior

`create an agent team` means:
1. Create the team and task list
2. Start execution immediately

Do not stop at planning unless a real blocker exists.

**Valid blockers:**
- An open `decision-required` gate
- Missing repository or workspace
- Missing mandatory human input that cannot be safely inferred

If blocked, the first reply must state:
- `team created, execution not started`
- The exact blocker
- The next required action from user or system

---

## Flow

### 1. Classify and scope
- Identify affected layers: Frontend? Backend? Database? DevOps? Security?
- Include dba-agent only if DB schema changes are needed
- Include security-agent if the feature touches auth, payments, PII, or file uploads

### 2. Preliminary decision gate check
- Trigger only if multiple valid technical approaches are **obvious from the request**
- Do not trigger for standard CRUD patterns (e.g., new form + API + table)
- If unsure, start architect-agent and ask it to assess during design

### 3. Design (architect-agent)
- architect-agent reads the codebase and produces the tech spec
- architect-agent decides the final decision gate and plan review triggers
- Standard CRUD features → architect writes spec directly (no plan review needed)
- Features with new external dependencies or breaking API changes → architect sends `ARCH-PLAN-REVIEW`

### 4. Implementation (parallel where possible)
- backend-agent, frontend-agent, and dba-agent work in parallel on the same feature branch
- Each agent owns its `file_domain` — no overlapping paths
- Shared files (pom.xml, package.json, etc.) must have a single owner task; others depend on it

### 5. Test
- qa-agent runs P0 (happy path) + P1 (main error scenarios)
- All P0 tests must pass before proceeding to review
- P1 failures produce bug reports routed through pm-agent

### 6. Review and security
- reviewer-agent checks code quality, architecture compliance, and security baseline
- security-agent runs if the feature involves auth, payments, PII, or external APIs

### 7. Deliver
- pm-agent collects all artifacts and writes `DELIVERY-REPORT.md`
- User merges the feature branch via pull request

---

## Decision Gate Scenarios (Common for New Features)

| Scenario | Gate Needed? | Notes |
|---|---|---|
| New CRUD endpoint with new DB table | No | Standard pattern |
| Auth with JWT vs Session | Yes | 20%+ cost/complexity difference |
| Add Redis for caching | Yes if new dependency, No if Redis already in stack | architect decides |
| New file upload to local disk vs S3 | Yes | SLA and cost difference |
| New UI page using existing API | No | Frontend only, no gate |

---

## User-Facing Status Contract

- If at least one task is active, name the active task ID and assignee
- If all tasks are `pending`, explicitly say execution has not started
- Do not imply progress is being monitored when no task is active
