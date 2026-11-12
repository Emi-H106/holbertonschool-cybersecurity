# Rules of Engagement — Lumen Industrial Systems

## Engagement Metadata

| Field | Details |
|---|---|
| Client | Lumen Industrial Systems, Brno, Czech Republic |
| Security Consultancy | Vanguard Security |
| Engagement Reference | VGS-LUMEN-PT-2026-001 (proposed; pending confirmation) |
| Engagement Type | Authorised penetration test and security assessment |
| Methodology | Penetration Testing Execution Standard (PTES) |
| Engagement Window | Proposed 10-business-day testing period; exact dates pending written approval |
| Client Authorising Representative | Lumen CISO, or formally delegated authorised signatory |
| Consultancy Authorising Representative | Vanguard Security Engagement Lead |
| Primary Client Contact | Lumen CISO |
| Engagement Status | Draft — pending scope confirmation and signatures |

### Engagement Objectives

The engagement assesses the security of Lumen-controlled cloud services, public APIs, internal administration interfaces, and designated demonstration industrial infrastructure.

The assessment will identify exploitable weaknesses, evaluate their technical and business consequences, and provide actionable remediation recommendations.

The final report will support Lumen's cybersecurity assurance discussions with its industrial customers, including customers subject to the NIS2 Directive (EU) 2022/2555.

The engagement does not constitute certification of NIS2 compliance. Compliance depends on broader organisational, technical, contractual, and legal requirements beyond the scope of a penetration test.

### Authorisation Requirement

No active testing may begin until both parties have approved and signed the Rules of Engagement and the target asset inventory has been formally confirmed.

Any proposed changes to scope, methodology, or testing conditions require documented approval before implementation.

## Scope

### In Scope

The following Lumen-controlled asset classes are authorised in principle, subject to confirmation of their exact identifiers in the approved asset inventory.

| Asset Class | Authorised Assessment Activities | Restrictions |
|---|---|---|
| Lumen-controlled cloud platform | Service discovery, configuration assessment, vulnerability validation | Only explicitly approved cloud resources and tenant boundaries |
| Public API | Endpoint enumeration, authentication and authorisation testing, input validation, controlled file upload testing | No destructive requests or unauthorised customer-data access |
| Internal administration panel | Authentication, session management, access-control and application-security testing | Approved test accounts only; no unauthorised privilege changes |
| In-house demonstration edge gateway | Controlled service enumeration, configuration review and vulnerability validation | Demonstration equipment only; no production industrial equipment |
| Demonstration MQTT broker | Authentication, topic authorisation, subscribe/publish permission testing | Test topics and synthetic messages only; no production telemetry manipulation |

The definitive target list must identify approved hostnames, IP addresses, API endpoints, cloud accounts, environments, demonstration devices, and MQTT topics.

Assets discovered through DNS, application responses, network enumeration, or public intelligence are not automatically authorised for testing.

### Out of Scope

The following asset classes are explicitly excluded:

1. Edge gateways deployed at Lumen customers' industrial premises.
2. IoT sensors installed in customer factories, warehouses, or other operational facilities.
3. Customer-owned or customer-operated industrial networks, production systems, and operational technology.
4. Third-party cloud accounts, infrastructure, or services not explicitly authorised for this engagement.
5. Other customer tenants and customer datasets not covered by the approved test accounts and asset inventory.
6. Employee personal devices, personal accounts, and unrelated third-party systems.
7. Physical security testing, social engineering, and denial-of-service testing unless separately authorised.

### Legal and Contractual Basis for Exclusions

Lumen cannot grant testing authorisation over infrastructure it does not own, operate, or have documented authority to represent.

Technical reachability does not establish legal permission.

Testing customer-deployed gateways, IoT sensors, or operational technology without appropriate authorisation could breach contractual obligations, affect industrial operations, and expose both parties to legal liability.

If an excluded asset is discovered during reconnaissance or exploitation, the consultant must stop interacting with that asset, document the discovery without further probing, and notify the designated client contact.

Any subsequent assessment requires a separate written authorisation identifying the relevant asset owner, scope, permitted techniques, and operational safeguards.

## Testing Window

### Proposed Schedule

| Parameter | Proposed Requirement |
|---|---|
| Testing Days | Monday to Friday |
| Testing Hours | 09:00–17:00 |
| Time Zone | Europe/Prague (CET/CEST as applicable) |
| Engagement Duration | 10 business days |
| Exact Start and End Dates | Pending written confirmation |
| Emergency Activities | Only those expressly approved by the client |

The proposed daytime schedule provides access to Lumen's technical and security contacts and supports rapid incident escalation.

### Blackout Periods

Active testing is prohibited during:

- Production deployments and infrastructure migrations.
- Scheduled maintenance affecting industrial customers.
- Critical customer demonstrations or contractual acceptance activities.
- Declared security incidents or operational emergencies.
- Any additional blackout period communicated by the CISO.

High-impact tests, including controlled exploitation and MQTT publish validation, require explicit scheduling and approval.

Testing outside the agreed window is prohibited unless a written exception is approved.

## Communication and Escalation

### Contact Structure

| Role | Responsibility |
|---|---|
| Primary Client Contact | Lumen CISO — scope decisions, risk acceptance, incident escalation |
| Secondary Client Contact | CISO-designated technical/security deputy — pending nomination |
| Consultancy Engagement Lead | Vanguard Security authorised engagement lead — technical oversight and escalation |
| Testing Consultant | Assigned Vanguard Security consultant — execution, evidence collection, action logging |

Names, telephone numbers, and secure contact details must be confirmed before testing begins.

### Communication Channels

Routine communications will use an approved corporate email channel or secure collaboration platform.

Sensitive findings, credentials, evidence, and technical reports must be transferred using an approved encrypted channel.

Urgent incidents require direct telephone contact with the primary or secondary client representative, followed by a written record.

No confidential engagement findings may be disclosed to customer executives, external stakeholders, or third parties outside the agreed communication process without appropriate authorisation.

### Proposed Response Times

| Event | Notification Requirement |
|---|---|
| Critical vulnerability or exposed credentials | Notify the CISO immediately, with a target of 15 minutes after confirmation |
| Service disruption or suspected operational impact | Stop affected testing immediately and initiate emergency contact |
| Scope ambiguity or out-of-scope discovery | Stop affected activity and request clarification before continuing |
| High-severity confirmed finding | Notify the CISO within 4 business hours |
| Routine status update | Daily written progress summary |
| Scope change request | Written approval required before execution |

These response times are proposed service expectations and must be accepted by both parties.

### Escalation Procedure

1. Stop the affected activity when a stop condition is triggered.
2. Preserve relevant evidence without performing additional intrusive operations.
3. Record the event and observed impact in the action log.
4. Notify the Lumen CISO through the agreed emergency channel.
5. Escalate to the Vanguard Security Engagement Lead.
6. Resume the affected activity only after documented authorisation.

## Authorised Tools, Forbidden Tools

### Authorised Tools and Techniques

Subject to final approval, the following tools and techniques may be used against explicitly authorised assets:

| Tool or Technique | Purpose |
|---|---|
| `dig` and DNS queries | Public DNS and subdomain reconnaissance |
| `whois` and certificate transparency research | Public domain and infrastructure intelligence |
| `curl` | HTTP response inspection and controlled API requests |
| `Nmap` | Rate-limited host and service enumeration |
| Burp Suite | HTTP interception and application security testing |
| `openssl` | TLS configuration and certificate inspection |
| Browser developer tools | Client-side application and API analysis |
| Public documentation and search engines | Passive OSINT and technology identification |
| Controlled manual payloads | Validation of authorised application vulnerabilities |
| MQTT test clients | Authentication and topic-permission assessment on the demo broker |
| Custom scripts | Reproducible, non-destructive tests reviewed against the approved scope |

Active scanning must use conservative rates and avoid unnecessary service disruption.

### Explicitly Forbidden Tools and Activities

The following restrictions apply:

- Metasploit is prohibited for obtaining the initial foothold.
- Any initial file-upload bypass must use a manually constructed payload or a documented public technique, with reproducible evidence.
- Metasploit utilities may be considered for post-exploitation only if explicitly authorised and technically justified.
- Denial-of-service, distributed denial-of-service, and destructive stress testing are prohibited.
- Unrestricted brute-force attacks and credential stuffing are prohibited.
- Malware deployment, ransomware simulation, and persistence mechanisms are prohibited unless separately approved.
- Phishing, social engineering, and physical intrusion are prohibited.
- Customer-deployed gateways, sensors, and production operational technology must not be tested.
- Production MQTT telemetry must not be altered.
- Unauthorised lateral movement, cross-tenant access, and bulk data extraction are prohibited.
- Exposed credentials must not be used to access additional systems without explicit authorisation.

All exploitation must be proportionate to the agreed objectives and limited to the minimum activity necessary to establish technical impact.

## Stop Conditions

Testing must stop immediately when any of the following occurs:

1. An out-of-scope asset is encountered and further interaction would cross the authorised boundary.
2. A target experiences unexpected downtime, instability, or significant performance degradation.
3. An action could affect customer production systems or industrial operations.
4. Testing unexpectedly exposes sensitive credentials, regulated information, or substantial customer data.
5. A vulnerability could permit uncontrolled lateral movement or cross-tenant access.
6. A test produces an unexpected destructive effect or modifies production data.
7. The client requests suspension or withdrawal of authorisation.
8. The approved testing window expires or an announced blackout period begins.
9. A security incident or emergency is declared.
10. The consultant cannot verify that the intended target remains within the approved scope.

When a stop condition is triggered, the consultant must document the event, notify the appropriate contacts, and await written instructions before resuming the affected testing.

Discovery of an exposed secret must be documented securely without using the secret for additional enumeration unless separately authorised.

## Data Handling

### Data Minimisation

The consultant will collect only the information necessary to validate findings and demonstrate business impact.

Real customer data must not be extracted when synthetic or redacted evidence is sufficient.

Passwords, tokens, API keys, and other secrets must not appear in plaintext in the final report.

### Evidence Protection

All evidence must be:

- Stored in access-controlled, encrypted storage.
- Accessible only to authorised engagement personnel.
- Labelled with the relevant target, timestamp, and finding reference.
- Protected against unauthorised modification or disclosure.
- Transferred only through approved secure channels.

Screenshots, logs, and HTTP responses must be redacted where necessary to protect personal information and confidential customer data.

### Action Logging

Significant activities performed during vulnerability analysis, exploitation, and post-exploitation must be recorded in `3-actions_log.md`.

Each entry must contain:

- Timestamp, including time zone.
- PTES phase.
- Action performed.
- Target asset.
- Observed result.
- Relevant evidence or verification reference, where available.

The log must distinguish observed facts from assumptions and must not contain fabricated commands, timestamps, or results.

### Retention and Destruction

A 90-day post-engagement evidence retention period is proposed, subject to contractual, legal, and audit requirements.

At the end of the approved retention period, engagement evidence must be securely deleted unless a documented legal hold or agreed extension applies.

The client may request written confirmation of evidence destruction.

Any suspected evidence compromise must be escalated immediately under the agreed incident communication procedure.

## Post-Engagement Obligations

### Reporting Timeline

The following milestones are proposed:

| Deliverable | Proposed Deadline |
|---|---|
| Immediate notification of critical findings | During testing, upon confirmation |
| Preliminary findings summary | Within 2 business days after testing |
| Draft technical report | Within 5 business days after testing |
| Final report | Within 10 business days after testing, subject to review |
| Remediation discussion | Within 5 business days after final delivery |
| Retesting | Separately scheduled following remediation |

These deadlines are proposed and require client approval.

The final report must contain:

- Executive summary.
- Confirmed and unconfirmed findings clearly distinguished.
- Affected assets and technical evidence.
- Severity and business-impact assessment.
- Reproduction steps where appropriate.
- Prioritised remediation recommendations.
- Testing limitations and scope exclusions.
- A remediation roadmap suitable for industrial customer assurance discussions.

The report must not represent the engagement as proof of complete NIS2 compliance.

### Cleanup and Restoration

Before closing the engagement, the consultant must:

1. Remove authorised test payloads, temporary files, and webshells.
2. Remove test accounts or access mechanisms created during the assessment, where applicable and approved.
3. Restore modified configurations when restoration is authorised and technically safe.
4. Verify that cleanup actions succeeded.
5. Record each cleanup action and verification result in the action log.
6. Disclose any residual artefacts or incomplete restoration to the CISO.

Cleanup must not destroy legitimate customer evidence or interfere with an active incident investigation.

### Evidence Retention

Evidence will be retained according to the approved data-handling policy and securely destroyed at the end of the retention period unless otherwise required.

### Audit Support

Vanguard Security proposes a 30-calendar-day audit support window following final report delivery.

During this period, the consultancy may clarify findings, explain testing limitations, and support reasonable technical questions from Lumen's authorised representatives.

Additional exploitation, remediation implementation, or retesting requires a separately approved scope.

### Professional Integrity

Confirmed vulnerabilities must not be concealed, falsified, or downgraded for commercial reasons.

Any correction to a finding must be supported by new evidence and documented transparently.

Customer-facing summaries may simplify technical language but must accurately reflect the full report, unresolved risks, and validation limitations.

## Signatures

This document becomes effective only after both parties have approved the final scope, testing schedule, communication arrangements, and operational restrictions.

### Client Authorisation

Name: ______________________________

Title: Authorised Representative / CISO, Lumen Industrial Systems

Signature: __________________________

Date: _______________________________

### Consultancy Authorisation

Name: ______________________________

Title: Authorised Engagement Lead, Vanguard Security

Signature: __________________________

Date: _______________________________

**Document Status:** Draft — Pending Written Approval

**Authorisation Notice:** This document does not itself establish permission to begin active testing until the required signatures and target inventory confirmation have been obtained.
