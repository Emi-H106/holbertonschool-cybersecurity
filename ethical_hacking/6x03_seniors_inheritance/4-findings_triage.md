# Findings Triage and Consolidation

## Retired Findings

### Retired finding F-07 — Authorized Bulk Patient Export Workflow

**Decision: RETIRED from the active vulnerability register.** Sarah's test demonstrated that a temporarily pre-approved Support Manager role could execute a multi-laboratory patient export, but did not establish unauthorized access or a bypass of the documented approval workflow. MediPath identifies this capability as an intended emergency and regulatory-response function governed by a DPO-approved ticket, WebAuthn step-up authentication, dual approval by the Support Operations Manager and DPO delegate, case-specific encryption, seven-day expiry, and immutable audit logging. On the evidence available, the observed export is therefore classified as authorized functionality rather than a demonstrated authorization vulnerability. F-07 is removed from the active findings and retained in the report addendum for traceability. This retirement concerns the reported test scenario only: the supplied evidence does not establish that every production export path has been independently verified, so enforcement of the documented safeguards remains a separate control-assurance activity rather than a confirmed completed penetration-test validation.

## Merged Findings

### Merger F-03 and F-09 as F-03/09 — Authorization Lifecycle and Privilege Governance

F-03 and F-09 are proposed for consolidation under a common authorization-lifecycle and privilege-governance weakness, subject to confirmation of the shared technical root cause. F-03 demonstrates that a hospital connector token with a 180-day lifetime and excessive `integration:all` scope can access functions outside its intended connector relationship. F-09 demonstrates that an administrator whose privileges were downgraded retained connector-profile write access through an existing session for approximately 27 minutes because authorization-cache invalidation was time-based rather than immediate.

Both findings concern the failure to ensure that effective permissions remain aligned with current, narrowly defined authorization decisions. The client context identifies authorization-cache behavior and token lifecycle management as related areas requiring investigation, but it does not conclusively establish that both manifestations arise from the same software defect or component. Consolidation therefore represents a proposed governance-level root-cause grouping, not proof of a single technical defect.

The consolidated remediation must address connector-specific token audiences and scopes, shorter credential lifetimes, immediate session and cache invalidation following privilege changes, centralized revocation, and verification of authorization at sensitive operations. Both original finding identifiers, evidence records, affected components, and remediation tests must remain independently traceable. If technical investigation identifies separate root causes, F-03 and F-09 must be retained as distinct findings rather than merged solely because both involve authorization.

## Consolidated Retained List

The following list carries forward all demonstrated security weaknesses that have not been conclusively retired. The environmental severities are based on the preceding recalibration matrix and remain subject to validation of the CVSS v3.1 vectors and environmental assumptions.

| Finding | Final severity | Carried to Task 6 |
| --- | --- | --- |
| F-01 — Cross-tenant diagnostic result access | High | Yes |
| F-02 — Stored active content in support case notes | Medium | Yes |
| F-03/09 — Authorization lifecycle and privilege governance (proposed merger) | High | Yes |
| F-04 — Disabled TLS peer verification in legacy connector worker | Medium (provisional) | Yes |
| F-05 — Unsigned partner sample-status webhook | High | Yes |
| F-06 — Excessive retention of diagnostic export packages | High | Yes |
| F-08 — Password-recovery account enumeration | Medium | Yes |
| F-10 — Caller-controlled laboratory identity in analytics service | High | Yes |

### Triage Decision and Traceability

F-01 is retained because cross-tenant access to diagnostic results was directly demonstrated and is not neutralized by the WAF or existing identity controls.

F-02 is retained because managed workstations and MFA do not prevent stored active content from executing in an authenticated support analyst's browser.

F-04 is retained because the legacy worker's disabled certificate verification remains a demonstrated configuration weakness. The managed mTLS gateway may reduce practical exploitability, but bypass resistance, certificate-validation enforcement, monitoring, and fail-closed behavior require verification before the finding can be retired.

F-05 is retained because source-IP allowlisting does not provide cryptographic message authenticity or prevent unauthorized sample-status changes from an approved or compromised source.

F-06 is retained because encryption at rest does not resolve the discrepancy between the documented 24-hour export expiry and the observed availability of an export approximately 29 days later.

F-08 is retained because differentiated password-recovery responses disclose account existence, while incomplete SSO/MFA coverage and IP-based throttling leave residual identity-attack opportunities.

F-10 is retained because direct application-network requests can supply an untrusted `X-Lab-ID` header and obtain another laboratory's analytics data, contrary to the intended tenant-isolation model.

F-07 is retired from the active vulnerability register because the inherited test evidence demonstrates use of an intended, pre-approved export capability rather than an unauthorized export or an approval bypass. Its original evidence, documented safeguards, and retirement rationale remain in the addendum. Verification of consistent enforcement across all production paths remains an outstanding control-assurance recommendation and is not represented as completed testing.

The consolidated retained list excludes F-07. The remaining findings continue into Task 6 for prioritization and remediation planning.

The proposed F-03/09 grouping is carried forward as one remediation workstream while preserving separate technical evidence and validation criteria. The final report must distinguish confirmed technical defects from provisional consolidation decisions and must not treat compensating controls as effective without evidence of their enforcement.
