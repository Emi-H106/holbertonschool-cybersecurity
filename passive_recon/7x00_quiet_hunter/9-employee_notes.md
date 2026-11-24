# Employee Profiles Cross-Referencing — OSINT Investigation Notes

**Target:** Helix Maritime Insurance N.V.  
**Target website:** `http://10.42.252.42`  
**Methodology:** Passive OSINT / Public-source cross-referencing  
**Scope:** Public employee profiles, developer repository metadata, career postings, corporate registry information, activity profiles, and published PDF metadata.

All findings are based on publicly accessible information. No authentication bypass, exploitation, or active intrusion was performed.

---

## Executive Summary

This investigation examined publicly available information associated with Helix Maritime Insurance N.V. to identify employee-related information exposures and demonstrate how separate public sources can be correlated.

Four findings were documented:

1. **Senior IT / Security Lead:** Pieter Janssen, Engineering Manager, with corporate email `pieter.janssen@helix-maritime.example`, supported by a professional employee profile, a security recruitment posting, and developer commit metadata.
2. **Developer Identity:** The developer username `dvries` belongs to Daan de Vries, Senior Software Engineer, confirmed through employee profile information and repository commit metadata.
3. **Direct Telephone Exposure:** Marleen Koster, Community & Communications Manager, publicly lists the direct telephone number `+31 10 555 0173`.
4. **GPS-Based Workplace Inference:** The activity-platform account `harbour_runner_92` repeatedly records activities near the company's Rotterdam office, creating a potential workplace-location disclosure.

The investigation distinguishes directly verified information from inferences. In particular, the GPS activity account cannot be conclusively attributed to a specific employee.

---

## Finding 1 — Senior IT / Security Lead

### Value

- **Full name:** Pieter Janssen
- **Role:** Engineering Manager, Technology Team
- **Company:** Helix Maritime Insurance N.V.
- **Corporate email:** `pieter.janssen@helix-maritime.example`
- **Developer username:** `pjanssen`
- **Verification status:** CONFIRMED for name, role, employer, and email as represented in the public sources.

### Sources

**Source 1 — Professional Employee Profile**

`http://10.42.252.42/social/employees/pieter-janssen`

Relevant fields:

- `name`: Pieter Janssen
- `headline`: Engineering Manager at Helix Maritime
- `employer`: Helix Maritime Insurance N.V.
- `Current role`: Engineering Manager
- `location`: Rotterdam, Netherlands

The profile identifies Pieter Janssen as a manager within the company's technology team.

**Source 2 — Security Engineer Recruitment Posting**

`http://10.42.252.42/careers/security-engineer`

Relevant information:

- Position: Security Engineer
- Recruitment contact: Pieter Janssen
- Contact's role: Engineering Manager

The job posting independently associates Pieter Janssen with the company's engineering management and security recruitment process.

**Source 3 — Public Developer Repository Metadata**

`http://10.42.252.42/developer`

Relevant metadata:

- Repository: Tidewater Risk Engine
- Commit hash: `a17be90`
- Commit author: `pjanssen`
- Commit email: `pieter.janssen@helix-maritime.example`
- Commit date: 2025-05-28
- Commit message: `chore: bump JVM toolchain, tidy gradle config`

The commit metadata provides the corporate email address associated with the developer identity `pjanssen`.

### Justification

Pieter Janssen is identified as Engineering Manager at Helix Maritime Insurance N.V. His professional profile establishes his full name, employer, and senior technical management role.

The Security Engineer recruitment posting independently identifies him as Engineering Manager, connecting his position to technical and security-related recruitment.

The developer repository metadata links the username `pjanssen` to the corporate email address `pieter.janssen@helix-maritime.example`.

Together, these public sources establish a consistent attribution between the employee's identity, technical management position, and corporate email.

### Cross-reference and Alternatives Ruled Out

Joris Bakker is separately identified in public professional information as Infrastructure & Security Lead at Helix Maritime. However, the reviewed sources did not provide a verified personal corporate email address for him.

Pieter Janssen was selected because his engineering management role and corporate email are supported by independent public sources.

The corporate email is taken directly from repository metadata rather than inferred from an email naming convention.

### Security Relevance

Combining public professional profiles, recruitment information, and developer metadata can reveal the identities and corporate contact details of technical managers.

This information may facilitate targeted phishing, impersonation, or social-engineering attempts.

**Finding status:** CONFIRMED

---

## Finding 2 — Developer Username and Real Employee Identity

### Value

- **Full name:** Daan de Vries
- **Role:** Senior Software Engineer
- **Company:** Helix Maritime Insurance N.V.
- **Public developer username:** `dvries`
- **Corporate email:** `daan.devries@helix-maritime.example`
- **Verification status:** CONFIRMED

### Sources

**Source 1 — Professional Employee Profile**

`http://10.42.252.42/social/employees/daan-de-vries`

Relevant fields:

- `name`: Daan de Vries
- `headline`: Senior Software Engineer at Helix Maritime
- `employer`: Helix Maritime Insurance N.V.
- `Username`: `dvries`

The employee profile explicitly associates Daan de Vries with the username `dvries`.

**Source 2 — Developer Repository Metadata**

`http://10.42.252.42/developer`

Relevant metadata:

- Repository: `helix-corporate-site`
- Commit hash: `2291abf`
- Commit author: `dvries`
- Commit email: `daan.devries@helix-maritime.example`

### Justification

The professional profile identifies Daan de Vries as a Senior Software Engineer and explicitly associates him with the username `dvries`.

The publicly visible repository commit metadata independently connects `dvries` to the corporate email address `daan.devries@helix-maritime.example`.

The username, employee identity, employer, and email are consistent across the two sources.

### Cross-reference and Alternatives Ruled Out

The separate developer identity `helix-dev99` was not treated as the same person.

No identity attribution was made solely from similarities between usernames.

The employee profile and commit metadata provide direct evidence supporting the attribution to Daan de Vries.

### Security Relevance

Public repository metadata can disclose employee usernames and corporate email addresses, allowing attackers to correlate technical accounts with real-world identities.

This may increase the effectiveness of targeted phishing and developer impersonation.

**Finding status:** CONFIRMED

---

## Finding 3 — Direct Telephone Number of a Customer-Facing Employee

### Value

- **Full name:** Marleen Koster
- **Role:** Community & Communications Manager
- **Company:** Helix Maritime Insurance N.V.
- **Direct telephone number:** `+31 10 555 0173`
- **Corporate social media handle:** `@helixmaritime`
- **Verification status:** CONFIRMED

### Sources

**Source 1 — Professional Employee Profile**

`http://10.42.252.42/social/employees/marleen-koster`

Relevant fields:

- Employee name: Marleen Koster
- Position: Community & Communications Manager
- Telephone field: `Direct line`
- Telephone value: `+31 10 555 0173`

The profile explicitly identifies the telephone number as a direct line rather than a general company switchboard number.

**Source 2 — Published Sponsorship Document**

`http://10.42.252.42/documents/marine-summit-sponsorship.pdf`

Relevant metadata:

- PDF metadata field: `Author`
- Value: Marleen Koster

**Source 3 — Published Quarterly Update**

`http://10.42.252.42/documents/quarterly-update-q2-2024.pdf`

Relevant metadata:

- PDF metadata field: `Author`
- Value: Marleen Koster

### Justification

Marleen Koster's public professional profile directly associates her name and communications role with the telephone number `+31 10 555 0173`.

The PDF author metadata in two separate published corporate documents independently supports her association with Helix Maritime's external communications activities.

The number is explicitly labelled as a direct line in the employee profile.

### Cross-reference and Alternatives Ruled Out

The general Rotterdam office telephone number `+31 10 555 0190` was not treated as Marleen Koster's direct line.

The direct number was selected because it is specifically associated with her employee profile.

The PDF documents corroborate her identity and communications involvement but do not independently verify the direct telephone number.

### Security Relevance

A publicly exposed direct telephone number for a communications employee can provide a contact point for targeted social engineering, impersonation, and unsolicited contact.

**Finding status:** CONFIRMED

---

## Finding 4 — GPS-Tagged Activity Account and Workplace Inference

### Value

- **Activity-platform username:** `harbour_runner_92`
- **Profile slug:** `harbour-runner-92`
- **Displayed initials:** `J.B.`
- **Inferred workplace area:** Wilhelminakade, Rotterdam, Netherlands
- **Associated company:** Helix Maritime Insurance N.V.
- **Identity attribution:** NOT CONFIRMED
- **Workplace-location inference:** SUPPORTED BY MULTIPLE PUBLIC OBSERVATIONS

### Sources

**Source 1 — Public Activity Profile**

`http://10.42.252.42/social/activities/harbour-runner-92`

Relevant information:

- Username: `harbour_runner_92`
- Displayed name: `J.B.`
- GPS-tagged activity records
- Activity dates: 2025-06-06, 2025-06-09, and 2025-06-10
- Repeated starting area: approximately latitude `51.905`, longitude `4.49`
- Location label: `Wilhelminakade (office)`

The activity records repeatedly associate the account with the same Rotterdam office-area location.

**Source 2 — Corporate Registry**

`http://10.42.252.42/registry`

Relevant information:

- Registered company: Helix Maritime Insurance N.V.
- Registered address: Wilhelminakade 909, 3072 AP Rotterdam, Netherlands

### Justification

The activity-platform account `harbour_runner_92` contains multiple GPS-tagged activities with starting points near Wilhelminakade in Rotterdam.

The repeated activity locations and the label `Wilhelminakade (office)` suggest that the location may be associated with the account holder's workplace.

The corporate registry independently places Helix Maritime Insurance N.V. at Wilhelminakade 909, Rotterdam.

The geographic overlap supports an inference that the activity account may be associated with someone working at or near the company's Rotterdam office.

### Cross-reference and Alternatives Ruled Out

The initials `J.B.` could correspond to Joris Bakker, whose public professional profile identifies him as a Helix Maritime employee in Rotterdam.

However, initials and geographic proximity are insufficient to establish account ownership conclusively.

The investigation therefore does not claim that Joris Bakker is the verified owner of `harbour_runner_92`.

Other people working in the same office area could produce similar activity patterns.

The supported conclusion is a potential workplace-location exposure, not a confirmed personal identity.

### Security Relevance

Repeated GPS-tagged activity records can reveal likely workplace locations, commuting patterns, and potentially predictable routines.

When combined with corporate registry records and employee profiles, this information may increase physical-security and personal-privacy risks.

**Finding status:** WORKPLACE INFERENCE SUPPORTED; ACCOUNT OWNER UNCONFIRMED

---

## Investigation Methodology

The investigation followed a passive OSINT methodology based on publicly accessible information.

### 1. Employee Profile Review

Reviewed publicly available professional profiles to identify employee names, positions, employers, usernames, and contact information.

### 2. Developer Metadata Analysis

Examined publicly visible repository metadata, including commit authors, usernames, corporate email addresses, and commit identifiers.

### 3. Recruitment Information Cross-Referencing

Compared employee profiles with publicly advertised career postings to corroborate technical management roles.

### 4. Published Document Metadata Review

Reviewed published corporate PDF metadata to identify document authors and corroborate employee involvement in company communications.

### 5. Corporate Registry Correlation

Compared publicly recorded corporate address information with geographic indicators in activity-platform records.

### 6. Alternative Explanation Assessment

Considered alternative identities, unrelated usernames, general office contact numbers, and geographic coincidence before assigning confidence to findings.

No guessed email addresses or unverified personal identities were presented as confirmed facts.

---

## Consolidated Findings

| Finding | Confirmed or inferred value | Primary evidence | Status |
|---|---|---|---|
| Senior IT / Security Lead | Pieter Janssen — `pieter.janssen@helix-maritime.example` | Employee profile, recruitment posting, developer commit | Confirmed source attribution |
| Developer identity | Daan de Vries — `dvries` | Employee profile and commit metadata | Confirmed |
| Direct telephone exposure | Marleen Koster — `+31 10 555 0173` | Employee profile, corroborating PDF metadata | Confirmed |
| GPS workplace inference | `harbour_runner_92` — Wilhelminakade office area | Activity records and company registry | Workplace inference supported; owner unconfirmed |

---

## Limitations

The investigation relied on publicly accessible information and did not attempt to authenticate against any Helix Maritime systems.

Repository author metadata was treated as public attribution evidence, not cryptographic proof of the author's identity.

The corporate email associated with Pieter Janssen was directly observed in commit metadata. No corporate email was fabricated for Joris Bakker.

The GPS activity records support a geographic workplace inference but do not establish the account holder's legal identity.

Historical information may no longer reflect current organizational structures or contact details.

---

## Conclusion

The investigation identified four employee-related OSINT findings through cross-referencing professional profiles, developer repository metadata, recruitment information, published documents, activity records, and corporate registry data.

The strongest identity correlations were established where independent public sources linked employee names, technical roles, usernames, and corporate contact information.

The direct telephone exposure was supported by an explicitly labelled employee contact field, while the GPS-based finding was appropriately limited to a workplace inference.

The results demonstrate how individually public information can become more sensitive when combined across multiple sources, particularly in the context of targeted social engineering, developer impersonation, and physical-location privacy.