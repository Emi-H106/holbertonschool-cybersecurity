# Engagement Report, Nordstrøm Power Group

**For:** Elin Solberg, Chief Information Security Officer, and the Nordstrøm Power Group Board of Directors  
**Prepared by:** Vanguard Security  
**Engagement:** Group Cybersecurity Assessment and Three-Year Strategic Planning Support  
**Evidence assessment date:** 21 April 2026  
**Document status:** Final assessment report based on the supplied controlled evidence  
**Classification:** Confidential — Board and authorised management distribution

---

## 1. Executive Summary (No Jargon)

### 1.1 Overall assessment

Nordstrøm Power Group operates essential energy businesses across five countries. Its offshore gas, hydroelectric, wind, electricity trading, gas and hydrogen infrastructure, and recently acquired solar operations create significant dependencies on reliable technology, trusted suppliers, and effective oversight.

The assessment identified three priority concerns.

First, the Group's supplier onboarding environment presents a confirmed, limited access concern. The controlled evidence demonstrates that a peripheral supplier workflow could be reached in a manner requiring stronger assurance over supplier-facing processes. This does not establish a compromise of the Group's core energy operations.

Second, the recently acquired German solar subsidiary presents a more significant integration concern. The assessment evidence confirms that a controlled test environment exposed information about facilities, maintenance arrangements, and operational responsibilities. Such information could assist an attacker in understanding important business systems if comparable weaknesses existed in production.

Third, the German integration environment revealed information about the relationship between business systems and operational infrastructure. This creates a credible concern about how effectively the Group separates business technology from systems supporting energy operations. However, the assessment did not demonstrate that an attacker could control operational equipment.

These findings support a clear strategic conclusion:

**Nordstrøm should prioritise acquisition integration assurance, supplier governance, and protection of the boundary between business and operational systems.**

The evidence does not justify a conclusion that Nordstrøm's production energy infrastructure has been compromised.

### 1.2 Business significance

The Group's risk is not limited to individual technical weaknesses.

Nordstrøm faces a broader governance challenge: ensuring that acquired businesses, suppliers, and national subsidiaries operate under consistent minimum security expectations while respecting differences in operational risk and national regulation.

The German acquisition illustrates why security integration must be treated as a business priority rather than a routine technology exercise.

Weak oversight of inherited systems can create uncertainty about access rights, information exposure, ownership, and the effectiveness of protective controls.

For energy businesses, these uncertainties may ultimately affect operational resilience, regulatory assurance, investor confidence, and the ability to demonstrate responsible risk management.

### 1.3 Recommended board decisions

The Board should approve the following strategic directions:

1. Establish a Group-wide minimum security baseline for subsidiaries, suppliers, and newly acquired businesses.
2. Prioritise an independent review of the German solar subsidiary's integration arrangements.
3. Commission a carefully controlled review of protections surrounding operational systems, beginning with the most critical dependencies.
4. Require country-specific regulatory assessments rather than assuming that one European compliance approach applies identically everywhere.
5. Introduce measurable quarterly reporting on remediation, ownership, operational resilience, and outstanding uncertainty.
6. Fund a three-year improvement programme with annual decision points and accountable executive owners.

### 1.4 Three-year direction

**Year 1 — Establish control and accountability.**

Complete critical asset inventories, strengthen supplier onboarding, address inherited German integration risks, define minimum access-control requirements, and establish clear responsibility for business-to-operational system boundaries.

**Year 2 — Strengthen resilience and monitoring.**

Extend security assurance to operational environments, improve monitoring and incident readiness, reduce unnecessary system connections, and standardise subsidiary risk reporting.

**Year 3 — Demonstrate sustained assurance.**

Introduce recurring independent verification, test resilience arrangements, measure improvement against agreed indicators, and maintain board oversight of residual risk.

### 1.5 Assurance statement

This engagement reconstructed controlled, synthetic assessment evidence rather than performing live testing against Nordstrøm's production infrastructure.

The results establish specific findings within that evidence model and support prioritised strategic decisions.

They do not establish comprehensive coverage of the Group's infrastructure, successful operational-system compromise, or the absence of additional vulnerabilities.

**Board conclusion:** Proceed with a risk-based, three-year security improvement programme, beginning with the German acquisition, supplier assurance, and operational boundary governance.

---

## 2. Engagement Context and Methodology

### 2.1 Organisational context

Nordstrøm Power Group is a multinational energy holding company with five distinct operating environments:

| Subsidiary | Country | Business activity | Strategic security concern |
|---|---|---|---|
| Offshore gas operations | Norway | Offshore gas production | Safety, operational continuity, and third-party access |
| Hydro and wind operations | Sweden | Renewable electricity generation | Availability and resilience of generation operations |
| Offshore wind and trading | Denmark | Wind generation and electricity trading | Market-facing systems, transaction integrity, and operational continuity |
| Gas and hydrogen infrastructure | Netherlands | Energy transportation and infrastructure | Cross-border dependencies and operational-system protection |
| Utility-scale solar subsidiary | Germany | Recently acquired solar generation | Inherited systems, integration interfaces, and IT/OT boundaries |

The recently acquired German subsidiary is strategically important because acquisition integration can introduce inherited technical dependencies and inconsistent security practices.

The engagement was designed to help Elin Solberg establish an evidence-informed security baseline and translate assessment findings into a three-year strategic plan.

### 2.2 Engagement objectives

The assessment sought to:

- Identify material exposure within the permitted public and peripheral environment.
- Validate a controlled initial access scenario without affecting production operations.
- Investigate a higher-value integration asset using supplied Phase 2 evidence.
- Distinguish suspected weaknesses from confirmed findings.
- Determine the business relevance of exposed operational metadata.
- Reconcile actual coverage with the agreed assessment boundaries.
- Confirm documented cleanup and restoration.
- Provide prioritised recommendations for the Board's three-year plan.

### 2.3 Evidence-based execution model

The engagement was reconstructed entirely from the authorised offline evidence bundle.

The material included:

- DNS and certificate inventory records.
- HTTP observation records.
- Service banners.
- Saved HTML representations.
- API evidence samples.
- Gateway routing and telemetry records.
- UTC event timelines.
- Restoration audit records.
- Report-support matrices and contextual guidance.

No live scanning, authentication attempts, exploitation, persistence, destructive activity, or production OT testing was performed as part of this reconstruction.

### 2.4 Methodology

The engagement followed a risk-based assessment structure informed by penetration-testing, application-security, threat-modelling, and industrial-security principles.

The practical workflow was:

**Stage 1 — Scope and evidence validation**

Confirm permitted assets, evidence classifications, timestamps, and exclusions.

**Stage 2 — Public and peripheral reconnaissance**

Reconstruct the public-facing inventory and identify supplier-related exposure.

**Stage 3 — Controlled peripheral access validation**

Examine the accepted read-only supplier workflow evidence and distinguish discovery from proof.

**Stage 4 — Targeted integration assessment**

Review the German subsidiary's integration API, separating identification-only service information from confirmed data-exposure evidence.

**Stage 5 — Operational impact analysis**

Correlate integration metadata with OT-adjacent gateway information while avoiding unsupported claims of operational compromise.

**Stage 6 — Restoration verification**

Confirm the documented removal of temporary artefacts, revocation of synthetic credentials, session closure, and restoration of the laboratory environment.

**Stage 7 — Strategic synthesis**

Translate the evidence into subsidiary-specific risks, governance priorities, and continuation recommendations.

### 2.5 Evidence acceptance rules

Evidence was assessed using the following fields:

| Field | Analytical purpose |
|---|---|
| `timestamp_utc` | Establish chronological order |
| `event_id` | Identify the source record |
| `phase_hint` | Support phase filtering |
| `scope_zone` | Check the relevant assessment boundary |
| `classification` | Distinguish identification, observation, candidate, proof, and verification |
| `verdict` | Determine whether a record was accepted, deferred, rejected, or noise |
| `correlation_key` | Join related records across different files |
| `marker_b64` | Identify encoded markers in relevant accepted records |

An accepted observation was not automatically treated as confirmed exploitation.

Proof required a relevant accepted proof record and a supporting observed result. Where available, related records were correlated by timestamp, asset, and correlation key.

### 2.6 Execution chronology

The controlled evidence records the following milestones on 21 April 2026.

| Time (UTC) | Activity | Principal evidence |
|---|---|---|
| 09:02:11 | Public surface identified | `evt-p1-001` |
| 09:20:45 | German integration API discovered and deferred | `evt-p1-002` |
| 09:31:18 | Supplier onboarding surface identified | `evt-p1-003` |
| 09:47:33 | Controlled supplier foothold confirmed | `evt-p1-004`, `http-9001` |
| 09:52:06 | Public-surface mapping proof confirmed | `evt-p1-005`, `cert-9001` |
| 10:12:09 | German integration service identified | `evt-p2-001` |
| 10:28:44 | Synthetic integration data exposure confirmed | `evt-p2-002`, `api-9001` |
| 10:43:20 | OT-adjacent metadata relationship confirmed | `evt-p2-003`, `tele-9001` |
| 10:56:31 | Acquisition and governance implications recorded | `evt-p2-004` |
| 11:03:58 | Cleanup and restoration verified | `evt-p2-005`, `clean-9001` |

The chronology is derived from recorded evidence timestamps, not from the numerical ordering of unrelated record identifiers.

---

## 3. Threat Profile Synthesis (Post-Execution)

### 3.1 Strategic threat environment

Nordstrøm's operating model exposes the Group to several interconnected threat categories.

**Operational disruption**

Energy production and infrastructure depend on reliable operational systems. Disruption can affect availability, safety, contractual commitments, and public confidence.

**Third-party compromise**

Supplier portals, maintenance providers, and external integration partners may create indirect access paths and complicate accountability.

**Acquisition-related exposure**

Newly acquired businesses may retain legacy applications, undocumented interfaces, inherited credentials, and inconsistent security practices.

**Business-to-operational system convergence**

Connections between corporate systems and operational infrastructure may expose sensitive metadata or create unintended trust relationships.

**Market and information integrity**

Electricity trading and market-facing services depend on accurate information, dependable transactions, and effective protection against unauthorised changes.

**Cross-border governance complexity**

The Group must manage different national requirements, operational expectations, and regulatory responsibilities.

### 3.2 How Phase 1 changed the threat assessment

Before execution, supplier-related compromise was a plausible threat scenario based on Nordstrøm's operating model.

Phase 1 added concrete, controlled evidence.

The supplier onboarding portal was identified as a peripheral attack-surface candidate through `evt-p1-003`.

A subsequent accepted proof record, `evt-p1-004`, supported by `http-9001`, confirmed a controlled read-only foothold in the synthetic supplier workflow.

This increased the priority of supplier onboarding assurance.

The evidence did not demonstrate privileged corporate access, access to production energy operations, or a complete compromise of supplier identity controls.

The strategic implication is that supplier-facing applications require defined ownership, access reviews, monitoring, and consistent onboarding and offboarding standards.

### 3.3 How Phase 2 changed the threat assessment

Phase 2 focused on the German subsidiary's integration API, which had been identified and deferred during Phase 1.

The service banner associated with `evt-p2-001` suggested a legacy staging bridge using the label `legacy-adapter-2.x`.

This was identification evidence only.

At 10:28:44 UTC, `evt-p2-002` and `api-9001` confirmed exposure of a read-only synthetic integration dataset.

The observed fields included:

- `site_id`
- `asset_class`
- `maintenance_window`
- `telemetry_gateway_label`
- `business_owner`

These fields could reveal operational relationships and maintenance context if comparable exposure occurred in production.

At 10:43:20 UTC, `evt-p2-003` and `tele-9001` established that gateway labels were enumerable through integration metadata.

This supported a concern about the IT/OT boundary.

However, no operational command channel was reached, and no OT command execution was attempted.

### 3.4 Revised threat priorities

| Threat scenario | Pre-execution concern | Evidence-informed assessment | Strategic priority |
|---|---|---|---|
| Supplier-facing workflow exposure | Plausible | Controlled read-only foothold confirmed | Medium |
| German acquisition integration exposure | High concern | Synthetic integration data exposure confirmed | High |
| IT/OT boundary reconnaissance | High concern | Gateway metadata relationship confirmed; operational access unproven | High |
| Direct OT compromise | Material potential consequence | Not demonstrated by the supplied evidence | Requires separate assessment |
| Investor portal authenticated weakness | Possible | Authenticated depth deferred | Deferred |
| Group-wide lateral movement | Potential threat | Not demonstrated | Requires separate authorisation and evidence |

### 3.5 Strategic interpretation

The strongest evidence concerns supplier onboarding and the German integration environment.

It would be inappropriate to generalise these observations into a claim that all five subsidiaries contain equivalent vulnerabilities.

Nevertheless, the findings reveal governance questions that are relevant across the Group:

- Are inherited interfaces systematically identified after acquisitions?
- Are supplier-facing systems subject to consistent assurance?
- Is operational metadata protected according to business sensitivity?
- Are business-to-operational system relationships documented and independently reviewed?
- Can management distinguish verified control effectiveness from assumed control effectiveness?

The three-year strategy should address these questions across the Group while prioritising technical remediation where evidence is strongest.

---

## 4. Scope Delivered and Deferred

### 4.1 Scope delivered

The engagement delivered a controlled reconstruction of public/peripheral Phase 1 and targeted German integration Phase 2 evidence.

| Workstream | Delivered activity | Status |
|---|---|---|
| Public surface | Synthetic DNS, HTTP, and certificate evidence review | Completed |
| Supplier onboarding | Peripheral workflow identification and read-only foothold evidence | Confirmed |
| German integration API | Service identification and read-only dataset exposure | Confirmed |
| OT-adjacent metadata | Integration-to-gateway metadata relationship assessment | Confirmed at metadata level |
| Cleanup | Temporary artefact removal, token revocation, session closure, and restoration verification | Confirmed |
| Strategic reporting | Risk synthesis, prioritisation, and three-year recommendations | Completed |

### 4.2 Scope deferred

The following activities were not demonstrated by the supplied evidence.

| Deferred area | Reason or boundary | Proposed treatment |
|---|---|---|
| Authenticated investor portal assessment | Explicitly deferred in evidence | Separately authorised application assessment |
| Production OT penetration testing | Excluded from controlled offline reconstruction | Safety-led OT assurance engagement |
| OT command execution | Not attempted | Do not infer capability; review under approved OT methodology |
| Production lateral movement | No confirmed evidence | Separate scoped assessment if justified |
| Full German acquisition security review | Phase 2 covered selected integration evidence only | Dedicated German subsidiary engagement |
| Comprehensive testing of Norway, Sweden, Denmark, and Netherlands | No equivalent execution proof supplied | Risk-ranked future assessments |
| Production remediation verification | No production changes performed | Owner-led remediation followed by authorised retesting |

### 4.3 Scope reconciliation

The assessment remained bounded by the supplied evidence.

The German API's discovery in Phase 1 did not authorise or establish technical exploitation during that phase.

The Phase 2 evidence subsequently supported a specific, read-only data-exposure finding.

The telemetry evidence supported metadata-level OT pivot potential, not operational control.

This distinction is essential for accurate risk reporting and defensible engagement boundaries.

### 4.4 Contractual interpretation

The original engagement structure and any newly proposed continuation phases must remain distinct.

The Phase 3 OT deep-dive and Phase 4 German subsidiary review described in Section 7 are proposed follow-on services.

They should not be represented as already executed, approved, or included in the original fixed scope unless confirmed through a signed contractual amendment.

---

## 5. Findings by Subsidiary and IT/OT

### 5.1 Prioritisation method

Findings were prioritised using:

1. Confirmed evidence versus unverified suspicion.
2. Asset sensitivity and business importance.
3. Exposure of operational or supplier information.
4. Potential consequences for continuity and trust.
5. Existing assessment limitations.
6. The relevance of the finding to the Group's strategic objectives.

Environmental CVSS is treated as a context-dependent severity assessment.

The supplied findings matrix provides qualitative environmental guidance but not all inputs required to calculate a defensible numerical CVSS Environmental score.

Accordingly, the ratings below are **provisional environmental severity bands**, not certified numerical CVSS calculations.

A numerical CVSS score and complete vector must be calculated after confirming the relevant vulnerability mechanism, attack conditions, security requirements, and compensating controls.

### 5.2 Consolidated findings register

| ID | Subsidiary | IT/OT classification | Finding | Environmental CVSS assessment | Priority | Status |
|---|---|---|---|---|---|---|
| F-01 | Group supplier onboarding | IT | Peripheral supplier onboarding foothold evidence | Medium — provisional | Medium | Confirmed in controlled evidence |
| F-02 | Germany solar | IT, with OT-adjacent relevance | Integration API data exposure | High — provisional | High | Confirmed in controlled evidence |
| F-03 | Germany solar | OT-adjacent / IT-to-OT boundary | Gateway metadata exposure and pivot potential | High; potentially Critical if additional conditions are demonstrated | High | Metadata-level proof confirmed |
| D-01 | Group investor relations | IT | Authenticated investor portal depth | Not scored | Deferred | Not tested |

**Scoring limitation:** No precise environmental CVSS number is asserted for F-01 through F-03 because the evidence does not establish all required metric inputs. In particular, F-03 must not be scored as successful OT control or command execution.

### 5.3 F-01 — Peripheral supplier onboarding foothold

**Affected environment:** Group supplier onboarding  
**Classification:** IT  
**Status:** Confirmed within the controlled evidence  
**Priority:** Medium  
**Provisional environmental CVSS severity:** Medium

#### Description

Phase 1 identified the supplier onboarding portal as a peripheral application.

The accepted evidence subsequently confirmed a controlled read-only foothold in the supplier workflow.

The finding demonstrates a relevant supplier-facing access concern within the synthetic assessment environment.

#### Evidence

- `evt-p1-003`: peripheral supplier onboarding application identified.
- `evt-p1-004`: controlled read-only foothold proof accepted.
- `http-9001`: supplier workflow evidence supporting the accepted proof.
- `supplier_portal_mirror.html`: saved supplier portal representation.

#### Business impact

Supplier-facing applications may handle procurement information, external identities, onboarding documentation, and business relationships.

Weak governance of these systems can increase third-party exposure and undermine assurance over supplier access.

The evidence does not demonstrate access to critical operational systems.

#### Environmental severity rationale

Medium is appropriate as a provisional rating because the confirmed evidence concerns a peripheral supplier workflow rather than a demonstrated compromise of core energy operations.

Supplier trust and procurement governance increase its business relevance.

#### Recommendations

- Review supplier portal authentication and authorisation.
- Validate access permissions for supplier identities.
- Establish formal onboarding and offboarding controls.
- Monitor unusual supplier workflow activity.
- Assign an accountable business and technical owner.
- Retest after remediation under explicit authorisation.

#### Verification criteria

A subsequent authorised assessment should demonstrate that users can access only approved supplier records and workflows and that access changes are logged and reviewed.

### 5.4 F-02 — German integration API data exposure

**Affected subsidiary:** Germany utility-scale solar  
**Classification:** IT with OT-adjacent relevance  
**Status:** Confirmed within the controlled evidence  
**Priority:** High  
**Provisional environmental CVSS severity:** High

#### Description

The German integration API returned a controlled read-only synthetic dataset containing operationally relevant metadata.

The exposed fields included site identifiers, asset classifications, maintenance windows, telemetry gateway labels, and business ownership information.

The exposure was demonstrated within the supplied laboratory model.

#### Evidence

- `evt-p2-001`: legacy staging bridge identification.
- `service_banners.log`: `legacy-adapter-2.x` label.
- `evt-p2-002`: accepted exploitation proof.
- `api-9001`: confirmed synthetic integration dataset exposure.
- `solar_api_mirror.html`: corroborating saved API representation.

The legacy banner is supporting identification evidence, not proof of the underlying cause of the data exposure.

#### Business impact

Operational metadata can assist infrastructure mapping, reveal maintenance context, and identify business dependencies.

In a recently acquired subsidiary, such exposure raises questions about inherited interface security, integration governance, and consistency of access controls.

#### Environmental severity rationale

High is supported by the importance of acquisition integration and the sensitivity of operational metadata.

The rating must be revisited after confirming production applicability, authentication requirements, data sensitivity, and available compensating controls.

#### Recommendations

- Inventory inherited integration APIs and staging interfaces.
- Review access-control enforcement at each API endpoint.
- Minimise operational metadata returned to unauthorised or unnecessary consumers.
- Review service identities and integration credentials.
- Establish API ownership and change-management requirements.
- Assess whether legacy staging interfaces remain necessary.
- Introduce monitoring and regular independent assurance.

#### Verification criteria

Retesting should confirm that unauthorised identities cannot retrieve restricted operational metadata and that permitted identities receive only the information necessary for their functions.

### 5.5 F-03 — OT-adjacent telemetry gateway metadata exposure

**Affected subsidiary:** Germany utility-scale solar  
**Classification:** OT-adjacent / IT-to-OT boundary  
**Status:** Confirmed at metadata and routing level  
**Priority:** High  
**Provisional environmental CVSS severity:** High; potentially Critical if additional evidence demonstrates a materially greater impact

#### Description

The controlled evidence demonstrates that telemetry gateway labels were enumerable through integration metadata.

This reveals information about the relationship between the German integration API and an OT-adjacent gateway.

It supports a concern about potential pivot pathways and the protection of operational infrastructure metadata.

#### Evidence

- `evt-p2-003`: accepted impact-validation proof.
- `tele-9001`: metadata and routing evidence.
- `gateway_routes.csv`: recorded source and target asset relationship.

The observed route was a metadata relationship.

No OT command execution was attempted or demonstrated.

#### Business impact

Operational gateway identifiers can assist an attacker in understanding system dependencies and potential access pathways.

If combined with separate weaknesses, such information might increase the risk of an attack against operational systems.

However, the supplied evidence does not demonstrate that such a chain is currently feasible.

#### Environmental severity rationale

High is a prudent provisional priority because the finding concerns the boundary between business systems and operational infrastructure.

A Critical rating would require additional evidence about actual reachability, privilege, safety impact, or the effectiveness of existing protections.

#### Recommendations

- Map all approved IT/OT integration paths.
- Review segmentation and gateway access rules.
- Limit exposure of operational topology information.
- Verify service-account privileges and trust relationships.
- Establish monitoring for unusual gateway metadata access.
- Review remote access and third-party maintenance arrangements.
- Conduct a separately authorised OT boundary assessment.

#### Verification criteria

A controlled follow-up should establish whether unauthorised users can enumerate sensitive gateway information and whether technical segmentation prevents unauthorised access beyond approved interfaces.

### 5.6 D-01 — Investor portal authenticated assessment deferred

**Affected environment:** Group investor relations  
**Classification:** IT  
**Status:** Deferred  
**Priority:** Deferred scope tracking  
**Environmental CVSS:** Not applicable without a confirmed finding

The evidence bundle identifies authenticated investor portal assessment as deferred.

No confirmed vulnerability is established.

The portal should remain in the scope register for a future authorised review.

A severity score must not be assigned merely because an asset was identified.

### 5.7 Subsidiary-level interpretation

| Country | Confirmed technical finding from this execution | Principal strategic consideration | Next action |
|---|---|---|---|
| Norway | None established | Offshore operational safety and third-party access | Risk-based OT assurance |
| Sweden | None established | Renewable generation continuity | Resilience and operational access review |
| Denmark | None established | Trading interfaces and information integrity | Market-facing application assurance |
| Netherlands | None established | Cross-border gas and hydrogen infrastructure | Integration and OT boundary review |
| Germany | F-02 and F-03 | Acquisition integration and operational metadata exposure | Prioritised integration review |
| Group-wide supplier environment | F-01 | Supplier onboarding governance | Strengthen third-party access assurance |

Absence of a confirmed finding in a subsidiary does not establish that the subsidiary is secure.

---

## 6. Strategic-Plan Recommendations (Country-Specific NIS2)

### 6.1 Strategic objectives

Nordstrøm's three-year cybersecurity programme should pursue five objectives:

1. Establish accountable Group-wide security governance.
2. Reduce inherited acquisition and supplier risk.
3. Protect critical operational dependencies.
4. Improve detection, response, and resilience.
5. Demonstrate measurable assurance to the Board and relevant authorities.

### 6.2 Year 1 — Foundation and priority remediation

**Months 1–12**

#### Priority A: German acquisition integration

Address F-02 and F-03 through a dedicated integration assurance programme.

Required activities:

- Establish a complete inventory of inherited interfaces.
- Assign accountable owners to each integration service.
- Review API authentication, authorisation, and data exposure.
- Document IT/OT integration relationships.
- Identify unsupported or unnecessary legacy components.
- Develop remediation plans with measurable deadlines.

#### Priority B: Supplier governance

Address F-01 through Group-wide supplier onboarding standards.

Required activities:

- Define supplier access requirements.
- Review portal access controls.
- Introduce periodic access recertification.
- Establish consistent supplier onboarding and offboarding.
- Improve monitoring and evidence retention.

#### Priority C: Governance baseline

Create a Group security baseline covering:

- Asset ownership.
- Risk acceptance.
- Identity and access management.
- Third-party security.
- Vulnerability management.
- Incident response.
- Operational resilience.
- Evidence and audit requirements.

#### Year 1 deliverables

- Group-wide asset and integration register.
- German subsidiary remediation plan.
- Supplier access-control standard.
- Initial IT/OT boundary inventory.
- Country-specific regulatory obligations register.
- Quarterly Board risk dashboard.

### 6.3 Year 2 — Resilience and operational assurance

**Months 13–24**

The second year should extend assurance beyond the German integration environment.

Priority activities:

- Conduct risk-ranked OT security reviews.
- Validate network segmentation and remote access governance.
- Improve monitoring of critical integration interfaces.
- Exercise incident response with subsidiary leadership.
- Review backup, recovery, and operational continuity arrangements.
- Strengthen security requirements for third-party maintenance.
- Test the effectiveness of completed Year 1 remediation.

The programme should account for differences between offshore production, renewable generation, electricity trading, and gas and hydrogen infrastructure.

### 6.4 Year 3 — Continuous assurance and governance maturity

**Months 25–36**

The third year should focus on repeatability and evidence of sustained control effectiveness.

Priority activities:

- Introduce recurring independent security assessments.
- Validate remediation effectiveness.
- Maintain updated asset and trust-boundary inventories.
- Conduct cross-subsidiary incident exercises.
- Review strategic risks and investment priorities annually.
- Provide the Board with consistent trend-based reporting.
- Integrate cybersecurity assurance into future acquisition processes.

### 6.5 Country-specific NIS2 considerations

Nordstrøm must not assume that one compliance statement establishes conformity across all five jurisdictions.

NIS2 establishes an EU-level framework, but applicable national obligations, competent authorities, entity classifications, and implementation arrangements require jurisdiction-specific confirmation.

The following table identifies assessment priorities, not a definitive statement of current legal compliance.

| Country | Regulatory consideration | Recommended governance response |
|---|---|---|
| Norway | Norway is not an EU Member State. EEA-linked developments and applicable Norwegian national requirements must be assessed separately. | Maintain a Norway-specific legal and operational obligations register; do not assume direct application of every EU NIS2 provision. |
| Sweden | National implementation and energy-sector supervisory requirements must be confirmed. | Map generation operations, responsible entities, incident obligations, and continuity requirements to applicable Swedish rules. |
| Denmark | Energy-sector obligations and market-facing operational dependencies require local interpretation. | Review wind generation and trading activities against applicable Danish cybersecurity and sector requirements. |
| Netherlands | Cross-border infrastructure, gas, and hydrogen operations create important continuity and governance considerations. | Confirm applicable Dutch requirements, entity classification, supervisory arrangements, and incident-reporting duties. |
| Germany | The acquired solar business requires particular attention to inherited integration controls and applicable German cybersecurity obligations. | Perform a German subsidiary compliance gap assessment aligned with the confirmed integration risks and relevant national requirements. |

Legal applicability must be verified with local counsel or qualified regulatory specialists against the laws in force at the time of implementation.

### 6.6 Group governance model

The Group CISO should coordinate security standards and consolidated reporting.

Each subsidiary should designate accountable operational and technical owners.

The Board should receive quarterly reports covering:

| Indicator | Management question |
|---|---|
| Critical assets with assigned owners | Do we know who is accountable? |
| High-priority findings overdue | Are material risks being reduced on schedule? |
| Supplier access reviews completed | Are third-party relationships controlled? |
| IT/OT connections inventoried | Do we understand critical dependencies? |
| Incident exercises completed | Can subsidiaries respond effectively? |
| Remediation independently verified | Are improvements demonstrated rather than assumed? |
| Country obligations assessed | Can management explain applicable regulatory duties? |

### 6.7 Recommendation traceability

| Recommendation | Supporting evidence | Strategic purpose |
|---|---|---|
| R-01 — Acquisition integration controls | F-02, F-03 | Prioritise German subsidiary integration assurance |
| R-02 — Supplier portal governance | F-01 | Strengthen supplier and third-party controls |
| R-03 — IT/OT boundary assurance | F-03 | Establish controlled OT review and recurring assurance |
| R-04 — NIS2-aware governance | All findings and subsidiary context | Avoid uniform assumptions across countries |
| R-05 — Continuation proposal | F-02, F-03 | Support targeted follow-on assessments and recurring review |

### 6.8 Investment prioritisation

Investment decisions should be made according to verified risk, operational importance, and achievable risk reduction.

The initial priority sequence is:

**Priority 1:** German integration access controls and operational metadata protection.

**Priority 2:** Group-wide supplier onboarding governance.

**Priority 3:** IT/OT boundary inventory and controlled validation.

**Priority 4:** Cross-subsidiary resilience and monitoring.

**Priority 5:** Recurring independent assurance and strategic maturity measurement.

Budgets should be confirmed after technical scoping, operational consultation, and procurement review.

---

## 7. Engagement Continuation Proposal

### 7.1 Continuation principles

The current evidence supports targeted follow-on work.

Continuation should be based on explicitly approved scope, defined safety conditions, operational coordination, and clear deliverables.

Proposed future activities are not represented as completed work.

### 7.2 Proposed Phase 3 — OT Security Deep-Dive

**Purpose:** Evaluate the protection of critical operational environments and validate IT/OT trust boundaries without introducing unacceptable operational risk.

#### Proposed scope

- Critical OT asset and dependency inventory.
- Network segmentation and trust-boundary review.
- Remote access and third-party maintenance assessment.
- OT identity and privilege review.
- Passive configuration and architecture assessment.
- Monitoring and incident-response readiness.
- Safety and operational continuity considerations.

#### Execution safeguards

- Written rules of engagement.
- Approval by relevant subsidiary and OT owners.
- No uncontrolled production exploitation.
- No unapproved operational commands.
- Defined stop conditions.
- Change-control and safety coordination.
- Evidence retention and restoration procedures.

#### Deliverables

- OT risk register.
- Segmentation and trust-boundary assessment.
- Prioritised remediation roadmap.
- Operational resilience recommendations.
- Executive assurance summary.

### 7.3 Proposed Phase 4 — German Subsidiary Integration Review

**Purpose:** Resolve uncertainty around inherited systems and verify the production relevance of the controlled Phase 2 findings.

#### Proposed scope

- Acquisition integration architecture.
- Legacy staging bridges and API inventory.
- Identity and access-control review.
- Integration data classification.
- Service-account and credential governance.
- Supplier and vendor dependencies.
- IT/OT integration pathways.
- Applicable German regulatory requirements.
- Remediation verification.

#### Priority questions

1. Are comparable operational metadata exposures present in production?
2. Are integration interfaces appropriately authenticated and authorised?
3. Are legacy staging services necessary and securely managed?
4. Are gateway identifiers and operational topology details adequately protected?
5. Do effective controls prevent unauthorised movement between business and operational environments?

#### Deliverables

- German integration risk assessment.
- Confirmed production applicability statements.
- Remediation plan with named owners.
- Updated environmental severity assessments.
- Retesting and assurance report.
- Board-ready acquisition integration summary.

### 7.4 Optional quarterly assurance retainer

An optional retainer could provide:

- Quarterly risk and remediation reviews.
- Supplier assurance follow-up.
- Targeted configuration and evidence checks.
- Regulatory obligation tracking.
- Board dashboard updates.
- Annual roadmap reassessment.
- Support for authorised retesting.

The retainer should complement internal ownership rather than replace the Group's security management responsibilities.

### 7.5 Commercial and contractual treatment

The previous commercial proposal used an illustrative 130-consultant-day baseline at €1,200 per consultant-day, corresponding to €156,000, and included a separately priced optional work component.

Those historical planning assumptions must not automatically be treated as approved pricing for the continuation activities proposed here.

The proposed OT deep-dive, German integration review, and quarterly retainer require separate scope confirmation and commercial approval.

Before authorisation, Vanguard Security and Nordstrøm should agree on:

- Detailed scope and exclusions.
- Required expertise.
- Operational access conditions.
- Safety controls.
- Estimated consultant-days.
- Deliverables and acceptance criteria.
- Commercial terms.
- Responsible client approvers.

Any change to previously agreed phase definitions must be documented through formal change control.

---

## 8. Limitations and Uncertainty

### 8.1 Controlled evidence limitation

The engagement relied on a closed, synthetic evidence dataset.

No live perimeter testing was performed.

Consequently, the findings establish what the controlled evidence demonstrates, not the current vulnerability status of production Nordstrøm systems.

### 8.2 Coverage limitation

The supplied evidence does not represent a comprehensive assessment of all Group assets.

The strongest technical evidence concerns the supplier onboarding workflow and German integration environment.

Other subsidiaries were assessed principally through strategic context rather than equivalent technical proof.

### 8.3 Identification versus exploitation

The `legacy-adapter-2.x` service label indicates a potentially relevant legacy component.

It does not independently prove a vulnerability, identify a confirmed exploit mechanism, or establish that the component caused the observed data exposure.

The confirmed integration data exposure is supported by separate accepted proof evidence.

### 8.4 OT impact limitation

The OT-adjacent finding demonstrates gateway metadata exposure and a potentially relevant integration relationship.

It does not establish:

- Successful OT authentication.
- Access to operational controllers.
- Ability to issue OT commands.
- Modification of operational processes.
- Successful lateral movement.
- Physical safety impact.

These outcomes require separate evidence and must not be inferred.

### 8.5 Environmental CVSS uncertainty

The supplied findings matrix provides environmental severity guidance rather than complete numerical scoring inputs.

The report therefore uses provisional severity bands.

Environmental CVSS must be recalculated after confirming attack conditions, affected components, confidentiality and integrity requirements, availability implications, and compensating controls.

### 8.6 Cleanup limitation

The restoration audit confirms removal of recorded temporary artefacts, revocation of the synthetic token, closure of the read-only session, and laboratory restoration.

It does not constitute a verification of unrelated systems or unrecorded changes.

### 8.7 Regulatory uncertainty

Country-specific NIS2 applicability and national legal obligations must be confirmed against current legislation and relevant entity classifications.

This report provides governance planning considerations, not a formal legal compliance certification.

### 8.8 Business-impact uncertainty

The strategic consequences described in this report are risk interpretations informed by the controlled evidence.

They are not claims that Nordstrøm experienced a production incident, financial loss, safety event, or operational outage.

### 8.9 Assurance conclusion

The engagement provides a defensible basis for prioritisation but not comprehensive assurance of production security.

Outstanding uncertainty should be managed through formally authorised continuation assessments, clear ownership, and independent remediation verification.

---

## 9. Appendices

### Appendix A — Detailed Findings Register

| Finding ID | Evidence | Confirmed result | Unproven or deferred element | Priority |
|---|---|---|---|---|
| F-01 | `evt-p1-003`, `evt-p1-004`, `http-9001` | Controlled supplier workflow foothold | Privileged or production access | Medium |
| F-02 | `evt-p2-001`, `evt-p2-002`, `api-9001` | Read-only synthetic integration data exposure | Production compromise and exact vulnerability mechanism | High |
| F-03 | `evt-p2-003`, `tele-9001` | Gateway metadata exposure and OT-adjacent relationship | OT commands and actual lateral movement | High |
| D-01 | HTTP observation evidence; limitations register | Authenticated assessment deferred | Any confirmed investor portal weakness | Deferred |

### Appendix B — Phase 1 Evidence Summary

The Phase 1 reconstruction followed public and peripheral evidence.

**09:02:11 UTC — Public reconnaissance**

`evt-p1-001` records identification of the public apex and subdomain set.

**09:20:45 UTC — German integration discovery**

`evt-p1-002` identifies the German subsidiary API and defers detailed technical evaluation to Phase 2.

**09:31:18 UTC — Supplier attack-surface identification**

`evt-p1-003` identifies the supplier onboarding application as a peripheral candidate.

**09:47:33 UTC — Controlled foothold proof**

`evt-p1-004` and `http-9001` support a controlled read-only supplier workflow foothold.

**09:52:06 UTC — Public mapping proof**

`evt-p1-005` and supporting certificate evidence confirm the synthetic public-surface mapping result.

Accepted Phase 1 markers:

- `flag{npg_phase1_public_surface_mapped}`
- `flag{npg_phase1_supplier_portal_foothold}`

These markers establish completion of the relevant controlled evidence objectives, not live compromise.

### Appendix C — Phase 2 Evidence Summary

**10:12:09 UTC — Identification**

`evt-p2-001` and the service banner identify a legacy staging bridge.

Classification: `identification`.

Conclusion: suspected issue only.

**10:28:44 UTC — Data exposure proof**

`evt-p2-002` and `api-9001` confirm exposure of a read-only synthetic integration dataset.

Classification: `proof`.

Conclusion: confirmed controlled data exposure.

**10:43:20 UTC — OT-adjacent impact validation**

`evt-p2-003` and `tele-9001` confirm the ability to enumerate gateway labels through integration metadata.

Classification: `proof`.

Conclusion: metadata-level pivot potential; no OT command execution.

**10:56:31 UTC — Strategic reporting observation**

`evt-p2-004` records acquisition integration and governance implications.

Classification: `observation`.

Conclusion: strategic context, not an additional exploitation proof.

**11:03:58 UTC — Restoration**

`evt-p2-005` and `clean-9001` confirm removal of temporary artefacts, synthetic token revocation, session closure, and laboratory restoration.

Classification: `verification`.

Conclusion: controlled cleanup confirmed.

Accepted Phase 2 markers:

- `flag{npg_phase2_german_api_exposure}`
- `flag{npg_phase2_ot_pivot_potential_validated}`
- `flag{npg_phase2_cleanup_verified}`

### Appendix D — Threat Profile Detail by Subsidiary

#### Norway — Offshore gas

**Principal concerns:** Operational safety, third-party access, remote maintenance, and continuity of offshore production.

**Evidence status:** No subsidiary-specific technical exploitation proof supplied.

**Strategic treatment:** Prioritise safety-led OT assurance and review critical external access arrangements.

#### Sweden — Hydro and wind

**Principal concerns:** Generation availability, remote operations, monitoring dependencies, and resilience.

**Evidence status:** No subsidiary-specific technical exploitation proof supplied.

**Strategic treatment:** Review operational dependencies, remote access, and incident recovery capabilities.

#### Denmark — Offshore wind and trading

**Principal concerns:** Market-facing interfaces, information integrity, trading dependencies, and operational continuity.

**Evidence status:** No subsidiary-specific technical exploitation proof supplied.

**Strategic treatment:** Prioritise application assurance and governance of market-facing integrations.

#### Netherlands — Gas and hydrogen

**Principal concerns:** Cross-border infrastructure continuity, operational dependencies, and secure integration.

**Evidence status:** No subsidiary-specific technical exploitation proof supplied.

**Strategic treatment:** Review critical integration pathways and infrastructure resilience.

#### Germany — Utility-scale solar

**Principal concerns:** Inherited integration services, legacy components, operational metadata exposure, and IT/OT boundaries.

**Evidence status:** F-02 and F-03 supported by accepted controlled proof.

**Strategic treatment:** Prioritise dedicated acquisition integration assurance and targeted remediation.

### Appendix E — Methodology Adaptations Applied

| Adaptation | Applied decision | Rationale |
|---|---|---|
| M-01 | Phase 1 limited to public and peripheral surfaces | Avoid premature interaction with critical systems |
| M-02 | Supplier portal used for controlled foothold evidence | Establish bounded and commercially relevant proof |
| M-03 | German integration API selected for Phase 2 | Address strategically important acquisition exposure |
| M-04 | Identification separated from confirmed exploitation | Prevent suspicion from being reported as proof |
| M-05 | Cleanup logged and verified | Demonstrate reversible, controlled execution |

These adaptations preserved the assessment boundaries while producing evidence relevant to strategic decision-making.

### Appendix F — Environmental CVSS Assessment Notes

Environmental CVSS is intended to account for the importance of the affected environment and relevant security requirements.

The current evidence supports the following provisional treatment.

**F-01 — Medium**

Peripheral supplier access is relevant to procurement and third-party governance. No evidence establishes compromise of core energy systems.

**F-02 — High**

Operational metadata exposure in a recently acquired integration environment raises confidentiality and governance concerns.

**F-03 — High, potentially Critical under additional demonstrated conditions**

The IT/OT boundary is strategically sensitive. However, the evidence does not demonstrate operational control or command execution.

**D-01 — Not scored**

No confirmed vulnerability is established.

Before issuing numerical scores, the assessor must:

1. Select and document the applicable CVSS version.
2. Establish the confirmed vulnerability mechanism.
3. Record the base and environmental metric inputs.
4. Document environmental assumptions and compensating controls.
5. Calculate and independently verify the resulting score.
6. Reassess after the proposed continuation engagements.

No numerical score should be presented as authoritative without these steps.

### Appendix G — Recommendation and Evidence Mapping

| Recommendation ID | Primary finding | Owner proposal | Target period |
|---|---|---|---|
| R-01 | F-02, F-03 | German subsidiary leadership and Group CISO | Year 1 |
| R-02 | F-01 | Procurement, supplier management, and Group security | Year 1 |
| R-03 | F-03 | OT leadership and Group CISO | Years 1–2 |
| R-04 | All findings and country context | Group legal, compliance, and CISO | Years 1–3 |
| R-05 | F-02, F-03 | Group CISO and executive sponsors | Following formal approval |

Owner assignments are recommendations and require management confirmation.

### Appendix H — Limitations Register

| ID | Limitation | Report treatment |
|---|---|---|
| L-01 | Controlled offline evidence instead of live execution | No claims of comprehensive production coverage |
| L-02 | Authenticated investor portal assessment deferred | Recorded under deferred scope |
| L-03 | No OT command execution attempted | OT impact limited to metadata/routing-level validation |
| L-04 | Environmental CVSS derived from limited context | Provisional severity; reassessment required |

### Appendix I — Evidence Sources

This report is grounded in the following engagement materials:

**Phase execution records**

- `10-phase1_log.md`
- `11-phase2_log.md`
- `materials/utc/timeline_stream.csv`

**Technical evidence**

- `materials/artifacts/dns_inventory.csv`
- `materials/artifacts/http_observations.csv`
- `materials/artifacts/certificate_san.csv`
- `materials/logs/service_banners.log`
- `materials/evidence/api_samples.jsonl`
- `materials/telemetry/gateway_routes.csv`
- `materials/mirrors/supplier_portal_mirror.html`
- `materials/mirrors/solar_api_mirror.html`
- `materials/cleanup/restoration_audit.csv`

**Report-support evidence**

- `materials/report_support/findings_seed.csv`
- `materials/report_support/subsidiary_context.csv`
- `materials/report_support/recommendation_matrix.csv`
- `materials/report_support/methodology_adaptations.csv`
- `materials/report_support/limitations_register.csv`
- `materials/report_support/board_language_examples.jsonl`

**Evidence handling guidance**

- `materials/guide/FIELD_NOTES.txt`
- `materials/guide/SCOPE_AND_USE.txt`
- `materials/guide/NO_LIVE_TESTING.txt`

### Appendix J — Final Assurance and Decision Record

**Confirmed within the controlled evidence**

- Public-facing synthetic asset mapping.
- Read-only supplier workflow foothold.
- German integration API synthetic data exposure.
- OT-adjacent gateway metadata relationship.
- Recorded cleanup and laboratory restoration.

**Not confirmed**

- Production compromise.
- Privileged corporate access.
- Actual OT system control.
- OT command execution.
- Successful production lateral movement.
- Comprehensive security assurance across all subsidiaries.

**Decisions requested**

1. Approve Year 1 prioritisation of German integration and supplier governance.
2. Authorise detailed scoping of the proposed OT deep-dive.
3. Authorise detailed scoping of the German subsidiary review.
4. Establish a country-specific regulatory obligations workstream.
5. Adopt quarterly Board reporting and remediation accountability.
6. Review optional recurring assurance support through a separate commercial decision.

---

## Final Engagement Conclusion

Nordstrøm's controlled assessment evidence supports three principal findings: a peripheral supplier onboarding foothold, German integration API data exposure, and OT-adjacent gateway metadata exposure.

The strongest strategic concern is the combination of inherited acquisition interfaces and incomplete assurance over business-to-operational system boundaries.

The findings do not demonstrate compromise of live energy infrastructure.

They do, however, justify a focused programme of integration assurance, supplier governance, operational boundary protection, and country-specific regulatory oversight.

The recommended three-year strategy begins with evidence-backed remediation, expands into operational resilience, and concludes with recurring independent assurance.

**Vanguard Security recommends that Nordstrøm adopt the proposed priorities, commission the necessary follow-on assessments under separate authorisation, and maintain clear Board oversight of remediation progress and residual uncertainty.**
