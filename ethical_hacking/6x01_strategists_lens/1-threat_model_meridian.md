## Framework Declaration

STRIDE

## Rationale

The engagement brief describes a six-week dual-running period during Meridian Federal Bank's migration from a legacy mainframe to a hybrid AWS/on-premises architecture, making transitional trust boundaries and data flows the primary analytical concern. The stated audience is the internal architecture team, which needs engineering decisions rather than a board-level business-risk narrative. The listed migration architecture diagram would ordinarily supply the component and flow inventory, while the Rules of Engagement (RoE) would establish authorized boundaries; neither underlying document is available in this exercise. STRIDE is therefore the best provisional fit, with every element below treated as an architecture-derived hypothesis rather than a verified diagram finding.

## Framework Selection Feedback

STRIDE can systematically expose authentication, integrity, availability, and privilege risks introduced when old and new banking environments run concurrently. Its limitation here is that the actual architecture, controls, and RoE clauses are unavailable, so component mappings and priorities remain provisional; STRIDE also does not by itself establish adversary likelihood or regulatory compliance.

## Threat Model

**Basis and scope:** The task brief confirms a legacy mainframe, hybrid AWS/on-premises target, six-week parallel operation, and intended legacy decommissioning. The table models only the transition interfaces and controls that would plausibly fall within the authorized bank-managed migration estate. Specific connectors, identity platforms, databases, and network paths have not been verified. The matrix is a design-review hypothesis, not evidence of exploited vulnerabilities or confirmed misconfigurations. No out-of-scope subsidiary assets are modeled.

| In-scope candidate architecture element / boundary | STRIDE category | Threat scenario to validate | Potential impact | Priority | Evidence needed |
|---|---|---|---|---|---|
| Legacy-to-target data exchange during dual running (if present) | T — Tampering | Inadequate integrity checks or reconciliation permit divergent transaction records | Incorrect balances, reconciliation failure | High | Actual data-flow diagram, reconciliation and integrity controls |
| Cross-environment authentication and service identities (if present) | S — Spoofing | A reused or weakly validated service identity allows unauthorized calls across the boundary | Unauthorized system access | High | Identity flows, authentication methods, credential ownership |
| Migration administration and automation (if present) | E — Elevation of Privilege | Broad migration permissions persist across legacy and cloud components | Privileged compromise affecting both environments | High | Role definitions, least-privilege reviews, privileged access logs |
| Parallel-run dependencies and cutover interfaces (if present) | D — Denial of Service | Failure or overload of a shared transition dependency interrupts processing | Banking-service disruption during cutover | High | Dependency map, capacity tests, failover and rollback procedures |
| Customer-data movement and temporary storage (if present) | I — Information Disclosure | Excessive access or unprotected staging exposes sensitive banking data | Confidentiality loss and potential regulatory consequences | High | Data classification, encryption, access and retention controls |
| Cross-system transaction and administrative audit trails (if present) | R — Repudiation | Uncorrelated or incomplete logs prevent reconstruction of changes during parallel operation | Weak incident investigation and reconciliation | Medium | Log coverage, timestamps, correlation IDs, retention settings |
| Legacy decommissioning interfaces and credentials (if present) | S / E — Spoofing / Elevation of Privilege | Obsolete accounts or connections remain usable after cutover | Persistent unauthorized access path | High | Decommission checklist, access revocation evidence, closure tests |

**Priority rationale:** High indicates potentially material banking integrity, confidentiality, privileged-access, or availability impact during the time-limited parallel run. Medium indicates an important detection/accountability gap whose severity depends on actual logging coverage. These are qualitative preliminary priorities, not verified likelihood scores.

## Identified Findings

1. **High — Potential integrity and reconciliation exposure in dual-running data exchange.** Confirm synchronization paths, transaction ordering, integrity validation, and exception handling; require reconciliation evidence before cutover.

2. **High — Potential cross-environment identity and privilege exposure.** Inventory service identities and migration administrators; verify strong authentication, least privilege, credential rotation, and time-bounded access.

3. **High — Potential transition availability and rollback exposure.** Identify shared dependencies and single points of failure; test failure handling, recovery, and a controlled rollback before legacy shutdown.

4. **High — Potential sensitive-data exposure during migration.** Validate encryption, staging-area access, retention, and removal of temporary copies.

5. **High — Potential residual legacy access after decommission.** Require evidence that accounts, routes, integrations, and secrets are revoked or disabled.

6. **Medium — Potential audit-trail gaps across old and new systems.** Confirm correlated, tamper-resistant logs sufficient to trace transactions and privileged changes.

**Evidence status:** All findings are conditional risks inferred from the task brief. No architecture-specific weakness, undocumented connection, or hidden flag has been confirmed.
