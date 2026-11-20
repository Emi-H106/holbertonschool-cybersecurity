# Phase 1 Action Log, Nordstrøm engagement

## Evidence and execution boundaries

This action log reconstructs Phase 1 from the authorised offline Nordstrøm training evidence bundle. It records historical observations and controlled proof events rather than new live testing.

The assessment covers public reconnaissance, attack-surface identification, and a controlled read-only foothold on a peripheral supplier onboarding application.

All timestamps are in UTC (ISO 8601). Evidence references identify the corresponding records in the supplied artefacts. No live scanning, exploitation, credential testing, or OT interaction was performed.

## Phase 1 Action Trail

| Timestamp (UTC) | Phase | Action | Target | Observed result |
|---|---|---|---|---|
| 2026-04-21T09:01:02Z | Recon | Review public DNS inventory | www.npg-lab.example | Public web front door identified in the DNS snapshot. Evidence: dns-0056. |
| 2026-04-21T09:02:11Z | Recon | Identify public domain and subdomain inventory | npg-lab.example | Public apex and associated subdomain set identified. Accepted event evt-p1-001; correlation key 747662bff6. |
| 2026-04-21T09:05:44Z | Recon | Correlate supplier domain metadata | supplier-portal.npg-lab.example | Supplier onboarding asset identified in the peripheral scope. Evidence: dns-0033. |
| 2026-04-21T09:06:37Z | Attack Surface | Review recorded HTTP response and onboarding workflow | supplier-portal.npg-lab.example | HTTP 200; supplier onboarding workflow visible with maintenance header enabled. Candidate evidence, not yet foothold proof. Evidence: http-0058 and supplier_portal_mirror.html. |
| 2026-04-21T09:07:56Z | Recon | Review public corporate web response | www.npg-lab.example | HTTP 200 corporate front door confirmed. Evidence: http-0042. |
| 2026-04-21T09:20:45Z | Recon | Identify German subsidiary integration interface | api.solar-de.npg-lab.example | German integration API label identified through available metadata. Detailed assessment deferred to Phase 2. Evidence: evt-p1-002. |
| 2026-04-21T09:31:18Z | Attack Surface | Select bounded peripheral assessment candidate | supplier-portal.npg-lab.example | Supplier onboarding application identified as the controlled peripheral foothold candidate. Evidence: evt-p1-003; correlation key 9d3afb564d. |
| 2026-04-21T09:47:25Z | Foothold | Review controlled supplier onboarding confirmation | supplier-portal.npg-lab.example | Accepted proof record confirms access to a read-only onboarding confirmation page. No destructive action recorded. Evidence: http-0065. |
| 2026-04-21T09:47:33Z | Foothold | Correlate controlled foothold evidence | supplier-portal.npg-lab.example | Read-only foothold confirmed by evt-p1-004 and http-9001. No production data or OT systems accessed. Accepted Phase 1 foothold proof marker identified. |
| 2026-04-21T09:52:06Z | Recon | Validate public-surface mapping evidence | npg-lab.example | Accepted public-surface proof confirmed by evt-p1-005 and cert-9001. Certificate SAN evidence references the corporate web front door, supplier portal, and German integration API. |

## Accepted Phase 1 Proof Markers

Only markers associated with accepted, in-scope Phase 1 proof records were decoded.

| Proof | Evidence references | Decoded marker |
|---|---|---|
| Public surface mapping | evt-p1-005; cert-9001 | `flag{npg_phase1_public_surface_mapped}` |
| Controlled supplier portal foothold | evt-p1-004; http-9001; http-0065 | `flag{npg_phase1_supplier_portal_foothold}` |

## Scope Boundaries and Deferred Activities

The German subsidiary integration API was identified during reconnaissance but reserved for Phase 2 technical assessment.

Authenticated investor portal functionality, VPN testing, and operational technology environments were not treated as authorised Phase 1 exploitation targets.

The supplier portal evidence establishes a bounded, read-only foothold. It does not demonstrate privileged access, persistence, lateral movement, or compromise of production infrastructure.

The offline dataset does not establish that these actions were executed against live Nordstrøm systems.

## Phase 1 Outcome

Phase 1 achieved its documented objectives within the controlled evidence perimeter:

- The public-facing domain and relevant subsidiary-facing interfaces were identified.
- The supplier onboarding portal was selected as a bounded peripheral assessment target.
- A controlled, read-only foothold was supported by accepted evidence.
- Two relevant Phase 1 proof markers were validated.
- Higher-risk integration and operational environments were deferred for subsequent authorised assessment.

The resulting evidence trail supports Phase 2 planning and the final engagement report without overstating the scope of technical validation.