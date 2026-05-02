# Agent Messaging Protocol — Final Edition

All teammates send status, blockers, decisions, bugs, and completion messages to `pm-agent` using the formats below. Free-form notes are allowed after the structured block, but the structured fields must stay intact.

---

## Overview: Message Types & Flow

### Design Phase Messages
```
architect-agent → pm-agent: DECISION-REQUIRED (if multiple options exist)
                 pm-agent: [wait for human decision]
architect-agent → pm-agent: ARCH-PLAN-REVIEW (if approval needed)
                 pm-agent: ARCH-PLAN-APPROVED (response)
architect-agent → pm-agent: TASK-COMPLETED (design done)
```

### Implementation Phase Messages
```
backend-agent   → pm-agent: TASK-COMPLETED (code done)
frontend-agent  → pm-agent: TASK-COMPLETED (code done)
dba-agent       → pm-agent: TASK-COMPLETED (migrations done)
devops-agent    → pm-agent: TASK-COMPLETED (infra done)
```

### Quality Assurance Phase Messages
```
qa-agent        → pm-agent: QA-REPORT (if bugs found)
implementation-agent → pm-agent: BUG-FIXED (after fix)
qa-agent        → pm-agent: TASK-COMPLETED (testing done)
```

### Code Review Phase Messages
```
reviewer-agent  → pm-agent: QA-REPORT (if review issues found)
security-agent  → pm-agent: QA-REPORT (if security issues found)
reviewer-agent  → pm-agent: TASK-COMPLETED (review done)
security-agent  → pm-agent: TASK-COMPLETED (audit done)
```

### Anytime Messages
```
any-agent       → pm-agent: BLOCKED (when stuck)
                 pm-agent: ACK (response to any message)
```

---

## Message Priority for pm-agent

Respond to messages in **this priority order**:

| Priority | Message Type | Response Time | Impact |
|---|---|---|---|
| 🔴 **CRITICAL** | **BLOCKED** | **Immediate** | Work stalled for one Agent |
| 🔴 **CRITICAL** | **DECISION-REQUIRED** | **ASAP (≤5 min)** | All dependent tasks blocked; human decision needed |
| 🟠 **HIGH** | **QA-REPORT** (Critical/High severity) | **Within 5 min** | Review stage blocked |
| 🟠 **HIGH** | **ARCH-PLAN-REVIEW** | **Within 5 min** | Implementation stage blocked |
| 🟡 **MEDIUM** | **QA-REPORT** (Medium severity) | **Within 15 min** | Track but doesn't block |
| 🟡 **MEDIUM** | **BUG-FIXED** | **Within 2 min** | Retest needed soon |
| 🟢 **LOW** | **TASK-COMPLETED** | **Within 2 min** | Unblock dependent tasks |
| 🔵 **INFO** | **ACK** (no need to wait) | N/A | Acknowledgement only |

---

## Message Formats

### 1. Bug Report (QA-REPORT)

Used by `qa-agent`, `reviewer-agent`, or `security-agent` when work must return to an implementation agent.

```text
QA-REPORT: {TASK_ID}
Status: BUG_FOUND
Severity: Critical | High | Medium | Low
Assignee: backend-agent | frontend-agent | dba-agent | devops-agent
Bug ID: BUG-{YYYYMMDD}-{NNN}
Linked Test: TC-{NNN}
Evidence: {path | request/response | screenshot | log excerpt}
Regression Scope: {minimal | adjacent | full — see qa-agent regression rules}

Description:
{one-line summary}

Steps:
1. {step}
2. {step}

Expected:
{expected behavior}

Actual:
{actual behavior}
```

**Example:**
```text
QA-REPORT: TASK-20260427-005
Status: BUG_FOUND
Severity: Critical
Assignee: backend-agent
Bug ID: BUG-20260427-001
Linked Test: TC-002
Evidence: POST /api/v1/auth/login returns 500 after 5 wrong attempts

Description:
Login endpoint crashes when account is locked due to failed attempts

Steps:
1. Send wrong password 5 times
2. Send correct password on 6th attempt
3. Observe response

Expected:
HTTP 400 with error code 10002 (account locked)

Actual:
HTTP 500 Internal Server Error (null pointer exception in logs)
```

---

### 2. Decision Gate (DECISION-REQUIRED)

Used by `architect-agent` when a human decision is required. Must be sent **before** `ARCH-PLAN-REVIEW` if both are needed.

```text
DECISION-REQUIRED: {TASK_ID}
Topic: {short title}
Blocking Tasks: {TASK_ID list}
Decision Artifact: {OUTPUT_BASE}/design/{MODULE}_DECISION-GATE.md
Recommendation: Option A | Option B | Option C

Reason:
{why this must pause for human choice}
```

**Example:**
```text
DECISION-REQUIRED: TASK-20260427-001
Topic: Authentication Caching Strategy
Blocking Tasks: TASK-20260427-002, TASK-20260427-003, TASK-20260427-004
Decision Artifact: outputs/20260427T100000_myproject/design/auth_DECISION-GATE.md
Recommendation: Option B (Redis distributed cache)

Reason:
Two valid approaches exist with significant cost difference:
- Option A: In-process cache (2h dev, $0/mo, single-instance only)
- Option B: Redis (4h dev, $200/mo, distributed, horizontal scale)

The codebase will grow to multi-instance deployment in Q3 2026.
Option A would require rearchitecture then. Option B future-proofs now.

Awaiting your decision on cost vs. future-readiness.
```

---

### 3. Architecture Plan Review (ARCH-PLAN-REVIEW)

Used by `architect-agent` when plan approval is required before finalizing a tech spec.
Must **not** be sent while a `DECISION-REQUIRED` for the same task is still open.

```text
ARCH-PLAN-REVIEW: {TASK_ID}
Status: PENDING_APPROVAL
Stage: draft_design
Artifact: {OUTPUT_BASE}/design/{MODULE}_TECH-SPEC.md (draft)
Scope: backend | frontend | dba | devops | security
External Dependencies: yes | no; {list if yes}
Decision Gate Resolved: yes | n/a

Key Decisions Made:
- {decision}
- {decision}

Awaiting approval before finalizing.
```

**Example:**
```text
ARCH-PLAN-REVIEW: TASK-20260427-001
Status: PENDING_APPROVAL
Stage: draft_design
Artifact: outputs/20260427T100000_myproject/design/auth_TECH-SPEC.md (draft)
Scope: backend | frontend | dba
External Dependencies: yes; Redis (KV store for login attempts)
Decision Gate Resolved: yes (chose Redis caching on 2026-04-27T10:30Z)

Key Decisions Made:
- Chosen Option B: Redis distributed cache for login attempt throttling
- New table: login_attempts (stores attempt count keyed by user_id)
- JWT expiry: 1 hour access token + 7 day refresh token
- API versioning: /api/v1/auth (no breaking changes to existing endpoints)
- New dependency: spring-data-redis 2.7.x

Plan covers all 3 layers: backend auth service, frontend form + token storage, dba schema for users + login_log.

Awaiting approval to finalize tech spec and unblock implementation.
```

---

### 4. Architecture Plan Approval Response (ARCH-PLAN-APPROVED)

Used by `pm-agent` to respond to `ARCH-PLAN-REVIEW`.

```text
ARCH-PLAN-APPROVED: {TASK_ID}
Decision: APPROVED | APPROVED_WITH_NOTES | REQUIRES_REVISION
Notes: {feedback}
```

**Example (APPROVED):**
```text
ARCH-PLAN-APPROVED: TASK-20260427-001
Decision: APPROVED
Notes: Plan approved. Redis dependency, new tables, and JWT strategy all acceptable.
```

**Example (APPROVED_WITH_NOTES):**
```text
ARCH-PLAN-APPROVED: TASK-20260427-001
Decision: APPROVED_WITH_NOTES
Notes: Plan approved with one note: ensure Redis cluster is configured for HA before production.
```

**Example (REQUIRES_REVISION):**
```text
ARCH-PLAN-APPROVED: TASK-20260427-001
Decision: REQUIRES_REVISION
Notes: Please revise: 
  1. JWT expiry of 1 hour is too short for our mobile clients. Increase to 4 hours.
  2. Add rate-limit enforcement to prevent brute-force on /login endpoint.
  Resubmit ARCH-PLAN-REVIEW after revisions.
```

**Behavior after each decision:**
- **APPROVED** or **APPROVED_WITH_NOTES** → architect-agent proceeds to write final tech spec
- **REQUIRES_REVISION** → architect-agent revises draft and sends another `ARCH-PLAN-REVIEW`

---

### 5. Blocker (BLOCKED)

Used by any teammate that cannot continue.

```text
BLOCKED: {TASK_ID}
Assignee: {agent-name}
Reason: {specific blocker}
Needed From: pm-agent | architect-agent | backend-agent | frontend-agent | dba-agent | user
Blocking Since: {timestamp}
```

**Example:**
```text
BLOCKED: TASK-20260427-002
Assignee: backend-agent
Reason: Tech spec not found at outputs/20260427T100000_myproject/design/auth_TECH-SPEC.md
Needed From: architect-agent
Blocking Since: 2026-04-27T14:35:00Z
```

---

### 6. Bug Fixed (BUG-FIXED)

Used by an implementation agent after fixing a bug previously reported through `QA-REPORT`.

```text
BUG-FIXED: {BUG_ID}
Task: {TASK_ID}
Fixed by: {agent-name}
Branch: {branch}
Commit: {commit-hash}
Retest Scope: {test cases or endpoints}
Awaiting re-test by qa-agent
```

**Example:**
```text
BUG-FIXED: BUG-20260427-001
Task: TASK-20260427-006
Fixed by: backend-agent
Branch: fix/TASK-20260427-006
Commit: a3f9e2c1d8b5 (prevent null pointer when account is locked)
Retest Scope: TC-002 (login with locked account), P0 smoke tests for /api/v1/auth/login
Awaiting re-test by qa-agent
```

---

### 7. Task Completion (TASK-COMPLETED)

Used by any teammate after finishing assigned work.

```text
TASK-COMPLETED: {TASK_ID}
Assignee: {agent-name}
Branch: {branch}
Output Path: {OUTPUT_BASE}/{stage}/{artifact}
Commits: {commit count or list}
Status: completed

Summary:
{short summary}

Follow-ups:
{none or bullet list}
```

**Example (architect-agent):**
```text
TASK-COMPLETED: TASK-20260427-001
Assignee: architect-agent
Branch: feature/TASK-20260427-001
Output Path: outputs/20260427T100000_myproject/design/auth_TECH-SPEC.md
Commits: 0 (design artifact only, no code commits)
Status: completed

Summary:
Tech spec finalized for JWT-based authentication with Redis-backed login attempt throttling.
Covers backend (AuthController + AuthService), frontend (LoginPage + useAuth hook), 
and dba (users table + login_attempts table).

Follow-ups:
- backend-agent to implement per spec
- frontend-agent to implement per spec
- dba-agent to write migrations per spec
```

**Example (backend-agent):**
```text
TASK-COMPLETED: TASK-20260427-002
Assignee: backend-agent
Branch: feature/TASK-20260427-001
Output Path: outputs/20260427T100000_myproject/implement/auth_backend-agent.md
Commits: 5
Status: completed

Summary:
AuthController and AuthService implemented with unit tests covering happy path + 3 failure scenarios.
Redis integration for login fail lockout (5 attempts = 10 min lockout).
All P0 tests passing locally.

Follow-ups:
- qa-agent to run integration tests
```

---

### 8. Acknowledgement (ACK)

Used by `pm-agent` to acknowledge every `QA-REPORT`, `BUG-FIXED`, `BLOCKED`, `DECISION-REQUIRED`, and `ARCH-PLAN-REVIEW` message within the same turn.

```text
ACK: {MESSAGE_TYPE}:{TASK_ID}
Timestamp: {UTC timestamp}
Action: {next step}
```

**Examples:**

```text
ACK: QA-REPORT:TASK-20260427-005
Timestamp: 2026-04-27T14:35:00Z
Action: Routing BUG-20260427-001 to backend-agent for fix. Created TASK-20260427-006. Marking TASK-20260427-005 as blocked.
```

```text
ACK: DECISION-REQUIRED:TASK-20260427-001
Timestamp: 2026-04-27T10:15:00Z
Action: Decision gate received. Marked dependent tasks (002, 003, 004) as blocked. Presenting decision artifact to human.
```

```text
ACK: BUG-FIXED:BUG-20260427-001
Timestamp: 2026-04-27T15:45:00Z
Action: Retest assigned to qa-agent. Moved TASK-20260427-005 back to in_progress.
```

```text
ACK: BLOCKED:TASK-20260427-002
Timestamp: 2026-04-27T14:40:00Z
Action: Tech spec dependency identified. architect-agent is on task. Will notify backend-agent when ready.
```

---

## Message Handling Rules for pm-agent

### Upon receiving any message:

1. **Log the message** with timestamp
2. **Acknowledge immediately** with `ACK: {TYPE}:{TASK_ID}` (unless already acknowledged in same turn)
3. **Update task list** — reflect any status changes
4. **Respond to the message** according to its type:
   - `DECISION-REQUIRED` → Pause work, present decision to human
   - `ARCH-PLAN-REVIEW` → Review and reply with `ARCH-PLAN-APPROVED` or `REQUIRES_REVISION`
   - `BLOCKED` → Identify blocker cause, communicate with owner, provide ETA
   - `QA-REPORT` → Re-assign to fix owner, mark original task as blocked
   - `BUG-FIXED` → Resume qa-agent retest, note the fix commit
   - `TASK-COMPLETED` → Unblock dependent tasks, activate next runnable tasks
5. **Keep task list accurate** — reflect concurrent task counts, avoid exceeding MAX_CONCURRENT_AGENTS=4

### Response time commitments:

| Message | pm-agent Response | Impact of Delay |
|---|---|---|
| **BLOCKED** | Immediate (< 1 min) | Work halted; escalate to human if > 5 min delay |
| **DECISION-REQUIRED** | ASAP (< 5 min) | Dependent tasks stalled; decision can't be deferred |
| **QA-REPORT** (Critical) | Within 5 min | Review stage blocked |
| **ARCH-PLAN-REVIEW** | Within 5 min | Implementation stage blocked |
| **BUG-FIXED** | Within 2 min | Retest queued |
| **TASK-COMPLETED** | Within 2 min | Dependent tasks queued |

---

## Example: Full Workflow Communication

### Scenario: New login feature with decision gate

```
Timeline                   Message                          pm-agent Action
──────────────────────────────────────────────────────────────────────────────
T+0min     architect sends DECISION-REQUIRED           ACK immediately
           (caching strategy: Option A vs B)           Mark dependent tasks BLOCKED
                                                        Present decision to human

T+3min     [human chooses Option B: Redis]             Update decision task
                                                        Resume architect-agent

T+4min     architect sends ARCH-PLAN-REVIEW            ACK immediately
           (with Option B finalized)                   Review plan
                                                        Send ARCH-PLAN-APPROVED

T+5min     architect sends TASK-COMPLETED              ACK immediately
           (tech spec done)                            Unblock backend, frontend, dba
                                                        Mark them in_progress

T+6min     backend-agent works...
T+8min     frontend-agent works...
T+10min    dba-agent works...

T+12min    backend sends TASK-COMPLETED               ACK, unblock qa
           frontend sends TASK-COMPLETED
           dba sends TASK-COMPLETED

T+13min    qa-agent starts testing...
T+15min    qa-agent finds BUG in backend               Send QA-REPORT
                                                        Reassign to backend-agent
                                                        Mark qa task BLOCKED

T+16min    backend-agent sends BUG-FIXED              ACK, requeue qa-agent
           (fixed & committed)

T+18min    qa-agent retests...
T+19min    qa-agent sends TASK-COMPLETED              ACK, unblock reviewer
           (all tests pass)

T+20min    reviewer-agent reviews...
T+22min    reviewer sends TASK-COMPLETED              ACK
           (code approved)                            Final delivery ready
```

---

## Reserved Field Names in Messages

These field names have special meaning and must not be used for free-form notes:

```
QA-REPORT:      Status, Severity, Assignee, Bug ID, Linked Test, Evidence, 
                Regression Scope, Description, Steps, Expected, Actual

DECISION-REQUIRED:  Topic, Blocking Tasks, Decision Artifact, Recommendation, Reason

ARCH-PLAN-REVIEW:   Status, Stage, Artifact, Scope, External Dependencies, 
                    Decision Gate Resolved, Key Decisions Made

ARCH-PLAN-APPROVED: Decision, Notes

BLOCKED:        Reason, Needed From, Blocking Since

BUG-FIXED:      Fixed by, Branch, Commit, Retest Scope

TASK-COMPLETED: Assignee, Branch, Output Path, Commits, Status, Summary, Follow-ups

ACK:            Timestamp, Action
```

Free-form notes are allowed **after** the structured fields, but the structured fields are the contract.

---

## Summary

This protocol ensures:
- ✅ **Clear ownership** — every message has a sender and receiver
- ✅ **Structured data** — pm-agent can parse and act on messages reliably
- ✅ **Priority handling** — critical blockers surface immediately
- ✅ **Traceability** — full audit trail of decisions and actions
- ✅ **Responsiveness** — response time expectations are explicit
- ✅ **Flexibility** — free-form notes allowed for context and discussion
