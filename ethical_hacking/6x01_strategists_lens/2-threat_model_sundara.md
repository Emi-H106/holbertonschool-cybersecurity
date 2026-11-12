## Framework Declaration

PASTA (Process for Attack Simulation and Threat Analysis)

## Rationale

The business context described in the engagement brief identifies a board-level decision: whether Sundara should delay its European expansion by six months for security hardening or proceed on schedule while preparing for an IPO. The mobile application architecture description identifies 12 million active loyalty accounts, integrated payments, geolocation, AI recommendations, and cross-border reservations, creating potentially significant customer-data exposure. The business context also cites a competitor's loyalty-data breach, while the Rules of Engagement description highlights cross-jurisdictional considerations involving Singapore's PDPA and the EU GDPR. PASTA is the most appropriate framework because it connects these technical and regulatory risks to business impact, risk tolerance, and the board's launch decision, unlike the architecture-focused STRIDE approach selected for Meridian.

## Framework Selection Feedback

PASTA's main strength for Sundara is its ability to translate loyalty-data security, international expansion, and regulatory exposure into a structured board-level risk decision. Its limitation is that the actual architecture, data-transfer mechanisms, security controls, and detailed Rules of Engagement are unavailable, so attack scenarios and residual-risk estimates remain provisional rather than validated findings.

## Threat Model

### Stage 1 — Define Business Objectives

**Primary business decision:** Determine whether Sundara should proceed with its planned EU expansion or delay the launch by six months to complete security hardening.

**Business objectives:**
- Protect 12 million active loyalty accounts and customer trust.
- Support expansion into Germany, France, and the Netherlands.
- Reduce the likelihood of a major customer-data incident before launch.
- Maintain investor confidence and IPO readiness.
- Demonstrate appropriate handling of personal data under Singapore's PDPA and the EU GDPR.
- Establish acceptable residual risk before the board authorizes launch.

**Business impact:** A major breach could undermine customer confidence, disrupt expansion, create incident-response costs, and affect IPO credibility. A six-month delay also has commercial consequences, so the decision requires evidence rather than assumptions.

### Stage 2 — Define Technical Scope

**First-party candidate systems and responsibilities:**
- Sundara-controlled mobile application and associated backend services.
- Loyalty-account information and authentication processes.
- Sundara-managed customer-data processing and storage.
- Payment integration interfaces under Sundara's control.
- Geolocation and AI recommendation features.
- Cross-border reservation functionality.
- Sundara-controlled interfaces with marketing or other partners.
- International customer-data processing and transfer arrangements.

**Third-party boundary:** POS hardware is built and operated by external parties. Its internal hardware, firmware, and operational security are not modeled as Sundara-controlled assets. Sundara's own data exchanges, contractual safeguards, and integration responsibilities remain relevant where applicable.

**Jurisdictional scope:** Singapore's PDPA and potentially applicable GDPR obligations must be considered together, including personal-data processing involving EU customers and international transfers.

The exact system inventory and authorization boundaries remain unverified because the underlying RoE is unavailable.

### Stage 3 — Application Decomposition

The engagement brief identifies the following functional components and potential data relationships:

| Component | Data or function | Security concern to validate |
|---|---|---|
| Loyalty platform | 12 million active accounts | Unauthorized access, excessive data exposure |
| Mobile application | Customer authentication and account access | Account takeover, insecure sessions |
| Payment integration | Payment-related interactions | Insecure interfaces or excessive access |
| Geolocation | Location-related personal data | Unnecessary collection or disclosure |
| AI recommendations | Customer preferences and behavioral information | Excessive processing or unauthorized access |
| Cross-border reservations | Reservation information across markets | International transfers and unclear processing responsibilities |
| Marketing partnerships | Potential partner access to customer information | Excessive sharing, unclear accountability |

These are functional areas stated or suggested by the brief, not a verified network diagram. Specific databases, APIs, processors, hosting locations, and transfer destinations have not been established.

### Stage 4 — Threat Analysis

**Threat 1 — Loyalty-data compromise:** Attackers may attempt to obtain customer profiles or account information, causing significant reputational and commercial damage.

**Threat 2 — Account takeover:** Stolen credentials or weaknesses in authentication and session management could enable unauthorized customer-account access.

**Threat 3 — Unauthorized cross-border disclosure:** Inadequate controls or unclear responsibilities could expose customer information during international processing or partner transfers.

**Threat 4 — Third-party integration exposure:** Weaknesses at Sundara-controlled integration boundaries could expose data even when an external provider manages the underlying service.

**Threat 5 — Insufficient detection and response:** Delayed identification or containment of an incident could increase harm immediately before or during the EU expansion.

The retail-sector threat-intelligence description mentions skimming and loyalty-data activity, but it does not establish a specific attacker, campaign, or vulnerability affecting Sundara.

### Stage 5 — Vulnerability Analysis

The following weaknesses require validation and are not confirmed findings:

1. Inadequate authentication, authorization, or session protection.
2. Excessive access to loyalty and behavioral data.
3. Insufficient encryption or protection of sensitive information.
4. Incomplete mapping of international data transfers and recipients.
5. Unclear controller, processor, and partner responsibilities.
6. Inadequate logging, incident response, or breach-notification procedures.
7. Weak governance of third-party integration interfaces.

Validation would require architecture evidence, access-control reviews, processing records, relevant contracts, and authorized security testing.

### Stage 6 — Attack Modeling

**Scenario A — Loyalty-account compromise**

An attacker obtains unauthorized access through a customer or service identity, reaches loyalty-account information, and attempts to extract data. The potential business outcome is loss of customer trust, incident-response expense, and reduced confidence in the EU launch.

**Scenario B — Cross-border data exposure**

Customer information is transferred or made accessible across jurisdictions without sufficiently verified access restrictions, processing responsibilities, or transfer safeguards. The potential outcome includes unauthorized disclosure and legal or operational uncertainty under applicable PDPA and GDPR requirements.

**Scenario C — Partner integration compromise**

A weakness in an authorized Sundara-managed partner interface permits unintended access to customer information. The potential outcome is data exposure and uncertainty over incident responsibilities.

These scenarios are hypothetical attack paths, not demonstrated compromises.

### Stage 7 — Risk and Impact Analysis

| Risk | Business impact | Preliminary priority | Board implication |
|---|---|---|---|
| Large-scale loyalty-data compromise | Customer trust, EU expansion credibility, IPO confidence | Critical | Require verified protective controls before launch |
| Uncontrolled international data processing or transfers | Legal exposure, remediation costs, operational disruption | Critical | Require documented PDPA/GDPR assessment and transfer safeguards |
| Account takeover and unauthorized access | Customer harm, fraud-related costs, reputational damage | High | Require authentication and access-control validation |
| Inadequate third-party integration governance | Data exposure, contractual disputes, unclear accountability | High | Require documented responsibilities and interface controls |
| Weak detection and incident response | Longer incidents, higher recovery costs, loss of confidence | High | Require tested response and escalation procedures |

**Decision recommendation:** A full six-month delay cannot be justified solely from hypothetical threats. However, proceeding unconditionally is also unsupported. The board should authorize launch only after critical data-protection, international-transfer, and incident-response controls are independently validated. If material gaps remain unresolved at the launch decision deadline, postponement should be the default risk-management option, with the duration determined by a verified remediation plan.

## Identified Findings

1. **Critical — Potential large-scale loyalty-data exposure.** With 12 million active accounts and a relevant competitor-breach precedent, a major incident could materially undermine the EU expansion and IPO confidence. Validate access controls, data minimization, encryption, and monitoring before launch.

2. **Critical — Potential cross-jurisdictional data-governance gaps.** Processing involving Singapore and EU markets may create overlapping PDPA and GDPR obligations, including requirements for international transfers. Map data flows, processing roles, legal bases, and applicable safeguards before the board's decision.

3. **High — Potential account takeover and unauthorized access.** Verify authentication, session security, privileged access, and anomaly detection for loyalty accounts and related services.

4. **High — Potential third-party integration and accountability gaps.** Assess Sundara-controlled interfaces and contracts without treating externally managed POS hardware as Sundara's own infrastructure.

5. **High — Potential incident-response readiness gaps.** Test detection, escalation, containment, and applicable breach-notification procedures before the EU launch.

**Evidence status:** All findings are conditional risks inferred from the supplied engagement brief. No specific technical vulnerability, regulatory violation, hidden relationship, or flag has been verified.
