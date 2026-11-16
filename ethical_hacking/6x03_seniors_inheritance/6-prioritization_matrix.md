# Risk Prioritization Matrix

## Prioritization Approach

This matrix translates MediPath Diagnostics' retained penetration-test findings and identified attack chains into an actionable remediation plan for the CISO and audit committee.

Priorities reflect environmental severity, demonstrated exploitability, patient-data sensitivity, business impact, attack-chain dependencies, and the effectiveness of documented compensating controls.

- **P1 — Immediate:** High-impact weaknesses requiring urgent containment and remediation, particularly cross-tenant exposure, diagnostic workflow integrity, and excessive privileges.
- **P2 — Quarterly:** Significant weaknesses requiring planned remediation and validation of existing compensating controls.
- **P3 — Backlog:** Lower-priority improvements that can be scheduled within routine security maintenance.

Indicative costs represent relative implementation effort rather than approved financial budgets. Attack-chain costs describe coordinated validation and remediation work and should not be added directly to the costs of their constituent findings.

## Remediation Prioritization Matrix

| Item | Priority | Owner | Timeline | Cost | Dependencies |
| --- | --- | --- | --- | --- | --- |
| F-01 — Cross-tenant diagnostic result access | P1 | Technical Director | Immediate | Medium | No prerequisite; enforce server-side tenant ownership checks and coordinate validation with F-10. |
| F-02 — Stored XSS in support case notes | P1 | Technical Director | Immediate | Medium | No prerequisite; implement contextual output encoding and sanitization, then validate support-session boundaries for Chains 2 and 3. |
| F-03/09 — Connector authorization and privilege lifecycle | P1 | Technical Director | Immediate | High | Coordinate connector-specific token scopes, credential revocation, and immediate session/cache invalidation; preserve separate F-03 and F-09 verification tests. |
| F-04 — Disabled TLS peer verification in legacy connector worker | P2 | Technical Director | Quarterly | Medium | First validate managed mTLS gateway enforcement, destination restrictions, bypass resistance, monitoring, and fail-closed behavior; then restore defense-in-depth certificate validation. |
| F-05 — Unsigned partner sample-status webhook | P1 | Technical Director | Immediate | Medium | Coordinate with partner integration owners; implement message authentication, replay protection, and partner identity binding before production enforcement. |
| F-06 — Excessive retention of diagnostic export packages | P2 | DPO | Quarterly | Medium | Confirm approved retention requirements and lawful exceptions; Technical Director implements automatic expiry, deletion, and access-control verification. |
| F-08 — Password-recovery account enumeration | P3 | Technical Director | Backlog | Low | No prerequisite; standardize recovery responses and strengthen account-based throttling, with coordination on laboratory-user MFA coverage. |
| F-10 — Caller-controlled laboratory identity in analytics service | P1 | Technical Director | Immediate | Medium | No prerequisite; replace trust in caller-supplied `X-Lab-ID` with verified tenant identity and enforce authorization within the service. Coordinate with F-01. |
| Chain 1 — Connector-to-diagnostic cross-tenant exposure (F-03 → F-10 → F-01) | P1 | CISO | Immediate | High | Coordinate remediation of F-03/09, F-10, and F-01; validate connector-to-analytics reachability and identifier-discovery assumptions before performing an end-to-end regression test. |
| Chain 2 — Support XSS to residual administrative privileges (F-02 → F-09) | P1 | CISO | Immediate | Medium | Requires F-02 remediation and F-09 session/cache invalidation; verify privileged-session separation, administrative origin boundaries, and sensitive-action authorization. |
| Chain 3 — Account enumeration to support-session compromise (F-08 → F-02) | P2 | CISO | Quarterly | Medium | Requires F-02 remediation and F-08 recovery-flow hardening; validate case-submission prerequisites, laboratory-user authentication coverage, and support-role access boundaries. |

## Remediation Sequence and Dependencies

### Phase 1 — Immediate Risk Reduction

The Technical Director should prioritize server-side authorization enforcement for F-01 and F-10, restrict excessive connector privileges under F-03, and eliminate delayed privilege revocation under F-09.

F-05 requires urgent integrity protection because the inherited evidence demonstrates unauthorized changes to synthetic sample-status records from an approved partner test source. Source-IP allowlisting must not be treated as equivalent to authenticated message integrity.

F-02 should also receive immediate attention because stored active content was demonstrated in an authenticated support browser and contributes to two potential attack chains.

The CISO should coordinate these workstreams and ensure that immediate containment measures, regression testing, and security monitoring are implemented without waiting for completion of all longer-term architectural improvements.

### Phase 2 — Attack-Chain Validation

Chain 1 requires coordinated remediation of F-03/09, F-10, and F-01 before the complete cross-tenant exposure scenario can be considered mitigated.

Chain 2 requires both stored-XSS remediation and effective administrative privilege revocation. Session separation and application-origin restrictions must be verified independently.

Chain 3 depends on the combination of account reconnaissance, a feasible case-submission route, and stored XSS. Its validation must distinguish actual authentication or submission access from hypothetical credential compromise.

Each attack chain should receive a dedicated regression test demonstrating that the relevant trust boundaries are enforced. The complete chains have not been proven end to end, and remediation acceptance must not assume that their hypothetical pivots were previously demonstrated.

### Phase 3 — Quarterly Control Improvements

F-04 should be addressed through verification of the managed mTLS gateway and restoration of certificate-validation defense in depth. The documented gateway controls reduce potential exposure only if they are consistently enforced and cannot be bypassed.

For F-06, the DPO should confirm the authorized retention policy and applicable exceptions. The Technical Director should then implement automatic expiration and deletion controls, supported by audit evidence showing that export packages cannot remain accessible beyond approved periods.

Chain 3 should undergo additional identity and support-workflow validation during the quarterly remediation cycle, with particular attention to laboratory users outside the documented SSO/MFA coverage.

### Phase 4 — Backlog Hardening

F-08 should be remediated through uniform password-recovery responses, improved throttling, and authentication monitoring.

Although classified as P3 when considered individually, F-08 remains a dependency of Chain 3. Its remediation should be accelerated if testing demonstrates a practical path from account enumeration to unauthorized case submission or account compromise.

## Ownership and Governance

The Technical Director is accountable for coordinating implementation of application, integration, and authorization fixes.

The CISO owns the overall risk-prioritization process, cross-system attack-chain validation, and reporting of remediation progress to the audit committee.

The DPO owns the privacy and retention-policy decisions associated with F-06, while technical implementation remains the responsibility of the Technical Director.

The Compliance / HDS Manager should review the resulting evidence for relevance to the upcoming HDS renewal audit and applicable regulatory obligations.

Each remediation item should be closed only after its owner has provided documented implementation evidence and a successful security regression test. A compensating control must not be treated as effective solely because it is described in policy or architecture documentation.

## Budget and Audit Committee Considerations

The immediate remediation budget should prioritize tenant isolation, connector authorization, diagnostic workflow integrity, and support-portal security.

High-cost work is concentrated in authorization-lifecycle improvements and coordinated attack-chain validation. These investments address multiple findings and reduce the risk of repeated failures across shared trust boundaries.

MediPath's annual recurring revenue is approximately EUR 31.2 million. A hypothetical 1% laboratory-client churn scenario corresponds to approximately EUR 312,000 in annual recurring revenue exposure, while a 5% scenario corresponds to approximately EUR 1.56 million. These are illustrative commercial scenarios, not expected losses attributable to any individual finding.

The upcoming HDS renewal audit and the audit committee's eight-week budget window increase the importance of early remediation ownership, measurable milestones, and documented evidence.

F-07 is excluded from this matrix because the reported bulk-export behavior was retired from the active vulnerability register as an intended, pre-approved business function. Assurance testing of the documented export safeguards remains a separate control-verification recommendation.

## Conclusion

The remediation plan prioritizes confirmed cross-tenant authorization failures, integrity weaknesses, and excessive privileges while accounting for the potential escalation created by multi-stage attack chains.

Immediate actions focus on reducing the most consequential patient-data and workflow risks. Quarterly work addresses retention governance, transport-security defense in depth, and additional chain validation. Lower-priority identity hardening remains visible in the backlog and may be accelerated if new evidence changes its risk profile.

Clear ownership, explicit dependencies, and evidence-based closure criteria provide MediPath's CISO and audit committee with a defensible basis for allocating remediation resources and tracking progress.
