# Dependency Upgrade Workflow

Use this workflow for library, framework, runtime, or build-tool upgrades.

---

## Goal

Upgrade dependencies safely, surface and resolve breaking changes, preserve compatibility, and verify with targeted regression.

---

## Upgrade Risk Classification

| Upgrade Type | Risk | Required Validation |
|---|---|---|
| Patch version (x.y.Z) | Low — bug/security fixes | P0 smoke test |
| Minor version (x.Y.0) | Medium — new features, usually backward compatible | P0 + P1 |
| Major version (X.0.0) | High — breaking changes likely | P0 + P1 + P2 full regression |
| Runtime upgrade (JDK, Node) | High — compilation and behavior changes | Full regression + build verification |
| Framework upgrade (Spring Boot, React) | High | Full regression + migration guide review |

---

## Flow

### 1. Identify target versions and upgrade scope
- What is being upgraded? (single library, all dependencies, framework, runtime?)
- What is the current version and target version?
- Is this a security-motivated upgrade (CVE)? → Expedited path

### 2. Review release notes and breaking changes
- Read the official migration guide for major version upgrades
- List all breaking changes relevant to this codebase
- Identify which source files need adaptation

### 3. Decision gate check
- Patch/minor upgrade: typically no gate
- Major upgrade that requires code changes across >3 files or >2 layers: gate if multiple migration strategies exist
- Example: Spring Boot 2 → 3 migration with Java EE to Jakarta EE namespace change

### 4. Create tasks
- backend-agent: update pom.xml/build.gradle, adapt source code to breaking changes
- frontend-agent: update package.json, adapt to API changes in upgraded libraries
- dba-agent: only if the ORM or migration tool itself is being upgraded
- qa-agent: regression testing with appropriate depth (see table above)

### 5. Implementation rules
- Never upgrade multiple major dependencies in one task — one at a time
- Keep the upgrade commit separate from any other changes
- Run the build and all existing tests locally before marking complete

### 6. Validation (qa-agent)
- Run regression at the depth required by risk classification
- Specifically test the functionality most likely to be affected by breaking changes
- For security CVE fixes: verify the CVE is no longer reported by the scanner

### 7. Review
- reviewer-agent checks that no breaking API changes were silently ignored
- reviewer-agent checks that the upgrade did not introduce new CVEs

### 8. Deliver
- pm-agent notes the upgraded versions, breaking changes resolved, and any deferred work in `DELIVERY-REPORT.md`

---

## Security CVE Expedited Path

When the upgrade is specifically to fix a known CVE:
1. Skip the preliminary decision gate (urgency overrides)
2. Apply the minimum version bump that resolves the CVE
3. Run P0 + P1 regression
4. Fast-track review
5. Document the CVE ID and resolution in `DELIVERY-REPORT.md`
