# Task 10 — Technology Stack Synthesis

> Conclusions that must be supported by a chain of earlier sources, not a single page.

## Suggested sources

- Task 1 — DNS and passive-DNS history
- Task 2 — Website HTML source, HTTP response headers, and `/humans.txt`
- Task 3 — Published PDF metadata
- Task 4 — Archived corporate website snapshots
- Task 7 — Public job postings

## Findings to record

### 1. Exact content-platform (CMS) name + version

- **Value:** `Veridian CMS 5.2.1`
- **Exact source (URL / file / metadata field):**
  - Task 2 — `http://10.42.126.67/` — HTML metadata: `<meta name="generator" content="Veridian CMS 5.2.1" />`.
  - Task 2 — HTTP response header: `X-Powered-By: Veridian CMS 5.2.1`.
  - Task 2 — `http://10.42.126.67/humans.txt` — `Content platform: Veridian CMS 5.2.1`.
  - Task 7 — `http://10.42.252.42/careers/crm-administrator` — Requirements identify `Nimbus CRM 9.4 Enterprise Edition` as the corporate CRM, a separate system from the website CMS.
- **Justification (1 line):** Three independent website indicators consistently identify Veridian CMS 5.2.1 as the content platform, while the job posting confirms that the separately named Nimbus product is a CRM rather than the CMS.
- **Cross-reference / alternative ruled out:** `Nimbus CRM 9.4 Enterprise Edition` is used for broker-facing and underwriting workflows, not identified as the website publishing platform. Task 4's archived pages document historical website content but do not establish a different CMS version; no CMS migration or version change can be concluded from those snapshots.

### 2. Corporate email provider

- **Value:** `ZephyrMail`
- **Exact source (URL / file / metadata field):**
  - Task 1 — `http://10.42.126.67/dns-intelligence/history` — MX records `10 mx1.zephyrmail.example` and `20 mx2.zephyrmail.example`, first observed 2024-08-09 and last observed 2025-05-28.
  - Task 1 — TXT/SPF record: `v=spf1 include:spf.zephyrmail.example include:spf.marlinmail.example -all`, first observed 2024-08-10 and last observed 2025-05-28.
  - Task 1 — Historical MX record `10 mail.helix-maritime.example`, last observed 2024-08-08, and corresponding historical A record `198.51.100.25`.
  - Task 3 — `http://10.42.126.67/documents/helix-annual-report-2024.pdf` — `[XMP-dc] Creator` and `[PDF] Contact`: `document.services@helix-maritime.example`.
- **Justification (1 line):** The latest observed MX records point to ZephyrMail, corroborated by the domain's SPF authorization, while the PDF metadata independently confirms use of the corporate email domain without identifying its provider.
- **Cross-reference / alternative ruled out:** The historical `mail.helix-maritime.example` record reflects an earlier self-hosted mail configuration. MarlinMail appears in SPF as an authorized sending service and is described as a campaign mail service, but it is not identified by the MX records as the primary inbound provider. The last observed records date to May 2025, so continued use in November 2026 has not been independently verified.

## Open questions / things to verify

- Verify whether newer public evidence confirms continued use of Veridian CMS 5.2.1.
- Verify whether newer passive-DNS observations confirm that ZephyrMail remains the corporate email provider.
- Confirm acceptance of both exact values through the intranet flag-submission interface.