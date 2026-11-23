
# Task 2 — Website Source-Code Archaeology

> What the page source, public scripts and headers disclose.

## Suggested sources

- View-source of /
- Public JS under /assets/
- Response headers (curl -I)
- /humans.txt

## Findings to record

### 1. Internal developer identifier (HTML comment)

- **Value:** `dvries (DEV-2291)`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/` — HTML source comment: `build pipeline maintained by: dvries (developer id DEV-2291)`.
- **Justification (1 line):** A publicly accessible HTML comment reveals the internal username and developer ID of a Helix website maintainer.
- **Cross-reference / alternative ruled out:** `http://10.42.126.67/assets/legacy-app.js`, line 5, confirms `Platform owner: dvries (DEV-2291)`; `http://10.42.126.67/humans.txt` identifies Daan de Vries as `dvries`.

### 2. Non-public API endpoint referenced in a script

- **Value:** `https://api-internal.helix-maritime.example/v2/quote-engine`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/assets/legacy-app.js` — line 15, `LEGACY.quoteEngine` configuration property.
- **Justification (1 line):** A publicly disclosed JavaScript file exposes the full URL of an internal quote-engine API endpoint.
- **Cross-reference / alternative ruled out:** The developer commit message `feat(quote): wire quote-engine client to api-internal v2 endpoint` supports the v2 reference; line 14 contains the older `/v1/quotes` endpoint, explicitly marked as historical.

### 3. Exact content-platform / framework name + version

- **Value:** `Veridian CMS 5.2.1`
- **Exact source (URL / file / metadata field):** `http://10.42.126.67/` — HTML meta tag: `<meta name="generator" content="Veridian CMS 5.2.1" />`.
- **Justification (1 line):** The public HTML generator metadata explicitly identifies the CMS product and its exact version.
- **Cross-reference / alternative ruled out:** The HTTP response header `X-Powered-By: Veridian CMS 5.2.1` and `http://10.42.126.67/humans.txt` (`Content platform: Veridian CMS 5.2.1`) independently confirm the version.

## Open questions / things to verify

- Confirm that all three submitted flags are accepted by the intranet flag-submission interface.
- No requests were made to the discovered internal API; findings were collected through passive source inspection only.
