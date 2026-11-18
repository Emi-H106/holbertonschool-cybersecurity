# Engagement Risk Register, Nordstrøm Power Group

## Purpose and Risk Assessment Criteria

This register identifies risks to Vanguard Security's ability to deliver the Nordstrøm Power Group engagement safely, independently, within the agreed scope, and before the 90-day board deadline.

It addresses engagement delivery risks rather than vulnerabilities within Nordstrøm's IT or OT systems.

The baseline engagement covers 130 consultant-days across three phases over 12 weeks, with a board-ready report targeted for Day 85. Optional intrusive technical validation remains outside the initial scope and requires separate authorisation.

**Likelihood:** Low = unlikely under current controls; Medium = plausible during the engagement; High = likely without active management.

**Impact:** Low = limited disruption; Medium = material rework or scheduling pressure; High = significant contractual, financial, or delivery consequences; Critical = potential safety incident, legal breach, loss of independence, or failure of a fundamental engagement obligation.

## Engagement Risk Register

| Risk | Likelihood | Impact | Mitigation | Trigger | Owner |
| ---- | ---------- | ------ | ---------- | ------- | ----- |
| **R01 — Scope creep:** Requests for additional subsidiaries' assets, unrestricted penetration testing, remediation work, or production OT exploitation exceed the agreed Statement of Work and Rules of Engagement. | High | **High:** Unbudgeted consultant-days, delivery delays, contractual disputes, and loss of the 90-day reporting window. | Establish a signed scope baseline, asset boundaries, exclusions, deliverables, and change-control procedure before mobilisation. Record all additional requests, assess cost and schedule implications, and obtain written approval before execution. Defer intrusive testing to separately contracted Phase 4. | Any stakeholder requests work outside the approved scope, or forecast effort exceeds the allocated consultant-day baseline. | **Lead Engagement Architect** |
| **R02 — Conflict of interest and prior-firm assurance:** A previous consulting firm's German acquisition audit, integration assessment, or control recommendations overlap with Vanguard's work. Undisclosed commercial relationships or pressure to endorse inherited conclusions may compromise independent assessment. | Medium | **High:** Questioned independence, disputed findings, client dissatisfaction, rework, or rejection of assurance conclusions. | Conduct a documented independence and relationship check before accepting inherited evidence. Identify previous providers, work ownership, contractual restrictions, and any Vanguard affiliations. Treat prior reports as unverified inputs until corroborated. Disclose actual or perceived conflicts, apply independent peer review, and obtain an agreed resolution or recusal where necessary. | An undisclosed relationship, restriction on reviewing prior work, material contradiction with inherited findings, or request to accept a previous firm's conclusions without verification is identified. | **Lead Engagement Architect** |
| **R03 — Board deadline failure:** Delayed access, evidence collection, subsidiary interviews, technical reviews, or executive approvals prevent completion of the three-year security roadmap within Elin Solberg's 90-day deadline. | High | **Critical:** The CISO cannot present a defensible strategy on time; the engagement fails a central business objective and may lose executive confidence. | Maintain a 12-week integrated schedule with weekly milestone reviews, named deliverable owners, and a Day 85 board-report target. Prioritise board-critical evidence, escalate blockers promptly, and provide an explicitly qualified report where evidence remains unavailable rather than inventing conclusions. Protect Phase 3 reporting capacity from late technical scope expansion. | A critical milestone slips by more than five working days, a required input threatens the Day 85 target, or a dependency makes the 90-day board deadline unachievable. | **Lead Engagement Architect** |
| **R04 — OT incident during assessment:** Assessment activity unintentionally disrupts SCADA communications, industrial monitoring, remote engineering access, or operational processes at an energy subsidiary. | Low | **Critical:** Personnel or environmental safety exposure, operational interruption, contractual liability, immediate suspension of testing, and reputational damage. | Prohibit intrusive production OT testing within the initial engagement. Use documentation-led and non-intrusive assessment methods, approved access paths, designated maintenance arrangements where applicable, and OT engineering oversight. Agree stop-work authority, operational contacts, escalation channels, and incident procedures before any OT interaction. | Any unexpected process alarm, communication degradation, abnormal controller behaviour, safety warning, or stop-work instruction from the local operations team. | **OT / ICS Security Consultant** |
| **R05 — Subsidiary cooperation and governance resistance:** Local CISOs or operational leaders resist group-level coordination, restrict access to evidence, challenge the assessment mandate, or prioritise local operations over the holding company's engagement. | High | **High:** Incomplete subsidiary coverage, inconsistent evidence, delays, political escalation, and reduced credibility of group-wide recommendations. | Obtain a documented group-level mandate endorsed by Elin Solberg and acknowledged by subsidiary leadership. Establish named local sponsors, a responsibility matrix, interview schedules, evidence deadlines, and an escalation path. Respect local operational authority and document limitations transparently rather than bypassing access controls. | A subsidiary refuses an authorised interview or evidence request, misses an agreed delivery date, or disputes the engagement authority or scope. | **Lead Engagement Architect** |
| **R06 — Cross-jurisdiction legal and regulatory exposure:** Assessment activities, evidence processing, reporting, or regulatory interpretations conflict with applicable requirements in Norway, Sweden, Denmark, the Netherlands, or Germany. | Medium | **Critical:** Unauthorised testing, unlawful data handling, misleading compliance conclusions, legal disputes, regulatory consequences, or engagement suspension. | Maintain a jurisdiction-specific legal and authorisation matrix. Engage the external NIS2 legal advisor to validate material interpretations and distinguish EU member-state requirements from Norway's applicable domestic framework. Confirm data-processing permissions, confidentiality, third-party rights, and testing authority before relevant activities. Restrict or suspend work where legal authority is unresolved. | Unclear or conflicting legal obligations, missing testing consent, disputed data-transfer permissions, newly identified third-party restrictions, or a material legal concern raised by local counsel. | **Regulatory and Risk Consultant** |

## Risk Ownership and Escalation

The named owner is accountable for monitoring the risk, identifying trigger events, initiating mitigation, documenting decisions, and reporting residual exposure.

The Lead Engagement Architect maintains the consolidated register and coordinates contractual or executive escalations.

For OT-related incidents, the OT / ICS Security Consultant has immediate technical stop-work responsibility. Local operations personnel retain authority over their industrial environment. The Lead Engagement Architect manages contractual notification and engagement-level decisions.

For cross-jurisdiction legal concerns, the Regulatory and Risk Consultant coordinates with the external NIS2 legal advisor. Legal interpretation must be validated by appropriately qualified counsel; the internal consultant does not independently issue legal opinions.

Risk owners review the register weekly and immediately after any trigger event.

## Trigger Response and Change Control

When a trigger occurs, the responsible owner must:

1. Record the event, affected subsidiary, evidence, date, and potential engagement impact.
2. Initiate the defined mitigation and notify the Lead Engagement Architect.
3. Assess consequences for safety, authorisation, scope, consultant-days, cost, and the Day 85 reporting target.
4. Escalate to Elin Solberg or the designated subsidiary authority when a client decision is required.
5. Obtain written approval before undertaking additional or materially changed work.
6. Update the register with the decision, residual risk, accountable owner, and follow-up deadline.

A safety-related OT trigger requires immediate cessation of the affected activity before any further assessment.

An unresolved legal-authorisation issue requires suspension of the affected work until the necessary permissions or legal clarification have been obtained.

A scope change must never be treated as automatically approved because a subsidiary or senior stakeholder requested it.

## Engagement Governance and Acceptance

This register is an active management control, not a one-time reporting attachment.

Risk acceptance must be explicit and documented. The Lead Engagement Architect may recommend treatment options, but cannot independently accept risks that require client authorisation, changes to contractual obligations, or decisions affecting operational safety.

Critical risks must be escalated promptly to the appropriate Vanguard leadership and Nordstrøm decision-makers. No commercial pressure or reporting deadline overrides safety, legal authorisation, or the agreed Rules of Engagement.

The register will be maintained throughout the initial three-phase engagement and reviewed before any separately contracted Phase 4 activities.

This preventive approach reflects Henrik Lindqvist's lesson: predictable ambiguity, conflicting expectations, and unmanaged dependencies must be resolved before they become mid-engagement disputes, unplanned work, or delivery failures.