# Documentation Workflow

Use this workflow for README updates, API docs, runbooks, onboarding notes, and release notes.

---

## Goal

Produce accurate documentation that matches current system behavior and is appropriate for the intended audience.

---

## Audience Types

| Audience | Document Type | Tone |
|---|---|---|
| External API consumers | API reference docs | Precise, formal, versioned |
| Internal developers | README, runbook, onboarding guide | Practical, example-heavy |
| Operations team | Deployment guide, runbook | Step-by-step, error-recovery focused |
| End users | User guide, FAQ | Plain language, no jargon |

Identify the audience before writing. The same feature may require multiple documents for different audiences.

---

## Flow

### 1. Determine the target audience and document type
- Who will read this? (see table above)
- What do they need to accomplish with this document?
- What format is most useful? (Markdown API reference, README section, CHANGELOG entry?)

### 2. Gather source-of-truth inputs
Priority order (from most to least authoritative):
1. architect-agent tech spec in `{OUTPUT_BASE}/design/`
2. Code annotations (Javadoc, JSDoc)
3. qa-agent test cases (describes real verified behavior)
4. Actual implementation code (last resort — mark extrapolated content as "verify with team")

**Never document from memory or assumption.** If the behavior cannot be confirmed from one of these sources, mark it `TBD`.

### 3. Create documentation tasks with ownership
- doc-agent owns all documentation files
- One task per document type (API docs, README update, CHANGELOG entry)
- Start the first task immediately

### 4. Accuracy validation
Before finalizing:
- Cross-check every endpoint path, field name, and type against the tech spec or actual code
- Verify all example request/response bodies are valid JSON
- Verify all error codes are defined in the implementation

### 5. Review
- reviewer-agent is optional for pure documentation tasks
- If the feature had a security-agent audit, have doc-agent update any security-related notes (rate limits, auth requirements) to match the final implementation

### 6. Deliver
- doc-agent commits updated docs to the feature branch
- pm-agent notes updated files in `DELIVERY-REPORT.md`

---

## Document Quality Rules

| Rule | Detail |
|---|---|
| No placeholder text | Every `{field}` placeholder must be replaced before publishing |
| No assumed behavior | If it is not in the spec or code, mark it TBD |
| Examples are required | Every API endpoint must have a working request/response example |
| CHANGELOG always updated | Every feature, bug fix, and breaking change gets a CHANGELOG entry |
| Version noted | Breaking changes must include the version in which they apply |

---

## CHANGELOG Format

```markdown
## [Unreleased]

### Added
- POST /api/v1/auth/login — user authentication with JWT (TASK-20260426-001)

### Fixed
- Login lockout not resetting after 10 minutes (BUG-20260426-001)

### Changed (Breaking)
- POST /api/v1/auth/login now returns `expireAt` in milliseconds (was seconds)
```
