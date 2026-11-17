# Penetration Test Report, MediPath Diagnostics

**Engagement reference:** VS-MPD-26-041  
**Reporting period:** 04–12 June 2026  
**Prepared by:** Junior Consultant, Vanguard Security  
**Technical assessment:** Sarah Chen, Senior Security Consultant  
**Distribution:** MediPath Diagnostics Audit Committee  
**Classification:** Confidential — Client Distribution Only

---

## 1. Executive Summary

The security assessment of MediPath Diagnostics examined how effectively the company protects patient information, laboratory operations, and trusted relationships with healthcare partners. MediPath serves 400 laboratories, manages 1.9 million active patient profiles, and generates €31.2 million in annual recurring revenue. The assessment confirmed weaknesses that could allow one laboratory to view another laboratory's patient results, permit unauthorized changes to sample-processing records, and leave sensitive business functions accessible longer than intended. These findings create risks to patient confidentiality, diagnostic workflow integrity, customer confidence, and regulatory readiness. No widespread patient-data breach, incorrect clinical result release, or successful combination of these weaknesses into a larger attack was demonstrated.

The audit committee should make four decisions. First, authorize immediate correction of patient-information access controls and require independent confirmation that laboratories can access only their own records. The modeled financial exposure for this weakness ranges from €90,000 to €2.31 million. Second, approve tighter access restrictions for healthcare partners and administrators, including prompt removal of permissions when responsibilities change; the associated scenario ranges from €75,000 to €1.60 million. Third, direct the company to strengthen the authenticity and reliability of sample-status updates before they affect diagnostic workflows. The corresponding financial scenario ranges from €40,000 to €1.25 million. Fourth, approve a coordinated, time-bound correction and independent verification program, with named owners, sufficient resources, and progress reporting to the committee. A hypothetical combination of weaknesses could produce losses ranging from €180,000 to €4.50 million. These figures represent conditional scenarios, not actual losses or forecasts, and must not be added together.

Even after the proposed corrections, some risk will remain because healthcare services depend on interconnected systems, external partners, and continuing operational changes. Management should require evidence that the most serious weaknesses have been corrected, confirm that existing safeguards work as intended, and document any unresolved exposure. The CISO and Technical Director should report progress and exceptions to the committee within its eight-week decision window, while the DPO and compliance leadership prepare supporting evidence for the upcoming health-data hosting certification renewal. The committee should formally accept only clearly explained residual risks, with accountable owners and agreed review dates.

---

## 2. Engagement Scope and Methodology

### 2.1 Engagement Objectives

Vanguard Security was engaged to evaluate the security of MediPath Diagnostics' production-equivalent staging environment and approved integration endpoints.

The assessment focused on identifying weaknesses that could affect patient-data confidentiality, diagnostic workflow integrity, laboratory tenant isolation, healthcare partner integrations, and administrative access.

MediPath operates a healthcare software platform supporting prescription intake, sample tracking, diagnostic result delivery, and hospital information-system integrations.

Its operations span France, Belgium, and the Netherlands. The company employs approximately 180 people and supports 400 contracted medical-analysis laboratories.

The platform processes approximately 62,000 samples per business day and delivers approximately 14 million diagnostic result documents annually.

Given this operational scale, security weaknesses must be assessed not only by technical severity but also by their potential effect on patients, laboratory customers, contractual commitments, and regulatory obligations.

### 2.2 Assessment Scope

The authorized assessment covered:

- Public-facing web and application interfaces.
- Patient diagnostic result access and export services.
- Laboratory tenant authorization boundaries.
- Hospital integration gateways and connector permissions.
- Partner sample-status notification interfaces.
- Internal support and administrative applications.
- Authentication, authorization, and session management.
- Internal analytics access controls.
- Relevant configuration and compensating-control evidence.

Testing was performed using approved synthetic laboratory accounts, synthetic patient records, and authorized integration identities.

The following activities were outside the engagement scope:

- Destructive testing.
- Denial-of-service testing.
- Social engineering.
- Access to production patient records.
- Testing of third-party laboratory infrastructure.
- Interference with managed connectivity infrastructure.
- Unapproved exploitation beyond the defined testing boundaries.

### 2.3 Assessment Methodology

The initial technical assessment was performed by Sarah Chen, Senior Security Consultant, during 04–12 June 2026.

Her work combined authenticated application and API testing, authorization-boundary analysis, integration-path review, configuration inspection, and controlled validation using synthetic records.

The original assessment documented ten findings, F-01 through F-10, with supporting evidence and CVSS v3.1 base scores.

The subsequent consultant review did not repeat the penetration test. Instead, it translated the established technical findings into an environment-specific assessment suitable for MediPath's audit committee.

The review consisted of six activities:

1. Examination of the original technical findings and supporting evidence.
2. Assessment of MediPath's architecture, asset criticality, and compensating controls.
3. Reconsideration of severity and remediation priority in the client environment.
4. Identification of related findings and potential multi-stage attack scenarios.
5. Quantification of conditional business impact using client-supplied financial assumptions.
6. Assignment of remediation ownership, timelines, and management reporting requirements.

### 2.4 Severity and Prioritization Approach

CVSS v3.1 base scores are retained as the technical reference for each original finding.

Environmental interpretation considers the confidentiality, integrity, and availability requirements of affected assets, together with the demonstrated coverage of compensating controls.

Remediation priority is determined separately from CVSS severity.

The following operational priority model is applied:

| Priority | Treatment |
| --- | --- |
| P1 — Immediate | Begin containment and corrective action within the twelve-day delivery window. |
| P2 — Quarterly | Implement planned remediation during the next quarterly improvement cycle, with interim monitoring. |
| P3 — Backlog | Schedule proportionate corrective action through the managed security backlog. |

A compensating control is credited only to the extent supported by evidence of its coverage and enforcement.

Environmental severity must not be reduced merely because a security control is documented.

---

## 3. Findings Synthesis

### 3.1 Overall Assessment

The assessment identified eight retained remediation items covering nine original technical findings. F-03 and F-09 are managed as one coordinated authorization workstream while retaining separate technical evidence.

F-07 has been retired following review of the authorized bulk-export workflow.

The retained findings include five P1 items, two P2 items, and one P3 item.

Three additional attack-chain scenarios were identified to illustrate how individual weaknesses could interact under specific conditions. These chains were not demonstrated end to end.

The most significant risks concern:

- Unauthorized access to another laboratory's patient information.
- Excessive permissions in trusted healthcare integrations.
- Unauthorized changes to diagnostic sample status.
- Inadequate tenant isolation in internal analytics.
- Delayed removal of administrative privileges.
- Malicious content executed in the internal support environment.

### 3.2 F-01 — Cross-Tenant Diagnostic Result Access

**Original CVSS v3.1:** 8.1 — High  
**Priority:** P1 — Immediate  
**Affected component:** Results API  
**Remediation owner:** Head of Platform Engineering  
**Business impact:** €90,000 / €660,000 / €2,310,000 (Low / Central / High)

#### Technical Description

The results service authenticates requests but does not consistently verify that the requested diagnostic result belongs to the laboratory associated with the requesting user.

During authorized testing, a synthetic laboratory operator retrieved a diagnostic result belonging to another synthetic laboratory by changing the requested result identifier.

The response included patient identity, test name, collection time, and result status.

This demonstrates a failure of tenant-level authorization for sensitive health information.

#### Environmental Assessment and Correction Note

Sarah's original High base severity remains technically justified.

The environmental assessment places particular emphasis on the very high confidentiality and integrity requirements of diagnostic records, the 400-laboratory tenant model, and the sensitivity of personal health information under GDPR Article 9.

Existing web filtering and authentication controls do not correct missing authorization at the application data-access layer.

**Correction note:** The base score is retained. The client-specific assessment elevates remediation urgency because the demonstrated weakness crosses a regulated patient-data boundary.

#### Business Impact

The modeled loss ranges from €90,000 to €2.31 million, with a central scenario of €660,000.

Potential costs include incident investigation, legal and privacy response, conditional regulatory and HDS-related corrective work, and laboratory contract losses.

The central scenario assumes a broader but hypothetical exposure affecting approximately ten laboratories and 10,000 patient records.

These figures do not represent an observed breach.

#### Attack Chain Context

F-01 is the potential final exposure point in Chain 1.

The proposed connection from connector access through internal analytics to patient results has not been demonstrated.

#### Remediation

- Enforce tenant ownership checks at the data-access layer.
- Derive laboratory identity from authenticated and verified context.
- Reject cross-tenant requests regardless of identifier validity.
- Add automated negative authorization tests.
- Review access logs for anomalous cross-tenant requests.
- Independently retest affected result-access paths.

**Timeline:** Immediate corrective action within the twelve-day window.

### 3.3 F-02 — Stored Active Content in Support Notes

**Original CVSS v3.1:** 6.1 — Medium  
**Priority:** P1 — Immediate  
**Affected component:** Internal support portal  
**Remediation owner:** Support Operations Manager  
**Business impact:** €25,000 / €140,000 / €740,000

#### Technical Description

Laboratory case notes accept content that is rendered without sufficient output encoding in the internal support portal.

An approved test marker executed when a support analyst opened a synthetic case.

The marker changed the page title and initiated a same-origin request to the analyst profile endpoint.

No credential theft, administrative takeover, or persistent compromise was demonstrated.

#### Environmental Assessment and Correction Note

Sarah's Medium base score is retained.

MediPath's managed workstations and multifactor authentication reduce some account-misuse risks but do not prevent malicious content from executing within an authenticated support session.

Support analysts may work across multiple laboratory tenants, increasing the operational significance of the affected interface.

**Correction note:** The technical base rating is unchanged. Remediation priority is increased to P1 because the affected support workflow can expose cross-laboratory operational context.

#### Business Impact

Conditional losses range from €25,000 to €740,000, with a central scenario of €140,000.

These costs include investigation, support-system recovery, legal review where required, and potential customer churn.

The higher scenario depends on additional consequences not demonstrated during testing.

#### Attack Chain Context

F-02 contributes to Chains 2 and 3.

Both scenarios require additional conditions before a broader compromise could occur.

#### Remediation

- Apply contextual output encoding.
- Sanitize previously stored rich-text content.
- Enforce an appropriate browser content security policy after compatibility testing.
- Restrict unnecessary support-session privileges.
- Add regression tests for stored content.
- Review support-portal monitoring and session controls.

**Timeline:** Immediate.

### 3.4 F-03/09 — Connector Authorization and Privilege Lifecycle

**Original CVSS v3.1:** F-03: 8.8 — High; F-09: 7.2 — High  
**Priority:** P1 — Immediate  
**Affected components:** Hospital Integration Gateway; administrative authorization cache  
**Remediation owner:** Identity and Access Management Lead  
**Business impact:** €75,000 / €465,000 / €1,600,000

#### Technical Description

F-03 concerns a hospital integration token with an excessive `integration:all` permission scope and a 180-day lifetime.

Testing confirmed that a synthetic connector token was accepted by a function associated with another connector profile.

F-09 concerns delayed administrative privilege revocation.

After a synthetic administrator was downgraded to a read-only role, the existing session retained connector-profile write privileges for approximately 27 minutes. A newly created session correctly received read-only permissions.

Both findings concern authorization lifecycle controls, although a common technical root cause has not been confirmed.

#### Environmental Assessment and Correction Note

The original High base scores remain relevant.

The private integration network reduces exposure to some external paths but does not justify broad token permissions.

Likewise, periodic access reviews and multifactor authentication do not guarantee immediate revocation of active sessions.

**Correction note:** F-03 and F-09 are consolidated for remediation governance because both require coordinated identity and authorization lifecycle improvements. Their original technical observations and CVSS base scores remain separate; a shared root cause is not asserted.

#### Business Impact

The combined remediation workstream has a conditional loss range of €75,000 to €1.60 million, with a central estimate of €465,000.

The modeled costs cover credential and session recovery, investigation, partner coordination, potential regulatory response, and laboratory churn.

This is a consolidated scenario, not the sum of two independently realized incidents.

#### Attack Chain Context

F-03 is an entry condition in Chain 1.

F-09 is a potential enabling condition in Chain 2.

Neither proposed attack chain was demonstrated end to end.

#### Remediation

- Replace broad connector permissions with narrowly scoped, partner-specific authorization.
- Bind tokens to verified connector and tenant identities.
- Shorten token lifetimes.
- Centralize token and session revocation.
- Invalidate active authorization state immediately after role changes.
- Test access removal across existing and newly established sessions.
- Review privileged-action monitoring.

**Timeline:** Immediate.

### 3.5 F-04 — Disabled TLS Peer Verification

**Original CVSS v3.1:** 8.2 — High  
**Priority:** P2 — Quarterly  
**Affected component:** Legacy hospital connector worker  
**Remediation owner:** Site Reliability Engineering Lead  
**Business impact:** €15,000 / €85,000 / €450,000

#### Technical Description

A legacy connector worker is configured with `verify_peer=false`, disabling certificate verification at the worker level.

However, the documented architecture routes connector traffic through a managed private gateway that establishes mutual TLS, validates upstream certificates, and restricts permitted destinations.

Direct interception was not attempted because the engagement rules prohibited interference with the managed connectivity layer.

#### Environmental Assessment and Correction Note

The original High base score describes the worker configuration without fully incorporating the surrounding network architecture.

The managed gateway provides a potentially significant compensating control.

However, the effectiveness of that control depends on verified enforcement, absence of bypass routes, and appropriate failure behavior.

**Correction note:** The operational priority is reduced from an immediate High-risk treatment to P2 because the managed gateway provides documented certificate validation and network restrictions. This adjustment remains conditional on verification of gateway enforcement and bypass resistance; the original base score is preserved.

#### Business Impact

Conditional losses range from €15,000 to €450,000, with a central scenario of €85,000.

The higher scenario requires an unverified gateway bypass or failure leading to confidentiality or integrity consequences.

#### Remediation

- Enable certificate verification in the legacy worker.
- Confirm certificate-chain compatibility.
- Verify that all relevant traffic passes through the managed gateway.
- Test bypass resistance and fail-closed behavior.
- Review gateway monitoring and alerting.

**Timeline:** Quarterly, with early validation of the compensating control.

### 3.6 F-05 — Unsigned Sample-Status Webhook

**Original CVSS v3.1:** 7.5 — High  
**Priority:** P1 — Immediate  
**Affected component:** Partner sample-status interface  
**Remediation owner:** Integration Engineering Lead  
**Business impact:** €40,000 / €290,000 / €1,250,000

#### Technical Description

The partner webhook accepts sample-status notifications without a cryptographic signature binding the message to an authorized partner.

Source IP allowlisting is present but does not independently verify message authenticity or integrity.

During testing from the approved partner test range, a synthetic sample status was changed from `received` to `validated` using a modified request.

No incorrect clinical result release or patient injury was demonstrated.

#### Environmental Assessment and Correction Note

Sarah's High base severity remains justified.

The environmental assessment emphasizes the very high integrity and availability requirements of MediPath's diagnostic workflow.

A false sample status could cause operational reconciliation work or disrupt trusted laboratory processes.

**Correction note:** The base score is retained. Immediate remediation priority is reinforced by the diagnostic workflow's sensitivity to unauthorized state changes, despite the existing source IP restrictions.

#### Business Impact

The modeled range is €40,000 to €1.25 million, with a central scenario of €290,000.

The central scenario assumes approximately 1,000 affected sample-status events and potential loss of one laboratory contract.

The high scenario assumes a substantially broader operational reconciliation effort.

Clinical injury and incorrect diagnostic result release are excluded from the demonstrated impact.

#### Remediation

- Require partner-specific cryptographic message signatures.
- Verify timestamps and reject replayed events.
- Bind each event to an authenticated partner identity.
- Enforce permitted sample-state transitions.
- Add reconciliation alerts for abnormal status changes.
- Coordinate validation with the Product Owner, Diagnostic Workflow.

**Timeline:** Immediate.

### 3.7 F-06 — Excessive Export Retention

**Original CVSS v3.1:** 6.5 — Medium  
**Priority:** P2 — Quarterly  
**Affected component:** Diagnostic export service  
**Remediation owner:** Head of Platform Engineering  
**Business impact:** €20,000 / €210,000 / €1,130,000

#### Technical Description

MediPath's documented export retention period is 24 hours.

Testing confirmed that a synthetic export created 29 days earlier remained downloadable through the authorized test account.

The underlying storage was encrypted, but application access continued beyond the documented expiration period.

The observation establishes a retention-control failure, not an unauthorized data breach.

#### Environmental Assessment and Correction Note

The original Medium base score remains appropriate as a technical reference.

The environmental assessment increases the significance of the finding because exported packages may contain regulated personal health information.

Encryption at rest does not resolve excessive retention.

**Correction note:** The technical base score is retained. The final assessment adds explicit privacy and HDS accountability considerations while distinguishing retention noncompliance from proven unauthorized disclosure.

#### Business Impact

The conditional loss range is €20,000 to €1.13 million, with a central estimate of €210,000.

The high scenario depends on subsequent unauthorized exposure, which was not observed.

#### Remediation

- Align application link validity with approved retention rules.
- Enforce object expiration and deletion.
- Validate that expired packages cannot be regenerated or accessed.
- Record deletion evidence.
- Obtain DPO approval of the applicable retention policy.
- Include retention verification in HDS audit preparation.

**Timeline:** Quarterly.

### 3.8 F-08 — Password-Recovery Account Enumeration

**Original CVSS v3.1:** 5.3 — Medium  
**Priority:** P3 — Backlog  
**Affected component:** Laboratory password recovery  
**Remediation owner:** Identity and Access Management Lead  
**Business impact:** €5,000 / €35,000 / €210,000

#### Technical Description

The password-recovery function returns different responses for registered and unregistered email addresses.

Synthetic registered accounts received `reset_requested`, while unknown accounts received `account_not_found`.

This permits identification of valid account names.

The finding does not establish credential theft or account takeover.

#### Environmental Assessment and Correction Note

The original Medium base score remains the technical reference.

MediPath reports single sign-on and multifactor authentication coverage for approximately 82% of laboratory users, together with source-address rate limiting.

These controls reduce some downstream risks but do not remove account enumeration.

**Correction note:** The finding is retained but assigned P3 because its demonstrated impact is limited to account identification, with no proven compromise and partial mitigation through existing identity controls.

#### Business Impact

Conditional losses range from €5,000 to €210,000, with a central scenario of €35,000.

The modeled costs concern investigation, monitoring, and account-security support rather than an assumed successful takeover.

#### Remediation

- Return uniform password-recovery responses.
- Introduce account-aware throttling.
- Monitor unusual recovery activity.
- Maintain multifactor authentication coverage.
- Test for response differences in content and timing.

**Timeline:** Managed backlog.

### 3.9 F-10 — Caller-Controlled Laboratory Identity in Analytics

**Original CVSS v3.1:** 8.0 — High  
**Priority:** P1 — Immediate  
**Affected component:** Internal analytics query service  
**Remediation owner:** Data Platform Lead  
**Business impact:** €35,000 / €220,000 / €970,000

#### Technical Description

The internal analytics service trusts the `X-Lab-ID` header normally supplied by the API gateway.

The service is also reachable from the application network, where a caller can supply the header directly.

During authorized testing, changing this header returned aggregate diagnostic activity associated with another synthetic laboratory.

The demonstrated exposure concerns cross-laboratory aggregate analytics.

Patient-level result access through this service was not established.

#### Environmental Assessment and Correction Note

Sarah's High base severity remains appropriate.

The environmental assessment recognizes the internal-network prerequisite but also the significance of bypassing laboratory tenant isolation.

The gateway's normal identity handling does not protect a service that accepts unverified identity information through an alternative route.

**Correction note:** The base severity is retained. Immediate remediation priority reflects the demonstrated trust-boundary failure, while the unverified patient-result pivot is excluded from the confirmed impact.

#### Business Impact

The modeled range is €35,000 to €970,000, with a central scenario of €220,000.

Potential costs include investigation, correction of analytics access controls, privacy review, and conditional customer churn.

#### Attack Chain Context

F-10 is a potential intermediate step in Chain 1.

Reachability from the connector identity and discovery of patient-result identifiers remain unverified.

#### Remediation

- Authenticate service-to-service requests.
- Derive tenant identity from verified authorization claims.
- Reject caller-controlled laboratory identity headers.
- Restrict direct access paths that bypass the gateway.
- Add cross-tenant analytics regression tests.
- Review internal service identity and network policies.

**Timeline:** Immediate.

### 3.10 Combined Attack Scenarios

Three potential attack chains were evaluated.

These scenarios illustrate how separate weaknesses might interact. They are not confirmed end-to-end compromises.

| Chain | Components | Priority | Low | Central | High |
| --- | --- | --- | ---: | ---: | ---: |
| Chain 1 | F-03 → F-10 → F-01 | P1 | €180,000 | €1,300,000 | €4,500,000 |
| Chain 2 | F-02 → F-09 | P1 | €60,000 | €420,000 | €2,050,000 |
| Chain 3 | F-08 → F-02 | P2 | €30,000 | €180,000 | €950,000 |

**Chain 1** represents a possible progression from excessive connector permissions to cross-laboratory analytics and then diagnostic result exposure. The connector-to-analytics path and the final pivot have not been verified.

**Chain 2** considers whether malicious support content could interact with an administrative session retaining previously granted permissions. The required session overlap and escalation conditions remain unverified.

**Chain 3** considers whether account enumeration could support a separate account-compromise or social-engineering attempt leading to malicious support content. Enumeration alone does not provide account access.

The financial ranges are scenario-based estimates. They must not be added to individual finding estimates because investigation, notification, recovery, and customer-loss costs overlap.

---

## 4. Addendum: Retired and Merged Findings

### 4.1 F-07 — Retired: Authorized Bulk Patient Export

**Original CVSS v3.1:** 9.1 — Critical  
**Final disposition:** Retired from the active vulnerability register

Sarah's technical assessment identified a Support Manager role capable of initiating a bulk export containing synthetic patient information across multiple laboratories.

The subsequent client-context review established that this function supports an approved emergency and regulatory-response workflow.

The documented production safeguards include:

- A DPO-approved case ticket.
- WebAuthn step-up authentication.
- Dual approval by the Support Operations Manager and DPO delegate.
- Encryption using a case-specific key.
- Seven-day package expiry.
- Immutable audit logging.

The engagement test role had been temporarily pre-approved to exercise this functionality.

**Neutral correction note:** The original technical observation is valid, but the subsequent authorization and control evidence changes its interpretation. The observed export is consistent with an intended, controlled business process rather than a demonstrated unauthorized capability.

Accordingly, F-07 is retired as a false positive in the active vulnerability register.

This decision remains subject to confirming that all production execution paths enforce the mandatory ticket, approvals, and audit requirements.

The observation and original evidence remain traceable for future audit review.

### 4.2 F-03 and F-09 — Consolidated Remediation Workstream

F-03 concerns excessive connector-token permissions and token lifetime.

F-09 concerns delayed revocation of administrative privileges in existing sessions.

Both findings require improvements to authorization lifecycle management, revocation, and identity governance.

**Neutral correction note:** The findings are consolidated for remediation ownership and reporting efficiency, not because a common underlying technical defect has been conclusively demonstrated.

Both original finding identifiers, CVSS base scores, and supporting evidence remain preserved.

The combined workstream must include separate verification tests for connector-token scope and administrative-session revocation.

### 4.3 Finding Register Reconciliation

| Original finding | Final disposition | Explanation |
| --- | --- | --- |
| F-01 | Retained | Confirmed cross-tenant result access |
| F-02 | Retained | Confirmed stored active content |
| F-03 | Retained; managed with F-09 | Excessive connector permissions |
| F-04 | Retained; priority adjusted | Managed gateway provides conditional mitigation |
| F-05 | Retained | Unsigned sample-status updates |
| F-06 | Retained | Export retention beyond documented policy |
| F-07 | Retired | Authorized controlled bulk-export workflow |
| F-08 | Retained; lower operational priority | Account enumeration without proven takeover |
| F-09 | Retained; managed with F-03 | Delayed administrative privilege revocation |
| F-10 | Retained | Cross-tenant analytics access |

---

## 5. Strategic Recommendations

### 5.1 Short-Term Actions — Twelve-Day Window

The first twelve days should focus on reducing exposure from the confirmed P1 findings and establishing evidence of effective corrective action.

**Patient-data access protection**

The Head of Platform Engineering should correct tenant-level authorization in the results service and demonstrate that cross-laboratory result requests are consistently rejected.

**Identity and authorization governance**

The Identity and Access Management Lead should restrict connector permissions, review long-lived tokens, and implement prompt revocation of administrative access after role changes.

**Diagnostic workflow integrity**

The Integration Engineering Lead should introduce authenticated and integrity-protected sample-status notifications, together with replay protection and strict state-transition validation.

**Internal analytics isolation**

The Data Platform Lead should ensure that laboratory identity is established through trusted authorization rather than caller-controlled request fields.

**Support portal protection**

The Support Operations Manager should coordinate correction of unsafe note rendering and verify that existing and newly submitted notes cannot execute unauthorized content.

**Independent validation**

The CISO and Technical Director should require evidence-based retesting of completed P1 corrections.

If a complete fix cannot be delivered within the window, the responsible owner must document interim containment, residual exposure, and a committed completion date.

### 5.2 Medium-Term Actions — Quarterly Improvement Cycle

The quarterly program should address the remaining P2 findings and systemic control improvements.

Priority activities include:

- Enabling certificate verification in legacy connector workers.
- Confirming the managed gateway cannot be bypassed.
- Aligning export retention with approved policy.
- Automating deletion and expiration verification.
- Strengthening security monitoring for cross-tenant access.
- Reviewing service identities and privileged access lifecycle controls.
- Adding authorization and workflow-integrity tests to release pipelines.
- Completing proportionate remediation of password-recovery enumeration.

Quarterly planning must not delay containment where a compensating control is found to be ineffective.

### 5.3 Governance-Level Recommendations

The audit committee should approve a coordinated security remediation program with clearly defined accountability.

The CISO should maintain a consolidated risk register that records:

- Confirmed findings and associated evidence.
- Technical and operational priority.
- Accountable remediation owners.
- Target completion dates.
- Required verification evidence.
- Open dependencies and unresolved assumptions.
- Residual risk and management acceptance decisions.

The CFO should review proposed expenditure against the modeled loss scenarios without treating conditional estimates as guaranteed savings.

The DPO should assess whether any confirmed facts require additional privacy investigation, regulatory notification analysis, or changes to retention policy.

The Compliance and HDS Manager should maintain evidence of remediation and control effectiveness for the upcoming HDS renewal audit.

The CEO and board observer should receive a concise progress dashboard covering overdue P1 actions, unresolved material risks, and decisions requiring committee approval.

Within the eight-week governance decision period, the committee should formally record remediation approvals, resource commitments, and any residual risks accepted by management.

---

## 6. Limitations and Uncertainty

### 6.1 Testing Boundaries

This report relies on the completed technical testing performed during the authorized engagement.

No additional penetration testing was conducted during the final consultant review.

The assessment used a production-equivalent staging environment and synthetic patient and laboratory records.

Consequently, the findings demonstrate weaknesses in the tested environment but do not establish the occurrence of equivalent incidents involving real patients.

Destructive testing, denial-of-service testing, social engineering, production patient-data access, and third-party infrastructure testing were excluded.

### 6.2 Unverified Technical Conditions

Several important questions remain unresolved.

For F-04, the managed gateway's actual bypass resistance and failure behavior require further verification.

For F-07, consistent enforcement of the approval workflow across all production paths remains an audit-validation requirement.

For F-03 and F-09, a shared technical root cause has not been confirmed.

For F-05, the assessment did not demonstrate incorrect clinical result release or patient injury.

For F-10, access to patient-level diagnostic results through the analytics service was not demonstrated.

None of the three attack chains was executed successfully from beginning to end.

These limitations must be preserved when communicating risk to the audit committee.

### 6.3 Environmental Severity Uncertainty

CVSS v3.1 base scores are inherited from the original technical assessment.

Environmental interpretation reflects asset criticality and the documented compensating controls.

However, a fully reproducible numerical environmental score requires confirmed Modified Base Metrics, Security Requirements, and calculator outputs.

Where control effectiveness or an attack prerequisite remains unverified, this report does not claim a validated numerical environmental score.

Operational priority is therefore presented separately from the original technical base score.

Any final numerical environmental recalibration must be reconciled with the validated CVSS v3.1 calculation record before formal sign-off.

### 6.4 Financial Uncertainty

The financial scenarios are illustrative estimates based on MediPath's supplied operating and revenue assumptions.

They are not actual incident costs, statistical expected losses, or predictions of regulatory sanctions.

The estimates consider investigation, remediation, legal and privacy response, operational disruption, and possible laboratory churn.

MediPath's cyber-insurance deductible is €250,000. It must not automatically be treated as an additional loss for every scenario.

The existing €180,000 annual incident-response retainer is a pre-existing operating cost and is not automatically an incremental incident expense.

GDPR penalties depend on the facts of a violation and the supervisory authority's assessment. The statutory maximum is not an expected fine.

The financial impact of different findings and attack chains must not be summed because the scenarios share possible costs and consequences.

### 6.5 Regulatory and Certification Uncertainty

The presence of a vulnerability does not automatically establish a reportable personal-data breach.

The DPO must assess notification obligations using verified incident facts.

Similarly, an identified weakness does not automatically result in loss of HDS certification.

Certification implications depend on the applicable requirements, audit findings, severity of nonconformities, and effectiveness of corrective action.

### 6.6 Residual Risk

Successful remediation will reduce identified exposure but cannot establish the absence of all vulnerabilities.

Residual risks include undiscovered weaknesses, changes in system architecture, partner dependencies, and incomplete coverage of automated controls.

Management should accept residual risks only when the remaining exposure, justification, accountable owner, and review date are documented.

---

## 7. Appendices

### Appendix A — Detailed Finding Register

| Finding | Original CVSS v3.1 | Priority | Low | Central | High | Owner | Timeline |
| --- | --- | --- | ---: | ---: | ---: | --- | --- |
| F-01 | 8.1 High | P1 | €90,000 | €660,000 | €2,310,000 | Head of Platform Engineering | Immediate |
| F-02 | 6.1 Medium | P1 | €25,000 | €140,000 | €740,000 | Support Operations Manager | Immediate |
| F-03/09 | 8.8 / 7.2 High | P1 | €75,000 | €465,000 | €1,600,000 | Identity and Access Management Lead | Immediate |
| F-04 | 8.2 High | P2 | €15,000 | €85,000 | €450,000 | Site Reliability Engineering Lead | Quarterly |
| F-05 | 7.5 High | P1 | €40,000 | €290,000 | €1,250,000 | Integration Engineering Lead | Immediate |
| F-06 | 6.5 Medium | P2 | €20,000 | €210,000 | €1,130,000 | Head of Platform Engineering | Quarterly |
| F-08 | 5.3 Medium | P3 | €5,000 | €35,000 | €210,000 | Identity and Access Management Lead | Backlog |
| F-10 | 8.0 High | P1 | €35,000 | €220,000 | €970,000 | Data Platform Lead | Immediate |

**Register note:** F-07 is excluded from the active register. F-03 and F-09 retain separate technical identities within one coordinated remediation workstream.

#### Business Impact Assumptions

| Item | Central scenario assumption |
| --- | --- |
| F-01 | Approximately 10 laboratories and 10,000 patient records potentially affected; five laboratory contracts lost |
| F-02 | Support investigation and recovery, with conditional privacy response |
| F-03/09 | Connector and session recovery, partner coordination, and conditional customer loss |
| F-04 | Gateway and connector verification, without assuming confirmed interception |
| F-05 | Approximately 1,000 sample-status events requiring investigation; one laboratory contract lost |
| F-06 | Retention correction, legal review, and conditional incident response |
| F-08 | Investigation and account-security support without proven takeover |
| F-10 | Cross-laboratory aggregate analytics exposure affecting approximately 10 laboratories |

MediPath's average annual laboratory contract value is approximately €78,000.

One percent laboratory churn corresponds to approximately €312,000 in annual recurring revenue, while five percent corresponds to approximately €1.56 million.

A core-platform outage has a supplied direct exposure estimate of €65,000–€120,000 per hour.

No outage was demonstrated by the tested findings; outage costs are therefore not automatically added to the scenarios.

### Appendix B — CVSS v3.1 Environmental Assessment

#### B.1 Calculation Method

The environmental assessment uses the CVSS v3.1 framework.

The original base vector is retained for traceability.

Environmental analysis considers:

- Confidentiality Requirement (CR).
- Integrity Requirement (IR).
- Availability Requirement (AR).
- Modified Attack Vector (MAV).
- Modified Attack Complexity (MAC).
- Modified Privileges Required (MPR).
- Modified User Interaction (MUI).
- Modified Scope (MS).
- Modified Confidentiality, Integrity, and Availability impacts (MC, MI, MA).

The environmental score is calculated using the CVSS v3.1 Modified Impact and Modified Exploitability equations, including the relevant security-requirement weights.

A score must not be represented as validated unless the full environmental vector and calculation have been checked.

#### B.2 Original Base Vectors and Environmental Considerations

| Finding | Original CVSS v3.1 base vector | Environmental considerations |
| --- | --- | --- |
| F-01 | `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N` | Very high confidentiality and integrity requirements for patient results; authentication does not enforce tenant ownership |
| F-02 | `CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:C/C:L/I:L/A:N` | Managed support devices and MFA; cross-tenant support access and demonstrated browser execution |
| F-03 | `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H` | High connector credential criticality; private network restrictions; excessive authorization remains exploitable |
| F-04 | `CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:L` | Managed gateway certificate validation, private connectivity, and unverified bypass resistance |
| F-05 | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N` | Very high diagnostic workflow integrity requirement; source IP restrictions do not authenticate message content |
| F-06 | `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N` | High health-data confidentiality requirement; encrypted storage but excessive access duration |
| F-07 | `CVSS:3.1/AV:N/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:N` | Retired after confirmation of approved workflow and mandatory controls; no active environmental score assigned |
| F-08 | `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N` | Limited demonstrated disclosure; rate limiting and substantial MFA coverage |
| F-09 | `CVSS:3.1/AV:N/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:N` | High administrative integrity requirement; delayed authorization invalidation |
| F-10 | `CVSS:3.1/AV:A/AC:L/PR:L/UI:N/S:U/C:H/I:L/A:N` | Internal-network prerequisite; demonstrated cross-tenant aggregate-data access |

#### B.3 Environmental Recalibration Decisions

**F-01:** Retain High technical severity. Patient-result confidentiality and tenant isolation justify immediate operational priority.

**F-02:** Retain Medium base severity. Increase operational priority because support analysts have access to multiple laboratory contexts.

**F-03:** Retain High base severity. Network restrictions do not compensate for excessive connector authorization.

**F-04:** Retain the original base score for technical traceability. Assign P2 provisionally because of the managed gateway; do not claim a verified reduced numerical environmental score until gateway enforcement is validated.

**F-05:** Retain High severity. The diagnostic workflow's integrity requirements support immediate remediation.

**F-06:** Retain Medium base severity. Incorporate regulatory accountability and retention requirements into remediation planning.

**F-07:** Retire as an active finding after reviewing the authorized export workflow and its documented safeguards.

**F-08:** Retain Medium base severity while assigning P3 operational priority because account compromise was not demonstrated.

**F-09:** Retain High base severity. Manage alongside F-03 without assuming an identical root cause.

**F-10:** Retain High base severity. Prioritize correction of the internal tenant-identity trust boundary.

#### B.4 Calculation Validation Requirement

The table above documents the inherited base vectors and environmental reasoning. It does not substitute for a numerical CVSS v3.1 environmental calculation.

Before final technical sign-off, the Technical Director and CISO should verify any numerical environmental scores against a CVSS v3.1 calculator, recording the complete environmental vector, calculated result, and evidence supporting each modified metric.

This distinction prevents unsupported precision where the available evidence does not establish all environmental metric values.

### Appendix C — Attack Chain Diagrams

#### C.1 Chain 1 — Connector to Patient-Result Exposure

```text
F-03: Excessive hospital connector permissions
                    |
                    v
Unverified access to internal analytics path
                    |
                    v
F-10: Caller-controlled laboratory identity
                    |
                    v
Unverified discovery or transfer of result identifiers
                    |
                    v
F-01: Cross-tenant diagnostic result access
                    |
                    v
Potential patient-data confidentiality impact
```

**Priority:** P1  
**Conditional financial range:** €180,000–€4,500,000  
**Central scenario:** €1,300,000

**Evidence boundary:** The individual weaknesses were observed. Connector-to-analytics reachability and the complete progression to patient results were not demonstrated.

#### C.2 Chain 2 — Support Content to Residual Administrative Privileges

```text
F-02: Malicious content in support case notes
                    |
                    v
Support analyst opens affected case
                    |
                    v
Unverified privileged-session interaction
                    |
                    v
F-09: Existing session retains previous permissions
                    |
                    v
Potential unauthorized administrative changes
```

**Priority:** P1  
**Conditional financial range:** €60,000–€2,050,000  
**Central scenario:** €420,000

**Evidence boundary:** Browser execution and delayed privilege revocation were demonstrated separately. Their combination was not validated.

#### C.3 Chain 3 — Account Enumeration to Support Compromise

```text
F-08: Account existence can be identified
                    |
                    v
Additional phishing or account-compromise prerequisite
                    |
                    v
Potential submission of malicious support content
                    |
                    v
F-02: Stored content executes in support portal
                    |
                    v
Potential support-session misuse
```

**Priority:** P2  
**Conditional financial range:** €30,000–€950,000  
**Central scenario:** €180,000

**Evidence boundary:** Account enumeration does not itself provide account access. The intermediate compromise and full chain remain hypothetical.

### Appendix D — Glossary

| Term | Explanation |
| --- | --- |
| Penetration test | An authorized security assessment that attempts to identify and validate weaknesses in systems or applications |
| CVSS | A standardized framework for expressing the technical severity of vulnerabilities |
| Base score | A technical severity score describing a vulnerability independently of a particular organization's environment |
| Environmental assessment | Evaluation of vulnerability severity in the context of an organization's assets, requirements, and controls |
| Tenant isolation | Separation that prevents one customer from accessing another customer's information |
| Authorization | The process of determining which resources or actions an authenticated identity may access |
| Multifactor authentication | Authentication requiring more than one type of verification |
| Connector token | A credential used by an integrated system to access permitted services |
| Webhook | An automated message sent from one system to another when an event occurs |
| Message signature | A cryptographic mechanism used to verify message authenticity and integrity |
| TLS | A protocol that protects communications between systems |
| mTLS | Mutual TLS, where both communicating parties authenticate using certificates |
| Compensating control | An alternative safeguard that reduces risk when a direct control is incomplete |
| Attack chain | A sequence of weaknesses or conditions that could combine into a broader attack |
| Residual risk | Risk remaining after security measures have been applied |
| Risk acceptance | A documented management decision to tolerate a defined remaining risk |
| DPO | Data Protection Officer, responsible for data-protection advice and oversight |
| GDPR / RGPD | European Union regulation governing the processing of personal data |
| HDS | French certification framework for hosting health data |
| HDS renewal audit | An assessment of continued compliance with applicable health-data hosting certification requirements |
| P1 / P2 / P3 | Operational remediation priorities, distinct from CVSS technical severity |
| ARR | Annual Recurring Revenue |
| False positive | An observation initially treated as a vulnerability but subsequently determined not to demonstrate the suspected security defect |

---

## 8. Final Assessment and Management Decision Record

The engagement confirms material weaknesses affecting MediPath's patient-data boundaries, trusted integrations, diagnostic workflow integrity, and authorization controls.

The most urgent corrective actions concern F-01, F-02, F-03/09, F-05, and F-10.

F-04 and F-06 require planned remediation and supporting control verification, while F-08 should be addressed through the managed security backlog.

F-07 has been retired from the active vulnerability register, subject to continued verification of the approved export workflow.

The audit committee should approve the immediate remediation program, confirm accountable owners and funding, require independent validation, and establish a formal process for residual-risk acceptance.

**Required management decisions:**

1. Approve and resource the P1 remediation program.
2. Require evidence-based verification of completed corrective actions.
3. Confirm DPO and HDS audit-readiness oversight.
4. Review and formally decide on any material residual risks within the eight-week governance window.

**Overall conclusion:** MediPath should treat the confirmed authorization and workflow-integrity weaknesses as immediate remediation priorities while maintaining a clear distinction between demonstrated technical findings, conditional attack scenarios, and hypothetical financial consequences.

**End of Report**
