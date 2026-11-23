
# Task 1 — DNS & Subdomain Hunt

> Recover hosts and mail records the company would rather you didn't notice.

## Suggested sources

- Certificate-transparency search
- Passive-DNS history

## Findings to record

### 1. Forgotten/staging subdomain

- **Value:** `staging-quote.helix-maritime.example`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/dns-intelligence/certificates` — CT record `ct-1002`, Common Name and SAN; valid from 2025-03-04 to 2025-06-02. Retrieved on 2026-11-23.
- **Justification (1 line):** The CT record identifies a Helix-owned staging subdomain that was disclosed through public certificate records.
- **Cross-reference / alternative ruled out:** The corporate website's HTML source (`http://10.42.126.67/`) contains the comment `TODO(dvries): retire staging-quote node before public DNS cutover`, independently corroborating the hostname.

### 2. Legacy host with an old naming style + expired certificate

- **Value:** `hlx-owa01.helix-maritime.example`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/dns-intelligence/certificates` — CT record `ct-1003`, Common Name; SAN includes `webmail.helix-maritime.example`; valid from 2018-09-10 to 2021-09-10; status `expired`. Retrieved on 2026-11-23.
- **Justification (1 line):** The expired certificate exposes the legacy `hlx-owa01` hostname, whose naming pattern suggests an older internal webmail system.
- **Cross-reference / alternative ruled out:** CT record `ct-1005` also contains an expired mail-related certificate, but `hlx-owa01` more clearly demonstrates the legacy internal naming convention required by this finding.

### 3. Mail server IP (from passive MX + historical records)

- **Value:** `198.51.100.25`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/dns-intelligence/history` — historical MX record `10 mail.helix-maritime.example` (2014-06-01 to 2024-08-08) and historical A record `mail.helix-maritime.example` → `198.51.100.25` (2014-06-01 to 2024-09-30). Retrieved on 2026-11-23.
- **Justification (1 line):** The historical MX record identifies the former mail exchanger, and its corresponding A record establishes the IP address `198.51.100.25`.
- **Cross-reference / alternative ruled out:** MX records for `mx1.zephyrmail.example` and `mx2.zephyrmail.example` appeared in August 2024, indicating a later migration to an external mailbox provider; the historical self-hosted IP must not be presented as the current mail server.

### 4. A mail record that names a third-party service

- **Value:** `v=spf1 include:spf.zephyrmail.example include:spf.marlinmail.example -all`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/dns-intelligence/history` — TXT/SPF record for `helix-maritime.example`, first seen 2024-08-10, last seen 2025-05-28. Retrieved on 2026-11-23.
- **Justification (1 line):** The SPF record explicitly references ZephyrMail and MarlinMail as authorized third-party email-sending services.
- **Cross-reference / alternative ruled out:** Historical MX records independently support ZephyrMail's role as the managed mailbox provider, while the passive DNS annotation identifies MarlinMail as a campaign mail service; the DMARC record does not identify these providers.

## Open questions / things to verify

- Confirm whether `staging-quote.helix-maritime.example` remains active; the CT record alone does not establish current availability, and active probing is prohibited.
- Determine whether `hlx-owa01.helix-maritime.example` was retired after its certificate expired; no current operational status can be inferred from the historical CT record.
- Verify the current mail infrastructure from newer published passive records, without querying target DNS servers.
- Determine whether the historical third-party email services are still authorized, as the available TXT record was last observed on 2025-05-28.
