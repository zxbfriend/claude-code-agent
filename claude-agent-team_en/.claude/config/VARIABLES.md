# Agent Team Variables

These variables are created by `pm-agent` once per task run and must be passed to every teammate in the start instruction.

## Required Context Package

```text
TASK_ID: TASK-{YYYYMMDD}-{NNN}
TASK_SET_ID: TASK-{YYYYMMDD}-{NNN}
WORKFLOW: new-feature | bug-fix | refactor | change-request | performance | security-audit | dependency-upgrade | documentation
PROJECT_ID: {project-id}
TIMESTAMP: {UTC timestamp from date -u +%Y%m%dT%H%M%S}
OUTPUT_BASE: outputs/{TIMESTAMP}_{PROJECT_ID}
BRANCH: {feature|fix|refactor}/TASK-{YYYYMMDD}-{NNN}
MODULE: {module-name}
TASK_LIST_PATH: {OUTPUT_BASE}/TASK-LIST.md
```

## Derived Paths

```text
TECH_SPEC_PATH: {OUTPUT_BASE}/design/{MODULE}_TECH-SPEC.md
IMPLEMENT_PATH: {OUTPUT_BASE}/implement/{MODULE}_{agent-name}.md
TEST_REPORT_PATH: {OUTPUT_BASE}/test/{MODULE}_TEST-REPORT.md
REVIEW_REPORT_PATH: {OUTPUT_BASE}/review/{MODULE}_REVIEW-REPORT.md
SECURITY_REPORT_PATH: {OUTPUT_BASE}/review/{MODULE}_SECURITY-REPORT.md
DELIVERY_REPORT_PATH: {OUTPUT_BASE}/DELIVERY-REPORT.md
```

## Timestamp Standard

All agents use UTC timestamps in this exact format:

```bash
date -u +%Y%m%dT%H%M%S
```

Example: `20260426T143000`

## Start Instruction Requirements

Every direct start instruction from `pm-agent` to a teammate must include:

- the required context package above
- the task's `file_domain` JSON array
- the task's `output_path`
- dependencies and blocking decisions
- constraints specific to the assignee
