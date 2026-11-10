
# Task 5: The Full Engagement
# Nexus Financial — Pre-Engagement Dossier

**Prepared by:** Vanguard Security — Offensive Security Team  
**Engagement Lead:** Sarah Chen  
**Client:** Nexus Financial  
**Client Primary Contact:** James Okafor, CISO  
**Document Status:** DRAFT — Pending Internal Review and Client Approval  
**Classification:** Confidential  
**Engagement Duration:** Proposed 4-week assessment  
**Authorization Status:** NOT AUTHORIZED TO TEST

> **Important:** This document is a proposed engagement framework, not an authorization to begin testing. All scope details, legal authority, contractual terms, and Rules of Engagement must be confirmed and approved in writing before any active testing begins.

---

## 1. Executive Summary

Nexus Financial, a European fintech company processing approximately €2 million in daily payments across three markets, has requested an independent security assessment from Vanguard Security as part of its Series B funding requirements established by Meridian Capital. The proposed engagement will evaluate the security of Nexus's payments API, web and mobile applications, AWS infrastructure, administrative systems, and corporate remote-access environment. Vanguard recommends a risk-based, primarily gray-box assessment that combines detailed testing in staging with carefully controlled production validation to identify meaningful security risks while protecting payment availability and customer data. The engagement is expected to conclude within four weeks, subject to verified written authorization, agreed scope, approved Rules of Engagement, and appropriate safeguards for third-party integrations and personal data.

---

## 2. Scope Document

### 2.1 Scope Status and Authorization

The assets below are **proposed in-scope assets**, not yet authorized targets.

Before testing, Nexus Financial must provide an approved asset inventory identifying exact hostnames, IP addresses or CIDR ranges, AWS account IDs, application identifiers, environments, and ownership.

Only assets explicitly listed in the final signed scope are authorized.

Discovery of additional assets does not automatically expand the scope.

### 2.2 Proposed In-Scope Assets

| Asset | Known Identifier | Proposed Assessment | Authorization Status |
|---|---|---|---|
| Core Payments API | Ruby on Rails; AWS eu-west-1; hostname TBD | Authentication, authorization, API security, payment workflow logic | Pending |
| Customer Web Application | Production and staging hostnames TBD | OWASP-based application penetration testing | Pending |
| iOS Application | App identifier and approved build TBD | Mobile authentication, storage, transport, and API interaction | Pending |
| Android Application | Package name and approved build TBD | Mobile authentication, storage, transport, and API interaction | Pending |
| Backoffice Admin Panel | `admin.nexus-financial.com` | Credential controls, MFA, authorization, session management, privilege boundaries | Pending |
| AWS EKS | Cluster names, AWS account IDs, namespaces TBD | Kubernetes configuration, IAM, workload exposure, network policies | Pending |
| AWS RDS | PostgreSQL instance identifiers TBD | Configuration, access controls, encryption, database exposure | Pending |
| AWS S3 | Bucket identifiers TBD | Bucket policies, public exposure, encryption, access permissions | Pending |
| WireGuard VPN | VPN endpoints, IP ranges TBD | Configuration, authentication, access control, segmentation | Pending |
| Corporate Network | Authorized IP/CIDR ranges TBD | Limited internal infrastructure security assessment | Pending |
| Staging Environment | Hostnames, IP ranges, AWS resources TBD | Primary environment for detailed vulnerability validation | Pending |
| Nexus-Controlled Third-Party Integrations | Nexus-owned application code and configurations | Integration authentication, authorization, data handling, error handling | Pending |

**Required clarification:** Nexus must confirm which assets it legally owns or controls and which cloud resources are covered by its provider agreements.

For mobile testing, Nexus must provide approved application builds and test accounts. Testing of third-party mobile infrastructure or external services is not implied.

### 2.3 Explicitly Out-of-Scope Assets

| Excluded Asset or Activity | Justification |
|---|---|
| VerifyID-owned infrastructure, applications, and API endpoints | VerifyID is an independent third party; Nexus does not own or manage its infrastructure |
| Stripe-owned infrastructure and services | Stripe is a third-party payment processor; Nexus cannot authorize testing of Stripe systems |
| Other third-party systems and shared infrastructure | Ownership and authorization have not been established |
| Denial-of-service, stress testing, and destructive exploitation | Unacceptable risk to payment availability and business continuity |
| Unauthorized real financial transactions | Could create financial, regulatory, and operational consequences |
| Modification or deletion of real customer records | Unnecessary privacy and data-integrity risks |
| Physical intrusion | Not requested or separately authorized |
| Employee phishing and other social engineering | Requires a separate approved campaign scope and safeguards |
| Personal devices and employee home networks | Not automatically covered by corporate VPN authorization |
| Unlisted IP addresses, domains, AWS accounts, and environments | No authorization exists outside the signed asset inventory |

Third-party systems may only be added through a formal scope amendment supported by appropriate authorization from their owners.

### 2.4 Scope Boundary: VerifyID Integration

**Recommendation:** Assess the Nexus-controlled integration, but exclude direct security testing of VerifyID infrastructure.

Permitted activities, once authorized, may include:

- Reviewing Nexus's integration code and configuration.
- Evaluating how Nexus authenticates to VerifyID.
- Assessing how Nexus validates and processes verification responses.
- Reviewing the protection of customer information transmitted through the integration.
- Testing error handling using approved mocks or test fixtures.

Direct testing against VerifyID endpoints, sending synthetic requests to its live API, fuzzing, or attempting to bypass VerifyID controls must not occur without confirming contractual permissions and obtaining any required third-party authorization.

If VerifyID provides an approved sandbox, its permitted use must be documented before testing.

**Reasoning:** Nexus can authorize testing of systems it controls, but cannot automatically authorize attacks against a third-party provider.

### 2.5 Scope Boundary: Staging vs. Production

**Recommendation:** Use a staging-first, production-controlled testing strategy.

**Staging:**
- Conduct detailed authentication and authorization testing.
- Validate application and API vulnerabilities.
- Perform controlled privilege escalation where permitted.
- Use synthetic customer records and non-production payment credentials.
- Confirm whether staging configurations adequately represent production.

**Production:**
- Perform approved configuration reviews and low-impact validation.
- Use dedicated test accounts and approved payment test mechanisms.
- Avoid destructive exploitation, aggressive scanning, and uncontrolled automation.
- Stop immediately if payment processing or customer experience is affected.

A staging finding must not automatically be treated as proof that production is vulnerable. Production-specific differences should be assessed through safe, authorized methods.

### 2.6 Scope Boundary: Social Engineering

**Recommendation:** Exclude employee phishing from the initial four-week engagement.

The CTO's verbal request does not constitute sufficient authorization for a company-wide phishing campaign.

A separate social engineering engagement would require:

- Written approval from a legally authorized representative.
- Defined employee groups and exclusions.
- Approved phishing techniques and message content.
- Restrictions on credential collection.
- Privacy and employee-notification considerations.
- Emergency contacts and stopping conditions.
- Coordination with HR, legal, and security leadership.

**Reasoning:** The immediate investor requirement is best addressed through a focused technical security assessment without introducing unnecessary employee or operational risk.

### 2.7 Admin Panel Credential Testing

Credential testing of `admin.nexus-financial.com` is proposed under strict limitations:

- Use designated test accounts.
- Verify MFA and account lockout controls.
- Test authorization boundaries between approved user roles.
- Avoid password spraying against real employees.
- Avoid brute-force attacks that could lock out operations staff.
- Obtain written approval for all authentication test cases.

### 2.8 Scope Change Procedure

Any new asset, technique, testing window, or third-party integration requires:

1. A documented change request.
2. Assessment of legal, technical, privacy, and operational risks.
3. Approval from Vanguard's engagement lead.
4. Written approval from Nexus's authorized representative.
5. An updated scope and Rules of Engagement.

No expanded testing may begin before the amendment is approved.

---

## 3. Rules of Engagement

### 3.1 Testing Windows

**Proposed standard testing window:**

- Monday to Friday.
- 09:00–18:00, Europe/Paris local time.
- No weekend or overnight active testing without prior written approval.

Europe/Paris is used to account for both CET and CEST.

Any production testing must also comply with Nexus's approved maintenance and business-continuity requirements.

High-risk activities require a separately agreed testing window and explicit approval.

The exact engagement dates must be confirmed before signing.

### 3.2 Testing Approach

**Recommended approach: Primarily Gray Box, supplemented by targeted White Box review.**

Gray-box testing is appropriate because Nexus can provide:

- Application architecture information.
- Test accounts with different privilege levels.
- API documentation.
- Staging access.
- Relevant infrastructure configuration details.

Targeted white-box review may be used for critical payment workflows, authentication logic, cloud IAM policies, and the previous API-key exposure incident.

This approach is preferable to a purely black-box engagement because it improves coverage within the four-week deadline and reduces unnecessary operational risk.

Testing will follow established methodologies such as PTES and relevant OWASP testing guidance.

### 3.3 Authorized and Prohibited Techniques

**Proposed permitted techniques:**

- Controlled vulnerability scanning.
- Manual web and API security testing.
- Authentication and authorization testing.
- Cloud and Kubernetes configuration assessment.
- Limited network service enumeration.
- Controlled validation of identified vulnerabilities.
- Review of secrets management and exposed credentials.
- Evidence collection using data-minimization principles.

**Prohibited unless separately authorized:**

- Denial-of-service or stress testing.
- Destructive exploitation.
- Unrestricted credential attacks.
- Persistence or malware deployment.
- Real customer data extraction.
- Unauthorized financial transactions.
- Social engineering or physical intrusion.
- Testing third-party systems.
- Actions likely to interrupt payment processing.

### 3.4 Communication Protocols

**Primary communication contacts:**

| Organization | Contact | Responsibility |
|---|---|---|
| Vanguard Security | Sarah Chen | Engagement leadership and primary client communication |
| Nexus Financial | James Okafor, CISO | Technical coordination and primary client contact |
| Nexus Financial | Thomas, CTO | Technical decisions and scope consultation |
| Nexus Financial | Maria, CFO | Business continuity and financial risk consultation |
| Nexus Financial | Authorized Signatory — TBD | Binding approval of engagement and scope |
| Both Organizations | Emergency Contacts — TBD | Incident escalation and emergency stop coordination |

Routine updates will be exchanged through an agreed secure channel.

Critical findings and operational incidents must be escalated immediately through the designated emergency contact process.

All important scope decisions and approvals must be documented in writing.

### 3.5 Emergency Stop Procedure

Testing must stop immediately if any of the following occurs:

- Payment processing becomes unavailable or materially degraded.
- Production systems experience unexpected instability.
- Customer data is unexpectedly exposed, altered, or destroyed.
- Testing affects an out-of-scope system.
- An unapproved financial transaction is triggered.
- Evidence of an active compromise requires incident response coordination.
- Nexus or Vanguard identifies an unacceptable operational or legal risk.

**Stop authority:**

Any Vanguard tester may immediately stop their own activity and escalate the issue. Sarah Chen and Nexus's designated emergency authority may order a wider engagement stop.

**Procedure:**

1. Immediately cease the affected testing activity.
2. Notify Sarah Chen and Nexus's emergency contact using the approved urgent channel.
3. Record the time, activity, observed symptoms, and relevant evidence.
4. Preserve necessary evidence without making unauthorized system changes.
5. Allow Nexus's operational or incident response team to assess the impact.
6. Resume only after documented approval from the designated authorities.

Emergency phone numbers and escalation backups must be confirmed before testing begins.

### 3.6 Data Handling and GDPR Safeguards

Nexus processes personal data, including customer names, addresses, and banking information.

Vanguard will apply the following controls:

**Data minimization**
- Prefer synthetic data and dedicated test accounts.
- Avoid accessing real customer records unless strictly necessary and explicitly authorized.
- Collect only the minimum evidence required to demonstrate a finding.
- Mask or redact personal information in reports.

**Secure storage**
- Encrypt evidence in transit and at rest.
- Restrict access to authorized engagement personnel.
- Do not store customer information in personal devices or unauthorized cloud services.
- Do not include secrets, raw personal data, or sensitive evidence in public repositories.

**Data retention**
- Proposed retention period: 30 days after final report acceptance, subject to contractual and legal requirements.
- Confirm the final retention period in the signed agreement.
- Securely delete working copies when retention expires.
- Document destruction and provide confirmation where contractually required.

**Privacy and contractual controls**
- Determine the applicable GDPR roles and responsibilities.
- Execute appropriate data processing terms where required.
- Agree on approved data storage and transfer locations.
- Establish procedures for personal data incidents and legally required notifications.
- Ensure any subcontractor or processing arrangement is approved.

Vanguard must not independently disclose client personal data to third parties except where legally required or contractually authorized.

### 3.7 Incident Discovery Protocol

If testing reveals evidence of an active compromise:

1. Stop any activity that could interfere with incident response or evidence preservation.
2. Record minimal, relevant indicators of compromise.
3. Immediately notify Sarah Chen.
4. Escalate to James Okafor and the approved Nexus incident response contact.
5. Share verified observations through a secure channel.
6. Allow Nexus to activate its incident response procedures.
7. Do not independently remove attackers, reset production credentials, or alter systems without additional authorization.
8. Document the event and determine whether testing may safely continue.

Active compromise indicators must not be withheld until the final report.

### 3.8 Prior Exposed API Keys

Nexus reported that a developer previously committed API keys to a public GitHub repository.

Vanguard proposes to:

- Review the documented incident and remediation actions.
- Confirm that affected credentials were revoked or rotated.
- Assess the current secrets management process.
- Review relevant repository scanning and CI/CD controls.
- Evaluate the potential exposure of replacement credentials.

Any review of public repositories must be limited to authorized, relevant information. Previously exposed keys must not be used to access systems without explicit permission.

---

## 4. Communication Plan

### 4.1 Designated Points of Contact

**Vanguard Security**
- Sarah Chen — Engagement Lead.
- Assigned Technical Lead — TBD.
- Emergency Backup Contact — TBD.

**Nexus Financial**
- James Okafor — CISO and Primary Technical Contact.
- Thomas — CTO and Technical Decision-Maker.
- Maria — CFO and Business Continuity Stakeholder.
- Authorized Contract Signatory — TBD.
- Incident Response / Operations Emergency Contact — TBD.

All contacts, roles, email addresses, and emergency phone numbers must be confirmed before the engagement begins.

### 4.2 Reporting Cadence

| Event | Timing | Audience |
|---|---|---|
| Pre-engagement approval meeting | Before testing | Vanguard Lead, CISO, CTO, CFO, authorized signatory |
| Kickoff meeting | Day 1 | Technical and operational stakeholders |
| Progress updates | Twice weekly | Sarah Chen and James Okafor |
| Critical vulnerability notification | Immediately after validation | Approved security escalation contacts |
| Operational emergency | Immediately | Emergency contacts |
| Draft findings review | During final assessment week | Vanguard Lead and Nexus CISO |
| Final technical report | By end of Week 4 | Authorized Nexus recipients |
| Executive summary and debrief | By end of Week 4 | CISO, CTO, CFO, designated leadership |

The report should be ready approximately two weeks before the investor meeting, assuming the agreed schedule begins on time.

Any deadline risk must be communicated immediately.

### 4.3 Stakeholder Management: CTO vs. CFO

The CTO wants broad, realistic testing, while the CFO prioritizes uninterrupted payment processing.

Vanguard recommends a joint decision meeting with James, Thomas, Maria, and Sarah before signing.

The proposed compromise is:

**Phase 1 — Staging Assessment**
- Detailed application, API, and infrastructure testing.
- Controlled validation of potentially impactful vulnerabilities.
- Synthetic data and dedicated test accounts.

**Phase 2 — Controlled Production Validation**
- Low-impact testing of critical findings.
- Configuration and access-control verification.
- Approved testing windows and immediate stop procedures.

**Phase 3 — Reporting and Remediation Planning**
- Prioritized technical findings.
- Business risk analysis.
- Executive-level presentation.
- Recommendations for future advanced testing.

Social engineering and broader adversary simulation can be proposed as separate future engagements.

The final approach must be documented and approved by the authorized client representative. If the disagreement remains unresolved, the engagement is **NO-GO**.

### 4.4 Secure Communication Channels

**Proposed channels:**

- Approved encrypted file-sharing platform for reports and evidence.
- Corporate email for routine non-sensitive scheduling.
- Encrypted or otherwise approved secure messaging for sensitive findings.
- Verified emergency telephone contacts for urgent incidents.
- Restricted-access project workspace for engagement documentation.

Sensitive evidence, credentials, personal data, and unredacted reports must not be sent through unapproved channels.

All critical decisions must have a written record.

### 4.5 Deliverables

Vanguard will provide:

1. Executive summary for leadership and investor due diligence.
2. Technical security assessment report.
3. Vulnerability register with severity and business impact.
4. Reproducible evidence with sensitive data redacted.
5. Prioritized remediation recommendations.
6. Description of tested assets, methods, and limitations.
7. Final debriefing with Nexus stakeholders.

A clean assessment or the absence of identified critical findings does not guarantee that the environment is free of vulnerabilities.

The report will describe the assessment's scope and limitations transparently.

---

## 5. Engagement Risk Register

The following risks concern the successful and safe execution of the engagement, rather than vulnerabilities within the target environment.

Likelihood and impact ratings are preliminary and must be reviewed with Nexus.

| ID | Engagement Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | Production payment processing disruption during testing | Medium | Critical | Staging-first testing, controlled production validation, stop conditions, operational monitoring |
| R2 | Testing begins without legally valid written authorization | High | Critical | Verify signatory authority, obtain signed authorization and RoE before testing |
| R3 | Accidental testing of VerifyID, Stripe, or other third-party assets | Medium | High | Explicit exclusions, asset allowlist, integration boundary review, third-party approval where needed |
| R4 | Exposure or mishandling of customer PII and banking information | Medium | Critical | Synthetic data, minimal evidence, encryption, access restrictions, retention and deletion controls |
| R5 | CTO/CFO disagreement delays scope approval or creates conflicting instructions | High | High | Joint stakeholder meeting, written scope agreement, clear change-control process |
| R6 | Four-week deadline prevents sufficient assessment coverage | Medium | High | Risk-based prioritization, staging access before kickoff, twice-weekly progress reviews, explicit coverage limitations |
| R7 | Authentication testing locks out backoffice users | Medium | High | Dedicated accounts, approved test cases, rate limits, lockout coordination |
| R8 | Testing accidentally triggers real payments or external KYC requests | Medium | High | Approved test credentials, mocks, sandbox integrations, transaction safeguards |
| R9 | Incomplete asset inventory results in unauthorized or missed testing | High | High | Client-validated asset register, ownership checks, written scope freeze |
| R10 | Active compromise discovered during testing disrupts the engagement | Medium | Critical | Incident discovery protocol, immediate escalation, evidence preservation, controlled suspension |

### Risk Management Responsibilities

Sarah Chen will maintain the engagement risk register and coordinate mitigation activities with James Okafor.

Risks will be reviewed during progress meetings and updated whenever the scope, environment, or operational conditions change.

Critical risks without effective mitigation may require suspension or cancellation of affected testing activities.

---

## 6. Go / No-Go Checklist

**Decision Rule:** Every mandatory condition below must be satisfied before active testing begins. An unchecked mandatory condition results in **NO-GO**.

### 6.1 Legal and Contractual Authorization

- [ ] Nexus's legally authorized signatory has been identified and verified.
- [ ] Written authorization to test has been signed by the appropriate parties.
- [ ] The final scope document has been approved and signed.
- [ ] The Rules of Engagement have been approved and signed.
- [ ] Confidentiality, liability, and applicable contractual terms have been agreed.
- [ ] Third-party authorization requirements have been reviewed and resolved.

### 6.2 Scope and Technical Readiness

- [ ] Exact in-scope domains, IP ranges, AWS accounts, and environments are documented.
- [ ] Asset ownership and operational responsibility are confirmed.
- [ ] VerifyID and Stripe boundaries are documented.
- [ ] Staging and production testing permissions are separately defined.
- [ ] Authorized test accounts and access credentials are available.
- [ ] Admin panel credential testing limits are approved.
- [ ] Social engineering is either explicitly excluded or separately authorized.
- [ ] Prohibited techniques and out-of-scope assets are clearly documented.

### 6.3 Operational Safety

- [ ] Testing dates, hours, and time zone are approved.
- [ ] Production safeguards and monitoring responsibilities are agreed.
- [ ] Emergency stop triggers and procedures are approved.
- [ ] Primary and backup emergency contacts are verified.
- [ ] Approved test data and payment testing mechanisms are available.
- [ ] Business continuity and incident response coordination is confirmed.

### 6.4 Data Protection and Reporting

- [ ] GDPR-related responsibilities and contractual data processing terms are agreed.
- [ ] Evidence storage and secure transfer methods are approved.
- [ ] Data minimization, retention, and destruction procedures are agreed.
- [ ] Active compromise escalation procedures are approved.
- [ ] Reporting recipients and communication channels are confirmed.
- [ ] Final deliverables and acceptance criteria are agreed.

### 6.5 Stakeholder Alignment

- [ ] CISO, CTO, and CFO have reviewed the proposed assessment approach.
- [ ] The production risk tolerance has been formally agreed.
- [ ] The final testing scope has been accepted by the authorized signatory.
- [ ] The four-week schedule and reporting deadline are confirmed.
- [ ] Vanguard's engagement lead has approved operational readiness.

### 6.6 Current Decision

**Status: NO-GO — Pending Authorization and Scope Finalization**

At the time of drafting, the following matters remain unresolved:

1. Verification of the client's legal signing authority.
2. Written approval of the engagement and Rules of Engagement.
3. Confirmation of exact in-scope assets and identifiers.
4. Resolution of the CTO/CFO disagreement.
5. Approval of staging and production testing boundaries.
6. Confirmation of third-party integration restrictions.
7. Approval of data handling and emergency response procedures.
8. Confirmation of testing dates, contacts, and operational safeguards.

**No active penetration testing, credential testing, scanning, or adversary simulation may begin until all mandatory conditions are met.**

---

## 7. Proposed Approval and Sign-Off

The following sign-off fields are provided for review. Signatures do not authorize any asset or technique that is not included in the final approved scope.

### Nexus Financial

**Authorized Representative:** TBD  
**Title:** TBD  
**Signature:** __________________________  
**Date:** _______________________________

**Technical Scope Acknowledgment — James Okafor, CISO:**  
**Signature:** __________________________  
**Date:** _______________________________

**Technical and Operational Review — Thomas, CTO:**  
**Signature:** __________________________  
**Date:** _______________________________

**Business Continuity Review — Maria, CFO:**  
**Signature:** __________________________  
**Date:** _______________________________

### Vanguard Security

**Engagement Lead:** Sarah Chen  
**Signature:** __________________________  
**Date:** _______________________________

**Authorized Vanguard Representative:** TBD  
**Signature:** __________________________  
**Date:** _______________________________

---

## Final Recommendation

Vanguard Security recommends proceeding with a staged, risk-based security assessment after all authorization and operational prerequisites have been satisfied.

The engagement should prioritize the core payments API, administrative access controls, AWS security configuration, customer-facing applications, and the previously reported secrets exposure incident.

Detailed testing should begin in staging, followed by explicitly authorized, low-impact production validation.

Third-party infrastructure, destructive techniques, and social engineering should remain excluded unless separately authorized.

**Final Engagement Decision: NO-GO until written authorization, scope approval, stakeholder alignment, and operational safeguards are complete.**
