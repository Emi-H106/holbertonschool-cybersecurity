# Environmental CVSS Recalibration

| Finding | Sarah base (severity) | Environmental (severity) | Delta | Justification |
| --- | --- | --- | --- | --- |
| F-01 | 8.1 (High) | 8.8 (High) | ↑ | Diagnostic results contain highly sensitive patient health data, making confidentiality and integrity requirements High under MediPath's GDPR and HDS obligations. Cross-tenant result retrieval affects a platform serving 400 laboratories, and the WAF does not compensate for missing object-level authorization. |
| F-02 | 6.1 (Medium) | 6.7 (Medium) | ↑ | Support analysts can access multiple laboratory tenants, increasing the confidentiality and integrity requirements for the support portal. MFA and managed workstations reduce account-compromise exposure but do not prevent stored active content from executing in an authenticated analyst's browser. |
| F-03 | 8.8 (High) | 8.0 (High) | ↓ | Hospital connector credentials protect high-criticality integration boundaries, justifying High confidentiality, integrity, and availability requirements. The private integration network restricts direct token reachability, although excessive `integration:all` privileges and the 180-day token lifetime remain significant risks. |
| F-04 | 8.2 (High) | 5.8 (Medium) | ↓ | The managed private egress gateway reportedly enforces mutual TLS, validates upstream certificates, and restricts destinations, potentially increasing the complexity of exploiting the worker-level validation weakness. This reduction is provisional until gateway bypass resistance, monitoring, and fail-closed behavior are verified. |
| F-05 | 7.5 (High) | 8.3 (High) | ↑ | Sample-status integrity is critical to diagnostic operations because false validation states may compromise downstream laboratory workflows. Source-IP allowlisting restricts network access, but unsigned messages remain susceptible to manipulation from an authorized or compromised partner source. |
| F-06 | 6.5 (Medium) | 8.3 (High) | ↑ | Diagnostic exports contain sensitive health information, and retention beyond the documented 24-hour period increases confidentiality and GDPR/HDS accountability concerns. Storage encryption does not eliminate the exposure created by valid download links remaining available for approximately 30 days. |
| F-07 | 9.1 (Critical) | 6.6 (Medium) | ↓ | The bulk-export function processes highly sensitive patient data but is documented as an authorized emergency workflow requiring DPO approval, WebAuthn step-up, dual authorization, case-specific encryption, and audit logging. The provisional calculation assumes these controls increase exploitation complexity; production enforcement must be verified before deciding whether the finding should remain open. |
| F-08 | 5.3 (Medium) | 5.3 (Medium) | = | Account enumeration exposes laboratory-user identity information, but its confidentiality impact is limited compared with direct patient-health-data disclosure. SSO and MFA cover 82% of laboratory users, although remaining local accounts and source-based rate limiting preserve a meaningful identity-attack risk. |
| F-09 | 7.2 (High) | 7.2 (High) | = | The administrative console controls critical platform configuration and integration trust relationships, supporting High confidentiality, integrity, and availability requirements. MFA, managed workstations, and quarterly reviews do not immediately invalidate stale authorization, leaving the observed 27-minute privilege-retention window unresolved. |
| F-10 | 8.0 (High) | 7.6 (High) | ↓ | Internal analytics access is restricted to the application network, while the service's trust in caller-supplied tenant headers exposes cross-laboratory information. High confidentiality and integrity requirements reflect tenant-isolation concerns, but the network-restricted attack path reduces exposure relative to a publicly reachable service. |

## Environmental Metric Assumptions

The following CVSS v3.1 environmental metric selections reproduce the calculated scores when applied to Sarah's original vectors. Unspecified modified metrics inherit their corresponding base values, and unspecified security requirements use Medium.

| Finding | Environmental metric selections |
| --- | --- |
| F-01 | `CR:H/IR:H/AR:M` |
| F-02 | `CR:H/IR:H/AR:M` |
| F-03 | `CR:H/IR:H/AR:H/MAV:A` |
| F-04 | `CR:H/IR:H/AR:M/MAC:H/MC:L/MI:L/MA:L` |
| F-05 | `CR:M/IR:H/AR:H/MAV:A` |
| F-06 | `CR:H/IR:M/AR:M` |
| F-07 | `CR:H/IR:H/AR:M/MAC:H` |
| F-08 | `CR:M/IR:M/AR:L` |
| F-09 | `CR:H/IR:H/AR:H` |
| F-10 | `CR:H/IR:H/AR:M/MAV:L` |

## Validation and Reporting Notes

- The inherited base-score values are preserved exactly as written in Sarah's report; discrepancies between those values and their CVSS v3.1 vectors require reconciliation before the final client report.
- F-04 and F-07 environmental scores are conditional on the documented compensating controls being effective and consistently enforced.
- F-07 may ultimately be retired as intended, authorized functionality if all mandatory production approvals and safeguards are verified; an environmental score alone does not establish that a vulnerability exists.
- These scores are calculated from CVSS v3.1 environmental metrics and should be independently checked against the official FIRST.org calculator before final submission.
