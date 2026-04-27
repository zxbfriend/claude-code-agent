# Agent Messaging Protocol

All teammates send status, blockers, decisions, bugs, and completion messages to `pm-agent` using the formats below. Free-form notes are allowed after the structured block, but the structured fields must stay intact.

## Bug Report

Used by `qa-agent`, `reviewer-agent`, or `security-agent` when work must return to an implementation agent.

```text
QA-REPORT: {TASK_ID}
Status: BUG_FOUND
Severity: Critical | High | Medium | Low
Assignee: backend-agent | frontend-agent | dba-agent | devops-agent
Bug ID: BUG-{YYYYMMDD}-{NNN}
Linked Test: TC-{NNN}
Evidence: {path | request/response | screenshot | log excerpt}

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

## Decision Gate

Used by `architect-agent` when a human decision is required.

```text
DECISION-REQUIRED: {TASK_ID}
Topic: {short title}
Blocking Tasks: {TASK_ID list}
Decision Artifact: {OUTPUT_BASE}/design/{MODULE}_DECISION-GATE.md
Recommendation: Option A | Option B | Option C

Reason:
{why this must pause for human choice}
```

## Architecture Plan Review

Used by `architect-agent` when plan approval is required before finalizing a tech spec.

```text
ARCH-PLAN-REVIEW: {TASK_ID}
Status: PENDING_APPROVAL
Stage: draft_design
Artifact: {OUTPUT_BASE}/design/{MODULE}_TECH-SPEC.md (draft)
Scope: backend | frontend | dba | devops | security
External Dependencies: yes | no; {list if yes}

Key Decisions Made:
- {decision}
- {decision}

Awaiting approval before finalizing.
```

`pm-agent` replies:

```text
ARCH-PLAN-APPROVED: {TASK_ID}
Decision: APPROVED | APPROVED_WITH_NOTES | REQUIRES_REVISION
Notes: {feedback}
```

`architect-agent` may write the final spec only after receiving `APPROVED` or `APPROVED_WITH_NOTES`.

## Blocker

Used by any teammate that cannot continue.

```text
BLOCKED: {TASK_ID}
Assignee: {agent-name}
Reason: {specific blocker}
Needed From: pm-agent | architect-agent | backend-agent | frontend-agent | dba-agent | user
Blocking Since: {timestamp}
```

## Bug Fixed

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

## Task Completion

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

## Acknowledgement

`pm-agent` must acknowledge every `QA-REPORT`, `BUG-FIXED`, `BLOCKED`, `DECISION-REQUIRED`, and `ARCH-PLAN-REVIEW` message.

```text
ACK: {MESSAGE_TYPE}:{TASK_ID}
Timestamp: {UTC timestamp}
Action: {next step}
```

Example:

```text
ACK: QA-REPORT:TASK-20260427-004
Timestamp: 2026-04-27T14:35:00Z
Action: Routing BUG-20260427-001 to backend-agent for fix
```
