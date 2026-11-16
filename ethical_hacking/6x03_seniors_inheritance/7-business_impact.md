
# Business Impact Quantification

**Client:** MediPath Diagnostics  
**Engagement:** VS-MPD-26-041  
**Currency:** EUR  
**Assessment basis:** Conditional business-impact scenarios, not confirmed financial losses.

## 1. Methodology and Financial Baseline

This assessment translates retained penetration-test findings and potential attack chains into financial scenarios suitable for remediation-budget decisions.

The figures represent plausible consequences if an identified weakness is exploited and produces the stated business outcome. They are not annualized expected losses, statistical predictions, or evidence that a breach has occurred.

Each scenario contains:

- A low estimate representing limited exploitation and rapid containment.
- A central estimate representing a material but contained incident.
- A high estimate representing wider exposure, more extensive response requirements, or significant customer consequences.

### MediPath Financial and Operational Baseline

| Metric | Client-supplied value |
| --- | --- |
| Contracted laboratories | 400 |
| Active patient profiles | 1,900,000 |
| Samples processed per business day | Approximately 62,000 |
| Result documents delivered annually | Approximately 14,000,000 |
| Annual recurring revenue (ARR) | EUR 31,200,000 |
| Average annual contract value per laboratory | EUR 78,000 |
| Core-platform outage exposure | EUR 65,000–120,000 per hour |
| Cyber-insurance deductible | EUR 250,000 |
| Existing incident-response retainer | EUR 180,000 per year |
| HDS renewal audit | Within five months |

Customer churn is modeled using annual revenue at risk:

- 1 laboratory: EUR 78,000 ARR.
- 4 laboratories (1%): EUR 312,000 ARR.
- 12 laboratories (3%): EUR 936,000 ARR.
- 20 laboratories (5%): EUR 1,560,000 ARR.

ARR loss represents a one-year revenue exposure, not an equivalent cash expense or profit loss.

The EUR 180,000 incident-response retainer is an existing annual commitment and is not automatically charged again to individual incidents. Additional investigation, legal, notification, recovery, and specialist costs are estimated separately.

The EUR 250,000 insurance deductible is not an automatic incident cost. Insurance recovery is excluded because policy coverage, exclusions, limits, and eligibility have not been established.

### Regulatory and External Context

Health data is subject to heightened protection under GDPR Article 9.

For infringements falling under the higher GDPR Article 83 tier, the maximum administrative fine is EUR 20 million or 4% of the preceding financial year's total worldwide annual turnover, whichever is higher.

Using MediPath's EUR 31.2 million ARR solely as an illustrative turnover proxy, 4% equals EUR 1,248,000. The EUR 20 million statutory alternative is therefore higher. Actual worldwide turnover has not been verified, and the statutory maximum is not a probable fine.

Regulatory-response provisions in the scenarios below are planning assumptions, not predictions of CNIL enforcement.

The CNIL's healthcare-data enforcement history, including its EUR 5 million sanction against IQVIA Operations France in May 2026, demonstrates that health-data governance failures can have material consequences. That case involved different facts and must not be used as a direct fine benchmark for MediPath.

ANSSI's 2025 cyber-threat panorama reported 1,366 confirmed incidents, with healthcare accounting for approximately 10%. CERT Santé reported 764 healthcare-sector incidents in 2025. These reports support the relevance of incident-response and care-continuity planning; they do not establish a monetary loss per MediPath incident.

HDS-related costs are modeled as conditional audit, corrective-action, and customer-assurance expenses. No scenario assumes automatic suspension or loss of certification merely because a vulnerability exists.

### Financial Modeling Rules

Each estimate is the sum of explicitly identified cost components:

**Scenario impact = incident response + recovery or operational costs + legal/notification costs + conditional regulatory or HDS costs + one-year customer revenue at risk.**

Components vary according to the finding. A zero allocation means the consequence is not sufficiently supported for that scenario.

The cost allocations are illustrative budgeting assumptions rather than externally observed unit prices.

Individual findings and attack-chain scenarios overlap. They must not be summed to produce a portfolio-wide loss figure.

## 2. Individual Finding Scenarios

## Item: F-01 — Cross-Laboratory Diagnostic Result Access

- **Priority:** P1
- **Range:** EUR 90,000 to EUR 2,310,000 (central estimate EUR 660,000).
- **Reasoning:** The demonstrated authorization weakness permits an authenticated laboratory user to retrieve a synthetic result belonging to another laboratory. A real incident involving health data could generate forensic investigation, patient and laboratory notification analysis, legal response, regulatory scrutiny, and customer churn. Larger exposure depends on result-identifier discovery and repeated exploitation, neither of which was established by the limited test.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Investigation and containment | 40,000 | 90,000 | 200,000 |
| Legal, privacy and notification response | 30,000 | 100,000 | 250,000 |
| Conditional regulatory/HDS response | 20,000 | 80,000 | 300,000 |
| One-year laboratory revenue at risk | 0 | 390,000 | 1,560,000 |
| **Total** | **90,000** | **660,000** | **2,310,000** |

- **Assumptions:**
  - Low: one laboratory relationship and a small number of records require investigation; no contract is lost.
  - Central: exposure concerns approximately 10 laboratories and up to 10,000 patient records; five laboratory contracts are at risk.
  - High: exposure concerns up to 40 laboratories and 100,000 patient records; 20 laboratory contracts are at risk.
  - Record counts and customer losses are hypothetical, not observed.
  - No system outage is attributed to this confidentiality finding.

## Item: F-02 — Stored XSS in Support Case Notes

- **Priority:** P1
- **Range:** EUR 25,000 to EUR 740,000 (central estimate EUR 140,000).
- **Reasoning:** Executable content was demonstrated in a support analyst's authenticated browser. The immediate financial exposure concerns investigation, content cleanup, session protection, and support workflow recovery. A broader scenario could involve unauthorized access to information available to affected support users. Credential theft and administrative privilege escalation were not demonstrated.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Investigation and containment | 15,000 | 50,000 | 120,000 |
| Support workflow recovery and validation | 10,000 | 40,000 | 100,000 |
| Conditional privacy/legal response | 0 | 50,000 | 130,000 |
| One-year laboratory revenue at risk | 0 | 0 | 390,000 |
| **Total** | **25,000** | **140,000** | **740,000** |

- **Assumptions:**
  - Low: one affected support session and rapid removal of malicious content.
  - Central: several support sessions require investigation and a limited privacy assessment.
  - High: a wider support-session incident affects multiple laboratory relationships, with five contracts at risk.
  - MFA and managed workstations reduce some risks but do not prevent same-origin script execution.
  - No privileged administrative action is assumed without the additional conditions examined in Chain 2.

## Item: F-03/09 — Connector Authorization and Privilege Lifecycle

- **Priority:** P1
- **Range:** EUR 75,000 to EUR 1,600,000 (central estimate EUR 465,000).
- **Reasoning:** F-03 demonstrates excessive connector-token scope, while F-09 demonstrates delayed revocation of administrative privileges. These findings are managed together as an authorization-lifecycle workstream, but a common technical root cause remains unverified. A consequential incident could require credential rotation, access-log review, connector configuration restoration, privacy investigation, and partner reassurance.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Credential, session and configuration recovery | 35,000 | 90,000 | 180,000 |
| Forensics and partner coordination | 25,000 | 80,000 | 180,000 |
| Conditional legal/regulatory/HDS response | 15,000 | 100,000 | 460,000 |
| One-year laboratory revenue at risk | 0 | 195,000 | 780,000 |
| **Total** | **75,000** | **465,000** | **1,600,000** |

- **Assumptions:**
  - Low: limited credential misuse or stale-session activity, contained without customer loss.
  - Central: several hospital or laboratory relationships require investigation; revenue equivalent to 2.5 average laboratory contracts is at risk.
  - High: broader connector misuse or unauthorized configuration changes affect up to 20 laboratory relationships, with revenue equivalent to 10 contracts at risk.
  - Revenue-equivalent assumptions represent aggregate exposure, not necessarily fractional contracts.
  - No compromise of every hospital connector is assumed.
  - The consolidation does not erase the separate F-03 and F-09 evidence or validation requirements.

## Item: F-04 — Disabled TLS Peer Verification

- **Priority:** P2
- **Range:** EUR 15,000 to EUR 450,000 (central estimate EUR 85,000).
- **Reasoning:** A legacy connector worker disables certificate verification, but a managed mTLS gateway reportedly validates upstream certificates and restricts destinations. The lower scenarios concern investigation and corrective configuration work. A higher impact requires gateway bypass or enforcement failure together with a feasible interception position. No interception attack was demonstrated.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Gateway verification and investigation | 10,000 | 25,000 | 70,000 |
| Connector recovery and partner coordination | 5,000 | 40,000 | 100,000 |
| Conditional confidentiality/integrity response | 0 | 20,000 | 280,000 |
| **Total** | **15,000** | **85,000** | **450,000** |

- **Assumptions:**
  - Low: compensating gateway controls operate correctly and no traffic interception occurs.
  - Central: a limited control-enforcement issue requires connector and partner investigation.
  - High: a previously unverified bypass permits interception or modification of sensitive integration traffic.
  - No customer churn or core-platform outage is assumed.
  - The high scenario is conditional and has lower evidential confidence than the demonstrated authorization failures.

## Item: F-05 — Unsigned Partner Sample-Status Webhook

- **Priority:** P1
- **Range:** EUR 40,000 to EUR 1,250,000 (central estimate EUR 290,000).
- **Reasoning:** The test demonstrated unauthorized modification of a synthetic sample status through an unsigned webhook from an approved partner test source. A real integrity incident could require laboratory reconciliation, investigation of affected samples, correction of workflow states, partner notification, and customer assurance. Downstream release of incorrect clinical results was not demonstrated.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Investigation and sample-state reconciliation | 25,000 | 90,000 | 250,000 |
| Workflow correction and partner coordination | 15,000 | 80,000 | 220,000 |
| Conditional legal/HDS and clinical-process review | 0 | 42,000 | 390,000 |
| One-year laboratory revenue at risk | 0 | 78,000 | 390,000 |
| **Total** | **40,000** | **290,000** | **1,250,000** |

- **Assumptions:**
  - Low: one partner integration and a limited number of synthetic-equivalent sample records require reconciliation.
  - Central: approximately 1,000 sample-status events across several laboratory relationships require review; one contract is at risk.
  - High: up to 10,000 events require reconciliation and five laboratory contracts are at risk.
  - The volume estimates are illustrative and are not derived from the proof of exploitation.
  - No incorrect diagnosis, patient injury, or confirmed result release is assumed.
  - Source-IP allowlisting does not provide cryptographic message integrity.

## Item: F-06 — Excessive Diagnostic Export Retention

- **Priority:** P2
- **Range:** EUR 20,000 to EUR 1,130,000 (central estimate EUR 210,000).
- **Reasoning:** An export package remained accessible beyond the documented retention period. Extended availability increases the potential exposure window and creates privacy-governance and HDS evidence concerns. The observed access was by an authorized user; unauthorized disclosure was not established. Financial consequences therefore depend on whether the retained data is subsequently exposed or whether a material compliance failure requires remediation.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Retention audit and deletion verification | 15,000 | 45,000 | 100,000 |
| Legal, DPO and HDS corrective-action work | 5,000 | 65,000 | 250,000 |
| Conditional incident response and notification | 0 | 100,000 | 390,000 |
| One-year laboratory revenue at risk | 0 | 0 | 390,000 |
| **Total** | **20,000** | **210,000** | **1,130,000** |

- **Assumptions:**
  - Low: isolated excessive retention without unauthorized access.
  - Central: multiple retained packages require investigation, remediation, and limited notification analysis.
  - High: retained health-data exports are subsequently exposed, affecting several laboratories; five contracts are at risk.
  - Encryption at rest remains relevant but does not enforce retention periods.
  - No regulatory sanction or certification suspension is treated as automatic.

## Item: F-08 — Password-Recovery Account Enumeration

- **Priority:** P3
- **Range:** EUR 5,000 to EUR 210,000 (central estimate EUR 35,000).
- **Reasoning:** Distinguishable recovery responses reveal whether an account exists. The direct weakness supports reconnaissance but does not demonstrate credential compromise or account takeover. The primary costs concern investigation, authentication monitoring, recovery-flow correction, and possible targeted-user support. Broader consequences require additional independent attacker actions.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Investigation and authentication monitoring | 5,000 | 15,000 | 40,000 |
| User-support and account-security response | 0 | 20,000 | 80,000 |
| Conditional wider incident investigation | 0 | 0 | 90,000 |
| **Total** | **5,000** | **35,000** | **210,000** |

- **Assumptions:**
  - Low: limited enumeration with no compromised accounts.
  - Central: repeated enumeration requires monitoring and user-support measures.
  - High: enumeration is associated with a separate successful account-compromise attempt requiring broader investigation.
  - The high scenario is conditional; the finding alone does not prove account compromise.
  - No regulatory fine, outage, or customer churn is assigned directly to enumeration.

## Item: F-10 — Caller-Controlled Laboratory Identity in Analytics

- **Priority:** P1
- **Range:** EUR 35,000 to EUR 970,000 (central estimate EUR 220,000).
- **Reasoning:** The analytics service accepted a caller-controlled laboratory identifier from an internal application-network path, exposing aggregate activity for another laboratory. A real incident could require tenant-access investigation, service identity redesign, reporting-data review, privacy assessment, and laboratory reassurance. Access to individual patient result records was not demonstrated through this finding alone.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Investigation and containment | 20,000 | 55,000 | 130,000 |
| Analytics access-control and reporting review | 15,000 | 65,000 | 130,000 |
| Conditional legal/privacy/HDS response | 0 | 100,000 | 320,000 |
| One-year laboratory revenue at risk | 0 | 0 | 390,000 |
| **Total** | **35,000** | **220,000** | **970,000** |

- **Assumptions:**
  - Low: a single laboratory's aggregate reporting information is exposed.
  - Central: unauthorized access affects analytics data associated with approximately 10 laboratories.
  - High: a broader cross-laboratory analytics exposure affects up to 40 laboratories, with five contracts at risk.
  - Internal network reachability is required.
  - No patient-level result disclosure or successful pivot into F-01 is assumed in this individual scenario.

## 3. Attack-Chain Scenarios

Attack-chain estimates describe a single combined incident and are not the arithmetic sum of the individual findings.

Each chain remains conditional because the complete sequence was not demonstrated during the inherited engagement.

## Item: Chain 1 — Connector-to-Diagnostic Cross-Tenant Exposure

**Path:** F-03 → F-10 → F-01

- **Priority:** P1
- **Range:** EUR 180,000 to EUR 4,500,000 (central estimate EUR 1,300,000).
- **Reasoning:** If an overprivileged connector identity can reach the internal analytics service, and analytics information enables discovery of result identifiers, the attacker may be able to exploit the cross-tenant Results API weakness. A successful combined incident could create a wider patient-data exposure than any isolated test demonstrated. Costs include multi-system forensics, health-data notification, regulatory and HDS response, and laboratory-client churn.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Multi-system investigation and containment | 70,000 | 180,000 | 450,000 |
| Legal, patient and laboratory notification | 50,000 | 220,000 | 650,000 |
| Conditional regulatory/HDS response | 60,000 | 354,000 | 1,840,000 |
| One-year laboratory revenue at risk | 0 | 546,000 | 1,560,000 |
| **Total** | **180,000** | **1,300,000** | **4,500,000** |

- **Assumptions:**
  - Low: a limited multi-system exposure is detected before large-scale data access.
  - Central: approximately 20 laboratories and up to 50,000 patient records are implicated; revenue equivalent to seven laboratory contracts is at risk.
  - High: up to 100 laboratories and 250,000 patient records are implicated; 20 contracts are at risk.
  - The connector-to-analytics path and identifier-discovery step require validation.
  - The full chain has not been proven.
  - No outage or confirmed HDS certification suspension is assumed.
  - This scenario supersedes overlapping F-03/09, F-10, and F-01 incident costs when modeling the same event.

## Item: Chain 2 — Support XSS to Residual Administrative Privileges

**Path:** F-02 → F-09

- **Priority:** P1
- **Range:** EUR 60,000 to EUR 2,050,000 (central estimate EUR 420,000).
- **Reasoning:** Stored XSS could become more consequential if support and privileged administrative sessions share an exploitable security context and an attacker can act during the stale-authorization window. A successful chain could require privileged configuration recovery, cross-system investigation, partner assurance, and privacy or regulatory response. The necessary origin, session, and privilege relationships have not been demonstrated.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Forensics and session containment | 30,000 | 100,000 | 250,000 |
| Privileged configuration recovery | 20,000 | 90,000 | 250,000 |
| Conditional privacy, legal and HDS response | 10,000 | 152,000 | 770,000 |
| One-year laboratory revenue at risk | 0 | 78,000 | 780,000 |
| **Total** | **60,000** | **420,000** | **2,050,000** |

- **Assumptions:**
  - Low: attempted chain activity is contained with limited privileged-system investigation.
  - Central: unauthorized configuration activity affects several integration relationships; one contract is at risk.
  - High: material privileged configuration misuse affects multiple laboratory relationships; 10 contracts are at risk.
  - Exploitation requires a suitable administrative context and a valid stale-privilege window.
  - The observed F-09 window was approximately 27 minutes.
  - No credential theft, privilege escalation, or end-to-end chain success was demonstrated.
  - The scenario does not assume a core-platform outage.

## Item: Chain 3 — Account Enumeration to Support-Session Compromise

**Path:** F-08 → F-02

- **Priority:** P2
- **Range:** EUR 30,000 to EUR 950,000 (central estimate EUR 180,000).
- **Reasoning:** Account enumeration could support targeted social engineering or identification of valid laboratory accounts. A separate compromise or authorized case-submission path would then be required to place malicious content into a support note and trigger the stored XSS weakness. Financial exposure could include account investigation, support-session containment, privacy response, and customer reassurance. Enumeration itself does not supply credentials.

**Financial breakdown:**

| Component | Low | Central | High |
| --- | ---: | ---: | ---: |
| Identity and support-session investigation | 20,000 | 60,000 | 150,000 |
| Account and support workflow recovery | 10,000 | 50,000 | 130,000 |
| Conditional legal/privacy response | 0 | 70,000 | 280,000 |
| One-year laboratory revenue at risk | 0 | 0 | 390,000 |
| **Total** | **30,000** | **180,000** | **950,000** |

- **Assumptions:**
  - Low: targeted enumeration and attempted malicious note submission are detected and contained.
  - Central: one compromised or otherwise authorized laboratory account enables malicious case content to reach several support users.
  - High: a wider support-session incident affects multiple laboratory relationships; five contracts are at risk.
  - Social engineering or account compromise is an additional hypothetical step, not an observed result of F-08.
  - Existing MFA coverage reduces some account-compromise paths.
  - No successful complete attack chain was demonstrated.

## 4. Consolidated Financial Comparison

| Item | Priority | Low (EUR) | Central (EUR) | High (EUR) |
| --- | --- | ---: | ---: | ---: |
| F-01 | P1 | 90,000 | 660,000 | 2,310,000 |
| F-02 | P1 | 25,000 | 140,000 | 740,000 |
| F-03/09 | P1 | 75,000 | 465,000 | 1,600,000 |
| F-04 | P2 | 15,000 | 85,000 | 450,000 |
| F-05 | P1 | 40,000 | 290,000 | 1,250,000 |
| F-06 | P2 | 20,000 | 210,000 | 1,130,000 |
| F-08 | P3 | 5,000 | 35,000 | 210,000 |
| F-10 | P1 | 35,000 | 220,000 | 970,000 |
| Chain 1 | P1 | 180,000 | 1,300,000 | 4,500,000 |
| Chain 2 | P1 | 60,000 | 420,000 | 2,050,000 |
| Chain 3 | P2 | 30,000 | 180,000 | 950,000 |

**Important:** The figures in this table are alternative conditional incident scenarios. Adding all rows would materially overstate exposure because the chains share vulnerabilities, investigation costs, affected assets, and potentially affected customers.

## 5. Regulatory, Insurance and Certification Uncertainty

### GDPR and CNIL

The GDPR statutory ceiling must be distinguished from a plausible sanction scenario.

The amounts allocated to regulatory and HDS response are scenario provisions combining possible external advice, compliance investigation, corrective-action work, and conditional enforcement consequences. They are not forecasts of a specific CNIL fine.

A formal enforcement assessment would require confirmed facts concerning affected data, controller/processor responsibilities, actual harm, safeguards, breach notification, prior conduct, and applicable turnover.

### Cyber Insurance

The EUR 250,000 deductible is relevant to MediPath's potential retained financial exposure but must not be added automatically to every incident.

The model presents gross business impact before insurance recovery. Any subsequent net-loss calculation should deduct only recoveries confirmed under the policy and should account for applicable deductibles, limits, and exclusions.

### HDS Certification

HDS exposure may involve additional evidence collection, corrective-action plans, independent assessment, customer assurance, or contract-renewal uncertainty.

Certification suspension is not established by the penetration-test findings. Any suspension or loss-of-certification scenario requires separate evidence and should not be treated as inevitable.

### Operational Disruption

MediPath estimates EUR 65,000–120,000 per hour in direct operating and service-credit exposure during a core-platform outage.

For reference:

- 2 hours: EUR 130,000–240,000.
- 4 hours: EUR 260,000–480,000.
- 8 hours: EUR 520,000–960,000.

These values are sensitivity references only. They have not been added to the finding or chain estimates because the inherited tests did not demonstrate a core-platform outage or establish that any particular exploit would cause one.

If future validation establishes a credible outage pathway, the corresponding duration-based costs should be included in a revised scenario without duplicating recovery or service-credit components.

## 6. Implications for Remediation Investment

The financial scenarios support prioritizing F-01, F-03/09, F-05, F-10, and the related cross-system attack chains.

Chain 1 presents the largest modeled conditional exposure because it combines connector authorization, analytics tenant identity, and patient-result access. Its central scenario is EUR 1.30 million, but that figure assumes unverified attack pivots and must not be interpreted as expected loss.

F-05 warrants immediate remediation because the inherited test demonstrated a workflow-integrity failure. The financial model does not assume incorrect clinical results or patient harm.

F-02 and F-09 also warrant urgent treatment because their combination could increase the consequences of a support-session incident if the required administrative context exists.

F-04, F-06, and F-08 remain important but have different evidence and exposure characteristics. Their scenario ranges should be revisited when gateway enforcement, retention scope, and account-access prerequisites are verified.

The CFO should compare proposed remediation spending against these conditional loss scenarios while recognizing that incident probability has not been estimated. A defensible return-on-security-investment calculation would additionally require an assessed annual likelihood, expected risk reduction, implementation cost, and ongoing control-maintenance expense.

## Conclusion

The modeled financial exposure varies substantially according to exploitation scope, the sensitivity of affected information, the number of laboratory customers involved, and the effectiveness of containment.

The estimates provide the CISO and CFO with transparent scenarios for discussing remediation investment without confusing technical vulnerabilities with confirmed financial losses.

The most important financial risk drivers are patient-data confidentiality, diagnostic workflow integrity, privileged access, customer retention, and regulatory accountability.

Every estimate should be recalibrated when MediPath obtains stronger evidence concerning actual exposure, attack-chain feasibility, customer response, insurance coverage, or remediation effectiveness.
