
# Task 8 — Corporate Social Media Footprint

> Read the brand feed and look closely at the photos.

## Suggested sources

- http://10.42.252.42/social
- http://10.42.252.42/social/gallery

## Findings to record

### 1. Community-manager identity (from signatures/patterns)

- **Value:** Marleen Koster — Community & Communications Manager at Helix Maritime Insurance N.V.
- **Platform/Page:** Wavelength corporate social feed and employee profile.
- **Post URL or identifier:** `post-1`, `post-2`, `post-4`, `post-5`; employee profile `marleen-koster`.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social/employees/marleen-koster — employee profile, including the `name`, `headline`, `about`, and `Handles` fields. Supporting source: http://10.42.252.42/social.
- **Evidence:** Corporate posts repeatedly contain the signature "M.K." The employee profile identifies Marleen Koster and states that she runs the corporate communications and `@helixmaritime` social channels.
- **Retrieval date:** 2026-11-24.
- **Justification (1 line):** The repeated "M.K." signatures are consistent with Marleen Koster, whose employee profile explicitly confirms responsibility for the corporate account.
- **Cross-reference / alternative ruled out:** Initials alone are insufficient to identify a person; the employee profile provides independent confirmation of her role.

### 2. An upcoming event not yet on the corporate site

- **Value:** Rotterdam Maritime Week 2025 — September 2025, with Helix Maritime announcing its planned participation.
- **Platform/Page:** Wavelength — Helix Maritime corporate social feed.
- **Post URL or identifier:** `post-2`, published 2025-05-29, by `@helixmaritime`.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social — corporate post `post-2`, `date` and `body` fields.
- **Evidence:** "Save the date — we can confirm Helix will exhibit at Rotterdam Maritime Week 2025 this September. Come and find the team at the Helix stand for a coffee and a chat about hull, cargo and the year ahead. More details soon. — M.K."
- **Retrieval date:** 2026-11-24.
- **Observation:** The social post directly announces Helix Maritime's intention to exhibit at Rotterdam Maritime Week in September 2025.
- **Inference:** None required to establish the event announcement. Whether the event was absent from the corporate website at the time has not been verified.
- **Justification (1 line):** The dated corporate social post explicitly names the event, its planned month, and the company's intended participation.
- **Cross-reference / alternative ruled out:** The finding is based exclusively on the identified corporate social post; no unsupported claim about the corporate website's contents is made.

### 3. Information accidentally visible in a corporate photo

- **Value:** `hlx-app-03.helix-maritime.example` — an internal-looking hostname visible in a photographed sprint-planning whiteboard.
- **Platform/Page:** Wavelength corporate social gallery and original SVG image.
- **Post URL or identifier:** Gallery image `photo-whiteboard`; corporate post `post-3`, dated 2025-06-03.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social/gallery — image `photo-whiteboard`. Original SVG: http://10.42.252.42/images/whiteboard-exposure.svg.
- **Evidence:** Visible whiteboard text includes "Deploy Tidewater v2", "target host: hlx-app-03", and "(hlx-app-03.helix-maritime.example)".
- **Retrieval date:** 2026-11-24.
- **Observation:** The image contains the hostname `hlx-app-03.helix-maritime.example` alongside the text "Deploy Tidewater v2" and "target host: hlx-app-03".
- **Inference:** The hostname may identify a system associated with the Tidewater v2 deployment. The image alone does not establish whether the host exists, is operational, or is accessible.
- **Justification (1 line):** The original SVG visibly exposes a hostname and related project text that are not present in the social post's caption.
- **Cross-reference / alternative ruled out:** The finding is grounded in the image's visible text rather than an assumption about infrastructure configuration; no claim of confirmed host accessibility is made.

## Open questions / things to verify

- Whether Rotterdam Maritime Week 2025 was absent from the corporate website when `post-2` was published on 2025-05-29.
- Whether the hostname visible in `photo-whiteboard` corresponds to an operational internal system.
- Whether the whiteboard information was approved for public disclosure.
- The event was upcoming relative to the May 2025 announcement, not relative to the evidence retrieval date.
- Evidence reviewed: 2026-11-24.
