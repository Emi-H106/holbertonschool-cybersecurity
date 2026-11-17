# Methodology, Nordstrøm Power Group

## Methodological Approach

Vanguard Security recommends PTES (Penetration Testing Execution Standard) as the primary methodological foundation for Nordstrøm Power Group, supplemented by OWASP Web Security Testing Guide and API Security Top 10, MITRE ATT&CK Enterprise, MITRE ATT&CK for ICS, and NIST SP 800-53.

The methodology is adapted to Nordstrøm's five subsidiaries, their different energy-sector operations, the German acquisition's incomplete integration, and CISO Elin Solberg's requirement to present a defensible three-year cybersecurity strategy to the board within ninety days.

PTES provides the engagement lifecycle, but its activities must not be interpreted as a requirement to conduct unrestricted exploitation. Assessment depth will depend on business risk, operational safety, asset ownership, written authorisation, and the phased scope established in the engagement architecture.

The first three commercial phases deliver strategic assurance and targeted technical assessment within the board deadline. A fourth, optional phase provides separately authorised penetration testing and remediation validation.

All findings will distinguish verified technical evidence, documented control weaknesses, credible threat hypotheses, and untested assumptions.

## PTES Phases: Full / Abbreviated / Extended

| PTES phase | Adaptation | Nordstrøm-specific implementation |
|---|---|---|
| 1. Pre-engagement Interactions | **Extended** | Establish subsidiary-specific authorisations, cross-border evidence rules, OT safety restrictions, third-party permissions, German acquisition ownership, and explicit contractual boundaries. |
| 2. Intelligence Gathering | **Full** | Collect and validate relevant asset inventories, architecture diagrams, identity relationships, supplier access pathways, and existing assurance evidence across all five subsidiaries. |
| 3. Threat Modeling | **Extended** | Apply differentiated IT and ICS threat scenarios to offshore gas, hydroelectric and wind generation, energy trading, gas and hydrogen infrastructure, and acquired solar operations. |
| 4. Vulnerability Analysis | **Full** | Assess weaknesses within the approved perimeter through evidence review, configuration assessment, access-control analysis, and authorised non-disruptive validation. |
| 5. Exploitation | **Abbreviated** | Restrict active exploitation during the initial engagement to explicitly authorised, controlled, non-production or otherwise approved IT environments. Exclude intrusive production OT exploitation. |
| 6. Post-Exploitation | **Abbreviated** | Evaluate potential business impact, privilege escalation, lateral movement, and IT/OT consequences primarily through evidence-based analysis and safe simulation rather than uncontrolled persistence or movement. |
| 7. Reporting | **Extended** | Produce subsidiary-specific technical findings, regulatory control mappings, evidence-confidence statements, executive risk prioritisation, and a three-year board-level investment roadmap. |

A **Full** PTES phase means that the required activities are completed rigorously within the approved scope. It does not imply exhaustive assessment of every asset.

### 1. Pre-engagement Interactions — Extended

Pre-engagement activities are extended beyond standard penetration-testing preparation because Nordstrøm operates across five jurisdictions and multiple safety-critical energy sectors.

Vanguard will establish a written Statement of Work, subsidiary-specific Rules of Engagement, named asset owners, authorised technical contacts, permitted assessment methods, operational restrictions, evidence-handling requirements, escalation paths, and emergency stop conditions.

Norwegian offshore gas, Swedish hydroelectric facilities, Danish offshore wind, and Dutch gas and hydrogen infrastructure require explicit OT safety approval before technical interaction with operational environments.

For the recently acquired German solar subsidiary, Vanguard will independently establish ownership of legacy systems, the legal authority to assess inherited infrastructure, the status of supplier contracts, and the permitted use of previous third-party audit evidence.

The national regulatory applicability assessment will distinguish Norway's domestic framework from the applicable national implementations of NIS2 in Sweden, Denmark, the Netherlands, and Germany.

No assessment activity will begin without appropriate written authorisation.

**Justification:** Henrik Lindqvist's previous engagement demonstrated that accepting ambiguous requirements under commercial pressure can create contradictory stakeholder expectations, uncontrolled OT scope, and unpriced change requests. Nordstrøm's broad RFP makes enhanced pre-engagement clarification essential.

### 2. Intelligence Gathering — Full

Intelligence gathering will cover the authorised perimeter of all five subsidiaries through stakeholder interviews, documentation analysis, approved asset inventories, architecture reviews, and limited technical discovery where expressly permitted.

The assessment will identify:

- Group identity infrastructure, privileged accounts, and cross-subsidiary trust relationships.
- Norwegian offshore remote engineering and contractor-access pathways.
- Swedish hydroelectric SCADA boundaries and distributed wind-management services.
- Danish trading applications, API dependencies, and offshore wind supervisory access.
- Dutch pipeline telemetry, industrial network boundaries, and engineering contractor access.
- German legacy domains, inherited VPN accounts, integration gateways, supplier access, and solar-management architecture.

Information obtained from inherited audit reports will be labelled according to provenance, recency, and independent verification status.

Passive and documentation-led collection will be preferred for production OT. Active discovery will require explicit approval, technical compatibility assessment, and appropriate operational supervision.

**Justification:** A group-wide threat profile cannot be credible without distinguishing the actual technical dependencies of five different energy businesses. German integration uncertainty also makes inherited documentation insufficient without validation.

### 3. Threat Modeling — Extended

Threat modeling will extend standard PTES analysis by integrating business impact, sector-specific adversary behaviour, operational safety, and regulatory consequences.

PASTA principles will support the connection between business objectives, attack scenarios, and risk prioritisation. MITRE ATT&CK Enterprise and ATT&CK for ICS will provide structured technique references.

The subsidiary-specific scenarios are:

**Norway — Offshore gas:** Compromised contractor credentials, unauthorised remote engineering access, and potential disruption of safety-critical operational dependencies.

**Sweden — Hydroelectric and wind:** Unauthorised SCADA access in hydroelectric operations and compromised remote maintenance pathways affecting geographically distributed wind facilities.

**Denmark — Offshore wind and trading:** Operational disruption of offshore wind supervisory systems and compromise of trading identities, APIs, scheduling, or settlement dependencies.

**Netherlands — Gas and hydrogen:** Compromise of pipeline telemetry, industrial communications, contractor access, and process-support systems with potential operational safety consequences.

**Germany — Acquired solar:** Inherited credentials, undocumented trust relationships, insufficiently reviewed supplier access, and lateral movement risks arising from incomplete acquisition integration.

Threat scenarios will be mapped to specific assets, plausible adversary capabilities, relevant ATT&CK techniques, and consequences. They will remain hypotheses until supported by assessment evidence.

**Justification:** A generic energy-sector threat model would conceal the differences between physical process safety, renewable generation availability, trading integrity, and acquisition-related enterprise exposure.

### 4. Vulnerability Analysis — Full

Vulnerability analysis will be performed thoroughly within the authorised scope, using techniques appropriate to the operational environment.

For enterprise IT, the methodology includes configuration review, identity and privilege analysis, patch and exposure assessment, application security review, and targeted validation of identified weaknesses.

For OT, the methodology prioritises architecture inspection, segmentation assessment, remote-access governance, vendor configuration evidence, and non-intrusive examination of known weaknesses.

For Denmark's trading applications, OWASP-based testing will focus on authentication, authorisation, API access control, session security, and relevant business-logic risks.

For Germany, special attention will be given to legacy identity lifecycle controls, inherited network permissions, integration trust relationships, and inconsistencies between historical audit evidence and current configurations.

Findings will be assessed according to technical severity, exploitability, business impact, operational safety, and evidence confidence.

**Justification:** Nordstrøm requires meaningful technical assurance, but the depth of vulnerability analysis must reflect the difference between a trading API, a corporate identity service, and a live industrial controller.

### 5. Exploitation — Abbreviated

Active exploitation is deliberately abbreviated during the initial ninety-day engagement.

Where separately authorised within the initial scope, Vanguard may perform limited, controlled validation against approved IT systems, test accounts, or non-production applications. Testing must avoid production disruption, sensitive transaction modification, and uncontrolled privilege escalation.

No live exploitation will be performed against production offshore gas controllers, hydroelectric controls, wind-turbine control systems, gas or hydrogen process equipment, or solar inverter-management infrastructure.

Production trading transactions, destructive payloads, denial-of-service testing, and unauthorised third-party access are excluded.

Where a vulnerability cannot be safely exploited, Vanguard will document the evidence, plausible attack path, potential consequence, and validation limitation without presenting hypothetical impact as a confirmed compromise.

More intrusive technical testing may be proposed in Phase 4 under a separately approved Statement of Work and Rules of Engagement.

**Justification:** The potential safety and continuity consequences of intrusive testing outweigh the marginal assurance benefit during the board-focused initial engagement. Nordstrøm's ninety-day deadline also does not justify assuming unrestricted operational access.

### 6. Post-Exploitation — Abbreviated

Post-exploitation activities will focus on determining credible business consequences rather than establishing persistence or conducting unrestricted lateral movement.

Assessment activities will include:

- Reviewing potential privilege escalation paths within shared identity infrastructure.
- Evaluating possible movement from German acquired networks into Nordstrøm group systems.
- Assessing whether compromised IT support services could affect OT availability or visibility.
- Examining the potential consequences of compromised Danish trading accounts or APIs.
- Identifying dependencies that could amplify ransomware disruption across subsidiaries.

Where controlled exploitation has been authorised and successfully performed, any subsequent activity must remain within the approved boundaries, use minimal necessary access, and follow agreed evidence-handling and cleanup procedures.

Unexecuted attack paths will be reported as analytical scenarios, not demonstrated post-exploitation outcomes.

**Justification:** Nordstrøm needs to understand cross-subsidiary business impact and systemic exposure, particularly during the German integration, without introducing unnecessary operational risk or exceeding authorised scope.

### 7. Reporting — Extended

Reporting is extended because the primary client requirement is a board-ready assessment supporting a three-year cybersecurity strategy.

Vanguard will produce both technical and executive-level deliverables.

Technical reporting will include affected assets, verified evidence, relevant attack techniques, severity, business impact, remediation recommendations, scope limitations, and confidence levels.

Executive reporting will consolidate subsidiary findings into a group-wide risk register, prioritised remediation roadmap, investment recommendations, risk ownership assignments, and regulatory control gaps.

The report will distinguish:

- Confirmed vulnerabilities and verified control weaknesses.
- Credible but unvalidated threat scenarios.
- Inherited audit claims not independently confirmed.
- Deferred testing and residual assurance gaps.
- Risks accepted or requiring executive decisions.

The final board materials will be delivered by Day 85, preserving a review period before Elin's ninety-day deadline.

**Justification:** A conventional penetration-testing report would not sufficiently support Nordstrøm's board-level investment decisions. The reporting methodology must translate technical evidence into accountable, prioritised, financially defensible actions.

## Complementary Frameworks and Where They Apply

### OWASP — Web Applications and APIs

**Primary application:** Danish energy trading platforms, trading APIs, authentication workflows, and relevant web-based management services.

Vanguard will use the OWASP Web Security Testing Guide and OWASP API Security Top 10 to structure assessment of:

- Authentication and session management.
- Broken object-level and function-level authorisation.
- API access restrictions and excessive privileges.
- Security misconfiguration and sensitive data exposure.
- Business-logic weaknesses relevant to trading workflows.

Testing will use approved accounts and non-production environments where available. Real market transactions and production settlement modifications remain excluded.

**Why OWASP is appropriate:** Danish trading risk is not adequately represented by industrial control-system techniques alone. Application-specific testing is necessary to evaluate financial integrity and transaction-related exposure.

### MITRE ATT&CK Enterprise — Corporate IT and Integration

**Primary application:** Group identity infrastructure, privileged access, remote administration, supplier access, and German acquisition integration.

Relevant techniques include:

- **T1078 — Valid Accounts:** Inherited or compromised identities, particularly German legacy accounts and contractor credentials.
- **T1133 — External Remote Services:** VPN and third-party remote-access pathways across subsidiaries.
- **T1021 — Remote Services:** Potential lateral movement through permitted administrative connections.
- **T1486 — Data Encrypted for Impact:** Ransomware scenarios affecting operational support, trading, and corporate systems.

MITRE ATT&CK will guide threat hypotheses, detection coverage review, and targeted validation rather than serve as proof that an adversary has used a particular technique against Nordstrøm.

**Why ATT&CK Enterprise is appropriate:** The group has shared IT dependencies and a newly acquired subsidiary whose incomplete integration may expose trust relationships beyond a single business unit.

### MITRE ATT&CK for ICS — Operational Technology

**Primary application:** Norwegian offshore gas, Swedish hydroelectric and wind generation, Danish offshore wind, Dutch gas and hydrogen infrastructure, and German solar OT architecture.

The framework will guide assessment of:

- Unauthorised use of industrial-system accounts.
- Compromise of remote engineering and maintenance access.
- Exposure of supervisory control and telemetry communications.
- Potential denial of service affecting operational visibility or availability.
- Trust boundaries between corporate IT, engineering systems, and industrial control networks.

ATT&CK for ICS will be used primarily for scenario analysis, architecture assessment, and evidence-based risk evaluation during the initial engagement.

It does not authorise live manipulation of controllers, safety systems, or industrial processes.

**Why ATT&CK for ICS is appropriate:** Nordstrøm's OT environments have distinct safety, reliability, and process-integrity requirements that cannot be adequately evaluated using enterprise IT techniques alone.

### NIST SP 800-53 — Security Control and Compliance Gap Assessment

**Primary application:** Group-wide security governance, subsidiary control maturity, acquisition assurance, and regulatory evidence mapping.

Relevant control families include:

| Control family | Assessment focus | Nordstrøm application |
|---|---|---|
| AC — Access Control | Identity lifecycle, privileges, access restrictions | Group identity services, contractor access, German inherited accounts |
| AU — Audit and Accountability | Logging, traceability, audit evidence | Historical German audit evidence and subsidiary security monitoring |
| CA — Assessment, Authorization, and Monitoring | Control assessment and ongoing assurance | Subsidiary assurance processes and validation of previous findings |
| IR — Incident Response | Incident handling, escalation, reporting | Cross-subsidiary response coordination and regulatory notification readiness |
| SC — System and Communications Protection | Network boundaries and communication protection | IT/OT segmentation and cross-subsidiary connectivity |
| SR — Supply Chain Risk Management | Supplier security and third-party dependencies | Offshore maintenance providers, solar technology suppliers, engineering contractors |

NIST SP 800-53 will provide a consistent control-assessment vocabulary across subsidiaries, while national laws and sector-specific requirements determine actual regulatory obligations.

The methodology will not equate NIST control alignment with NIS2 compliance or treat all five jurisdictions as legally identical.

**Why NIST SP 800-53 is appropriate:** Nordstrøm requires comparable group-level control evidence while maintaining jurisdiction-specific accountability and avoiding unsupported compliance conclusions.

## Per-Adaptation Justification

| Nordstrøm-specific condition | Methodological adaptation | Intended value |
|---|---|---|
| Five subsidiaries across different jurisdictions | Extend pre-engagement authorisation and regulatory mapping | Prevent inconsistent permissions, legal assumptions, and uncontrolled scope expansion |
| Norwegian offshore gas production | Abbreviate exploitation and use ICS-informed non-intrusive assessment | Protect worker safety and production continuity |
| Swedish hydroelectric and distributed wind operations | Differentiate hydro SCADA threats from wind remote-maintenance threats | Avoid generic treatment of distinct operational environments |
| Danish offshore wind and energy trading | Combine ICS assessment with OWASP application and API analysis | Address both generation availability and trading integrity |
| Dutch gas and hydrogen infrastructure | Prioritise telemetry, segmentation, contractor access, and process-safety constraints | Identify operational exposure without unsafe process interference |
| German solar subsidiary under integration | Extend identity analysis, evidence validation, and acquisition-specific threat modeling | Detect inherited access risks and unverified cross-entity trust |
| National NIS2 implementation differences and Norwegian domestic requirements | Map NIST controls to jurisdiction-specific obligations | Support defensible compliance gap analysis without claiming certification |
| Elin's ninety-day board deadline | Extend reporting and restrict initial exploitation to high-value safe validation | Deliver decision-ready assurance within the required timeframe |
| Henrik Lindqvist's historical scope failure | Extend contractual clarification, change control, and decision gates | Avoid unpriced OT work and contradictory stakeholder expectations |

## Alignment with the Four Engagement Phases

### Phase 1 — Strategic Baseline and German Integration Assurance

**Primary PTES activities:** Extended Pre-engagement Interactions, Full Intelligence Gathering, and Extended Threat Modeling.

**Complementary frameworks:** MITRE ATT&CK Enterprise, PASTA principles, and NIST SP 800-53.

**Application:** Establish group-wide security baselines, validate identity and trust relationships, assess inherited German integration risks, and classify evidence confidence.

**Methodological boundary:** No unrestricted exploitation or production OT testing.

### Phase 2 — Critical Operations and Trading Exposure Assessment

**Primary PTES activities:** Full Vulnerability Analysis, continued Threat Modeling, and limited authorised validation.

**Complementary frameworks:** MITRE ATT&CK for ICS, MITRE ATT&CK Enterprise, OWASP, and selected NIST SP 800-53 controls.

**Application:** Assess safety-critical OT architecture, supplier access, Danish trading security, and differentiated subsidiary exposures.

**Methodological boundary:** Non-disruptive OT assessment; no production control manipulation or live market transactions.

### Phase 3 — Board Assurance and Three-Year Security Roadmap

**Primary PTES activities:** Extended Reporting, evidence reconciliation, and executive risk prioritisation.

**Complementary frameworks:** NIST SP 800-53 for control-gap organisation, MITRE for technique traceability, and PASTA principles for business-risk alignment.

**Application:** Consolidate verified findings, identify residual assurance gaps, assign risk ownership, and prepare the three-year investment roadmap.

**Methodological boundary:** No additional intrusive testing; the objective is defensible executive decision support.

### Phase 4 — Optional Targeted Technical Validation

**Primary PTES activities:** Targeted Vulnerability Analysis, authorised Exploitation, controlled Post-Exploitation, and technical Reporting.

**Complementary frameworks:** PTES, OWASP, MITRE ATT&CK Enterprise, and ATT&CK for ICS as appropriate to each approved work package.

**Application:** Validate selected high-risk findings through separately scoped technical engagements and perform remediation retesting where contracted.

**Methodological boundary:** New written authorisation, asset-specific RoE, operational safety approval, stop conditions, and separately agreed pricing are mandatory.

The abbreviated exploitation and post-exploitation approach applies to the initial engagement. Phase 4 may use greater technical depth where the relevant work package is explicitly authorised and operationally safe.

## Safety, Authorisation, and Methodology Boundaries

The methodology is governed by the following mandatory principles:

1. **Written authorisation:** No testing outside explicitly approved assets, systems, accounts, and methods.
2. **Operational safety:** Production OT remains non-intrusive during the initial engagement. Safety-critical validation requires appropriate specialist oversight and explicit approval.
3. **Evidence integrity:** Verified findings, inherited audit claims, simulations, and untested hypotheses must be distinguishable.
4. **Jurisdictional accountability:** Regulatory requirements must be assessed against applicable national laws and sector-specific obligations, not assumed to be identical across the group.
5. **Third-party protection:** Supplier systems and externally owned infrastructure are excluded without the relevant owner's written permission.
6. **Controlled change management:** Material scope expansion requires documented impact assessment and contractual approval.
7. **Business-focused reporting:** Technical findings must be linked to operational consequences, remediation ownership, investment priorities, and residual risk.

## Final Methodological Recommendation

Vanguard should adopt PTES as the engagement lifecycle while deliberately extending pre-engagement governance, threat modeling, and reporting; fully deploying intelligence gathering and scoped vulnerability analysis; and abbreviating exploitation and post-exploitation during the initial board-focused engagement.

OWASP is applied where Nordstrøm has web application and API exposure, particularly Danish energy trading. MITRE ATT&CK Enterprise addresses corporate IT and German integration threats. ATT&CK for ICS addresses operational technology risks across the energy subsidiaries. NIST SP 800-53 provides a consistent control-assessment structure without replacing jurisdiction-specific legal requirements.

This adaptation ensures that methodology follows Nordstrøm's actual business risks rather than forcing five different energy operations into a generic penetration-testing template.

The intended outcome is credible technical assurance, safe assessment execution, transparent scope control, and actionable board-level security decisions within ninety days.