# Vanguard Security: Threat Modeling Engagement Report

## Client: Meridian Federal Bank

**Prepared by:** Junior Consultant, Vanguard Security  
**Date:** 10 November 2026  
**Distribution:** Meridian internal architecture team  
**Status:** Preliminary, brief-based assessment; technical validation required

## 1. Executive Summary

Meridian Federal Bank is midway through a multi-year migration from a legacy mainframe to a hybrid AWS/on-premises architecture. The planned six-week period in which both environments operate creates a concentrated engineering risk window: data may be exchanged or reconciled across environments, identities and permissions may span old and new boundaries, and dependencies may complicate recovery and cutover. Using STRIDE, this assessment identifies six conditional risk areas for architecture-team validation: transaction integrity, cross-environment identity and privilege, transition availability, sensitive-data handling, residual legacy access, and auditability. The highest-priority engineering actions are to verify reconciliation controls, constrain privileged migration access, and demonstrate failure recovery and decommission readiness. These are **threat hypotheses, not confirmed vulnerabilities**: the underlying architecture diagram, business-context document, threat briefing, and detailed Rules of Engagement (RoE) are not supplied in the exercise.

## 2. Engagement Context

The task brief describes a US mid-size regional bank with approximately 800 employees and more than 60 branches, operating under a regulatory profile that includes SOX, GLBA, and OCC oversight. Vanguard's assignment is specifically to identify risks introduced by the transition state, not to conduct a general enterprise-wide penetration test. The deliverable is directed to Meridian's internal architecture leads and should support decisions on interfaces, access controls, reconciliation, resilience, and safe retirement of legacy components. Any active validation would require confirmation of the RoE and the exact bank-managed asset inventory before execution.

## 3. Framework Choice and Rationale

**Selected framework: STRIDE.**

The engagement description's migration architecture and six-week dual-running window make changes in system boundaries, data flows, and component responsibilities the central technical problem. The specified internal architecture-team audience needs threats associated with identifiable design elements and actionable mitigations. The workspace inventory identifies a migration architecture diagram and an RoE document as the two materials that would ordinarily anchor this analysis: the former should establish actual flows and trust boundaries, while the latter should establish permitted systems and exclusions. Because the documents themselves are unavailable, the mappings below remain provisional and do not claim that any particular interface appears in the diagram. STRIDE is preferable here to a primarily business-decision-driven PASTA analysis or an adversary-technique-led MITRE ATT&CK assessment, though both can supplement a later validated review.

**Framework selection feedback.**

STRIDE's Meridian-specific strength is its ability to examine each new or changing trust boundary during concurrent legacy and cloud operation. Its trade-off is that it cannot independently establish which hypothetical flows exist, which controls are effective, or how likely an adversary is to exploit them; those conclusions require diagrams, configuration evidence, testing authorization, and relevant intelligence.

## 4. Threat Model

The following matrix covers **candidate transition elements only**, contingent on confirmation that they exist and are authorized within Meridian's bank-managed migration scope. It does not establish an asset inventory or assert confirmed deficiencies.

| Candidate element | STRIDE | Threat to investigate | Impact | Priority |
|---|---|---|---|---|
| Dual-running data exchange | Tampering | Missing integrity or reconciliation checks permit divergent records | Transaction integrity | High |
| Cross-environment service authentication | Spoofing | Weak identity validation permits unauthorized service calls | Unauthorized access | High |
| Migration roles and automation | Elevation of Privilege | Excessive rights span legacy and cloud environments | Privileged compromise | High |
| Transition dependencies and cutover | Denial of Service | Shared dependency failure interrupts processing | Service outage | High |
| Customer-data transfer or staging | Information Disclosure | Excessive access or insufficient protection exposes records | Confidentiality loss | High |
| Cross-system logging | Repudiation | Missing correlation prevents reliable reconstruction | Investigation gaps | Medium |
| Decommissioned legacy access paths | Spoofing / Elevation of Privilege | Old credentials or routes remain active | Persistent access | High |

The qualitative priorities reflect possible impact on core banking services and data during the six-week overlap, **not demonstrated exploitability**. The architecture team should revise each row after identifying real components, existing safeguards, owners, and likelihood. For each confirmed issue, record the supporting diagram reference, configuration evidence, and acceptance criterion.

## 5. Recommendations and Prioritization

1. **P1 — Prove transaction integrity during parallel running.** Inventory all actual data-exchange and reconciliation paths. For each, document source of truth, ordering, integrity validation, retry behavior, exception queues, and accountable owners. Run controlled reconciliation tests and define measurable cutover acceptance thresholds before retiring the mainframe.

2. **P1 — Constrain cross-environment identities and privileges.** Inventory service accounts, administrators, automation roles, secrets, and trust relationships used for migration. Apply least privilege and strong authentication, rotate temporary credentials where appropriate, and set explicit expiration and revocation conditions for migration-only access.

3. **P1 — Validate resilience and rollback.** Map confirmed shared dependencies, perform approved failure and recovery exercises, document recovery targets, and rehearse a rollback decision before the six-week overlap ends. Ensure monitoring can distinguish faults in the legacy estate, target estate, and interconnection layer.

4. **P1 — Protect data in transit and temporary locations.** Verify encryption and authorization on confirmed transfer paths, restrict staging access, define retention periods, and document secure disposal of temporary copies. Validate relevant data-handling obligations with the bank's compliance function.

5. **P1 — Make legacy retirement verifiable.** Use a signed decommission checklist covering access revocation, network-route removal, integration shutdown, secret invalidation, residual-data handling, and post-cutover monitoring. Require evidence of completion and an accountable approval owner.

6. **P2 — Correlate audit evidence across environments.** Verify synchronized timestamps, transaction identifiers, administrative-event coverage, protected log storage, and retention sufficient for incident reconstruction and internal control review.

## 6. Limitations and Uncertainty

This report is based **only on the Task 1 engagement brief**. The four described workspace materials—the interactive migration diagram, business-context document, 12-month financial-sector threat-intelligence briefing, and detailed RoE—were not accessible. Therefore, specific data paths, technologies, trust boundaries, control failures, and adversary activity cannot be verified. No scanning, exploitation, configuration inspection, or control testing was performed. The RoE must be reviewed before any live assessment; the report does not authorize activity against any system merely because it is connected to the migration environment.

The brief mentions a Luxembourg subsidiary serving expatriate US customers. **The subsidiary is excluded from the threat-model scope** and has not been modeled as an asset or attack target. Its presence may create cross-jurisdictional questions that Meridian's legal and compliance teams should assess separately if relevant to permitted data flows; no conclusion about EU-law applicability or actual transfers is made here. SOX, GLBA, and OCC are part of the stated US regulatory context, but this is not a compliance attestation. All severity rankings and recommendations should be revalidated against the actual architecture and signed scope.

## 7. Appendix: Sourced Findings

**Source A — Task 1 engagement brief (client profile):** US mid-size regional bank; approximately 800 employees; more than 60 branches; US regulatory profile; Luxembourg subsidiary. Used for engagement context and limitations only.

**Source B — Task 1 engagement brief (migration and audience):** Multi-year legacy-mainframe-to-hybrid-AWS/on-premises migration, six-week dual-running period, eventual legacy decommission, internal architecture-team audience. Used to derive the conditional STRIDE threat scenarios and engineering priorities.

**Source C — Task 1 workspace inventory:** Lists an interactive architecture diagram, business-context document, 12-month threat-intelligence briefing, and RoE with explicit scope clauses. These underlying materials were not provided; no claims are attributed to their unseen contents.

**Hidden findings / flags:** None verified or submitted. No undocumented connection is claimed. If new information is later supplied, document its exact source and authorization before adding it to the report.
