# Action Log, Lumen Engagement

## Engagement Information

- Client: Lumen Industrial Systems
- Consultancy: Vanguard Security
- Methodology: Penetration Testing Execution Standard (PTES)
- Scope: Lumen-controlled customer-facing web portal, internal administration panel, public REST API, SSH-accessible demonstration edge gateway, and in-house demonstration MQTT broker.
- Exclusions: Customer-deployed edge gateways, IoT sensors, industrial production networks, and all other unauthorised third-party assets.
- Logging Policy: Append-only. All significant actions must be recorded at execution time using UTC timestamps.
- Evidence Policy: Record observed results accurately. Identified vulnerabilities must not be described as confirmed exploits without supporting validation evidence.

## Action Log

| Timestamp (UTC) | Phase | Action | Target | Result |

| 2026-11-12T13:31:25Z | 4 | Reviewed the Rules of Engagement and identified the five authorised assessment surfaces | Lumen engagement scope | Confirmed the documented scope includes the customer-facing web portal, internal admin panel, public REST API, demo edge gateway, and demo MQTT broker. No active enumeration or vulnerability validation performed. |


## Logging Conventions

- Phase 4: Vulnerability Analysis
- Phase 5: Exploitation
- Phase 6: Post-Exploitation
- Record the exact command or action performed.
- Record the actual target and observed result.
- Distinguish suspected vulnerabilities from confirmed exploitation.
- Record stop conditions and escalation events.
- Preserve previous entries when adding new actions.
- Include cleanup actions and verification results.
- Never fabricate timestamps, findings, commands, or evidence.
