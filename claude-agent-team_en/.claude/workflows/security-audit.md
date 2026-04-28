# Security Audit Workflow

Use this workflow for auth, authorization, secrets handling, sensitive data, dependency risk, and attack-surface reviews.

---

## Goal

Find and prioritize security risks, implement approved fixes, and document unresolved exposure.

---

## Flow

### 1. Define the audit scope and threat surface
- Which modules are in scope? (auth, payment, file upload, admin panel, external API integration?)
- What data is handled? (PII, financial data, credentials, health data?)
- What is the deployment environment? (public internet, internal network, multi-tenant?)

### 2. Identify affected layers and sensitive paths
- Backend: auth middleware, input validation, query construction, secrets management
- Frontend: token storage, sensitive form handling, content security policy
- Database: PII column encryption, audit logging, access controls
- Infrastructure: secrets in env vars, exposed debug endpoints, CORS policy

### 3. Spawn security-agent with the audit scope
- security-agent runs the OWASP Top 10 checklist
- security-agent runs `mvn dependency-check:check` or `npm audit` for CVE scanning
- security-agent produces findings at Critical/High/Medium/Low severity

### 4. Create remediation tasks for Critical and High findings
- Assign each finding to the responsible agent (backend-agent, frontend-agent, etc.)
- Critical findings: block all other work until fixed
- High findings: fix in current sprint before delivery
- Medium/Low: track as follow-up items

### 5. Verify fixes
- security-agent re-reviews each fixed finding against its original evidence
- qa-agent runs targeted regression for the affected flows

### 6. Deliver
- pm-agent writes `DELIVERY-REPORT.md` with audit verdict, fixed findings, and open items

---

## When to Spawn security-agent Outside Security Audit Workflow

Also include security-agent as an optional teammate in new-feature workflow when:
- Feature involves authentication or authorization (login, token, session, role check)
- Feature handles payment, financial data, or PII
- Feature accepts file uploads
- Feature integrates with an external API that receives sensitive data

---

## Priority Rules

| Finding | Action | Blocks Delivery? |
|---|---|---|
| Critical | Fix immediately, re-audit before any other work proceeds | Yes |
| High | Fix before sprint delivery | Yes |
| Medium | Track as backlog item | No |
| Low | Advisory only | No |

---

## Common Findings by Layer

| Layer | Common Issues |
|---|---|
| Backend | SQL injection via `${}`, missing `@PreAuthorize`, tokens without expiry |
| Frontend | Token in localStorage without httpOnly, no XSS sanitization, CORS wildcard |
| Database | Plaintext PII, missing audit log, no row-level access control |
| Infrastructure | Actuator exposed publicly, secrets in ConfigMap, wildcard CORS in API gateway |
