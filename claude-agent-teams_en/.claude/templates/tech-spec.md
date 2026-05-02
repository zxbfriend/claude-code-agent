# Technical Specification

## Metadata

- Task ID: `{TASK-ID}`
- Module: `{module name}`
- Author: `architect-agent`
- Branch: `{branch name}`
- Generated at: `{timestamp}`
- Plan approval required: `yes | no`
- Plan approval status: `approved | n/a`

## Summary

Describe the feature or change in one short paragraph.

---

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

---

## Data Model

This section is required. If no database work is needed, set `Requires dba-agent` to `NO` and mark all changes `None`.

### Schema Changes

- **Requires dba-agent:** `YES | NO`
- **Changes:**
  - [ ] New table
  - [ ] New column
  - [ ] Index optimization
  - [ ] Data migration
  - [ ] None

### Table: `{table_name}`

| Column | Type | Nullable | Default | Description |
|---|---|---|---|---|
| id | BIGINT | NO | AUTO_INCREMENT | Primary key |
| created_at | DATETIME | NO | CURRENT_TIMESTAMP | Record creation time |
| updated_at | DATETIME | NO | CURRENT_TIMESTAMP ON UPDATE | Last update time |
| is_deleted | TINYINT(1) | NO | 0 | Soft delete flag (0=active, 1=deleted) |

### Indexes

| Name | Columns | Type | Reason |
|---|---|---|---|
| idx_example | example_col | BTREE | Example index |

---

## Module Boundaries

```json
{
  "module_boundaries": {
    "backend-agent": {
      "file_domain": ["src/main/java/com/example/{module}/"],
      "type": "java"
    },
    "frontend-agent": {
      "file_domain": ["src/frontend/src/pages/{module}/"],
      "type": "javascript"
    },
    "dba-agent": {
      "file_domain": ["src/main/resources/db/migration/"],
      "type": "sql",
      "required": false
    }
  }
}
```

---

## Redis / MQ Usage

*(Omit this section if not applicable)*

| Purpose | Key Pattern | Value Type | TTL |
|---|---|---|---|
| Example | `{project}:example:{id}` | String | 10 min |

---

## Technical Decisions

| Decision | Chosen Approach | Rationale | Alternatives Rejected |
|---|---|---|---|
| Example | Example choice | Example reason | Example alternative |

---

## Risks

- `{risk description and mitigation}`

---

## Implementation Guidance

### backend-agent

- `{specific instructions}`
- `{known risk points}`

### frontend-agent

- `{specific instructions}`

### dba-agent

*(Omit this section entirely if Requires dba-agent: NO)*

- `{migration notes}`
- `{index usage notes for backend-agent}`
