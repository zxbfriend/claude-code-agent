# Bug Fix Workflow

Use this workflow for defects, crashes, incorrect behavior, and production-like failures.

---

## Goal

Diagnose the root cause, implement the minimum safe fix, validate the fix with directed regression, and document residual risk.

---

## Flow

### 1. Reproduce and characterize
- Identify the failing endpoint, component, or flow
- Collect evidence: error logs, stack traces, request/response samples
- Determine if the bug is backend, frontend, database, or cross-layer

### 2. Root cause assessment
- Is the root cause clear? → Proceed directly to fix
- Is root cause ambiguous? → Have backend-agent or frontend-agent run a diagnosis step first, then fix
- Does the fix require a schema change? → Spawn dba-agent provisionally

### 3. Assign and fix
- Assign the fix to the appropriate implementer (backend-agent, frontend-agent, dba-agent)
- The fix must be on a feature branch: `fix/TASK-{ID}`
- The fix must be minimal — do not refactor adjacent code in the same commit

### 4. Directed validation (qa-agent)
- Run only the test cases related to the fixed behavior
- Also run a short adjacent smoke: P0 tests for the same endpoint or component
- Do **not** run full module regression (that is for refactor workflow)
- See regression scope table in qa-agent.md

### 5. Review
- reviewer-agent performs a focused review on the changed files only
- If the fix is small (≤ 3 files, ≤ 50 lines), reviewer may use a lightweight checklist pass

### 6. Deliver
- pm-agent writes `DELIVERY-REPORT.md` with the bug ID, root cause, fix summary, and retest evidence

---

## architect-agent Involvement

Bug fixes typically do **not** require architect-agent. Exceptions:
- The bug reveals a design flaw that requires a structural change (e.g., wrong cache invalidation strategy)
- The fix requires a new external dependency
- The root cause spans three or more layers

If architect-agent is needed, pm-agent spawns it with a focused scope: "diagnose and propose a fix approach for {BUG_ID}".

---

## Decision Gate Rules

- Standard bug fixes: **no decision gate**
- If two or more fix approaches exist with >20% difference in risk or effort → trigger gate
- Example that triggers gate: bug in auth module where fix option A patches the token validation and option B redesigns the session layer

---

## Quality Bar

| Item | Requirement |
|---|---|
| Root cause documented | Always |
| Fix branch | Required (`fix/TASK-{ID}`) |
| Directed test evidence | Required |
| Full regression | Only if pm-agent explicitly requests it |
| Residual risk note | Required if fix is partial or workaround |
