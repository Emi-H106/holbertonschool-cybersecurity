# Phase 2 Action Log (append-only)

## Engagement Context and Evidence Boundaries

**Client:** Nordstrøm Power Group  
**Assessment team:** Vanguard Security  
**Assessment date:** 21 April 2026  
**Primary target:** `api.solar-de.npg-lab.example`  
**Related OT-adjacent asset:** `telemetry-gw-solar-de.npg-lab.example`  
**Evidence source:** Authorised offline Nordstrøm training evidence bundle, version 2.

This log reconstructs the targeted Phase 2 assessment of the German solar subsidiary's integration environment. The assessment follows the risk-based engagement plan, prioritising inherited integration interfaces, potential data exposure, and trust boundaries between corporate IT and operational technology.

All entries represent observations recorded in the supplied synthetic evidence, not new interactions with live systems. No production exploitation, OT command execution, destructive activity, or unauthorised lateral movement was performed.

The log is maintained in chronological, append-only style. All timestamps use ISO 8601 UTC.

## Phase 2 Action Trail

| Timestamp (UTC) | Phase | Action | Target | Observed result |
|---|---|---|---|---|
| 2026-04-21T10:12:09Z | Identification | **Suspected:** identify legacy integration component from recorded service banner | `api.solar-de.npg-lab.example` | Accepted identification evidence shows `service=solar-integration-api`, `mode=staging-bridge`, and `version_label=legacy-adapter-2.x`. The diagnostic endpoint was visible, but exploitation was not confirmed. Evidence: `evt-p2-001`; `service_banners.log`. |
| 2026-04-21T10:28:44Z | Exploitation | **Confirmed:** correlate controlled integration API data-exposure proof | `api.solar-de.npg-lab.example` | Accepted proof demonstrates that a read-only synthetic integration dataset was returned. Exposed fields include `site_id`, `asset_class`, `maintenance_window`, `telemetry_gateway_label`, and `business_owner`. This confirms data exposure within the laboratory model, not production compromise. Evidence: `evt-p2-002`; `api-9001`. |
| 2026-04-21T10:28:44Z | Impact | **Confirmed:** document exposure of integration and operational metadata | German solar integration dataset | The returned synthetic dataset contains site identifiers, asset classifications, maintenance windows, telemetry gateway labels, and business ownership information. These fields could assist infrastructure mapping and expose operational context. No evidence establishes access to live operational records or OT commands. Evidence: `api-9001`; `evt-p2-002`. |
| 2026-04-21T10:43:20Z | Impact Validation | **Confirmed:** correlate OT-adjacent routing and gateway metadata | `api.solar-de.npg-lab.example` → `telemetry-gw-solar-de.npg-lab.example` | Accepted telemetry evidence confirms that gateway labels were enumerable through integration metadata. OT pivot potential was validated at the metadata and routing layer only. No OT command path was executed or demonstrated. Evidence: `evt-p2-003`; `tele-9001`. |
| 2026-04-21T10:56:31Z | Reporting Preparation | Record acquisition-integration and governance implications | German solar subsidiary integration scope | Accepted observation documents the relevance of inherited integration exposure to acquisition assurance, IT/OT boundary governance, and the three-year security strategy. Evidence: `evt-p2-004`. |
| 2026-04-21T11:03:58Z | Cleanup | Remove temporary assessment artefact | Nordstrøm lab evidence workspace | Accepted restoration evidence confirms that the temporary note was removed. Evidence: `clean-9001`; `evt-p2-005`. |
| 2026-04-21T11:03:58Z | Cleanup | Revoke temporary synthetic credential | Nordstrøm lab evidence workspace | Accepted restoration evidence confirms revocation of the synthetic token. Evidence: `clean-9001`; `evt-p2-005`. |
| 2026-04-21T11:03:58Z | Cleanup | Close controlled read-only session | Nordstrøm lab evidence workspace | The restoration audit confirms closure of the read-only session. Evidence: `clean-9001`. |
| 2026-04-21T11:03:58Z | Cleanup Verification | **Confirmed:** verify removal and restoration of the laboratory environment | Nordstrøm lab evidence workspace | Accepted verification confirms temporary artefact removal, synthetic token revocation, session closure, and restoration of the lab workspace. No outstanding temporary change is identified in the accepted restoration record. Evidence: `clean-9001`; `evt-p2-005`. |

## Evidence Correlation and Confidence Assessment

### Identification: suspected legacy integration exposure

The service banner recorded at `2026-04-21T10:12:09Z` identifies a staging bridge using the version label `legacy-adapter-2.x`.

This establishes a potentially sensitive legacy integration component but does not independently prove that the component is vulnerable or exploitable.

**Evidence classification:** `identification`  
**Verdict:** `accepted`  
**Conclusion:** Suspected exposure requiring validation, not confirmed exploitation.

### Exploitation: confirmed synthetic dataset exposure

The timeline event `evt-p2-002` and JSONL evidence record `api-9001` share the timestamp `2026-04-21T10:28:44Z` and identify the German integration API as the affected asset.

Both records classify the result as `proof` with an `accepted` verdict.

The evidence confirms exposure of a read-only synthetic integration dataset containing operationally relevant metadata.

**Evidence classification:** `proof`  
**Verdict:** `accepted`  
**Conclusion:** Confirmed synthetic data exposure. The evidence does not establish production access, credential compromise, or write capability.

### Impact: confirmed OT-adjacent metadata exposure

The timeline event `evt-p2-003` and telemetry record `tele-9001` share the timestamp `2026-04-21T10:43:20Z` and identify the integration API-to-telemetry-gateway relationship.

The accepted evidence demonstrates that gateway labels can be enumerated through integration metadata.

This creates a credible concern about exposure of the IT/OT boundary and possible attacker reconnaissance paths.

**Evidence classification:** `proof`  
**Verdict:** `accepted`  
**Conclusion:** OT pivot potential validated at the metadata and routing layer. Actual lateral movement, OT authentication bypass, command execution, and control-system compromise remain unproven.

### Cleanup: verified restoration

The timeline event `evt-p2-005` and restoration record `clean-9001` share the timestamp `2026-04-21T11:03:58Z`.

The accepted restoration evidence confirms:

- Removal of the temporary note and assessment artefacts.
- Revocation of the synthetic token.
- Closure of the read-only session.
- Verification of the restored laboratory workspace.

**Evidence classification:** `verification`  
**Verdict:** `accepted`  
**Conclusion:** Cleanup and laboratory restoration confirmed within the supplied evidence.

## Accepted Phase 2 Proof Markers

Only markers belonging to relevant, accepted Phase 2 proof or verification records were decoded.

| Proof objective | Evidence references | Decoded marker |
|---|---|---|
| German integration API data exposure | `evt-p2-002`; `api-9001` | `flag{npg_phase2_german_api_exposure}` |
| OT-adjacent pivot potential | `evt-p2-003`; `tele-9001` | `flag{npg_phase2_ot_pivot_potential_validated}` |
| Cleanup and restoration verification | `evt-p2-005`; `clean-9001` | `flag{npg_phase2_cleanup_verified}` |

The identification-only banner does not constitute an exploitation proof. Phase 1 markers, unrelated records, rejected observations, and deferred targets are excluded.

## Strategic Impact and Recommended Follow-up

The confirmed findings concern the German solar subsidiary, whose inherited integration environment represents a priority for post-acquisition security assurance.

The exposed synthetic dataset illustrates how integration interfaces may disclose operational metadata, including maintenance windows and telemetry gateway identifiers. Such information could support infrastructure reconnaissance and increase risk at the boundary between corporate IT and operational systems.

The OT-adjacent telemetry evidence strengthens this concern but does not establish successful access to operational control functions.

The three-year security roadmap should therefore prioritise:

1. **German subsidiary integration assurance:** inventory inherited APIs, staging bridges, legacy adapters, identities, and supplier trust relationships.
2. **Integration API access control:** review authentication, authorisation, least-privilege access, data minimisation, and exposure of operational metadata.
3. **IT/OT boundary protection:** restrict and monitor integration-to-telemetry pathways, validate segmentation, and prevent unauthorised command paths.
4. **Acquisition governance:** establish group-wide ownership, evidence standards, remediation accountability, and applicable jurisdiction-specific regulatory assessments.
5. **Targeted retesting:** perform separately authorised verification of remediation without intrusive production OT testing.

These priorities support Nordstrøm's board-level cybersecurity strategy and should be incorporated into the risk-ranked remediation roadmap.

## Final Phase 2 Status

**Identification:** Completed — legacy integration exposure suspected from accepted banner evidence.

**Exploitation:** Confirmed within the synthetic lab — read-only integration dataset exposure.

**Impact:** Confirmed at the metadata and routing layer — operational metadata exposure and OT-adjacent pivot potential.

**OT compromise:** Not demonstrated — no OT command execution, control-system access, or actual lateral movement established.

**Cleanup:** Completed and verified — temporary artefacts removed, synthetic token revoked, read-only session closed, and laboratory restoration confirmed.

**Overall conclusion:** Phase 2 produced defensible evidence of integration data exposure and OT-adjacent security risk while preserving the agreed assessment boundaries. The results support prioritised remediation and board-level risk reporting without equating potential pivot paths with confirmed operational compromise.