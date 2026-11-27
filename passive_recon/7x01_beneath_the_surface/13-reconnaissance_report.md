# Active Reconnaissance Report, Astralis Cloud Services

**Prepared by:** Junior Reconnaissance Specialist, Vanguard Security  
**For:** Marcus Bauer, Lead Red Teamer, Vanguard Security  
**Date:** 2026-11-26  
**Classification:** Confidential — Internal Engagement Use  
**Engagement Phase:** Active Reconnaissance

## 1. Executive summary

This report presents the results of the active reconnaissance engagement conducted against Astralis Cloud Services. The objective was to establish an evidence-based understanding of the exposed infrastructure, identify relevant services and technologies, and provide the Vanguard red team with a structured intelligence package for the subsequent six-week engagement.

Astralis Cloud Services is a European cloud infrastructure provider headquartered in Dublin. Its business context includes cloud service delivery, data sovereignty, regulatory compliance, and a prospective German federal contract. Consequently, administrative infrastructure, customer-facing applications, internal APIs, and cloud storage represent potentially sensitive areas requiring careful assessment.

The reconnaissance was conducted within the authorized laboratory environment using DNS queries, bounded hostname discovery, TCP connect scanning, HTTP requests, TLS certificate inspection, service fingerprinting, and laboratory-hosted attribution and vulnerability APIs.

Twelve reconnaissance objectives were addressed, producing the following principal findings:

- The primary authoritative nameserver is `ns1.astralis-cloud.example`.
- Active DNS enumeration identified `internal-svc.astralis-cloud.example`.
- The laboratory BGP attribution service associated Astralis with `AS64500`.
- TCP port `54321` was discovered on the administrative hostname.
- The customer portal advertises `nginx/1.20.1`.
- The portal TLS certificate exposes the internal-looking hostname `internal-mgmt.astralis-cloud.example`.
- The portal robots.txt file discloses administrative and backend paths.
- The published DMARC policy is `quarantine`.
- WAF fingerprinting and HTTP response headers identify Cloudflare.
- The object storage bucket name `astralis-prod` produced a positive existence signal.
- The status page references an undocumented API endpoint, `/v1/internal-metrics`, which returned HTTP 401.
- The laboratory NVD-compatible API returned `CVE-2021-23017` as the highest-scoring vulnerability candidate, with a reported CVSS v3.1 base score of 9.8.

The most significant outcome is the convergence of independent information sources. DNS enumeration, TLS certificates, robots.txt, status information, and API documentation reveal infrastructure that would not be fully represented by examining the customer portal alone.

These findings establish a preliminary attack surface rather than a list of confirmed exploitable vulnerabilities. No exploitation, credential testing, authentication bypass, or object storage content retrieval was performed.

The next engagement phase should focus on validating service ownership, reconciling the observed infrastructure with the authorized asset inventory, and assessing the security controls protecting administrative and undocumented services. The vulnerability candidate returned by the laboratory API requires independent applicability and patch-status validation before being classified as a confirmed vulnerability.

## 2. Infrastructure cartography

### 2.1 Network topology

The reconnaissance environment consists of a single laboratory container hosting multiple simulated Astralis services. Hostnames resolve to addresses within the loopback range.

The following topology represents observed logical service relationships rather than verified physical infrastructure or network segmentation.

| Host or service | IP address | Observed role |
|---|---|---|
| astralis-cloud.example | 127.20.0.10 | Primary domain |
| www.astralis-cloud.example | 127.20.0.20 | Web hostname |
| portal.astralis-cloud.example | 127.20.0.20 | Customer portal |
| mail.astralis-cloud.example | 127.20.0.20 | Mail hostname |
| vpn.astralis-cloud.example | 127.20.0.20 | VPN-related hostname |
| cdn.astralis-cloud.example | 127.20.0.20 | CDN-related hostname |
| dev.astralis-cloud.example | 127.20.0.20 | Development-related hostname |
| internal-svc.astralis-cloud.example | 127.20.0.20 | Internal-looking service hostname |
| admin.astralis-cloud.example | 127.20.0.30 | Administrative hostname |
| status.astralis-cloud.example | 127.20.0.40 | Service status platform |
| api.astralis-cloud.example | 127.20.0.50 | API platform |
| ns1.astralis-cloud.example | 127.20.0.53 | Primary nameserver |
| internal-mgmt.astralis-cloud.example | Unverified | TLS certificate SAN entry |

The shared address `127.20.0.20` suggests that several hostnames are represented by a common service endpoint in the laboratory. This does not establish that the corresponding production services share a physical server, reverse proxy, or security boundary.

The laboratory BGPView-compatible API returned the following attribution information:

| Attribution field | Observed value |
|---|---|
| Autonomous System Number | AS64500 |
| Organization | Astralis Cloud Services Ltd |
| AS name | ASTRALIS |
| Network prefix | 127.20.0.0/24 |
| Prefix name | ASTRALIS-DUB |
| Country | IE |
| Regional Internet Registry | RIPE NCC |
| Reported PTR record | edge-dub-01.astralis-cloud.example |

The attribution was obtained by resolving the primary domain and querying the laboratory BGPView-compatible API.

Because the returned addresses belong to the loopback range, the attribution represents simulated laboratory intelligence rather than independently verified public BGP routing information.

The ASN and network prefix do not automatically authorize reconnaissance against additional addresses.

#### Supporting laboratory services

| Supporting service | Laboratory address | Purpose |
|---|---|---|
| api.bgpview.io | 127.20.0.60 | Network attribution |
| services.nvd.nist.gov | 127.20.0.70 | Vulnerability intelligence |
| s3.amazonaws.com | 127.20.0.80 | Simulated object storage |

These endpoints support the reconnaissance exercises and must not be interpreted as evidence that the corresponding external providers are hosted inside Astralis production infrastructure.

### 2.2 DNS structure

DNS reconnaissance established the primary nameserver, identified additional hostnames, and collected published mail security information.

The primary nameserver returned by the NS query was:

`ns1.astralis-cloud.example`

The SOA record contained the following information:

| SOA field | Value |
|---|---|
| Primary nameserver | ns1.astralis-cloud.example |
| Responsible mailbox | hostmaster.astralis-cloud.example |
| Serial | 2026011501 |
| Refresh | 3600 |
| Retry | 1800 |
| Expire | 1209600 |
| Minimum TTL | 3600 |

The primary domain also returned an MX record referencing the mail hostname and the following SPF policy:

`v=spf1 include:_spf.astralis-cloud.example -all`

Active hostname discovery was conducted using the laboratory-provided wordlist containing 143 entries.

The enumeration identified the following hostnames:

- www.astralis-cloud.example
- mail.astralis-cloud.example
- ns1.astralis-cloud.example
- vpn.astralis-cloud.example
- portal.astralis-cloud.example
- status.astralis-cloud.example
- api.astralis-cloud.example
- cdn.astralis-cloud.example
- dev.astralis-cloud.example
- internal-svc.astralis-cloud.example

The hostname `internal-svc.astralis-cloud.example` was selected as the hidden-subdomain finding because its naming convention suggests an internal service.

The administrative hostname was subsequently resolved separately.

TLS certificate inspection revealed an additional internal-looking hostname:

`internal-mgmt.astralis-cloud.example`

This hostname was obtained from the certificate Subject Alternative Name extension rather than from successful DNS enumeration. Its current resolution, operational status, and intended accessibility remain unverified.

The DNS results demonstrate the importance of combining independent discovery methods instead of treating a single hostname inventory as complete.

### 2.3 Exposed services

The following services produced observable responses during reconnaissance.

| Target | Port | Observation |
|---|---:|---|
| astralis-cloud.example | TCP 3000 | Open; HTTP 403 response |
| portal.astralis-cloud.example | TCP 443 | HTTPS 200 response |
| admin.astralis-cloud.example | TCP 54321 | Open; service unidentified |
| status.astralis-cloud.example | TCP 443 | HTTPS status information |
| api.astralis-cloud.example | TCP 443 | HTTPS API responses |
| s3.amazonaws.com | TCP 443 | Laboratory object storage response |
| api.bgpview.io | TCP 443 | Laboratory attribution API |
| services.nvd.nist.gov | TCP 443 | Laboratory vulnerability API |

HTTP requests to port 80 on the customer portal and API hostname were refused during testing.

A bounded investigation of TCP port 3000 on the primary domain returned HTTP 403. Service fingerprinting did not establish a reliable product identity.

The administrative hostname exposed TCP port 54321 during a TCP connect scan. The service was reported as unknown by Nmap.

The port number and hostname provide evidence of an exposed interface but do not establish the protocol, administrative functionality, authentication mechanism, or vulnerability status.

No exhaustive service inventory was attempted beyond the defined reconnaissance objectives.

## 3. Service and version inventory

The following inventory consolidates technologies identified through HTTP headers, TLS negotiation, application documentation, DNS information, and service fingerprinting.

| Service | Product or technology | Version | Evidence |
|---|---|---|---|
| Customer portal | nginx | 1.20.1 | HTTP Server header |
| Transport security | TLS | 1.3 | OpenSSL negotiation |
| WAF/CDN | Cloudflare | Unknown | WAFW00F and HTTP headers |
| API service | Astralis API | v1 | API root response |
| Public API | Astralis Cloud Public API | 1.4.0 | OpenAPI document |
| API specification | OpenAPI | 3.0.3 | OpenAPI document |
| Status platform | Astralis Status | Unknown | HTML and JSON responses |
| Administrative service | Unknown | Unknown | Nmap TCP connect scan |
| Primary-domain service | Unidentified HTTP-responsive service | Unknown | HTTP 403 and Nmap fingerprint |
| DNS resolver | BIND, laboratory environment | Unknown | Laboratory resolver configuration |
| Object storage | S3-compatible interface | Unknown | HTTP response |
| Attribution service | BGPView-compatible API | Unknown | JSON response |
| Vulnerability service | NVD-compatible API | 2.0 | JSON response |

### Customer portal fingerprint

The customer portal returned the following relevant HTTP headers:

```text
Server: nginx/1.20.1
X-Content-Type-Options: nosniff
CF-RAY: 7e2b9c4d1a3f8e21-FRA
CF-Cache-Status: DYNAMIC
```

The Server header provides the advertised product and version used for vulnerability intelligence correlation.

The Cloudflare-related headers independently support the WAFW00F identification. However, response headers may be generated, modified, or simulated by intermediary services.

### TLS certificate inventory

The customer portal TLS certificate contained the following observed attributes:

| Attribute | Observed value |
|---|---|
| Common Name | portal.astralis-cloud.example |
| Organization | Astralis Cloud Services |
| Country | IE |
| Issuer | Astralis Internal CA / Astralis Internal Root CA |
| Public key | RSA 2048-bit |
| Signature algorithm | RSA-SHA256 |
| Negotiated protocol | TLS 1.3 |
| Negotiated cipher | TLS_AES_256_GCM_SHA384 |
| Certificate verification | Successful in the laboratory |
| Valid from | 2026-06-19 |
| Valid until | 2036-06-16 |

The certificate contained the following SAN entries:

```text
DNS:portal.astralis-cloud.example
DNS:www.astralis-cloud.example
DNS:internal-mgmt.astralis-cloud.example
```

The internal management hostname is an intelligence finding derived from certificate metadata.

The long certificate validity period and internal certificate authority should be reviewed against the organization's certificate lifecycle policies. Their presence alone does not establish a security vulnerability.

## 4. Identified attack surface

### 4.1 DNS

DNS reconnaissance identified several names that suggest different operational functions, including customer services, development infrastructure, remote access, administration, and internal services.

The most relevant findings are the primary nameserver and the two internal-looking hostnames identified through different discovery methods.

The DNS-discovered hostname `internal-svc.astralis-cloud.example` resolved to the shared laboratory address `127.20.0.20`.

The certificate-derived hostname `internal-mgmt.astralis-cloud.example` has not been independently validated through DNS.

The distinction is important because certificate metadata can contain historical, reserved, or inactive names.

The observed DNS structure provides useful information for asset inventory reconciliation. However, hostname semantics do not prove the existence of separate systems or determine their security classification.

The organization should maintain consistency between its DNS inventory, certificate inventory, and approved exposure policies.

### 4.2 Network

The network attack surface includes the primary domain, customer portal, administrative hostname, status platform, API platform, and authoritative DNS infrastructure.

The administrative hostname returned the most notable network-level observation:

```text
54321/tcp open unknown
```

The successful discovery scan identified one open TCP port within the tested high-port range.

The non-standard port number is not itself a vulnerability. Security depends on the service behind the port, its configuration, authentication requirements, and intended network accessibility.

The primary domain also returned an HTTP 403 response on TCP port 3000. This demonstrates the presence of an HTTP-responsive interface but does not establish its purpose.

The laboratory ASN attribution provides organizational context but does not independently establish additional authorized targets.

The observed network topology should therefore be treated as a preliminary logical inventory requiring confirmation against authoritative asset ownership and exposure records.

### 4.3 Application

The application attack surface includes the customer portal, its published administrative paths, the public API, the status platform, and the technologies identified through HTTP and TLS fingerprinting.

#### Customer portal

The customer portal advertises nginx version 1.20.1.

This version information was used to construct a CPE query for the laboratory NVD-compatible API.

The advertised version is useful for vulnerability intelligence correlation, but it does not establish the installed package build or patch status.

#### Administrative paths

The portal robots.txt file contained the following directives:

```text
User-agent: *
Disallow: /tmp/
Disallow: /cgi-bin/
Disallow: /static/cache/
Disallow: /admin/dashboard
Disallow: /manage/users
Disallow: /backend/jobs
Crawl-delay: 10
Sitemap: https://portal.astralis-cloud.example/sitemap.xml
```

The first administrative-looking path was:

`/admin/dashboard`

The additional paths suggest user-management and backend-processing functions.

The robots.txt file is a crawler guidance mechanism rather than an access control mechanism. Its contents disclose naming information but do not establish whether the listed paths are active, accessible, or vulnerable.

No authentication attempts or access-control bypasses were performed.

#### WAF and CDN identification

WAFW00F identified Cloudflare after two requests.

The result was supported by the `CF-RAY` and `CF-Cache-Status` response headers.

The identification establishes a strong laboratory fingerprint for Cloudflare. It does not demonstrate the effectiveness of the WAF rules, the configuration of the CDN, or the accessibility of any underlying origin infrastructure.

#### Public and undocumented API inventory

The public OpenAPI document identified the following paths:

| Documented API path |
|---|
| /v1/authentication |
| /v1/billing |
| /v1/compute |
| /v1/docs/openapi.json |
| /v1/storage |

The status platform published component health-check references for authentication, billing, compute, storage, and internal metrics.

Comparison of the two sources identified one discrepancy:

`https://api.astralis-cloud.example/v1/internal-metrics`

The endpoint was referenced by the status platform but absent from the public OpenAPI specification.

A bounded HTTP request returned status code 401.

This establishes that the endpoint produced an authentication-related response and satisfies the exercise definition of an accessible endpoint.

It does not establish that authentication can be bypassed or that sensitive metrics are publicly accessible.

The discrepancy is primarily an API inventory and exposure-management finding. Its security significance depends on the intended visibility, ownership, and access controls of the endpoint.

#### Vulnerability intelligence

The laboratory NVD-compatible API returned four CVE records for the CPE associated with the advertised nginx version.

| CVE identifier | Reported CVSS v3.1 | Reported severity |
|---|---:|---|
| CVE-2021-23017 | 9.8 | CRITICAL |
| CVE-2022-41742 | 7.1 | HIGH |
| CVE-2022-41741 | 7.0 | HIGH |
| CVE-2019-20372 | 5.3 | MEDIUM |

The highest-scoring result was CVE-2021-23017, described by the laboratory API as an nginx resolver memory-overwrite issue.

This result is recorded as vulnerability intelligence rather than a confirmed vulnerability.

The advertised version, vendor advisories, actual package build, affected version ranges, configuration prerequisites, and patch history must be reconciled before determining applicability.

In particular, the reported association between CVE-2021-23017 and nginx 1.20.1 requires validation because the upstream version may already contain the relevant fix.

No vulnerability exploitation or proof-of-concept execution was performed.

### 4.4 Mail

The primary domain publishes the following SPF record:

```text
v=spf1 include:_spf.astralis-cloud.example -all
```

The DMARC record returned:

```text
v=DMARC1; p=quarantine; rua=mailto:dmarc@astralis-cloud.example; fo=1
```

The published policy requests quarantine treatment for messages that fail DMARC evaluation.

The SPF record uses a hard-fail qualifier and references an additional SPF policy.

The DMARC aggregate reporting destination is `dmarc@astralis-cloud.example`.

The `fo=1` tag specifies a failure-reporting preference. However, no forensic reporting destination was observed in the returned record.

These records demonstrate that mail authentication policies have been published.

They do not establish the effectiveness of SPF and DKIM alignment, the behavior of receiving mail systems, or the complete configuration of the mail infrastructure.

No spoofed messages, phishing activity, or credential testing was performed.

### 4.5 Cloud

The object storage reconnaissance identified the following bucket name:

`astralis-prod`

The laboratory S3 endpoint resolved to `127.20.0.80`.

A bounded HTTP HEAD request returned status code 200 for the candidate bucket.

The response satisfies the exercise's existence-signal criteria.

The naming convention suggests a possible relationship with production infrastructure, but the actual purpose, ownership, and sensitivity of the bucket remain unverified.

The following activities were deliberately excluded:

- Listing bucket contents.
- Retrieving stored objects.
- Uploading or modifying objects.
- Testing credentials.
- Changing access permissions.

A successful HEAD response does not demonstrate public access to stored data.

The bucket finding should therefore be recorded as an asset identification result rather than a confirmed storage exposure vulnerability.

## 5. Prioritized targets for enumeration

The following priorities are proposed for the next engagement phase based on the observed evidence, potential business relevance, and remaining uncertainty.

These are investigation priorities rather than confirmed vulnerability severity ratings. Any additional testing remains subject to the applicable Rules of Engagement and explicit authorization.

| Priority | Assessment area | Justification |
|---|---|---|
| High | Administrative infrastructure | An open non-standard port was observed, but the service identity and intended exposure remain unknown. |
| High | API inventory and access governance | The status platform references an endpoint absent from the public specification. Ownership and intended visibility require reconciliation. |
| High | Internal asset inventory | DNS and certificate metadata contain internal-looking hostnames whose operational roles are not fully established. |
| High | Customer portal vulnerability management | The advertised version and laboratory vulnerability intelligence require vendor and patch-status validation. |
| Medium | Cloud storage governance | A production-looking bucket name returned a positive existence signal, but ownership and permissions remain unverified. |
| Medium | Mail authentication governance | SPF and DMARC policies are present, but their operational effectiveness has not been established. |
| Medium | Certificate and DNS lifecycle management | Internal names and certificate validity information should be reconciled with approved infrastructure records. |

The administrative infrastructure and undocumented API findings deserve attention because they expose gaps in the current understanding of service ownership and intended accessibility.

The customer portal vulnerability candidate should not be assigned a confirmed critical rating solely because the laboratory API returned a CVSS score of 9.8.

The next phase should begin with scope confirmation, asset-owner consultation, and validation of the observed evidence. Further security testing should proceed only under the authorization established for that phase.

Tomas Lindqvist's lesson is directly relevant to this prioritization. His previous engagement demonstrated the risk of relying exclusively on documented architecture.

In the Astralis engagement, the public OpenAPI document did not include every endpoint referenced by the status platform. Similarly, DNS enumeration and TLS certificate inspection revealed different internal-looking hostnames.

These observations support an evidence-driven approach in which documentation is treated as one source of intelligence rather than a complete representation of the environment.

## 6. Methodology documentation

The following section records the exact one-line commands contained in the twelve scripts provided for the engagement.

The scripts use the Bash interpreter and are designed to produce one flag value through standard output.

The recorded flag values are supported by the reconnaissance observations. Successful execution of every final script revision and acceptance by every checker have not been independently established.

### 6.1 Primary nameserver

**Script:** `1-nameserver.sh`

**Target:** `astralis-cloud.example`

**Objective:** Identify the primary authoritative nameserver.

**Exact one-liner:**

```bash
timeout 10s dig astralis-cloud.example NS +short +time=3 +tries=1 | head -n 1 | sed 's/\.$//'
```

**Flag:**

```text
ns1.astralis-cloud.example
```

**Method:** Query the NS record, select the first result, and remove the trailing DNS root dot.

**Controls:** Ten-second overall timeout, three-second DNS query timeout, and one query attempt.

**Confidence:** High for the observed nameserver. The SOA record independently identified the same hostname as its primary nameserver.

### 6.2 Hidden subdomain

**Script:** `2-hidden_subdomain.sh`

**Target:** `astralis-cloud.example`

**Objective:** Identify an internal-looking hostname through active DNS enumeration.

**Exact one-liner:**

```bash
timeout 60s gobuster -m dns -u astralis-cloud.example -w /usr/share/wordlists/astralis-subdomains.txt -t 2 -q -np 2>/dev/null | awk '/^Found:/ && $2 ~ /(internal|backend|admin)/ {print $2}' | head -n 1
```

**Flag:**

```text
internal-svc.astralis-cloud.example
```

**Method:** Use the laboratory wordlist and filter discovered hostnames for internal-service naming patterns.

**Controls:** Two concurrent threads and a sixty-second overall timeout. The supplied wordlist limits the candidate set.

**Confidence:** High for hostname discovery and DNS resolution. The actual service function remains unknown.

### 6.3 Autonomous system attribution

**Script:** `3-asn.sh`

**Target:** `astralis-cloud.example`

**Supporting API:** `api.bgpview.io`

**Objective:** Obtain the ASN attributed to the resolved Astralis address.

**Exact one-liner:**

```bash
ip=$(dig astralis-cloud.example A +short +time=3 +tries=1 | head -n 1); curl -fsS --max-time 10 "https://api.bgpview.io/ip/$ip" 2>/dev/null | jq -er '.data.prefixes[0].asn.asn | numbers | "AS\(.)"'
```

**Flag:**

```text
AS64500
```

**Method:** Resolve the primary domain, query the laboratory attribution API, and extract the numeric ASN from the returned JSON.

**Controls:** Bounded DNS and HTTPS requests.

**Confidence:** High for the laboratory API result. Public BGP ownership has not been independently established.

### 6.4 Non-standard administrative port

**Script:** `4-admin_port.sh`

**Target:** `admin.astralis-cloud.example`

**Objective:** Identify an open TCP port in the non-standard high-port range.

**Exact one-liner:**

```bash
timeout 1800s nmap -sT -T2 --max-rate 50 --max-retries 1 -p 49152-65535 --open admin.astralis-cloud.example 2>/dev/null | awk '/^[0-9]+\/tcp[[:space:]]+open[[:space:]]/ {split($1,p,"/"); print p[1]}'
```

**Flag identified during reconnaissance:**

```text
54321
```

**Method:** Perform a TCP connect scan and extract the open port number.

**Controls:** Restricted port range, TCP connect scanning, conservative timing configuration, capped probe rate, limited retries, and an overall timeout.

**Execution qualification:** The open port was discovered during an earlier bounded scan using a different timing configuration. The final T2 script was interrupted before successful completion. Its ability to finish within the configured timeout remains unverified.

**Confidence:** High for the previously observed open port. Lower confidence in the reproducibility of the final script within its current timeout.

### 6.5 Customer portal web server version

**Script:** `5-portal_version.sh`

**Target:** `https://portal.astralis-cloud.example`

**Objective:** Identify the advertised web server product and version.

**Exact one-liner:**

```bash
curl -sSI --max-time 10 https://portal.astralis-cloud.example 2>/dev/null | grep -i '^Server:' | awk '{print $2; exit}' | tr -d '\r'
```

**Flag:**

```text
nginx/1.20.1
```

**Method:** Send an HTTP HEAD request and extract the Server header value.

**Controls:** One bounded HTTPS request with a ten-second timeout.

**Confidence:** High for the advertised version. The installed build and patch status remain unverified.

### 6.6 Internal SAN entry

**Script:** `6-san_entry.sh`

**Target:** `portal.astralis-cloud.example:443`

**Objective:** Identify an internal-looking hostname in the live TLS certificate.

**Exact one-liner:**

```bash
timeout 10s openssl s_client -connect portal.astralis-cloud.example:443 -servername portal.astralis-cloud.example </dev/null 2>/dev/null | openssl x509 -noout -ext subjectAltName 2>/dev/null | tr ',' '\n' | sed -n 's/^[[:space:]]*DNS://p' | grep -Ei 'internal|backend|admin|mgmt' | head -n 1
```

**Flag:**

```text
internal-mgmt.astralis-cloud.example
```

**Method:** Establish a TLS connection, extract the SAN extension, normalize its entries, and select an internal-looking DNS name.

**Controls:** Ten-second connection timeout and certificate metadata inspection only.

**Confidence:** High for the certificate entry. DNS resolution and operational status remain unverified.

### 6.7 Administrative path

**Script:** `7-admin_path.sh`

**Target:** `https://portal.astralis-cloud.example/robots.txt`

**Objective:** Identify the first administrative-looking Disallow path.

**Exact one-liner:**

```bash
curl -fsS --max-time 10 https://portal.astralis-cloud.example/robots.txt 2>/dev/null | tr -d '\r' | awk '$1=="Disallow:" && $2 ~ /^\// && tolower($2) ~ /(admin|manage|backend|console)/ {print $2}' | head -n 1
```

**Flag:**

```text
/admin/dashboard
```

**Method:** Retrieve robots.txt and filter Disallow directives for administrative naming patterns.

**Controls:** One bounded HTTPS request. No authentication attempts.

**Confidence:** High for the published path. Actual endpoint availability remains unverified.

### 6.8 DMARC policy

**Script:** `8-dmarc.sh`

**Target:** `_dmarc.astralis-cloud.example`

**Objective:** Extract the published DMARC policy directive.

**Exact one-liner:**

```bash
timeout 10s dig _dmarc.astralis-cloud.example TXT +short +time=3 +tries=1 2>/dev/null | tr -d '"' | tr ';' '\n' | grep -E '^[[:space:]]*p=(none|quarantine|reject)[[:space:]]*$' | awk -F= '{print $2}' | tr -d '[:blank:]' | head -n 1
```

**Flag:**

```text
quarantine
```

**Method:** Retrieve the DMARC TXT record, separate its directives, and extract the policy value.

**Controls:** Ten-second overall timeout, three-second DNS query timeout, and one attempt.

**Confidence:** High for the published policy. Operational enforcement remains unverified.

### 6.9 WAF provider

**Script:** `9-waf.sh`

**Target:** `https://portal.astralis-cloud.example`

**Objective:** Identify the WAF or CDN provider.

**Exact one-liner:**

```bash
waf=$(timeout 30s wafw00f -r https://portal.astralis-cloud.example 2>/dev/null | sed -nE 's/.* is behind ([^(]+) \(.*/\1/p' | head -n 1); if [ -n "$waf" ]; then echo "$waf"; else headers=$(curl -fsSI --max-time 10 https://portal.astralis-cloud.example 2>/dev/null); if echo "$headers" | grep -qiE '^CF-RAY:|^CF-Cache-Status:|^Server:.*cloudflare'; then echo "Cloudflare"; elif echo "$headers" | grep -qiE '^X-Amz-Cf-Id:|^Server:.*CloudFront'; then echo "CloudFront"; elif echo "$headers" | grep -qiE '^X-Served-By:.*cache-|^Server:.*Fastly'; then echo "Fastly"; fi; fi
```

**Flag:**

```text
Cloudflare
```

**Method:** Use WAFW00F as the primary fingerprinting method, with HTTP response-header inspection as a fallback.

**Controls:** Thirty-second primary detection timeout, ten-second fallback timeout, and no redirect following by the primary detection tool.

**Observed evidence:** WAFW00F identified Cloudflare after two requests. Cloudflare-related HTTP headers independently supported the result.

**Confidence:** High for the observed laboratory fingerprint. Actual WAF configuration and defensive effectiveness remain unknown.

### 6.10 Object storage bucket

**Script:** `10-bucket.sh`

**Target:** Laboratory S3-compatible endpoint at `s3.amazonaws.com`

**Objective:** Identify an Astralis-related bucket name without retrieving stored data.

**Exact one-liner:**

```bash
for suffix in prod prod-eu backup backups assets storage data logs public; do bucket="astralis-$suffix"; code=$(curl -sI --resolve s3.amazonaws.com:443:127.20.0.80 --max-time 5 -o /dev/null -w '%{http_code}' "https://s3.amazonaws.com/$bucket"); case "$code" in 2[0-9][0-9]|3[0-9][0-9]|403) echo "$bucket"; exit 0;; esac; sleep 1; done; exit 1
```

**Flag:**

```text
astralis-prod
```

**Method:** Generate a bounded set of candidate names and inspect HTTP response codes using HEAD requests.

**Controls:** Nine candidate names, five-second timeout per request, one-second delay between unsuccessful candidates, and explicit laboratory address resolution.

**Observed evidence:** The first candidate returned HTTP 200.

**Confidence:** High for the exercise-defined positive existence signal. Ownership, permissions, and stored data remain unverified.

### 6.11 Undocumented API endpoint

**Script:** `11-undoc_endpoint.sh`

**Targets:** Astralis public OpenAPI documentation and status platform.

**Objective:** Identify an accessible API endpoint referenced by the status platform but absent from the public specification.

**Exact one-liner:**

```bash
documented=$(curl -fsS --max-time 10 https://api.astralis-cloud.example/v1/docs/openapi.json | jq -er '.paths | keys[]') || exit 1; urls=$(curl -fsS --max-time 10 https://status.astralis-cloud.example/api/v2/summary.json | jq -er '.components[].check') || exit 1; for url in $urls; do case "$url" in https://api.astralis-cloud.example/*) path=${url#https://api.astralis-cloud.example};; *) continue;; esac; if ! grep -Fxq "$path" <<< "$documented"; then code=$(curl -s --max-time 10 -o /dev/null -w '%{http_code}' "$url"); case "$code" in 200|301|302|401|403) echo "$url"; exit 0;; esac; sleep 1; fi; done; exit 1
```

**Flag:**

```text
https://api.astralis-cloud.example/v1/internal-metrics
```

**Method:** Extract documented paths and status-page health-check references, compare the two inventories, and validate the HTTP response of an undocumented candidate.

**Controls:** Ten-second timeout per request, restriction to the authorized API hostname, response-body disposal during candidate validation, and no authentication attempts.

**Observed evidence:** The undocumented endpoint returned HTTP 401.

**Confidence:** High for the documentation discrepancy and observed response. Actual functionality and authorization effectiveness remain unverified.

### 6.12 Critical CVE

**Script:** `12-cve.sh`

**Targets:** Astralis customer portal and laboratory NVD-compatible API.

**Objective:** Identify the highest CVSS v3.1 base score returned for the advertised web server version.

**Exact one-liner:**

```bash
server=$(curl -fsSI --max-time 10 https://portal.astralis-cloud.example 2>/dev/null | awk 'tolower($1)=="server:" {print $2; exit}' | tr -d '\r'); product=${server%/*}; version=${server#*/}; [[ "$server" == */* && -n "$product" && -n "$version" ]] || exit 1; curl -fsS --max-time 15 -G 'https://services.nvd.nist.gov/rest/json/cves/2.0' --data-urlencode "cpeName=cpe:2.3:a:$product:$product:$version:*:*:*:*:*:*:*" 2>/dev/null | jq -er '[.vulnerabilities[].cve | {id: .id, score: (.metrics.cvssMetricV31[]?.cvssData.baseScore)}] | max_by(.score) | .id' | grep -m1 -E '^CVE-[0-9]{4}-[0-9]{4,}$'
```

**Flag:**

```text
CVE-2021-23017
```

**Method:** Retrieve the advertised server version, construct the corresponding CPE query, extract CVSS v3.1 scores, select the maximum score, and validate the output format.

**Controls:** Ten-second portal request timeout, fifteen-second vulnerability API timeout, and intelligence collection without exploitation.

**Observed evidence:** The laboratory API returned four CVE records. The highest reported base score was 9.8.

**Confidence:** High for the laboratory API selection. Actual vulnerability applicability remains unverified.

## 7. Limitations and uncertainty

### 7.1 Laboratory representation

The engagement was conducted in a simulated single-container environment.

The loopback addresses, ASN attribution, external-provider hostnames, and vulnerability intelligence responses represent laboratory data.

They must not be interpreted as independently verified public Internet infrastructure.

The reconnaissance does not establish physical data center topology, production network segmentation, or real-world routing relationships.

### 7.2 Scope and coverage

The investigation was limited to the authorized reconnaissance objectives.

The hostname enumeration used a finite wordlist and therefore cannot establish a complete DNS inventory.

The port scanning activities covered selected ranges and hosts rather than every possible network service.

No comprehensive IPv6, UDP, DNSSEC, CAA, or SRV inventory was completed.

The absence of an observed service must not be interpreted as proof that the service does not exist.

### 7.3 Service identification

An open TCP port establishes that a connection was accepted at the time of observation.

It does not establish the application protocol, service identity, configuration, or vulnerability status.

The administrative service on TCP port 54321 and the HTTP-responsive service on TCP port 3000 remain unidentified.

### 7.4 Script reproducibility

The final script contents have been preserved in this report.

However, the available evidence does not establish successful execution and checker acceptance for every final revision.

The administrative port script is a particular reproducibility limitation. Its conservative timing configuration may require more time than the configured 1800-second timeout permits.

The previously observed port finding remains valid as an observation, but the final script requires further validation.

Some scripts suppress standard error output to preserve the required single-value output format. This can reduce diagnostic visibility when requests fail.

### 7.5 Application and infrastructure metadata

HTTP headers, DNS names, certificate SAN entries, robots.txt directives, and status-page references provide useful intelligence but can contain stale, simulated, or misleading information.

The internal management hostname was not independently validated.

The administrative paths disclosed through robots.txt were not tested for actual accessibility.

The undocumented API returned HTTP 401, but its internal functionality and authorization controls were not assessed.

### 7.6 Vulnerability intelligence uncertainty

The vulnerability intelligence query relied on the advertised nginx version and the laboratory NVD-compatible API.

The API returned CVE-2021-23017 with a reported CVSS v3.1 score of 9.8.

The association between this CVE and nginx 1.20.1 requires reconciliation with authoritative vendor advisories and actual package information.

The laboratory result does not prove that the target is vulnerable.

The CVSS score describes the reported technical severity of a vulnerability candidate rather than the confirmed risk to Astralis.

No exploitability validation was performed.

### 7.7 Cloud and mail security uncertainty

The object storage finding is based on a positive HTTP existence signal.

A negative-control request against a known nonexistent bucket was not recorded. Consequently, the possibility of a generic endpoint response has not been fully excluded.

The bucket's ownership, purpose, permissions, and contents remain unknown.

Similarly, the published SPF and DMARC records do not establish the operational effectiveness of mail authentication.

### 7.8 Rules of Engagement

The reconnaissance activities were designed to remain within the authorized laboratory scope.

The methodology used bounded requests, restricted candidate sets, limited concurrency, TCP connect scanning, and laboratory-hosted intelligence APIs.

No exploitation, authentication attempts, credential brute force, storage content listing, data modification, or data exfiltration was performed.

Additional intrusive testing must not be inferred as authorized by this report.

### 7.9 Analytical conclusion

The reconnaissance established a useful preliminary understanding of Astralis infrastructure and exposed service metadata.

The strongest findings are those supported by multiple independent observations, such as the advertised portal version, Cloudflare fingerprint, and API documentation discrepancy.

The least certain conclusions concern actual vulnerability applicability, internal service functionality, and object storage permissions.

The report should therefore be used as an evidence-based starting point for the next authorized engagement phase rather than as proof of successful compromise.

## Appendix A: Script-to-flag index

| Task | Script | Flag |
|---:|---|---|
| 1 | 1-nameserver.sh | ns1.astralis-cloud.example |
| 2 | 2-hidden_subdomain.sh | internal-svc.astralis-cloud.example |
| 3 | 3-asn.sh | AS64500 |
| 4 | 4-admin_port.sh | 54321 |
| 5 | 5-portal_version.sh | nginx/1.20.1 |
| 6 | 6-san_entry.sh | internal-mgmt.astralis-cloud.example |
| 7 | 7-admin_path.sh | /admin/dashboard |
| 8 | 8-dmarc.sh | quarantine |
| 9 | 9-waf.sh | Cloudflare |
| 10 | 10-bucket.sh | astralis-prod |
| 11 | 11-undoc_endpoint.sh | https://api.astralis-cloud.example/v1/internal-metrics |
| 12 | 12-cve.sh | CVE-2021-23017 |

---

**End of Report**

**Prepared for:** Marcus Bauer, Lead Red Teamer, Vanguard Security

**Classification:** Confidential — Internal Engagement Use
