# Review Report

## Metadata

- **Task ID:** `{TASK-ID}`
- **Reviewer:** `reviewer-agent`
- **Branch:** `{branch name}`
- **Tech Spec:** `{OUTPUT_BASE}/design/{MODULE}_TECH-SPEC.md`
- **Reviewed at:** `{UTC timestamp}`

---

## Verdict

- **Status:** `PASS | CONDITIONAL PASS | REJECT`
- **Blocking issues (🔴 MUST):** `{N}`
- **Recommendations (🟡 SUGGEST):** `{N}`
- **Optional improvements (🔵 OPT):** `{N}`

---

## Checklist Results

### Code Standards
- [x/☐] Class/method/variable naming follows project conventions
- [x/☐] All public methods have Javadoc / JSDoc
- [x/☐] No magic values (constants or enums used)
- [x/☐] Methods ≤ 80 lines
- [x/☐] No commented-out code blocks

### Risk Detection
- [x/☐] Null pointer risks handled
- [x/☐] Empty collection edge cases handled
- [x/☐] `@Transactional` scope is correct
- [x/☐] No N+1 queries
- [x/☐] Thread safety in concurrent scenarios
- [x/☐] Resources closed properly
- [x/☐] Paginated queries have max page size limit

### Architecture Compliance
- [x/☐] API paths match tech spec exactly
- [x/☐] Request/response fields match tech spec
- [x/☐] DB schema matches dba-agent migration
- [x/☐] Layer dependencies correct (Controller → Service → Repository)
- [x/☐] No files modified outside assigned file_domain

### Security Baseline
- [x/☐] No hardcoded secrets / passwords / IPs
- [x/☐] No `${}` SQL interpolation
- [x/☐] No sensitive data in logs
- [x/☐] No extra sensitive fields in API responses

---

## Findings

### 🔴 MUST (Blocking)

```
MUST-001
File: {path} line {N}
Issue: {why it is a problem}
Fix:
  Before: {problematic code}
  After:  {corrected code}
```

*(or: None)*

### 🟡 SUGGEST (Recommended)

```
SUGGEST-001
File: {path} line {N}
Issue: {description}
Fix: {suggestion}
```

*(or: None)*

### 🔵 OPT (Optional)

```
OPT-001
File: {path}
Issue: {description}
Fix: {suggestion}
```

*(or: None)*

---

## Notes

`{Any important implementation details, follow-up items, or context for the next reviewer}`
