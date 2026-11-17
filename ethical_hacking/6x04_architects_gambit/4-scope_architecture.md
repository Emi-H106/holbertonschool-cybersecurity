# Scope Architecture, Nordstrøm Power Group

## Engagement architecture and planning assumptions

Vanguard Security recommends a risk-based, four-phase engagement rather than an exhaustive assessment of all Nordstrøm Power Group assets. The primary commitment is to provide CISO Elin Solberg with defensible, board-ready findings and a three-year cybersecurity investment roadmap within ninety calendar days. Detailed technical testing beyond this decision-making baseline will be separately authorised and priced.

The architecture reflects Nordstrøm's five distinct operating environments: Norwegian offshore gas, Swedish hydroelectric and wind generation, Danish offshore wind and energy trading, Dutch gas and hydrogen infrastructure, and the recently acquired German utility-scale solar subsidiary.

The proposed durations, consultant-days, and costs are indicative planning assumptions, not a binding quotation. They depend on confirmed asset inventories, subsidiary authorisations, stakeholder availability, regulatory classifications, evidence quality, and approved Rules of Engagement (RoE).

For commercial illustration, an assumed blended consulting rate of EUR 1,200 per consultant-day is used. This is not a confirmed Vanguard rate. Specialist expenses, travel, taxes, and additional technical testing would require separate estimation.

## In scope / Out of scope (per subsidiary, IT and OT)

### Group-wide boundaries

**In scope:**
- Group-level cybersecurity governance, risk ownership, and security investment priorities.
- Shared identity infrastructure, privileged access governance, cross-subsidiary trust relationships, and critical third-party access.
- IT/OT segmentation architecture, remote-access governance, and evidence-based assessment of operational dependencies.
- Existing security assessments, architecture documentation, incident-response arrangements, and relevant assurance evidence.
- Jurisdiction-specific regulatory applicability assessment and identification of material compliance gaps.
- Board-level risk reporting, remediation priorities, and a three-year investment roadmap.

**Out of scope:**
- Unrestricted penetration testing of all corporate networks, applications, and subsidiaries.
- Live exploitation of production OT/ICS assets, manipulation of control processes, or disruption of energy operations.
- Physical intrusion, social engineering against employees, and destructive testing.
- Testing of third-party infrastructure without explicit written authorisation from the relevant asset owner.
- Certification, formal legal opinions, or guarantees of NIS2 compliance.
- Full implementation of remediation measures or continuous managed security operations.

### Norway — Offshore gas

**IT in scope:**
- Corporate identity and privileged-access controls supporting offshore operations.
- Contractor VPN access, remote engineering authentication, and selected operational-support services.
- Architecture and configuration evidence for IT-to-OT connectivity.

**OT in scope:**
- Non-intrusive review of offshore control-system architecture, remote maintenance pathways, network segmentation, and safety-related dependencies.
- Interviews with operational owners and review of existing OT security evidence.

**Out of scope:**
- Active exploitation of production offshore controllers, safety instrumented systems, and platform communications.
- Operational command execution, production shutdown simulations, and unapproved offshore site access.

**Phasing decision:** Include architecture and access-path assessment in Phase 2; defer intrusive OT testing to a separate, safety-approved engagement.

### Sweden — Hydroelectric and wind generation

**IT in scope:**
- Remote-access controls for hydroelectric and wind operations.
- Supplier identity governance, monitoring-system access, and selected management infrastructure.

**OT in scope:**
- Evidence-based review of hydroelectric SCADA boundaries, wind-farm monitoring, and remote maintenance architecture.
- Non-disruptive examination of segmentation and operational access controls.

**Out of scope:**
- Manipulation of dam controls, turbine commands, protection systems, or live generation processes.
- Broad exploitation of geographically distributed production assets.

**Phasing decision:** Assess representative hydroelectric and wind environments in Phase 2; defer fleet-wide technical validation.

### Denmark — Offshore wind and energy trading

**IT in scope:**
- Trading-platform identity controls, privileged accounts, API authentication, and critical business-system dependencies.
- Offshore wind remote-access governance and selected corporate-to-operational trust boundaries.

**OT in scope:**
- Architecture and configuration review of offshore wind supervisory and remote-management pathways.
- Assessment of OT support dependencies without production interference.

**Out of scope:**
- Execution of real market trades, modification of settlement data, or production trading disruption.
- Intrusive testing of offshore wind controllers or safety-related systems.

**Phasing decision:** Prioritise trading-system access and business continuity in Phase 2, alongside non-intrusive offshore wind exposure assessment. Defer deeper application testing until transaction-safe conditions are approved.

### Netherlands — Gas and hydrogen infrastructure

**IT in scope:**
- Engineering contractor access, remote administration, identity governance, and selected support networks.
- Review of architecture and access-control evidence affecting industrial operations.

**OT in scope:**
- Non-intrusive assessment of pipeline SCADA segmentation, telemetry gateways, industrial remote-access pathways, and operational resilience dependencies.

**Out of scope:**
- Changes to pipeline or hydrogen process controls, live command injection, disruptive protocol testing, and safety-system interference.
- Testing beyond confirmed asset ownership and written authorisation.

**Phasing decision:** Prioritise safety-critical architecture and third-party access review in Phase 2; reserve intrusive validation for a separately approved safety-controlled work package.

### Germany — Utility-scale solar and acquisition integration

**IT in scope:**
- Legacy VPN accounts, inherited identities, privileged access, domain trust relationships, and integration gateways.
- Connections between acquired infrastructure and Nordstrøm group systems.
- Provenance, currency, permissions, and reliability of historical third-party audit evidence.
- Supplier access and integration-related security governance.

**OT in scope:**
- Documentation-based review of solar monitoring, inverter-management architecture, remote maintenance access, and IT/OT boundaries.
- Identification of unverified asset ownership and operational access dependencies.

**Out of scope:**
- Assumption that inherited audit findings constitute verified assurance.
- Unauthorised testing of legacy networks or third-party supplier systems.
- Intrusive solar OT testing before integration ownership, access rights, and safety restrictions are confirmed.
- Remediation of inherited integration defects within the assessment contract.

**Phasing decision:** Place German identity and trust-boundary validation in Phase 1 because incomplete integration may create group-wide exposure. Defer detailed solar OT testing until the ownership and evidence gaps are resolved.

## Phase 1 — Strategic Baseline and German Integration Assurance

**Perimeter:** Group-level cybersecurity governance, shared identity and privileged access, cross-subsidiary trust boundaries, critical third-party dependencies, and the German subsidiary's inherited identities, integration gateways, supplier access, and historical audit evidence. All five subsidiaries participate in evidence collection, but targeted independent technical validation is concentrated on the German integration perimeter.

**Methodology depth:** PASTA-informed business-risk analysis, MITRE ATT&CK-based threat mapping, stakeholder interviews, documentation review, access-control sampling, and controlled configuration validation. German audit findings are classified as verified, conditionally reliable, or unverified according to evidence quality and independent corroboration. No unrestricted exploitation or production OT testing is included.

**Deliverable:** Group security baseline, critical asset and trust-boundary map, German integration assurance memorandum, evidence-confidence register, initial regulatory applicability matrix, and prioritised risk hypotheses.

**Duration:** Weeks 1–3 (15 working days).

**Consultant-days:** 36, comprising 14 lead architect days, 14 IT/identity specialist days, and 8 regulatory/OT advisory days.

**Indicative consulting fee:** EUR 43,200.

**Commercial rationale:** This phase comes first because Elin needs a credible understanding of inherited group-wide exposure before committing to a three-year security strategy. The recently acquired German subsidiary creates a specific risk of uncontrolled trust relationships and unreliable historical assurance, making early independent validation more valuable than superficial testing across every subsidiary. Thirty-six consultant-days provide focused architectural and identity assurance without financing an exhaustive pentest. For Nordstrøm, this establishes a defensible starting point within the ninety-day deadline while avoiding the scope ambiguity and unestimated OT commitments highlighted by Henrik Lindqvist's earlier engagement failure.

## Phase 2 — Critical Operations and Trading Exposure Assessment

**Perimeter:** Norwegian offshore gas remote access and IT/OT boundaries; Swedish hydroelectric SCADA access and representative wind-farm management pathways; Danish energy trading identity, APIs, and business continuity dependencies alongside offshore wind remote access; Dutch gas and hydrogen telemetry, contractor access, and industrial segmentation; and German solar OT architecture only where reliable documentation and authorisation are available.

**Methodology depth:** Targeted MITRE ATT&CK and ATT&CK for ICS scenario analysis, OT architecture review, read-only configuration assessment, access-control sampling, and non-disruptive verification. Danish trading interfaces may undergo authenticated configuration and access-control review using approved test accounts and non-production environments where available. Production OT exploitation, unsafe scanning, and live market transactions are excluded.

**Deliverable:** Five differentiated subsidiary exposure assessments, IT/OT trust-boundary findings, Danish trading-risk memorandum, critical operational dependency map, and a severity-ranked technical risk register with explicit evidence limitations.

**Duration:** Weeks 4–8 (25 working days).

**Consultant-days:** 64, comprising 14 lead architect days, 22 OT specialist days, 18 IT/application security days, and 10 jurisdictional/regulatory advisory days.

**Indicative consulting fee:** EUR 76,800.

**Commercial rationale:** After the initial trust-boundary baseline, the engagement can target the exposures most likely to affect energy production, worker safety, and trading integrity. The sixty-four consultant-days reflect the need for specialist OT expertise and differentiated assessments across five jurisdictions, but avoid the much higher cost and operational risk of full penetration testing at every facility. Norway and the Netherlands receive safety-led industrial attention; Sweden receives representative hydro and wind coverage; Denmark receives distinct trading and generation analysis; Germany receives only evidence-supported OT review. This sequence gives Elin actionable, comparable findings without treating all subsidiaries as interchangeable or promising unsafe access.

## Phase 3 — Board Assurance and Three-Year Security Roadmap

**Perimeter:** Consolidation of verified findings from all five subsidiaries; group-level risk ownership; jurisdiction-specific regulatory applicability; remediation dependencies; investment sequencing; and executive decision support. Unverified assumptions are explicitly separated from confirmed findings.

**Methodology depth:** Evidence reconciliation, business-impact prioritisation, regulatory gap mapping, executive risk workshops, and investment-roadmap modelling. No new intrusive technical testing is performed. Findings are ranked using business impact, likelihood, operational safety, evidence confidence, and remediation feasibility.

**Deliverable:** Board-ready cybersecurity assessment, executive risk heat map, subsidiary comparison, three-year prioritised security roadmap, indicative investment bands, ownership and accountability matrix, and a register of deferred validation activities.

**Duration:** Weeks 9–12, with final board materials delivered no later than Day 85 to preserve a review buffer before the ninety-day deadline.

**Consultant-days:** 30, comprising 16 lead architect days, 8 regulatory/risk specialist days, and 6 technical quality-assurance and reporting days.

**Indicative consulting fee:** EUR 36,000.

**Commercial rationale:** This phase converts technical evidence into the decisions Elin actually needs: what to remediate first, where to invest, which subsidiary owns each risk, and what remains uncertain. Thirty consultant-days fund evidence reconciliation, executive workshops, and defensible reporting rather than another round of indiscriminate testing. Delivering by Day 85 protects the board deadline and provides time for executive challenge and revision. This is the essential commercial value of the initial engagement: a credible three-year strategy, not an oversized vulnerability inventory.

## Phase 4 — Optional Targeted Technical Validation and Remediation Assurance

**Perimeter:** Separately selected high-risk findings and assurance gaps from Phases 1–3. Potential work packages include German legacy-domain and integration-path testing, Danish trading application and API penetration testing in an approved test environment, and specialist OT validation for selected Norwegian, Swedish, Dutch, or German assets under asset-owner-approved conditions.

**Methodology depth:** PTES-aligned technical testing, targeted OWASP application testing, MITRE ATT&CK scenario validation, and ATT&CK for ICS-informed OT assessment. Each work package requires an explicit Statement of Work, asset list, authorisation, operational safety review, RoE, stop conditions, and agreed evidence-handling procedures. OT testing defaults to laboratory, simulation, or non-production environments unless production activity is independently approved.

**Deliverable:** Work-package-specific penetration test reports, validated findings, remediation recommendations, retest results where contracted, and updated residual-risk assessments.

**Duration:** Indicatively 6–10 weeks after the initial board-focused engagement, subject to approvals and operational windows.

**Consultant-days:** Provisional allowance of 60 consultant-days across selected work packages, to be re-estimated after scoping.

**Indicative consulting fee:** EUR 72,000, excluding specialist expenses and any additional site requirements.

**Commercial rationale:** Deep technical validation becomes commercially rational only after the first three phases establish which weaknesses justify it and which systems can be tested safely. The provisional sixty-day allowance gives Sarah a planning envelope without implying that all five subsidiaries will receive comprehensive penetration testing. Separately authorised work packages protect Nordstrøm from unnecessary expenditure and Vanguard from unpriced scope expansion. This also creates a transparent basis for discussing a potential annual retainer without making future commercial opportunity a substitute for evidence-based prioritisation.

## Consolidated schedule and commercial envelope

| Phase | Timing | Consultant-days | Indicative fee | Contract treatment |
|---|---|---:|---:|---|
| Phase 1 — Strategic Baseline and German Integration Assurance | Weeks 1–3 | 36 | EUR 43,200 | Initial engagement |
| Phase 2 — Critical Operations and Trading Exposure Assessment | Weeks 4–8 | 64 | EUR 76,800 | Initial engagement |
| Phase 3 — Board Assurance and Three-Year Security Roadmap | Weeks 9–12; delivery by Day 85 | 30 | EUR 36,000 | Initial engagement |
| Phase 4 — Targeted Technical Validation | Subsequent 6–10 weeks | 60 provisional | EUR 72,000 provisional | Optional, separately authorised |
| **Initial board-focused commitment** | **Within 90 calendar days** | **130** | **EUR 156,000** | **Phases 1–3** |
| **Illustrative total including Phase 4** | **Subject to separate approval** | **190** | **EUR 228,000** | **Not a single fixed-price commitment** |

The EUR 800,000 potential annual retainer must not be interpreted as the approved budget for this assessment. The initial EUR 156,000 estimate is an illustrative professional-services envelope based on stated assumptions, not an authorised price. Phase 4 is optional and cannot be treated as committed scope or guaranteed revenue.

## Jurisdictional governance and delivery dependencies

Each subsidiary must provide an accountable business owner, an authorised technical contact, written permission for the relevant assets, and confirmation of applicable operating restrictions.

Regulatory applicability must be validated individually. Norway is assessed under its applicable domestic framework, while Sweden, Denmark, the Netherlands, and Germany require country-specific evaluation of their national NIS2 implementations and relevant energy-sector requirements. No uniform compliance conclusion will be issued for the entire group without subsidiary-level evidence.

Cross-border evidence collection must follow agreed data-classification, access, retention, and transfer rules. Sensitive operational diagrams, credentials, personal data, and supplier documentation must not be transferred or retained without approved controls.

The initial schedule assumes timely access to stakeholders, architecture records, and approved test environments. Delayed authorisation, unavailable operational windows, undocumented assets, or material changes to the requested perimeter will trigger impact assessment and written change control rather than silent expansion of consultant effort.

## Explicit deferrals, exclusions, and decision gates

Vanguard will deliberately defer or exclude the following:

1. **Production OT exploitation:** Excluded from the initial engagement because safety, operational continuity, and authorisation outweigh the marginal value of intrusive validation before architecture and risk are understood.
2. **Exhaustive subsidiary penetration testing:** Deferred because comprehensive coverage across five jurisdictions cannot be credibly delivered within the ninety-day board deadline at the proposed effort level.
3. **Unverified German legacy systems:** No testing or reliance on inherited audit conclusions until ownership, permissions, evidence provenance, and integration boundaries are confirmed.
4. **Live Danish market transactions:** Excluded to prevent financial, contractual, and market-integrity consequences; approved test environments are preferred.
5. **Third-party infrastructure:** Excluded unless the actual asset owner supplies written permission and appropriate contractual protections.
6. **Remediation implementation and certification:** Excluded because the immediate mandate is independent assessment and strategic planning, not operational ownership or a legal guarantee of compliance.

**Gate 1 — Before Phase 1:** Confirm executive sponsorship, subsidiary contacts, initial asset boundaries, evidence permissions, and commercial assumptions.

**Gate 2 — Before Phase 2:** Approve subsidiary-specific RoE, OT safety constraints, test windows, and any authorised technical validation.

**Gate 3 — Before Phase 3:** Validate material findings with accountable owners and distinguish confirmed exposure from assumptions and assurance gaps.

**Gate 4 — Before Phase 4:** Approve a new Statement of Work, detailed scope, specialist staffing, price, and explicit testing authorisations.

## Final recommendation to Sarah Westerlund

Vanguard should offer Nordstrøm a bounded, three-phase, ninety-day board-assurance engagement, with a fourth phase available only through separate authorisation.

The recommended initial commitment is 130 consultant-days, indicatively EUR 156,000 under the illustrative rate assumption. This allocation prioritises the German integration risk, safety-critical operational dependencies, Danish trading exposure, and a board-ready three-year roadmap.

This structure addresses Elin's immediate strategic deadline without disguising uncertainty as a fixed technical promise. It also applies Henrik Lindqvist's central lesson: clarify scope, stakeholders, and operational boundaries before commercial commitment, rather than accepting an ambiguous RFP and absorbing the consequences as unchargeable change orders.

The objective is not to assess everything. It is to deliver the right assurance, at the right depth, in the right sequence, with a transparent contractual boundary.