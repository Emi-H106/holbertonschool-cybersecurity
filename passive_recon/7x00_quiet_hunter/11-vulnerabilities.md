# Vulnerabilities Identified — Helix Maritime Insurance N.V.

## Executive Summary

This assessment identifies seven OSINT-exploitable weaknesses affecting Helix Maritime Insurance N.V. by correlating validated findings from Tasks 1–10 of the passive reconnaissance investigation.

The assessment focuses on how publicly disclosed information may assist an adversary in identifying personnel, mapping internal infrastructure, constructing credible impersonation scenarios, and understanding the organization's technology dependencies.

The findings represent information-exposure weaknesses and potential attack-enabling conditions, not confirmed exploitable software defects or evidence of unauthorized access. Risk ratings reflect the sensitivity of the disclosed information, its corroboration across sources, and the additional conditions an attacker would need to exploit it.

All conclusions are based on passive OSINT evidence. Historical observations, unverified identities, and potentially misleading sources have been distinguished from confirmed findings.

## Vulnerability 1: Correlated Employee Identities and Contact Details Enable Targeted Phishing

**Description:**

Public employee profiles, developer repository metadata, recruitment information, and PDF metadata expose identifiable employees, corporate email addresses, and organizational responsibilities.

Pieter Janssen is identified as an Engineering Manager, and repository commit metadata associates his developer identity with `pieter.janssen@helix-maritime.example`. Daan de Vries is independently associated with the username `dvries` and `daan.devries@helix-maritime.example`. Published document metadata also exposes the functional address `document.services@helix-maritime.example`.

These independently corroborated details could allow an adversary to prepare personalized phishing messages that reference genuine employee roles, development activities, or document workflows.

The concern is strengthened by a historical corporate communiqué reporting targeted phishing in May 2024, which temporarily locked several staff mailboxes. That incident establishes previous exposure to phishing activity but does not demonstrate that the same weaknesses remain exploitable today.

**Source findings:**
- `9-employee_notes.md` — Finding 1: Pieter Janssen's engineering role and verified corporate email.
- `9-employee_notes.md` — Finding 2: Daan de Vries's identity, username, and corporate email.
- `3-pdf_metadata_notes.md` — Finding 1: Internal document-services email address.
- `5-press_notes.md` — Finding 2: Historical targeted phishing incident.

**Risk level: HIGH.**

**Rationale:** Verified technical contacts and corporate addresses enable precise targeting. The previous phishing incident increases the relevance of this exposure, although successful compromise, credential theft, and current control weaknesses have not been established.

**Exploitation potential:** Social engineering — spear-phishing, employee impersonation, and credential-harvesting attempts.

## Vulnerability 2: Public Client-Side Code Discloses an Internal API Endpoint

**Description:**

A publicly accessible JavaScript asset contains a configuration reference to `https://api-internal.helix-maritime.example/v2/quote-engine`.

The same investigation identified an older `/v1/quotes` reference and a developer commit message describing the integration of the v2 quote-engine client. These sources distinguish the newer endpoint reference from historical configuration.

The disclosure reveals an internal-looking service hostname, API version, and business function. An adversary could use this information to understand the application's integration points, prepare targeted technical reconnaissance, or craft convincing messages referring to an apparently legitimate internal service.

The exposed URL does not establish that the endpoint is externally reachable, improperly authenticated, or vulnerable. No request to the internal API was performed.

**Source findings:**
- `2-source_code_notes.md` — Finding 2: JavaScript configuration exposing the internal quote-engine API and historical endpoint reference.
- `2-source_code_notes.md` — Finding 1: Developer identifier corroborated across public source-code artifacts.
- `5-press_notes.md` — Finding 1: Public description of Helix's internal risk-processing platform, providing organizational context without proving that it uses the disclosed API.

**Risk level: MEDIUM.**

**Rationale:** The information reduces uncertainty about internal service naming and application integration. Actual exploitability remains unknown because network reachability, authentication controls, and service configuration were not assessed.

**Exploitation potential:** Technical and internal access — infrastructure mapping, API-focused reconnaissance, and preparation for attacks requiring additional access.

## Vulnerability 3: Staging Infrastructure Is Exposed Through Certificate and Source-Code Records

**Description:**

Certificate-transparency records disclose the hostname `staging-quote.helix-maritime.example`. The public corporate website independently contains a developer comment referring to retirement of the staging-quote node before a public DNS cutover.

The combination is significant because the certificate record establishes that the hostname appeared in a public certificate, while the source-code comment provides context suggesting an internal staging or transitional environment.

This disclosure could help an adversary identify non-production infrastructure associated with Helix's quotation workflow. Staging environments may warrant additional security review because their configuration and lifecycle can differ from production systems.

However, the certificate's validity period ended in June 2025. Neither the certificate record nor the comment proves that the staging host is currently operational, externally accessible, or less securely configured than production.

**Source findings:**
- `1-dns_notes.md` — Finding 1: Certificate-transparency record for `staging-quote.helix-maritime.example`.
- `2-source_code_notes.md` — Finding 1: Public HTML comments exposing internal development identifiers and staging-related context.

**Risk level: MEDIUM.**

**Rationale:** Two separate public artifacts corroborate the staging hostname and its organizational context. The risk is limited by the age of the evidence and the absence of verified operational status or security misconfiguration.

**Exploitation potential:** Technical and internal access — non-production asset discovery, infrastructure mapping, and identification of potentially overlooked systems.

## Vulnerability 4: Corporate Social Media Photography Reveals Internal Deployment Information

**Description:**

A photograph published in the corporate social gallery exposes a sprint-planning whiteboard containing the text `Deploy Tidewater v2`, `target host: hlx-app-03`, and `hlx-app-03.helix-maritime.example`.

A separate executive interview identifies Tidewater Risk Engine as an internal platform supporting underwriting decisions using casualty information, weather-routing feeds, and survey records.

Together, these sources associate an internal-looking hostname with a named business-critical platform and a deployment activity. The disclosure gives an adversary more context than a hostname alone: it reveals a possible relationship between an application, its versioned deployment, and a named target system.

The photograph does not prove that the host is currently active, that Tidewater v2 was successfully deployed, or that the system can be accessed from outside the organization.

**Source findings:**
- `8-social_notes.md` — Finding 3: Whiteboard photograph revealing the hostname and Tidewater v2 deployment text.
- `5-press_notes.md` — Finding 1: Executive confirmation of Tidewater Risk Engine and its underwriting purpose.

**Risk level: MEDIUM.**

**Rationale:** The combined disclosure identifies a potentially sensitive application-to-host relationship involving an important business function. The risk remains conditional because the system's present status and exposure are unverified.

**Exploitation potential:** Technical and internal access — infrastructure mapping, application targeting, and preparation for attacks following an independent foothold.

## Vulnerability 5: Technology Fingerprinting and Cloud-Partner Disclosure Support Targeted Impersonation

**Description:**

The corporate website exposes the precise content-platform identifier `Veridian CMS 5.2.1` through HTML generator metadata, an HTTP response header, and `/humans.txt`.

Separate recruitment materials identify `Nimbus CRM 9.4 Enterprise Edition` as a commercial CRM platform and Kotlin as the primary language used for internal risk-platform backend services. A conference programme identifies Meridian Cloud Systems as Helix's primary cloud partner at the time of publication.

This collection of disclosures provides a recognizable technology profile. An adversary could reference authentic product names, versions, and supplier relationships when impersonating a support provider, recruiter, contractor, or technology partner.

The confirmed weakness is the aggregation of detailed technology and supplier information. It is not evidence that Veridian CMS or Nimbus CRM contains a known exploitable vulnerability. Similarly, the available evidence does not establish that the Kotlin backend runs on Meridian Cloud Systems infrastructure.

**Source findings:**
- `2-source_code_notes.md` — Finding 3: Veridian CMS 5.2.1 identified in website metadata and headers.
- `7-jobs_notes.md` — Finding 1: Nimbus CRM 9.4 Enterprise Edition.
- `7-jobs_notes.md` — Finding 2: Kotlin-based internal backend services.
- `5-press_notes.md` — Finding 3: Meridian Cloud Systems identified as a primary cloud partner.
- `10-stack_notes.md` — Finding 1: Consolidated CMS identification.

**Risk level: MEDIUM.**

**Rationale:** Multiple verified disclosures make technology-specific impersonation and supplier-themed phishing more credible. The absence of confirmed vulnerabilities, compromised vendors, or current integration details prevents a higher technical severity rating.

**Exploitation potential:** Social engineering and supply chain — vendor impersonation, fraudulent support requests, and technology-specific pretext development.

## Vulnerability 6: Public Communications Expose a Direct Contact Channel and a Verifiable Corporate Identity

**Description:**

Marleen Koster is identified as Helix's Community & Communications Manager. Her public employee profile provides the direct telephone number `+31 10 555 0173`, while corporate social posts associate her with management of the organization's public communications channels.

Published PDF author metadata independently corroborates her involvement in corporate communications.

The combination of a named communications role, a direct telephone number, and documented publishing responsibilities creates a credible contact pathway for targeted telephone-based social engineering. An adversary could use authentic corporate information to make an unsolicited inquiry or impersonation attempt appear more legitimate.

The number is explicitly identified as a direct line, not the general office switchboard. Its public availability does not imply that the employee has been compromised or that any telephone-based attack has succeeded.

**Source findings:**
- `9-employee_notes.md` — Finding 3: Marleen Koster's verified direct telephone number and PDF author attribution.
- `8-social_notes.md` — Finding 1: Corroborated responsibility for corporate social media communications.
- `6-registry_notes.md` — Finding 1: Official corporate headquarters information, useful for validating corporate identity rather than establishing a security defect.

**Risk level: MEDIUM.**

**Rationale:** A direct contact route combined with verified responsibilities can support persuasive, role-specific impersonation. The evidence does not demonstrate inadequate call verification procedures or any successful attack.

**Exploitation potential:** Social engineering — voice phishing, caller impersonation, and fraudulent communications requests.

## Vulnerability 7: Public Activity Data Supports Workplace and Routine Inference

**Description:**

The public activity-platform account `harbour_runner_92` contains GPS-tagged activities dated June 6, 9, and 10, 2025, with repeated starting locations near Wilhelminakade in Rotterdam.

The activity records include the label `Wilhelminakade (office)`. An independent corporate registry extract identifies Helix Maritime Insurance N.V.'s registered headquarters as Wilhelminakade 909, Rotterdam.

This geographic correlation supports a possible association between the activity account and the company's office area. Repeated location disclosures may help an adversary infer likely workplace locations or historical routines.

The account displays the initials `J.B.`, but the evidence does not establish the account owner's identity. It would therefore be inappropriate to attribute the account to Joris Bakker or any other named employee.

The activity records are historical and do not establish current movements, working hours, or access arrangements.

**Source findings:**
- `9-employee_notes.md` — Finding 4: GPS-tagged activity account and supported workplace-location inference.
- `6-registry_notes.md` — Finding 1: Registered headquarters address.
- `4-web_archive_notes.md` — Finding 3: Historical Rotterdam office address, distinguished from the later registry address.

**Risk level: LOW.**

**Rationale:** The geographic overlap is supported by independent evidence, but the account owner's identity, employment relationship, and current routine remain unverified. These limitations substantially reduce the confidence and immediate exploitation potential.

**Exploitation potential:** Social engineering and physical-location intelligence — location-based pretext development and historical routine inference.

## Evidence Validation and Decoy Resistance

The assessment applied the following principles to prevent unsupported OSINT observations from being treated as confirmed vulnerabilities:

1. **Identity verification:** Employee names, usernames, roles, and email addresses were correlated across profiles, recruitment information, and repository metadata. No corporate email address was inferred solely from a naming pattern.
2. **Historical accuracy:** Expired certificates, legacy mail infrastructure, former partners, and past event announcements were not represented as confirmed current operational assets or relationships.
3. **Supplier differentiation:** Meridian Cloud Systems was distinguished from Meridian Marine Reinsurance. Historical partners such as Nordstern Re were not assumed to remain active.
4. **Document authenticity:** Third-party material, including the Westport Analytics document, was not attributed to Helix's internal document-production environment.
5. **Location attribution:** The GPS activity account was not assigned to a named employee based on initials or geographic proximity.
6. **Technical restraint:** Public hostnames, API URLs, product versions, and deployment references were treated as information exposures, not proof of exploitable vulnerabilities or successful access.

## Risk Prioritization and Recommendations

The highest-priority issue is the correlation of identifiable technical personnel, corporate contact details, and a documented history of targeted phishing. Helix should review exposure of employee contact information, reinforce phishing-resistant authentication, and maintain role-specific social-engineering awareness.

Medium-priority issues concern internal infrastructure and technology disclosures. Public-facing source files, build metadata, social media images, and developer comments should undergo information-disclosure review before publication. Internal hostnames and deployment details should be removed from public materials where they are not necessary.

Technology and supplier information should be managed with particular attention to impersonation risks. Staff should verify unexpected requests claiming to originate from software vendors, cloud partners, or internal technical teams through established channels.

The location-related finding warrants a privacy-focused response rather than an assumption of confirmed employee exposure. Awareness guidance should explain how public activity profiles can reveal repeated locations, while avoiding attempts to identify the unverified account holder.

## Conclusion

The seven vulnerabilities demonstrate how individually accessible information can acquire greater security significance when correlated across independent OSINT sources.

The strongest findings involve verified employee identities, internal application references, staging infrastructure, deployment disclosures, and technology relationships. Other findings illustrate more conditional social-engineering and privacy risks.

No exploitation, credential compromise, unauthorized access, or currently reachable vulnerable service was established during this passive assessment.

The central security lesson is that OSINT risk depends not merely on the existence of public information, but on the additional attack-enabling context created when reliable findings are combined.