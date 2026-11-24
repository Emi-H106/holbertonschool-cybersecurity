# Task 9 — Employee Profiles Cross-Referencing

## Investigation Overview

**Target:** Helix Maritime Insurance N.V.  
**Methodology:** Passive OSINT / Public-source cross-referencing  
**Target website:** `http://10.42.252.42`  
**Scope:** Public employee profiles, developer repositories, career postings, company registry information, activity profiles, and published PDF documents.

All findings are based on publicly accessible information. No authentication bypass, exploitation, or active intrusion was performed.

---

## Finding 1 — Senior IT / Security Lead

**Value:**
- Full name: **Joris Bakker**
- Position: Infrastructure & Security Lead
- Employer: Helix Maritime Insurance N.V.
- Location: Rotterdam, Netherlands
- Corporate email: **Not verified**

**Exact source (URL / file / metadata field):**

- `http://10.42.252.42/social/employees/joris-bakker`
  - `name`: Joris Bakker
  - `headline`: Infrastructure & Security Lead at Helix Maritime
  - `employer`: Helix Maritime Insurance N.V.
  - `location`: Rotterdam, Netherlands

- `http://10.42.252.42/careers/security-engineer`
  - Security Engineer job posting, published 2025-05-06
  - References the company's Infrastructure & Security Lead.

**Justification (1 line):**

The public employee profile explicitly identifies Joris Bakker as Helix Maritime's Infrastructure & Security Lead, and the security engineering job posting independently confirms that this role exists within the company.

**Cross-reference / alternative ruled out:**

A separate profile also named Joris Bakker belongs to a Logistics Coordinator at Batavia Freight BV in Amsterdam. That individual is excluded because the employer, role, and location do not match the target.

Pieter Janssen is identified as Engineering Manager and recruitment contact, not as the Infrastructure & Security Lead.

**Verification status: PARTIAL**

The employee's name and role are confirmed. No verified corporate email address was identified in the inspected public website data, repository metadata, career posting, or six published PDF documents. No email address has been inferred from naming conventions.

---

## Finding 2 — Developer Username and Real Employee Identity

**Value:**

- Public developer username: **`dvries`**
- Real name: **Daan de Vries**
- Position: Senior Software Engineer
- Employer: Helix Maritime Insurance N.V.
- Corporate email: `daan.devries@helix-maritime.example`

**Exact source (URL / file / metadata field):**

- `http://10.42.252.42/social/employees/daan-de-vries`
  - `name`: Daan de Vries
  - `headline`: Senior Software Engineer at Helix Maritime
  - Profile states that he uses `dvries` as his username.

- `http://10.42.252.42/developer`
  - Repository: `helix-corporate-site`
  - Commit: `2291abf`
  - Commit author: `dvries`
  - Commit email: `daan.devries@helix-maritime.example`

**Justification (1 line):**

The public employee profile links Daan de Vries to username `dvries`, while corporate repository commit metadata independently associates that username with his company email address.

**Cross-reference / alternative ruled out:**

The username, employee identity, employer, and commit email are consistent across two sources. The unrelated `helix-dev99` fork owner is not treated as the same employee.

**Verification status: CONFIRMED**

---

## Finding 3 — Direct Phone Number of a Marketing / Customer-Facing Employee

**Value:**

- Employee: **Marleen Koster**
- Position: Community & Communications Manager
- Direct telephone number: **`+31 10 555 0173`**
- Corporate social media handle: `@helixmaritime`

**Exact source (URL / file / metadata field):**

- `http://10.42.252.42/social/employees/marleen-koster`
  - `name`: Marleen Koster
  - `headline`: Community & Communications Manager at Helix Maritime
  - `Direct line`: +31 10 555 0173
  - `Handles`: @helixmaritime (corporate)

- `http://10.42.252.42/documents/marine-summit-sponsorship.pdf`
  - PDF metadata `Author`: Marleen Koster

- `http://10.42.252.42/documents/quarterly-update-q2-2024.pdf`
  - PDF metadata `Author`: Marleen Koster

**Justification (1 line):**

Marleen Koster's public employee profile explicitly publishes her direct telephone number and communications role, while two corporate PDF documents independently identify her as their author.

**Cross-reference / alternative ruled out:**

The number is labelled `Direct line` in her employee profile and is distinct from the general Rotterdam office telephone number `+31 10 555 0190`. The PDF metadata corroborates the employee's involvement in corporate communications but does not independently verify the telephone number.

**Verification status: CONFIRMED**

---

## Finding 4 — GPS-Tagged Activity Profile Revealing Workplace Location

**Value:**

- Activity platform username: **`harbour_runner_92`**
- Profile slug: `harbour-runner-92`
- Display name: `J.B.`
- Workplace location indicated by GPS: Wilhelminakade, Rotterdam, Netherlands
- Account owner's full identity: **Not conclusively verified**

**Exact source (URL / file / metadata field):**

- `http://10.42.252.42/social/employees/activity/harbour-runner-92`
  - `username`: harbour_runner_92
  - `displayName`: J.B.
  - Activity on 2025-06-10:
    - Type: Morning run
    - Distance: 6.4 km
    - Start: Wilhelminakade (office)
    - End: Wilhelminakade (office)
    - Start GPS: 51.905, 4.49
  - Activity on 2025-06-09:
    - Type: Lunch run
    - Distance: 4.1 km
    - Start GPS: 51.9051, 4.4899
  - Activity on 2025-06-06:
    - Type: Morning run
    - Distance: 8.0 km
    - Start GPS: 51.9049, 4.4901

- `http://10.42.252.42/registry`
  - Helix Maritime registered office: Wilhelminakade 909, 3072 AP Rotterdam, Netherlands

**Justification (1 line):**

Multiple GPS-tagged activities originate near Helix Maritime's registered Rotterdam office, with the activity profile explicitly labelling the location as an office.

**Cross-reference / alternative ruled out:**

The activity profile's display name `J.B.` is consistent with the initials of Joris Bakker, who works for Helix Maritime in Rotterdam. However, initials and geographic proximity alone do not prove account ownership.

The other public profile named Joris Bakker belongs to an Amsterdam-based logistics employee and cannot be assumed to own the account.

**Verification status: PARTIAL**

The activity username and repeated GPS location are verified. Attribution of the activity account to Joris Bakker remains unconfirmed.

---

## Investigation Summary

| Finding | Evidence | Status |
|---|---|---|
| 1. Senior IT / Security Lead | Joris Bakker | Partial — corporate email not verified |
| 2. Developer identity | `dvries` — Daan de Vries | Confirmed |
| 3. Direct phone | Marleen Koster — +31 10 555 0173 | Confirmed |
| 4. GPS activity account | `harbour_runner_92` | Partial — account ownership unconfirmed |

## Outstanding Verification

1. Identify a published, verifiable corporate email address for Joris Bakker.
2. Establish a direct public-source link between `harbour_runner_92` and a named Helix employee, if available.
3. Preserve the distinction between directly observed evidence and inferred relationships.

## Conclusion

Public employee profiles, repository commits, corporate PDF metadata, and GPS-tagged activity records reveal different aspects of the organization's personnel and operations.

Cross-referencing these sources confirms the developer's identity and a communications employee's direct phone number. It also identifies the Infrastructure & Security Lead and a GPS activity account associated with the company's office area.

Unverified email addresses and uncertain account ownership have been explicitly marked rather than presented as established facts.