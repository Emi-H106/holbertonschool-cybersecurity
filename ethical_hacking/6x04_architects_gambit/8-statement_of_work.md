# Statement of Work, Vanguard Security x Nordstrøm Power Group

**Document status:** Draft for commercial negotiation and legal review  
**Engagement:** Group Cybersecurity Assessment and Three-Year Security Roadmap  
**Proposed duration:** Twelve weeks, with final delivery no later than Day 90  
**Proposed fixed fee:** EUR 156,000, excluding applicable taxes and separately approved expenses  
**Version:** 1.0

## 1. Parties

This Statement of Work ("SoW") is proposed between:

**Consultant:** Vanguard Security ("Vanguard"), acting through its duly authorised contracting entity.

**Client:** Nordstrøm Power Group ("Nordstrøm"), acting through its duly authorised contracting entity.

The parties' full registered legal names, addresses, registration numbers, and authorised signatories shall be confirmed before execution.

Nordstrøm shall identify the legal entity authorised to contract on behalf of the group and shall secure the necessary participation, access permissions, and operational approvals from its subsidiaries in Norway, Sweden, Denmark, the Netherlands, and Germany.

Unless expressly agreed in writing, individual subsidiaries are not separate contracting parties under this SoW.

The engagement will be sponsored by Elin Solberg, Group Chief Information Security Officer, with an authorised Nordstrøm commercial representative responsible for contractual approvals.

Vanguard will appoint a Lead Engagement Architect as the primary delivery and governance contact.

This SoW becomes binding only upon execution by authorised representatives of both parties.

## 2. Engagement Objectives and Confirmed Scope

### 2.1 Objectives

Vanguard shall conduct a risk-based cybersecurity assessment of Nordstrøm's group-level security posture and selected subsidiary environments.

The engagement shall support Nordstrøm's objective of presenting a defensible three-year cybersecurity strategy to its board within ninety calendar days.

The assessment will focus on:

- Group cybersecurity governance and risk ownership.
- Shared identity, privileged access, and cross-subsidiary trust relationships.
- Cybersecurity implications of the recently acquired German solar subsidiary.
- IT/OT segmentation, industrial remote access, and operational dependencies.
- Danish energy trading application and API security exposure.
- Third-party and contractor access.
- Regulatory and control-assurance gaps across the relevant jurisdictions.
- Prioritised remediation initiatives and a three-year investment roadmap.

The engagement is an assessment and strategic advisory assignment. It does not constitute a certification, legal compliance guarantee, or unrestricted penetration-testing mandate.

### 2.2 Phase 1 — Strategic Baseline and German Integration Assurance

**Schedule:** Weeks 1–3  
**Effort:** 36 consultant-days

Vanguard shall:

1. Confirm the authorised scope, stakeholders, Rules of Engagement, evidence requirements, and operational constraints.
2. Review group security governance, identity architecture, and selected cross-subsidiary dependencies.
3. Assess the German acquisition's inherited identity, VPN, privileged access, supplier connectivity, and integration risks.
4. Review the provenance, completeness, and reliability of relevant inherited audit evidence.
5. Establish an initial group-level risk baseline and subsidiary-specific threat assumptions.
6. Identify jurisdictional and operational restrictions affecting subsequent assessment activities.

### 2.3 Phase 2 — Critical Operations and Trading Exposure Assessment

**Schedule:** Weeks 4–8  
**Effort:** 64 consultant-days

Vanguard shall perform authorised, risk-based assessments of selected systems and architectures across the following subsidiaries:

| Jurisdiction | Principal assessment focus |
|---|---|
| Norway | Offshore natural gas operations, OT safety boundaries, remote contractor access, and IT/OT trust |
| Sweden | Hydroelectric and wind operations, SCADA architecture, remote maintenance, and operational dependencies |
| Denmark | Offshore wind infrastructure, energy trading applications, APIs, authentication, and authorisation |
| Netherlands | Gas and hydrogen infrastructure, pipeline telemetry, industrial connectivity, and remote access |
| Germany | Acquired solar operations, inherited IT/OT architecture, identity integration, supplier access, and legacy assurance evidence |

Assessment methods shall be adapted from PTES and supported, where appropriate, by OWASP WSTG, OWASP API Security Top 10, MITRE ATT&CK Enterprise, MITRE ATT&CK for ICS, and NIST SP 800-53.

Production OT assessment shall be documentation-led and non-intrusive.

Any controlled technical validation within the initial engagement shall be limited to expressly authorised, non-disruptive IT or test environments.

### 2.4 Phase 3 — Board Assurance and Three-Year Security Roadmap

**Schedule:** Weeks 9–12  
**Effort:** 30 consultant-days

Vanguard shall:

1. Consolidate verified findings, evidence limitations, and risk scenarios.
2. Produce a prioritised group-level cybersecurity risk register.
3. Assess relevant governance and control gaps, distinguishing technical observations from legal compliance conclusions.
4. Develop a three-year security roadmap with implementation priorities, indicative investment bands, dependencies, and accountable business owners.
5. Prepare subsidiary-specific technical findings and a consolidated executive assessment.
6. Present the principal conclusions and recommendations to Nordstrøm's designated executive stakeholders.
7. Deliver a board-ready report targeted for Day 85 and no later than Day 90, subject to the dependencies and change-control provisions of this SoW.

### 2.5 Authorisation and Rules of Engagement

Before assessment activity begins, the parties shall approve an engagement-specific Rules of Engagement document defining:

- Authorised legal entities, assets, environments, and contacts.
- Permitted and prohibited techniques.
- Testing windows and operational restrictions.
- Evidence handling and security requirements.
- Incident escalation and emergency stop-work procedures.
- Third-party permissions and relevant local approvals.

No access or testing right shall be inferred solely from Nordstrøm's ownership interest in a subsidiary.

Vanguard may decline or suspend an activity where authorisation, operational safety, or legal permissibility remains unresolved.

## 3. Exclusions and Assumptions

### 3.1 Exclusions

The following activities are expressly excluded from the initial fixed-price engagement:

1. Intrusive exploitation of live production OT, SCADA, PLC, or safety-critical industrial systems.
2. Denial-of-service testing, destructive payloads, uncontrolled persistence, or unauthorised lateral movement.
3. Execution or manipulation of live energy market trades.
4. Exhaustive penetration testing of every asset across all five subsidiaries.
5. Testing of third-party infrastructure without separate written authorisation from the relevant rights holder.
6. Remediation implementation, infrastructure redesign, software development, or operational change execution.
7. Formal certification, regulatory approval, or a legal opinion guaranteeing NIS2 compliance.
8. Forensic incident response, continuous monitoring, or managed security services.
9. Unbounded investigation of unknown or undocumented legacy assets.
10. Optional Phase 4 technical validation, unless separately contracted.

### 3.2 Assumptions and Client Dependencies

The proposed scope, fee, and timeline assume that Nordstrøm shall:

- Provide timely access to relevant personnel, approved documentation, and agreed technical evidence.
- Designate authorised group and subsidiary representatives.
- Obtain necessary approvals from subsidiary operators and third parties.
- Confirm the legal and operational ownership of assets proposed for assessment.
- Provide accurate information about critical infrastructure, operational restrictions, and safety requirements.
- Make relevant local technical and operational personnel available.
- Review submitted deliverables and provide consolidated feedback within five working days.
- Disclose material changes to its infrastructure, ownership, or regulatory circumstances during the engagement.

Where these assumptions are not satisfied, Vanguard shall document the resulting limitation, notify Nordstrøm, and propose an appropriate mitigation or contractual change.

Vanguard shall not silently expand scope or represent unverified information as established fact.

## 4. Deliverables and Acceptance

Vanguard shall provide the following deliverables in electronic form:

| ID | Deliverable | Target delivery |
|---|---|---|
| D1 | Confirmed engagement scope, Rules of Engagement, evidence plan, and initial strategic risk baseline | End of Week 3 |
| D2 | German integration and group identity exposure assessment | End of Week 3 |
| D3 | Subsidiary-focused technical and architectural assessment findings, including documented evidence limitations | End of Week 8 |
| D4 | Consolidated group cybersecurity risk register and control-gap assessment | Weeks 9–10 |
| D5 | Three-year cybersecurity roadmap, prioritised initiatives, investment bands, and accountability recommendations | Weeks 10–12 |
| D6 | Final executive and board-ready cybersecurity assessment report | Target Day 85; no later than Day 90 |

Each deliverable shall distinguish verified evidence, documented assumptions, and unvalidated risk hypotheses.

Nordstrøm shall review a submitted deliverable within five working days and either accept it in writing or identify material, specific deviations from the agreed acceptance criteria.

Vanguard shall correct substantiated non-conformities within the agreed scope without additional professional fees.

Requests for new analysis, additional testing, or expanded coverage shall be handled through change control rather than classified as corrections.

If Nordstrøm does not respond within the review period, Vanguard shall issue a reminder and escalate the pending decision. Silence alone shall not constitute acceptance unless expressly agreed in the executed contract.

## 5. Milestones and Timeline

The engagement shall commence on the mutually agreed effective start date, following signature, required authorisations, and mobilisation readiness.

| Milestone | Timing | Acceptance or decision point |
|---|---|---|
| M0 — Contract execution and mobilisation | Before Week 1 | SoW, contacts, and initial authorisations confirmed |
| M1 — Strategic baseline complete | End of Week 3 | D1 and D2 submitted for review |
| M2 — Technical assessment complete | End of Week 8 | D3 submitted; evidence limitations documented |
| M3 — Risk prioritisation and roadmap structure complete | End of Week 10 | D4 and roadmap priorities reviewed |
| M4 — Board-ready report | Target Day 85 | D5 and D6 submitted for executive review |
| M5 — Final contractual delivery | No later than Day 90 | Final agreed deliverables issued |

Vanguard shall maintain a weekly delivery status report identifying completed activities, outstanding dependencies, material risks, and forecast milestone impacts.

A delay exceeding five working days on a critical milestone, or any dependency threatening Day 85 delivery, shall trigger formal escalation.

Client-caused delays, missing permissions, or approved scope changes may require a mutually agreed adjustment to the schedule and associated commercial terms.

Neither party shall be deemed to have authorised unsafe or unlawful activity solely to preserve a milestone.

## 6. Team Composition and Resource Allocation

Vanguard shall provide five core consultants and two limited-duration external specialists.

| Role | Seniority | Planned consultant-days |
|---|---|---:|
| Lead Engagement Architect | Senior / Principal | 44 |
| IT and Identity Security Consultant — German-speaking | Senior | 26 |
| OT / ICS Security Consultant | Senior | 20 |
| Application and API Security Consultant | Mid–Senior | 18 |
| Regulatory and Risk Consultant | Senior | 12 |
| External NIS2 Legal Advisor | Senior specialist | 6 |
| External OT Engineer Subcontractor | Senior specialist | 4 |
| **Total** | | **130** |

The internal team accounts for 120 consultant-days, and the two external specialists account for 10 consultant-days.

German-language capability is required for the German subsidiary assessment. Scandinavian-language capability is preferred for the holding-level interface, subject to confirmation of the working language.

Vanguard shall retain responsibility for subcontractor coordination, quality assurance, confidentiality obligations, and adherence to the Rules of Engagement.

Any material substitution of a named key role or reduction in required specialist capability shall be communicated to Nordstrøm in advance. Replacement personnel shall have substantially equivalent qualifications.

## 7. Pricing Structure

### 7.1 Fixed-Price Engagement

The parties propose a **fixed-price structure for the defined initial three-phase engagement**, subject to final commercial approval.

| Phase | Consultant-days | Fixed-price allocation |
|---|---:|---:|
| Phase 1 — Strategic Baseline and German Integration Assurance | 36 | EUR 43,200 |
| Phase 2 — Critical Operations and Trading Exposure Assessment | 64 | EUR 76,800 |
| Phase 3 — Board Assurance and Three-Year Security Roadmap | 30 | EUR 36,000 |
| **Total** | **130** | **EUR 156,000** |

The price is based on an illustrative blended planning rate of EUR 1,200 per consultant-day.

This amount is a proposed commercial baseline, not evidence of previously approved Vanguard rates or a confirmed Nordstrøm budget.

The parties shall validate subcontractor costs, applicable taxes, travel expenses, and any specialist premiums before signing.

### 7.2 Pricing Rationale

Fixed pricing is appropriate because the initial engagement has defined phases, deliverables, resource allocations, and a fixed board deadline.

It provides Nordstrøm with budget predictability while requiring Vanguard to maintain disciplined scope and resource management.

The fixed fee does not entitle Nordstrøm to unlimited consulting time, unrestricted testing, or additional deliverables.

Any work materially exceeding the agreed scope shall require a written change order.

### 7.3 Optional Phase 4

Targeted technical validation may be proposed separately after the initial engagement.

The provisional planning assumption is 60 consultant-days over approximately six to ten weeks, with an indicative value of EUR 72,000.

No Phase 4 activity is authorised by this SoW.

A separate Statement of Work, Rules of Engagement, resource plan, and commercial approval shall be required.

## 8. Payment Terms

Subject to final commercial agreement, the fixed fee shall be invoiced against the following milestones:

| Payment event | Percentage | Amount |
|---|---:|---:|
| Contract execution and mobilisation | 30% | EUR 46,800 |
| Phase 1 deliverables accepted | 25% | EUR 39,000 |
| Phase 2 deliverables accepted | 25% | EUR 39,000 |
| Final deliverables accepted | 20% | EUR 31,200 |
| **Total** | **100%** | **EUR 156,000** |

Invoices shall be payable within thirty calendar days of receipt of a valid invoice, unless the executed agreement specifies otherwise.

Amounts exclude applicable VAT or other legally required taxes.

Travel and accommodation expenses shall be reimbursable only where approved in writing in advance and supported by reasonable documentation.

A good-faith dispute concerning part of an invoice shall not automatically suspend payment of undisputed amounts.

The parties shall resolve disputed invoices promptly through their designated commercial representatives.

## 9. Change Management

Any proposed change affecting scope, deliverables, testing methods, authorised assets, staffing, fees, or schedule shall be subject to formal change control.

The change process shall include:

1. Submission of a written change request identifying the requested modification.
2. Assessment by Vanguard of technical feasibility, operational safety, legal authorisation, resource requirements, cost, and schedule impact.
3. Preparation of a written change order defining the revised scope, deliverables, assumptions, fees, and milestones.
4. Review and approval by authorised representatives of both parties.
5. Implementation only after the change order is executed and any required Rules of Engagement updates are approved.

Verbal instructions, informal emails from unauthorised personnel, or operational requests from individual subsidiaries shall not independently amend this SoW.

Where a requested change introduces material OT safety or legal risk, Vanguard may reject the activity or require additional specialist review.

This process is intended to prevent uncontrolled scope expansion, uncompensated work, and conflicting expectations.

## 10. Confidentiality, Data Protection, and Intellectual Property

### 10.1 Confidentiality

Each party shall protect the other party's non-public business, technical, operational, financial, and security information using reasonable safeguards appropriate to its sensitivity.

Confidential information includes system diagrams, audit reports, access information, credentials, vulnerability evidence, operational procedures, and unpublished assessment findings.

Confidential information shall be used only for the purposes of the engagement and disclosed only to personnel or approved subcontractors with a legitimate need to know and equivalent confidentiality obligations.

Disclosure required by applicable law shall be handled with appropriate notice where legally permitted.

Confidentiality obligations shall survive termination for a period to be agreed in the executed contract, with trade secrets protected for as long as required by applicable law.

### 10.2 Data Protection and Evidence Handling

The parties shall determine their respective data-protection roles and execute any required data-processing agreement before personal data is processed.

Evidence collection shall follow data-minimisation, access-control, encryption, retention, and secure-deletion requirements appropriate to the information involved.

Cross-border transfers of personal or sensitive operational information shall be subject to applicable legal requirements and approved transfer arrangements.

Vanguard shall not transfer regulated or sensitive data to an unauthorised third party or jurisdiction.

### 10.3 Intellectual Property

Each party retains ownership of its pre-existing intellectual property, methodologies, tools, templates, and proprietary materials.

Subject to full payment of applicable fees, Nordstrøm shall receive a perpetual, non-exclusive, internal-use licence to the final engagement deliverables, including the executive report, risk register, and security roadmap.

Vanguard retains ownership of its underlying assessment methodologies, reusable frameworks, know-how, and pre-existing materials.

Neither party may disclose the other's confidential information or commercially sensitive deliverables to external parties except as authorised by the agreement or required by law.

Any broader redistribution rights, including disclosure to regulators, auditors, subsidiaries, or professional advisors, shall be expressly addressed in the final agreement.

## 11. Liability and Limitation of Liability

Each party shall be responsible for losses arising from its breach of this SoW to the extent established under the applicable governing law.

Subject to mandatory legal requirements and the exceptions below, Vanguard's aggregate contractual liability arising from the initial engagement is proposed to be capped at the total fees paid or payable under this SoW.

Neither party shall be liable for indirect or consequential losses, including lost profits or anticipated business opportunities, except to the extent such exclusions are prohibited by applicable law or expressly agreed otherwise.

No limitation or exclusion shall apply where prohibited by law, including liability that cannot lawfully be limited for fraud, wilful misconduct, or other mandatory exceptions.

The parties shall specifically review the treatment of confidentiality breaches, data-protection obligations, gross negligence, and OT-related physical or operational harm before execution.

Vanguard does not guarantee the discovery of every vulnerability, prevention of future incidents, regulatory certification, or complete elimination of cybersecurity risk.

Nordstrøm retains operational control of its production systems and responsibility for approving operational changes.

Vanguard remains responsible for complying with the agreed Rules of Engagement and exercising appropriate professional care.

The final liability structure, insurance requirements, and any special OT-related provisions shall be reviewed by qualified legal counsel and agreed before signature.

## 12. Termination

Either party may terminate this SoW for a material breach by the other party that remains uncured thirty calendar days after receipt of written notice specifying the breach, except where immediate termination is required or permitted by applicable law.

Either party may suspend affected activities immediately where continuation would create a material safety risk, violate applicable law, or exceed the necessary authorisation.

If such conditions cannot be resolved through reasonable cooperation, the parties shall determine whether the affected scope should be amended or the engagement terminated.

Nordstrøm may request termination for convenience upon thirty calendar days' written notice, subject to payment for properly completed work, approved non-cancellable commitments, and any expressly agreed termination charges.

Upon termination:

- Vanguard shall cease affected activities in a controlled manner.
- The parties shall reconcile completed work, accepted deliverables, and outstanding payments.
- Vanguard shall provide completed and paid-for deliverables in accordance with the agreed intellectual-property provisions.
- Confidential information and collected evidence shall be returned, retained, or securely deleted according to contractual and legal obligations.
- Accrued payment rights, confidentiality, intellectual-property provisions, liability provisions, and dispute-resolution obligations shall survive where applicable.

Termination shall not authorise either party to disregard safety requirements or applicable legal obligations.

## 13. Governing Law and Dispute Resolution

### 13.1 Proposed Governing Law

**Proposed contractual governing law: Norwegian law.**

The parties propose Norwegian law as the governing law of this SoW because Nordstrøm's holding-level engagement is centred on its Scandinavian group governance and Norwegian operational context.

This selection is a negotiated contractual proposal, not an assertion that Norwegian law automatically governs all subsidiaries or that Nordstrøm's contracting entity is necessarily established in Norway.

The final choice shall be confirmed after verifying the legal identity and establishment of the contracting parties and obtaining appropriate legal advice.

### 13.2 Mandatory Local Laws

The choice of Norwegian governing law shall not displace mandatory laws applicable to activities conducted in Sweden, Denmark, the Netherlands, Germany, or Norway.

In particular, the parties shall separately comply with applicable requirements relating to:

- Cybersecurity and critical infrastructure.
- National implementation of relevant EU cybersecurity obligations.
- Industrial safety and operational authorisation.
- Personal data protection and cross-border processing.
- Third-party property, contractual access rights, and confidentiality.
- Incident reporting and regulatory cooperation where legally required.

The external NIS2 legal advisor shall support the identification of jurisdiction-specific obligations. Qualified local counsel shall be consulted where necessary.

No contractual governing-law clause shall be interpreted as permission to conduct testing prohibited by local law.

### 13.3 Dispute Resolution Procedure

The parties shall first seek to resolve disputes through good-faith negotiation between their designated engagement and commercial representatives.

If a dispute remains unresolved for fifteen working days after written notice, it shall be escalated to authorised senior executives of both parties.

If the dispute remains unresolved thirty calendar days after executive escalation, either party may commence proceedings in the agreed dispute-resolution forum.

### 13.4 Proposed Forum

**Proposed forum: the competent courts of Oslo, Norway, with exclusive jurisdiction over contractual disputes arising from this SoW, subject to applicable mandatory jurisdiction rules.**

The parties may instead agree to institutional arbitration if confidentiality, enforceability, or cross-border commercial considerations justify that approach.

The selected forum, procedural language, and any arbitration rules must be expressly agreed before execution; arbitration shall not be implied merely because it is mentioned as an alternative.

The governing-law and forum provisions shall be reviewed together to avoid inconsistent or unenforceable dispute-resolution arrangements.

### 13.5 Interim Relief and Regulatory Authority

Nothing in this clause shall prevent a party from seeking urgent protective relief from a competent court where permitted by applicable law.

Nothing shall restrict the lawful authority of regulators or public bodies in the jurisdictions where Nordstrøm operates.

## 14. Engagement Governance and Professional Standards

Vanguard shall perform the services with reasonable professional skill, care, independence, and diligence.

Both parties shall maintain clear decision-making authority, documented approvals, and timely escalation of material engagement risks.

Vanguard shall maintain an engagement risk register covering scope creep, prior-firm conflicts, deadline risk, OT incidents, subsidiary cooperation, and cross-jurisdiction legal exposure.

Findings shall be evidence-based, with assumptions and limitations explicitly disclosed.

Neither commercial pressure nor the board deadline shall override operational safety, legal authorisation, professional independence, or the agreed Rules of Engagement.

The parties acknowledge that the engagement's success depends on clear scope boundaries, active client cooperation, and timely decisions rather than an implied obligation to perform unlimited work.

## 15. Execution and Signatures

This document remains a draft until the parties confirm the contracting entities, legal terms, commercial assumptions, and authorised signatories.

The parties intend that the executed SoW, together with any agreed master services agreement, Rules of Engagement, data-processing agreement, and approved change orders, shall define their respective obligations.

In the event of inconsistency, the order of precedence shall be expressly established in the executed agreement.

| For Vanguard Security | For Nordstrøm Power Group |
|---|---|
| Authorised representative: __________________ | Authorised representative: __________________ |
| Title: __________________ | Title: __________________ |
| Date: __________________ | Date: __________________ |
| Signature: __________________ | Signature: __________________ |