# New Feature Workflow

Use this workflow for new capabilities, new pages, new APIs, or new data structures.

## Default Meaning

In this project, `create an agent team` means:
1. create the team and task list
2. start execution immediately

Do not stop at planning unless a real blocker exists.

## Valid Blockers

- an open `decision-required` gate
- missing repository or workspace required to execute the work
- missing mandatory human input that cannot be inferred safely

If blocked, the first reply must say:
- `team created, execution not started`
- the exact blocker
- the next required action

## Flow

1. Analyze the request and impacted layers.
2. Check whether a decision gate is required.
3. Have `architect-agent` produce the technical design.
4. Split implementation into backend, frontend, DBA, QA, and review tasks as needed.
5. Start the first runnable task immediately.
6. Auto-advance downstream tasks as dependencies are cleared.
7. Validate, review, and deliver.

## User-Facing Status Contract

- If at least one task is active, name the active task ID and assignee.
- If all tasks are `pending`, explicitly say execution has not started.
- Do not imply progress is being monitored when no task is active.

