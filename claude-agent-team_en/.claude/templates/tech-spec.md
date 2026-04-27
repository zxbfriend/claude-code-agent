# Technical Specification

## Metadata

- Task ID: `{TASK-ID}`
- Module: `{module name}`
- Author: `architect-agent`
- Branch: `{branch name}`
- Generated at: `{timestamp}`

## Summary

Describe the feature or change in one short paragraph.

## API Design

### Endpoint

- Method: `{GET|POST|PUT|DELETE}`
- Path: `/api/v1/{resource}`
- Auth: `{required | not required}`

### Request

| Field | Type | Required | Validation | Description |
|---|---|---|---|---|
| example | string | yes | non-empty | example field |

### Response

| Field | Type | Description |
|---|---|---|
| example | string | example field |

### Error Codes

| Code | HTTP | Trigger |
|---|---|---|
| EXAMPLE_ERROR | 400 | Example failure case |

## Data Model

Use this section only if database changes are needed.

### Table: `{table_name}`

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| id | BIGINT | NO | AUTO_INCREMENT | Primary key |

### Indexes

| Name | Columns | Type | Reason |
|---|---|---|---|
| idx_example | example_col | BTREE | Example index |

## Module Boundaries

- `backend-agent` owns: `{path}`
- `frontend-agent` owns: `{path}`
- `dba-agent` owns: `{path if needed}`

## Technical Decisions

| Decision | Chosen Approach | Rationale | Alternatives Rejected |
|---|---|---|---|
| Example | Example choice | Example reason | Example alternative |

## Risks

- `{risk}`

## Implementation Guidance

### backend-agent

- `{guidance}`

### frontend-agent

- `{guidance}`

### dba-agent

- `{guidance or omit if not needed}`

