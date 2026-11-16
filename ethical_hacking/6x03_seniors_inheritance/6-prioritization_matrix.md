# Risk Prioritization Matrix

## Prioritization Approach

This matrix establishes a risk-based remediation plan for MediPath Diagnostics, incorporating retained findings, environmental severity, attack-chain exposure, business impact, and existing compensating controls.

Priority definitions:

- P1 — Immediate: Urgent remediation of high-impact authorization, patient-data confidentiality, workflow-integrity, and privilege-management weaknesses.
- P2 — Quarterly: Planned remediation of significant weaknesses where compensating controls or additional validation requirements affect urgency.
- P3 — Backlog: Lower-priority improvements managed through routine security maintenance.

Indicative costs represent relative implementation effort, not approved financial expenditure.

Each item is assigned to an operational owner identified in MediPath's organization chart. The Technical Director provides engineering oversight, while the CISO coordinates risk treatment and reports progress to the audit committee.

## Remediation Prioritization Matrix

| Item | Priority | Owner | Timeline | Cost | Dependencies |
| --- | --- | --- | --- | --- | --- |
| F-01 — Cross-tenant diagnostic result access | P1 | Head of Platform Engineering | Immediate | Medium | Implement tenant ownership checks in the Results API and data-access layer; coordinate with the Data Platform Lead on F-10 and perform negative authorization tests. |
| F-02 — Stored XSS in support case notes | P1 | Support Operations Manager | Immediate | Medium | Coordinate technical fixes with the Technical Director; implement contextual output encoding, sanitize stored content, and validate CSP enforcement and support-session security. |
| F-03/09 — Connector authorization and privilege lifecycle | P1 | Identity and Access Management Lead | Immediate | High | Coordinate with the Integration Engineering Lead to restrict connector token scopes and lifetimes; implement immediate session revocation and authorization-cache invalidation; separately verify F-03 and F-09. |
| F-04 — Disabled TLS peer verification in legacy connector worker | P2 | Site Reliability Engineering Lead | Quarterly | Medium | Coordinate with the Integration Engineering Lead; verify managed mTLS gateway certificate enforcement, destination restrictions, bypass resistance, monitoring, and fail-closed behavior before restoring worker-side certificate validation. |
| F-05 — Unsigned partner sample-status webhook | P1 | Integration Engineering Lead | Immediate | Medium | Coordinate with the Product Owner, Diagnostic Workflow to validate permitted sample-state transitions; implement authenticated webhook signatures, replay protection, and partner identity binding. |
| F-06 — Excessive retention of diagnostic export packages | P2 | Head of Platform Engineering | Quarterly | Medium | Obtain retention-policy approval from the Data Protection Officer; implement automatic expiration, deletion, and verification of export-package access restrictions. |
| F-08 — Password-recovery account enumeration | P3 | Identity and Access Management Lead | Backlog | Low | Standardize account-recovery responses, implement account-based throttling, and review MFA coverage; coordinate with F-02 remediation for Chain 3. |
| F-10 — Caller-controlled laboratory identity in analytics service | P1 | Data Platform Lead | Immediate | Medium | Coordinate with the Head of Platform Engineering; enforce authenticated service-to-service communication and verified tenant claims instead of trusting caller-supplied X-Lab-ID headers. |
| Chain 1 — Connector-to-diagnostic cross-tenant exposure (F-03 → F-10 → F-01) | P1 | Head of Platform Engineering | Immediate | High | Coordinate implementation with the Identity and Access Management Lead, Integration Engineering Lead, and Data Platform Lead; complete F-03/09, F-10, and F-01 remediation and validate the conditional attack pivots. |
| Chain 2 — Support XSS to residual administrative privileges (F-02 → F-09) | P1 | Identity and Access Management Lead | Immediate | Medium | Coordinate with the Support Operations Manager; complete F-02 and F-09 remediation, enforce immediate privilege revocation, and verify administrative session and authorization boundaries. |
| Chain 3 — Account enumeration to support-session compromise (F-08 → F-02) | P2 | Support Operations Manager | Quarterly | Medium | Coordinate with the Identity and Access Management Lead; complete F-02 and F-08 remediation and validate case-submission permissions, authentication controls, and support-session boundaries. |

## Remediation Ownership and Accountability

### Technical Remediation Ownership

The Head of Platform Engineering owns corrective actions affecting core APIs, diagnostic result access, tenant isolation, and export-service implementation.

The Identity and Access Management Lead owns authentication and authorization controls, including service tokens, session management, privilege revocation, and password-recovery behavior.

The Integration Engineering Lead owns hospital connector security, partner webhook authentication, and integration-specific credential controls.

The Site Reliability Engineering Lead owns infrastructure security controls, including network restrictions, managed gateways, monitoring, and transport-security enforcement.

The Support Operations Manager owns the operational security of the support portal and support workforce. Application-level fixes are coordinated with the Technical Director, who is accountable for engineering delivery.

The Data Platform Lead owns analytics-service security, including laboratory-level access restrictions and verified tenant identity within analytics queries.

The Product Owner, Diagnostic Workflow validates the business rules and permitted transitions governing sample-status updates.

### Governance and Approval Responsibilities

The Technical Director is accountable for architecture, engineering delivery, and remediation assurance across technical teams.

The Chief Information Security Officer coordinates risk treatment, monitors remediation progress, and sponsors the remediation budget presented to the audit committee.

The Data Protection Officer approves applicable health-data retention requirements and evaluates privacy implications, particularly for F-01 and F-06.

The Compliance and HDS Manager coordinates audit evidence and ensures that remediation records support HDS renewal readiness.

The Chief Financial Officer reviews implementation cost assumptions and supports budget approval.

The Chief Executive Officer retains responsibility for strategic risk acceptance and business-continuity decisions.

These governance responsibilities do not replace the operational remediation owners identified in the matrix.

## Remediation Sequence

### Immediate Remediation

The Head of Platform Engineering must address F-01 to prevent unauthorized cross-laboratory access to diagnostic results.

The Data Platform Lead must remediate F-10 by enforcing verified tenant identity within the analytics service.

The Identity and Access Management Lead must remediate F-03/09 by restricting connector permissions and eliminating stale administrative privileges.

The Integration Engineering Lead must implement authenticated partner webhook processing for F-05.

The Support Operations Manager must coordinate remediation of F-02 with the Technical Director to prevent stored active content from executing in authenticated support sessions.

### Attack-Chain Validation

Chain 1 requires coordinated remediation of F-03/09, F-10, and F-01, followed by validation of the connector-to-analytics network path, identifier-discovery assumptions, and cross-tenant authorization boundaries.

Chain 2 requires correction of stored XSS and stale administrative authorization, followed by verification of session separation and privileged-action controls.

Chain 3 requires remediation of the support-portal XSS and password-recovery enumeration weaknesses, followed by validation of the account-access and case-submission prerequisites.

The inherited evidence establishes the individual weaknesses but does not demonstrate the complete attack chains end to end.

### Quarterly Remediation

The Site Reliability Engineering Lead must validate the managed mTLS gateway's enforcement and bypass resistance for F-04, coordinating connector-side changes with the Integration Engineering Lead.

The Head of Platform Engineering must implement retention enforcement for F-06 after the Data Protection Officer confirms the applicable retention policy.

Additional validation of Chain 3 must assess the feasibility of its intermediate attack steps and the effectiveness of authentication controls.

### Backlog Improvements

The Identity and Access Management Lead must address F-08 through uniform recovery responses, improved throttling, and authentication monitoring.

F-08 should be accelerated if additional evidence demonstrates a practical path to unauthorized account access or support-case submission.

## Remediation Verification and Closure

Every remediation owner must provide:

1. Documented corrective actions.
2. Configuration or implementation evidence.
3. Successful security regression testing.
4. Confirmation that related trust boundaries are enforced.
5. Evidence suitable for review by the CISO, Technical Director, and Compliance and HDS Manager.

Attack-chain remediation is considered complete only after the relevant operational owners have verified their individual fixes and the coordinated regression tests demonstrate that the identified attack paths are blocked.

F-07 remains retired from the active vulnerability register because the inherited test demonstrated an intended, pre-approved export capability rather than an unauthorized export. Verification of production enforcement across all export paths remains a separate control-assurance recommendation.

## Conclusion

The remediation matrix assigns each retained finding and attack chain to a specific operational role within MediPath's documented organization.

Technical implementation responsibilities are separated from executive oversight, regulatory approval, and budget governance.

This structure provides the CISO and audit committee with a defensible remediation sequence, clear accountability, and evidence-based closure criteria.
