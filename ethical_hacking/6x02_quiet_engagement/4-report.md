
# Penetration Test Report — Lumen Industrial Systems

**Engagement Reference:** VS-LUMEN-PT-2026-001  
**Reporting Period:** 12 November 2026  
**Prepared by:** Junior Security Consultant, Vanguard Security  
**Engagement Lead:** Sarah, Vanguard Security  
**Client:** Lumen Industrial Systems, Brno, Czech Republic  
**Methodology:** Penetration Testing Execution Standard (PTES)  
**Classification:** Confidential — Restricted Distribution  
**Distribution:** Lumen CISO, authorised management, and designated industrial customer auditors  
**Document Status:** Final — Educational Simulation  
**Evidence Status:** Fictional exercise scenario; no live-system testing was performed  

---

## 1. Executive Summary

Vanguard Security conducted a simulated penetration-testing engagement for Lumen Industrial Systems to assess the security of its customer-facing applications, internal administration functions, and Lumen-controlled demonstration infrastructure. The exercise identified a critical attack chain involving insufficient file-upload restrictions, exposure of internal service credentials, and inadequate separation of administrative access to IoT management functions. Within the simulated scenario, a manually constructed PNG/PHP polyglot was accepted by an administrative upload interface and executed with application-service privileges. Subsequent access to an internal authentication token enabled a pivot into administrative functions and read-only access to demonstration IoT management metadata. These weaknesses represent significant confidentiality and potential integrity risks for Lumen, particularly because three industrial customers operate as NIS2 essential entities and depend on the security of Lumen's services. The demonstrated scenario did not establish compromise of customer-deployed gateways, industrial production networks, or operational technology systems. Immediate remediation priorities include preventing execution of uploaded content, securing service credentials, and enforcing strict administrative access boundaries. The findings are relevant to cybersecurity risk-management measures under NIS2 Article 21 and to incident-response preparedness under Article 23. This report provides a structured educational assessment suitable for demonstrating professional reporting practices; its simulated technical evidence must not be represented as independently verified conformity evidence.

---

## 2. Scope and Methodology

### 2.1 Engagement Objectives

The engagement was designed to evaluate the resilience of Lumen-controlled infrastructure against realistic application-layer exploitation and subsequent unauthorised administrative access.

The principal objectives were to:

1. Identify weaknesses across the five authorised assessment surfaces.
2. Evaluate whether file-upload controls could permit server-side code execution.
3. Determine whether application-level access could expose internal credentials.
4. Assess the consequences of a pivot into administrative and IoT management functions.
5. Document potential business impacts and relevant NIS2 obligations.
6. Demonstrate non-destructive testing, evidence handling, and cleanup procedures.
7. Produce an auditable report with findings traceable to the engagement action log.

### 2.2 Authorised Scope

Consistent with the engagement Rules of Engagement, the authorised assessment surfaces were:

| Asset | Assessment Focus |
|---|---|
| Customer-facing web portal | Authentication, session management, input handling, and application security |
| Internal administration panel | File uploads, privilege boundaries, administrative access controls |
| Public REST API | Authentication, authorisation, information disclosure, and credential exposure |
| SSH-accessible demonstration edge gateway | Configuration and access-control assessment within the Lumen-controlled demonstration environment |
| In-house demonstration MQTT broker | Authentication, topic permissions, and exposure of demonstration messaging resources |

The exercise concentrated on the administrative application, associated application-server context, public API relationships, and internal IoT management functions.

The presence of an asset within the authorised scope does not imply that every security control on that asset was fully tested.

### 2.3 Explicit Exclusions

The following systems were excluded:

- Customer-deployed edge gateways.
- Production IoT sensors.
- Customer industrial and operational technology networks.
- Third-party infrastructure outside Lumen's authorisation.
- Production equipment operations and destructive testing.
- Unnecessary collection of sensitive customer information.

No findings in this report should be interpreted as evidence of direct compromise of these excluded environments.

### 2.4 Testing Constraints

The exercise followed the PTES methodology and the documented engagement boundaries.

Initial exploitation was designed around a manually constructed or publicly documented PNG/PHP polyglot technique. Metasploit was not used for the initial foothold.

Testing was limited to non-destructive validation of application execution, access permissions, administrative visibility, and demonstration metadata.

Sensitive credentials were represented only through redacted references. No production customer records or operational device commands were required to demonstrate the modelled impact.

The authoritative chronological record for this exercise is `3-actions_log.md`. Technical observations in this report are drawn from that fictional action log and must be interpreted within the educational simulation.

---

## 3. PTES Phase-by-Phase Methodology Summary

### Phase 1 — Pre-Engagement Interactions

The engagement began with the definition of business objectives, permitted systems, exclusions, testing constraints, communication requirements, and evidence-handling expectations. The Rules of Engagement established the boundaries between Lumen-controlled demonstration infrastructure and customer-owned industrial assets. This distinction was essential because technical reachability alone does not establish testing authorisation. The scope documentation also identified the importance of customer renewals, regulatory assurance, and the potential consequences of unauthorised access to industrial monitoring services.

### Phase 2 — Intelligence Gathering

The intelligence-gathering phase established the relevant application and infrastructure relationships using the scenario's supplied information. The assessment considered the customer-facing portal, internal administration panel, public REST API, demonstration edge gateway, and MQTT broker. Particular attention was given to relationships between application services, administrative authentication, and IoT management functionality. No independent discovery of production hosts, customer networks, or externally owned assets was performed.

### Phase 3 — Threat Modeling

Threat modeling evaluated plausible attack paths involving malicious file uploads, exposed service credentials, excessive administrative privileges, API authorisation weaknesses, and unauthorised access to IoT management information. Threats were prioritised according to potential exploitation paths and consequences for Lumen's business. The highest-priority scenario combined application compromise with credential-assisted lateral movement into internal administration. The model distinguished direct demonstration-system exposure from potential downstream effects on industrial customers.

### Phase 4 — Vulnerability Analysis

The vulnerability-analysis phase identified the administrative upload mechanism as the primary candidate for exploitation. The analysis considered whether file-type validation, content inspection, storage configuration, and server-side execution restrictions could be bypassed using a PNG/PHP polyglot. Related hypotheses included credential exposure through application configuration or API responses and insufficient segregation between application services and administrative functions. These hypotheses were documented before the modelled exploitation sequence and were not independently confirmed through live scanning.

### Phase 5 — Exploitation

The simulated exploitation phase demonstrated a coherent attack chain beginning with the acceptance of a manually constructed PNG/PHP polyglot, followed by application-level code execution under the `www-data` account. The scenario then modelled discovery of an internal service token and authenticated access to Lumen-controlled administrative functions. The final step demonstrated read-only access to synthetic IoT management metadata. The initial foothold did not involve Metasploit, and no root-level compromise was claimed. Each stage is mapped to a timestamped Phase 5 action-log entry.

### Phase 6 — Post-Exploitation

Post-exploitation activities assessed the confidentiality, integrity, and availability consequences of the modelled access. The exercise examined reachable application configuration information, internal credentials, administrative metadata, and demonstration IoT management records. The potential effect on Lumen's three NIS2-essential industrial customers was considered without claiming that their production environments had been accessed. The phase also documented simulated removal of the uploaded test file, verification of its absence, and checks for additional accounts, scheduled tasks, and configuration changes.

### Phase 7 — Reporting

The reporting phase consolidated the documented scope, threat model, simulated technical evidence, impact assessment, regulatory considerations, remediation priorities, and limitations into a single decision-oriented report. Findings were ranked according to their potential severity and relevance to Lumen's environment. Each exploitation claim was linked to the chronological action log, and each recommendation was associated with a specific security weakness. The report explicitly separates scenario observations, potential business consequences, and matters requiring independent validation.

---

## 4. Findings Prioritised by Severity

### 4.1 F-01 — Unsafe File Upload Leading to Server-Side Code Execution

**Severity:** Critical — Remediation Priority P1  
**Affected Asset:** Lumen internal administration panel  
**Category:** Unrestricted File Upload / Remote Code Execution  
**CWE References:** CWE-434, CWE-94  
**Evidence References:** Action Log, 13:38–13:47 UTC  

#### Technical Description

The simulated administrative upload interface accepted a manually constructed PNG/PHP polyglot and stored it at an application-accessible location.

The scenario demonstrated that the uploaded content could be interpreted by the server-side PHP execution environment, allowing a non-destructive identity check to run under the application service account.

The simulated command output was:

`uid=33(www-data) gid=33(www-data) groups=33(www-data)`

This result represents application-level execution rather than root access.

The weakness arises from the combination of inadequate upload validation, unsafe file storage or execution handling, and insufficient separation between uploaded content and executable application code.

#### CVSS Assessment

**CVSS Version:** 3.1  
**Illustrative Base Vector:** `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H`  
**Illustrative Base Score:** 8.8 — High

The vector assumes network accessibility, low attack complexity, an existing low-privilege upload capability, no additional user interaction, and potentially high confidentiality, integrity, and availability consequences.

**Environmental Assessment:** Critical remediation priority for Lumen. The precise CVSS environmental score remains unverified because production asset criticality, privilege requirements, security requirements, and compensating controls were not independently established. The Critical priority is a contextual business-risk classification, not a claim that the numerical CVSS score is Critical.

#### NIS2 Relevance

Article 21 is relevant to vulnerability handling, secure system development and maintenance, access control, and risk-management measures.

Article 23 may become relevant if a comparable real-world exploitation event meets the applicable criteria for a significant incident.

#### Business Impact

Successful exploitation could expose application secrets, enable manipulation of application-level information, and create an initial position for further compromise.

For Lumen, this risk directly affects customer confidence in the security of industrial monitoring services and could undermine renewal discussions with its three NIS2-essential industrial customers.

The exercise did not demonstrate compromise of industrial production equipment.

#### Recommended Remediation

1. Store uploaded files outside executable web directories.
2. Disable server-side script execution in upload storage locations.
3. Validate file types using strict allowlists and server-side content inspection.
4. Re-encode supported image formats rather than trusting supplied file contents.
5. Generate server-controlled filenames and reject dangerous extensions.
6. Apply least-privilege permissions to application services.
7. Introduce automated upload-security regression tests.

**Recommended Deadline:** Immediate containment, with permanent remediation targeted within seven days.

---

### 4.2 F-02 — Exposure and Misuse of Internal Service Credentials

**Severity:** High — Remediation Priority P1  
**Affected Assets:** Application server, public REST API relationships, internal administration  
**Category:** Sensitive Credential Exposure / Privilege Boundary Failure  
**CWE References:** CWE-200, CWE-522  
**Evidence References:** Action Log, 13:50–13:56 UTC  

#### Technical Description

Following the modelled application foothold, the exercise identified an internal service authentication token accessible from the compromised application context.

The token was then used in the simulated scenario to authenticate to an internal administrative endpoint.

An HTTP 200 response and access to administrative metadata represented successful credential-assisted movement from application-level access into a more sensitive management function.

The exact token value was excluded from the report.

The underlying weakness is that an application compromise can expose credentials whose permissions extend beyond the minimum functions required by the application.

#### CVSS Assessment

**CVSS Version:** 3.1  
**Illustrative Base Vector:** `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:L`  
**Illustrative Base Score:** 8.1 — High

The assessment assumes network-accessible exploitation after low-privilege application compromise, low additional attack complexity, and significant potential confidentiality and integrity consequences.

**Environmental Assessment:** High priority because the exposed token bridges application and administrative trust boundaries. A definitive environmental score requires validation of token scope, lifetime, production reachability, and compensating authentication controls.

#### NIS2 Relevance

Article 21 is relevant to identity and access management, credential protection, access-control policies, and cybersecurity risk assessment.

Article 20 is relevant to management oversight of the security controls required to prevent and respond to such weaknesses.

#### Business Impact

Compromised internal credentials could enable unauthorised access to administrative information, increase the consequences of an initial application compromise, and create opportunities for further lateral movement.

This could affect Lumen's ability to demonstrate effective separation of duties and protection of customer-related management systems.

The exercise established a simulated administrative pivot but did not demonstrate production customer account compromise.

#### Recommended Remediation

1. Rotate any potentially exposed service credentials.
2. Move secrets into a managed secret-storage solution.
3. Replace broad service tokens with narrowly scoped identities.
4. Separate application credentials from administrative credentials.
5. Enforce short token lifetimes and controlled renewal.
6. Monitor unusual token use and administrative authentication events.
7. Review API responses and configuration files for unnecessary secret exposure.

**Recommended Deadline:** Immediate credential containment, followed by architectural remediation within 30 days.

---

### 4.3 F-03 — Insufficient Segregation of IoT Management Information

**Severity:** High — Remediation Priority P2  
**Affected Asset:** Lumen-controlled IoT management functions  
**Category:** Excessive Administrative Access / Information Exposure  
**CWE References:** CWE-862, CWE-863  
**Evidence References:** Action Log, 13:59–14:02 and 14:18–14:24 UTC  

#### Technical Description

The simulated administrative session permitted read-only access to demonstration IoT management information.

The accessible information classes included:

- Synthetic device identifiers.
- Device-management status information.
- Monitoring configuration metadata.
- MQTT integration references.
- Internal service metadata.

The exercise demonstrated that a compromised application service token could provide visibility into management functions beyond the original application context.

No production device commands, customer-deployed gateways, or industrial networks were accessed.

The demonstrated weakness was information exposure through insufficient separation of administrative permissions. The ability to modify production IoT configurations was not established.

#### CVSS Assessment

**CVSS Version:** 3.1  
**Illustrative Base Vector:** `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N`  
**Illustrative Base Score:** 6.5 — Medium

This vector reflects the demonstrated read-only information exposure rather than unverified write access or service disruption.

**Environmental Assessment:** High business remediation priority due to the sensitivity of industrial monitoring relationships and the possibility of broader exposure if similar authorisation weaknesses exist in production. The numerical environmental score requires validation of actual customer-data sensitivity and production access boundaries.

#### NIS2 Relevance

Article 21 is relevant to access-control effectiveness, secure system architecture, risk management, and protection of network and information systems.

Article 23 would require assessment only if a real incident met the applicable significance and reporting conditions.

#### Business Impact

Unauthorised visibility into device-management information could reveal customer relationships, internal system architecture, monitoring configurations, or integration details.

For Lumen's three NIS2-essential industrial customers, comparable production weaknesses could create additional supplier risk and raise concerns during security audits and contract renewals.

However, the exercise does not establish that any particular customer was compromised or that operational technology availability was affected.

#### Recommended Remediation

1. Enforce server-side authorisation for every administrative endpoint.
2. Separate application identities from IoT management identities.
3. Implement role-based or attribute-based access controls.
4. Restrict management interfaces to approved administrative networks.
5. Require stronger authentication for privileged management operations.
6. Minimise sensitive metadata returned by APIs.
7. Log and review access to device-management resources.
8. Test cross-tenant and cross-role access restrictions.

**Recommended Deadline:** Initial access restrictions within 14 days, followed by complete authorisation review within 30 days.

---

### 4.4 Consolidated Risk Assessment

| Finding | Technical CVSS v3.1 Base | Business Priority | Demonstrated Exercise Impact |
|---|---|---|---|
| F-01 — Unsafe file upload | 8.8 High | Critical / P1 | Application-level code execution |
| F-02 — Service credential exposure | 8.1 High | High / P1 | Authenticated administrative pivot |
| F-03 — IoT management access segregation | 6.5 Medium | High / P2 | Read-only management metadata exposure |

The technical CVSS values are illustrative Base Scores. They are not independently verified Environmental Scores.

Business priorities reflect the potential consequences for Lumen's industrial customer relationships, security assurance requirements, and contractual obligations.

Availability disruption, production equipment manipulation, and customer-data exfiltration were not demonstrated.

---

## 5. Exploitation Narrative

### 5.1 Initial Access Preparation

At 13:35 UTC, the exercise documented the proposed attack chain and the requirement not to use Metasploit for initial access.

At 13:38 UTC, the candidate PNG/PHP polyglot structure was documented.

At 13:41 UTC, the exercise considered how inconsistent file-type validation and unsafe execution handling could allow uploaded content to be processed as server-side PHP.

These entries establish the rationale for the selected exploitation technique.

### 5.2 Foothold Establishment

At 13:44:30 UTC, the simulated payload was submitted to the authorised administrative upload endpoint.

The exercise response was HTTP 200 OK, with the uploaded file stored at:

`/uploads/polyglot.png`

At 13:45:15 UTC, a request to the uploaded file demonstrated simulated server-side execution.

At 13:46:20 UTC, the execution identity was validated using a non-destructive identity check.

The simulated output identified the application service account as `www-data`.

At 13:46:45 UTC, the foothold was classified as application-level execution without root privileges.

A subsequent verification at 13:47 UTC confirmed consistent execution behaviour within the scenario.

### 5.3 Credential-Assisted Pivot

At 13:50 UTC, the exercise documented discovery of an internal service token through the compromised application context.

At 13:53 UTC, that token was used to authenticate to an authorised internal administration endpoint.

The simulated HTTP 200 response demonstrated successful access to an administrative function beyond the original application context.

At 13:56 UTC, the pivot was validated through retrieval of non-destructive administrative metadata.

This established the modelled relationship between application compromise, credential exposure, and excessive administrative access.

### 5.4 Demonstration of Impact

At 13:59 UTC, the simulated administrative session reached the Lumen-controlled IoT management interface.

At 14:02 UTC, read-only access to synthetic device records and monitoring configuration metadata demonstrated the confidentiality consequences of the attack chain.

Phase 6 subsequently classified the exposed data categories and evaluated potential business consequences.

The exercise did not demonstrate write access to industrial devices, production telemetry manipulation, customer-network compromise, or service interruption.

### 5.5 Cleanup and Restoration

At 14:39 UTC, the exercise documented its cleanup inventory.

The uploaded polyglot file was the only test-created artefact identified in the scenario.

At 14:42 UTC, the file was removed using:

`rm -- /uploads/polyglot.png`

At 14:43 UTC, its absence was checked using:

`test ! -e /uploads/polyglot.png && echo "CLEANUP VERIFIED"`

The simulated verification returned `CLEANUP VERIFIED`.

Additional checks at 14:46 and 14:49 UTC documented the absence of test-created accounts, scheduled tasks, and persistent configuration changes.

At 14:52 UTC, the previously uploaded file path returned a simulated HTTP 404 response.

At 14:55 UTC, the cleanup review was completed.

These entries document restoration within the fictional exercise. They do not constitute independent verification of a live system.

---

## 6. Recommendations

### 6.1 Immediate Actions — Priority P1

**Target: 0–7 days**

Lumen should prioritise the controls that interrupt the demonstrated attack chain.

First, uploaded content must be prevented from executing as application code. The administrative upload workflow should be reviewed, unsafe upload paths disabled where necessary, and server-side execution restrictions enforced.

Second, internal service credentials potentially exposed through application components should be rotated and moved into controlled secret storage.

Third, access to sensitive administrative and IoT management functions should be restricted to explicitly authorised identities.

Fourth, relevant application, authentication, and administrative logs should be reviewed for evidence of comparable activity in real environments.

Each remediation should have a named owner, documented completion criteria, and a technical verification step.

### 6.2 Short-Term Actions — Priority P2

**Target: 7–30 days**

Lumen should implement systematic authorisation testing across the public API, internal administration, and IoT management interfaces.

Recommended measures include:

- Least-privilege service identities.
- Role-based access control.
- Administrative network restrictions.
- Automated upload validation tests.
- Credential exposure detection.
- Improved audit logging.
- Explicit tenant-isolation tests.
- Secure configuration baselines.

A targeted retest should verify that the original attack chain can no longer be reproduced in an authorised environment.

### 6.3 Long-Term Actions — Priority P3

**Target: 30–90 days**

Lumen should incorporate the findings into its broader cybersecurity governance and software development lifecycle.

Recommended improvements include formal threat modeling for new features, secure code-review requirements, regular penetration testing, incident-response exercises, supplier risk reviews, and documented vulnerability remediation service-level objectives.

Management should receive periodic reports on remediation progress, residual risk, and security assurance evidence.

The CISO should ensure that claims made to industrial customers are supported by verifiable technical evidence rather than relying solely on policy documentation.

### 6.4 NIS2 Assurance and Incident Readiness

Lumen should map relevant controls to NIS2 Article 21 and document their operational effectiveness.

Incident-response procedures should address the possibility of application compromise leading to administrative access and exposure of industrial monitoring information.

Where NIS2 applies to the affected entity and a real event qualifies as a significant incident, Article 23 reporting requirements must be assessed.

The general NIS2 reporting framework includes an early warning within 24 hours, an incident notification within 72 hours, and a final report within one month, subject to the Directive's detailed conditions and applicable national implementation.

A simulated vulnerability assessment does not itself establish a reportable incident.

---

## 7. Limitations and Uncertainty

### 7.1 Educational Simulation

This engagement was completed as a report-writing and penetration-testing methodology exercise.

No live Lumen laboratory, production endpoint, authenticated application session, or independent technical evidence was available.

The HTTP responses, identity output, credential-assisted pivot, IoT management access, and cleanup results described in the action log are constructed exercise observations.

They demonstrate how a professional penetration-testing report should document an attack chain, but they must not be presented as verified production findings.

### 7.2 Scope Restrictions

Customer-deployed edge gateways, production IoT sensors, customer industrial networks, and third-party infrastructure were explicitly excluded.

The exercise therefore cannot establish the security posture of these systems.

The inclusion of the demonstration edge gateway and MQTT broker in the authorised scope does not imply that either received comprehensive technical testing.

No conclusions about their full vulnerability status are warranted.

### 7.3 Unverified Production Impact

The scenario demonstrated application-level execution, an administrative pivot, and read-only management metadata exposure.

It did not demonstrate:

- Production customer-data exfiltration.
- Root-level system compromise.
- Industrial equipment manipulation.
- MQTT message injection into customer systems.
- Service interruption or denial of service.
- Persistence in a production environment.
- Cross-tenant compromise of actual customer accounts.

Potential downstream effects must therefore remain clearly distinguished from demonstrated exercise outcomes.

### 7.4 Severity and CVSS Uncertainty

The reported CVSS vectors and Base Scores are illustrative assessments based on the stated attack conditions.

A definitive Environmental Score would require verified information about actual production privileges, asset criticality, confidentiality requirements, integrity requirements, availability requirements, and deployed compensating controls.

The report assigns business remediation priorities separately from numerical CVSS severity.

These priorities should be reassessed after independent technical validation.

### 7.5 Regulatory and Contractual Uncertainty

The presence of three NIS2-essential industrial customers does not automatically establish Lumen's own regulatory classification or reporting obligations.

Applicability must be assessed according to Lumen's services, legal status, relevant sector, and applicable national legislation.

Likewise, this exercise does not establish a breach of NIS2 or prove that a significant incident occurred.

The potential consequences for contract renewals and Series A financing are business risks, not independently verified financial outcomes.

### 7.6 Evidence and Approval Limitations

The Rules of Engagement, action log, and technical observations were developed within a fictional case study.

No signed live-testing authorisation, production evidence package, independently verified cleanup confirmation, or genuine intranet cleanup flag was obtained.

Accordingly, this report is appropriate as an educational simulation but is not suitable for use as an unchanged independent penetration-testing attestation.

Before inclusion in a real conformity packet, the technical findings, CVSS environmental assessments, remediation status, and restoration evidence would require independent validation.

---

## 8. Appendices

### Appendix A — Finding and Evidence Traceability

| Finding | Evidence Source | Relevant Actions | Verification Status |
|---|---|---|---|
| F-01 — Unsafe file upload | `3-actions_log.md` | 13:38, 13:41, 13:44:30, 13:45:15, 13:46:20, 13:46:45 | Simulated |
| F-02 — Service credential exposure | `3-actions_log.md` | 13:50, 13:53, 13:56 | Simulated |
| F-03 — IoT management information exposure | `3-actions_log.md` | 13:59, 14:02, 14:18, 14:21 | Simulated |
| Customer impact assessment | `3-actions_log.md` | 14:24, 14:27 | Scenario-based assessment |
| NIS2 relevance | `3-actions_log.md` | 14:30, 14:33, 14:36 | Regulatory mapping |
| Cleanup verification | `3-actions_log.md` | 14:39–14:55 | Simulated |

Supporting engagement documents:

- `1-rules_of_engagement.md` — Scope, authorisation boundaries, exclusions, and engagement constraints.
- `2-threat_model.md` — Threat identification, prioritisation, and attack-path assumptions.
- `3-actions_log.md` — Chronological record of the exercise.
- `4-report.md` — Consolidated final report.

The action log is the primary traceability reference for the simulated technical sequence. The Rules of Engagement govern the permitted assessment boundaries.

### Appendix B — Selected Action Log Excerpt

| Timestamp (UTC) | Phase | Action | Target | Result |
|---|---|---|---|---|
| 2026-11-12T13:44:30Z | 5 | Submitted manually constructed PNG/PHP polyglot without Metasploit | admin.lumen.example | Simulated HTTP 200 OK; file accepted |
| 2026-11-12T13:46:20Z | 5 | Validated application-level execution identity | Lumen application server | Simulated uid=33(www-data) |
| 2026-11-12T13:53:00Z | 5 | Used internal service token for administrative access | Lumen internal administration | Simulated authenticated HTTP 200 response |
| 2026-11-12T14:02:00Z | 5 | Demonstrated read-only access to IoT management metadata | Lumen-controlled IoT management | Synthetic demonstration records accessible |
| 2026-11-12T14:24:00Z | 6 | Assessed potential industrial customer impact | Lumen customer services | Three NIS2-essential industrial customers identified as potentially affected stakeholders |
| 2026-11-12T14:30:00Z | 6 | Evaluated NIS2 Article 21 relevance | Lumen risk-management controls | Relevant control categories documented |
| 2026-11-12T14:42:00Z | 6 | Removed uploaded test file | Lumen application server | Simulated successful removal |
| 2026-11-12T14:43:00Z | 6 | Verified test file absence | Lumen application server | Simulated CLEANUP VERIFIED output |
| 2026-11-12T14:55:00Z | 6 | Completed cleanup and scope review | Lumen engagement | Exercise artefacts accounted for |

This appendix is a selected reconstruction aid, not a replacement for the complete chronological action log.

### Appendix C — Framework and Regulatory References

**Penetration Testing Execution Standard (PTES)**

Provides the seven-phase methodology used to structure engagement planning, intelligence gathering, threat modeling, vulnerability analysis, exploitation, post-exploitation, and reporting.

Reference: https://www.pentest-standard.org/

**FIRST CVSS v3.1**

Provides the vulnerability severity scoring framework used for the illustrative Base Score assessments.

Reference: https://www.first.org/cvss/v3.1/specification-document

**MITRE Common Weakness Enumeration (CWE)**

Provides standard weakness classifications, including:

- CWE-434 — Unrestricted Upload of File with Dangerous Type.
- CWE-94 — Improper Control of Generation of Code.
- CWE-200 — Exposure of Sensitive Information.
- CWE-522 — Insufficiently Protected Credentials.
- CWE-862 — Missing Authorization.
- CWE-863 — Incorrect Authorization.

Reference: https://cwe.mitre.org/

**Directive (EU) 2022/2555 — NIS2**

Relevant provisions include:

- Article 20 — Governance.
- Article 21 — Cybersecurity Risk-Management Measures.
- Article 23 — Reporting Obligations.

Reference: https://eur-lex.europa.eu/eli/dir/2022/2555/oj

### Appendix D — Final Assessment Statement

The simulated engagement demonstrates how weaknesses in file-upload validation, service credential management, and administrative access segregation can combine into a coherent compromise path.

The principal security lesson is that individually manageable weaknesses may create substantially greater risk when connected across application and administrative trust boundaries.

For Lumen Industrial Systems, the priority is to prevent an initial application compromise from becoming broader access to internal management functions and potentially sensitive industrial customer information.

The exercise also illustrates the importance of maintaining a defensible audit trail, respecting authorised boundaries, distinguishing observed impact from potential harm, and verifying cleanup.

**Final Exercise Status:** Reporting completed.  
**Technical Evidence Status:** Simulated and not independently verified.  
**Production Security Assurance:** Not established.  
**Recommended Next Step:** Authorised technical validation and remediation verification before any real conformity attestation.

---

**End of Report**
