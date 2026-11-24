
# Task 8 — Corporate Social Media Footprint

> Read the brand feed and look closely at the photos.

## Suggested sources

- http://10.42.252.42/social
- http://10.42.252.42/social/gallery

## Findings to record

### 1. Community-manager identity (from signatures/patterns)

- **Value:** Marleen Koster — Community & Communications Manager, Helix Maritime Insurance N.V., Rotterdam, Netherlands.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social/employees/marleen-koster — employee profile, `name`, `headline`, `about`, and `Handles` fields. Supporting evidence: http://10.42.252.42/social — corporate Wavelength posts `post-1`, `post-2`, `post-3`, `post-4`, and `post-5`, dated 2025-05-21 through 2025-06-12.
- **Justification (1 line):** The corporate posts repeatedly carry the signature "M.K.", and Marleen Koster's employee profile explicitly states that she manages the `@helixmaritime` corporate social channels.
- **Cross-reference / alternative ruled out:** The initials alone would not establish an identity, but the employee profile directly confirms Marleen Koster's responsibility for the account, making the attribution stronger than a signature-only inference.

### 2. An upcoming event not yet on the corporate site

- **Value:** Rotterdam Maritime Week 2025 — September 2025; Helix Maritime announced that it would exhibit at the event.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social — Wavelength corporate post `post-2`, published 2025-05-29, by `@helixmaritime`. The post states: "Save the date — we can confirm Helix will exhibit at Rotterdam Maritime Week 2025 this September."
- **Justification (1 line):** The corporate social-media announcement explicitly identifies the event, the September 2025 timeframe, and Helix's planned participation.
- **Cross-reference / alternative ruled out:** The announcement is distinct from general company updates and from the Rotterdam claims-team recognition post; the photographed sprint whiteboard independently references "RMW booth prep — Rotterdam Maritime Week (Sept)." Absence from the corporate website has not been independently verified.

### 3. Information accidentally visible in a corporate photo

- **Value:** Internal application host `hlx-app-03.helix-maritime.example`, identified as the target host for the Tidewater v2 deployment on a photographed platform-team sprint whiteboard.
- **Exact source (URL / file / metadata field):** http://10.42.252.42/social/gallery — gallery image `photo-whiteboard`, associated with the 2025-06-03 corporate post `post-3`. Original image: http://10.42.252.42/images/whiteboard-exposure.svg. Visible whiteboard text: "Deploy Tidewater v2", "target host: hlx-app-03", and "(hlx-app-03.helix-maritime.example)".
- **Justification (1 line):** A publicly shared office photograph exposes a specific internal application hostname and its association with an active software deployment.
- **Cross-reference / alternative ruled out:** The value comes from text embedded in the original SVG image rather than from the social-media caption alone; the same whiteboard also contains other infrastructure details, including `staging-quote.helix-maritime.example` and `hlx-mail01 (198.51.100.25)`, but the Tidewater deployment hostname is the selected finding.

## Open questions / things to verify

- Confirm whether Rotterdam Maritime Week 2025 was absent from the main corporate website at the time of the 2025-05-29 social-media announcement.
- Confirm whether the Tidewater v2 deployment target was intended to be publicly disclosed; the photograph provides evidence of exposure but does not establish the system's accessibility.
- The social posts and photograph are historical sources from May–June 2025. "Upcoming" refers to the event's status when the announcement was published, not its status on the investigation date.
- Evidence reviewed: 2026-11-24.
