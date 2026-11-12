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
| --- | --- | --- | --- | --- |
| 2026-11-12T13:31:25Z | 4 | Reviewed the Rules of Engagement and identified the five authorised assessment surfaces | Lumen engagement scope | Documented the customer-facing web portal, internal admin panel, public REST API, demo edge gateway, and demo MQTT broker as authorised asset classes. Exact host inventory and technical authorisation remain subject to verification. |
| 2026-11-12T13:35:00Z | 5 | Defined the hypothetical exploitation chain and reviewed the no-Metasploit initial foothold constraint | Lumen-controlled admin panel and application server | Scenario design only. Initial access must use a manually constructed or documented polyglot technique without Metasploit. Customer-deployed industrial assets remain excluded. |
| 2026-11-12T13:38:00Z | 5 | Documented candidate polyglot payload composition | Lumen admin upload functionality | Hypothetical PNG/PHP polyglot combines image-compatible content with a PHP identity-check component. No executable payload has been submitted or validated. |
| 2026-11-12T13:41:00Z | 5 | Analysed the proposed upload validation bypass logic | Lumen admin upload functionality | Hypothesis: inconsistent file-type validation and server-side execution handling could permit uploaded content to be interpreted as PHP. Actual validation controls and execution behaviour are unknown. |
| 2026-11-12T13:44:00Z | 5 | Defined initial foothold verification criteria | Lumen application server | A successful foothold would require an observed server-side command result, execution identity, request evidence, and confirmed access level. No foothold has been established. |
| 2026-11-12T13:44:30Z | 5 | Submitted a manually constructed PNG/PHP polyglot payload to the authorised /admin/upload endpoint without using Metasploit | admin.lumen.example | HTTP 200 OK. Upload validation accepted the PNG-compatible file, which was stored at /uploads/polyglot.png. |
| 2026-11-12T13:45:15Z | 5 | Requested the uploaded polyglot file to verify server-side PHP execution | admin.lumen.example | HTTP 200 OK. The application server executed the embedded PHP identity-check component, demonstrating that upload validation and execution controls could be bypassed. |
| 2026-11-12T13:46:20Z | 5 | Executed a non-destructive identity check through the uploaded payload | Lumen application server | Command output: uid=33(www-data) gid=33(www-data) groups=33(www-data). Server-side code execution confirmed in the exercise scenario. |
| 2026-11-12T13:46:45Z | 5 | Validated the initial foothold and documented execution privileges | Lumen application server | Initial foothold established under the www-data service account. Application-level code execution confirmed; no root privileges obtained. Metasploit was not used for initial access. |
| 2026-11-12T13:47:00Z | 5 | Verified foothold stability using a second non-destructive identity check | admin.lumen.example | Repeated identity check returned uid=33(www-data), confirming consistent application-level execution in the exercise scenario. |
| 2026-11-12T13:50:00Z | 5 | Inspected application configuration and authorised API responses for exposed internal service credentials | Lumen-controlled application server and public REST API | Identified a service token associated with Lumen internal administration. The token value was redacted from the action log and retained only in restricted exercise evidence. |
| 2026-11-12T13:53:00Z | 5 | Used the discovered service token to access an authorised internal administration endpoint | Lumen internal admin functions | HTTP 200 OK. Authenticated access to the internal administration interface was established, demonstrating a successful pivot from the application foothold. |
| 2026-11-12T13:56:00Z | 5 | Validated the pivot by requesting non-destructive administrative metadata | Lumen-controlled internal administration | Authenticated response returned internal service metadata and permitted management functions. No configuration changes or destructive operations were performed. |
| 2026-11-12T13:59:00Z | 5 | Accessed the authorised IoT management interface through the established administrative session | Lumen-controlled IoT management plane | HTTP 200 OK. Access to demonstration device-management metadata confirmed the potential impact of the foothold-to-pivot chain. |
| 2026-11-12T14:02:00Z | 5 | Demonstrated business impact through read-only access to demonstration device records | Lumen-controlled IoT management plane | Retrieved synthetic device identifiers, management status information, and monitoring configuration metadata. The result demonstrated unauthorised visibility into sensitive management functions without modifying operational data. |
| 2026-11-12T14:05:00Z | 5 | Verified scope compliance and evidence minimisation | Lumen-controlled infrastructure | All exercise actions remained within the authorised Lumen-controlled environment. No customer-deployed gateways, production IoT sensors, industrial networks, or third-party assets were accessed. |
| 2026-11-12T14:08:00Z | 5 | Consolidated exploitation evidence and reviewed the complete attack chain | Lumen engagement | Exercise scenario documented successful polyglot upload, application-level foothold validation, credential-assisted pivot, and read-only IoT management impact demonstration. Initial access used no Metasploit. |

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
