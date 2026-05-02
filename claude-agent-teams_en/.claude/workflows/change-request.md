# Change Request Workflow

Use this workflow when an existing feature must be adjusted without being a net-new capability.

---

## Goal

Apply the requested change with the smallest coherent scope while preserving all unchanged existing behavior.

---

## Flow

### 1. Clarify what changes and what must remain unchanged
- Get explicit confirmation on: which API fields/endpoints change, which stay the same
- Identify whether the change is additive (new field added) or mutative (existing field behavior changes)
- Mutative changes affecting existing consumers require an API versioning decision

### 2. Impact analysis
- Frontend: Does the UI need to reflect the new behavior?
- Backend: Does business logic change? Does the API contract change?
- Database: Does any schema need updating?
- Docs: Do API docs, README, or CHANGELOG need updating?

### 3. Decision gate check
- Additive change (new optional field, new endpoint) → typically no gate
- Mutative breaking change (removes field, changes type, changes error code) → gate if multiple migration strategies exist
- Example gate: "change authentication from phone+password to email+password" — migration strategy for existing users must be decided

### 4. Design (architect-agent)
- Required if API contract changes (even non-breaking additions to a public API)
- Required if the change affects two or more layers
- Not required for purely cosmetic or copy-text changes

### 5. Implementation
- Use branch: `feature/TASK-{ID}` or `fix/TASK-{ID}` depending on nature
- Implementation must not change behavior outside the declared scope
- Backward compatibility: if the change is breaking, the old behavior must be preserved in the same release or a migration plan must exist

### 6. Validation
- qa-agent tests changed paths + key adjacent regression
- Explicitly verify unchanged endpoints still behave identically

### 7. Deliver
- pm-agent notes the changed vs. preserved behaviors in `DELIVERY-REPORT.md`

---

## Backward Compatibility Rules

| Change Type | Compatibility Requirement |
|---|---|
| Add optional request field | Fully backward compatible — no special handling |
| Add optional response field | Fully backward compatible — no special handling |
| Remove or rename field | Breaking — requires versioning decision or migration plan |
| Change field type or format | Breaking — requires versioning decision or migration plan |
| Change error code | Breaking — document in CHANGELOG |
| Change business rule (e.g., lockout threshold) | Non-breaking API but may surprise existing clients — document clearly |
