# Refactor Workflow

Use this workflow for structural improvements without intended behavior changes.

---

## Goal

Improve maintainability, readability, or design while preserving all externally visible behavior.

---

## Flow

### 1. Define scope and non-goals
- What exactly is being refactored? (e.g., extract service layer, rename module, migrate ORM)
- What must not change? (API contracts, error codes, DB schema — unless explicitly in scope)
- Which files are in scope? Set strict `file_domain` per agent

### 2. Architecture assessment (architect-agent)
- Required if the refactor crosses layers (e.g., backend restructuring that changes DB query patterns)
- Required if the refactor introduces a new pattern or dependency
- Not required for single-layer cleanup (e.g., rename methods, extract constants, split large files)

### 3. Create tasks with strict file-domain isolation
- Each agent owns non-overlapping paths
- Shared config files must have a single owner task
- No agent may "opportunistically" fix unrelated code in the same commit

### 4. Implementation
- Use the same feature branch: `refactor/TASK-{ID}`
- Commits must be atomic: one logical change per commit
- Do not mix refactor changes with bug fixes or new features in the same commit

### 5. Full regression (P0 + P1 + P2)
- qa-agent runs the full test suite — no exceptions for refactor workflow
- Any test failure is a bug introduced by the refactor, not a known issue to defer
- Before/after behavior must be identical for all tested scenarios

### 6. Review
- reviewer-agent checks that no new patterns violate the existing architecture
- reviewer-agent checks that no business logic changed unintentionally

### 7. Deliver
- pm-agent writes `DELIVERY-REPORT.md` noting behavior preservation evidence

---

## Decision Gate Rules

| Scenario | Gate Needed? |
|---|---|
| Rename, extract, reorganize within same layer | No |
| Change ORM framework (MyBatis → JPA) | Yes — migration risk and effort |
| Introduce new design pattern across modules | Yes — if approaches differ significantly |
| Extract microservice from monolith | Yes — operational complexity |

---

## Quality Bar

| Item | Requirement |
|---|---|
| Scope document | Required (what changes, what does not) |
| Atomic commits | Required |
| Full P0+P1+P2 regression | Required |
| No mixed commits | Required (refactor only, no bug fixes or features) |
| Behavior preservation evidence | Required in test report |
