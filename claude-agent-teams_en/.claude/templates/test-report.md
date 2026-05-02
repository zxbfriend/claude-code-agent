# Test Report

## Metadata

- **Task ID:** `{TASK-ID}`
- **Tester:** `qa-agent`
- **Branch:** `{branch name}`
- **Workflow:** `{new-feature | bug-fix | refactor | performance | dependency-upgrade}`
- **Test scope:** `P0 only | P0 + P1 | P0 + P1 + P2 | directed regression`
- **Regression scope applied:** `minimal | adjacent | full | n/a`
- **Tested at:** `{UTC timestamp}`

---

## Result

- **Status:** `pass | fail | pass_with_known_issues`

---

## Test Cases

| ID | Scenario | Priority | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| TC-001 | Example scenario | P0 | Example result | Example result | PASS |
| TC-002 | Example failure scenario | P1 | Error code X returned | Error code X returned | PASS |

---

## Defects Found

### Critical (Block Review)

- `{BUG-ID}` — `{one-line description}`
  - **Assignee:** `{backend-agent | frontend-agent | dba-agent | devops-agent}`
  - **Evidence:** `{path | request/response | screenshot | log excerpt}`
  - **Linked Test:** `TC-{NNN}`

*(or: None)*

### High (Fix Before Release)

- `{BUG-ID}` — `{description}` *(or: None)*

### Medium (Track Follow-up)

- `{BUG-ID}` — `{description}` *(or: None)*

### Low (Optional Cleanup)

- `{BUG-ID}` — `{description}` *(or: None)*

---

## Defect Summary

| Severity | Count |
|---|---|
| Critical | `{N}` |
| High | `{N}` |
| Medium | `{N}` |
| Low | `{N}` |

---

## Retest Records

*(Populated after bug fixes are verified)*

| Bug ID | Fixed Commit | Linked Test | Scope Applied | Result |
|---|---|---|---|---|
| BUG-{ID} | {hash} | TC-{NNN} | minimal / adjacent / full | PASS / FAIL |

---

## Conclusion

```
✅ All tests passed — recommend proceeding to reviewer-agent
⚠️ Non-critical failures — N bugs listed above; recommend fixing before review
❌ Critical P0 failures — block review until BUG-{ID} is resolved
```

---

## Notes

- `{Any edge cases, environment-specific observations, or known limitations}`
