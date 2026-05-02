# Decision Gate

Use this template when work cannot proceed without a human decision.
Write to: `{OUTPUT_BASE}/design/{MODULE}_DECISION-GATE.md`

---

## Decision Summary

- **Topic:** `{short decision topic}`
- **Requested by:** `architect-agent`
- **Task ID:** `{TASK-ID}`
- **Blocking tasks:** `{TASK-ID list}`
- **Deadline impact:** `none | low | medium | high`
- **Created at:** `{UTC timestamp}`

---

## Context

Explain why this decision matters, what will be affected, and why the team cannot proceed without a human choice.

---

## Options

### Option A — `{name}`

- **Description:** `{what it is}`
- **Pros:**
  - `{benefit}`
  - `{benefit}`
- **Cons:**
  - `{trade-off}`
  - `{trade-off}`
- **Best when:** `{suitable scenario}`
- **Estimated effort:** `{relative effort, e.g. 2h | 1d | 1 week}`
- **Key risk:** `{primary risk if this option is chosen}`

### Option B — `{name}`

- **Description:** `{what it is}`
- **Pros:**
  - `{benefit}`
- **Cons:**
  - `{trade-off}`
- **Best when:** `{suitable scenario}`
- **Estimated effort:** `{relative effort}`
- **Key risk:** `{primary risk}`

### Option C — `{name}` *(if applicable)*

- **Description:** `{what it is}`
- **Pros:**
  - `{benefit}`
- **Cons:**
  - `{trade-off}`
- **Best when:** `{suitable scenario}`
- **Estimated effort:** `{relative effort}`
- **Key risk:** `{primary risk}`

---

## Comparison Matrix

| Criterion | Option A | Option B | Option C |
|---|---|---|---|
| Development effort | Low / Med / High | | |
| Operational complexity | Low / Med / High | | |
| Cost (infra/license) | Low / Med / High | | |
| Risk level | Low / Med / High | | |
| Time to first delivery | Fast / Med / Slow | | |

---

## Recommendation

- **Recommended option:** `{A | B | C}`
- **Reason:** `{brief rationale — 1-2 sentences}`
- **Conditions:** `{any assumptions or pre-conditions for the recommendation to hold}`

---

## Human Decision

*(To be filled by pm-agent after human input)*

- **Selected option:** `{to be filled}`
- **Decision note:** `{why this was chosen}`
- **Resolved at:** `{UTC timestamp}`
- **Resolved by:** `human`
