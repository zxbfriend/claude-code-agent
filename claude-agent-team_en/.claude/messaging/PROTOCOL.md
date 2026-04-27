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

## Blocker

Used by any teammate that cannot continue.

```text
BLOCKED: {TASK_ID}
Assignee: {agent-name}
Reason: {specific blocker}
Needed From: pm-agent | architect-agent | backend-agent | frontend-agent | dba-agent | user
Blocking Since: {timestamp}
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
