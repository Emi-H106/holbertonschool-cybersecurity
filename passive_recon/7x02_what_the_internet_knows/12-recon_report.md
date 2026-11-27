
# Competitive Footprinting Report, Synchrohouse Limited

**For:** Synchrohouse CISO and Business Leadership  
**Prepared by:** Vanguard Security — Threat Intelligence Team  
**Assessment date:** 27 November 2026  
**Classification:** Confidential — Internal Use Only  
**Assessment type:** Competitive Footprinting and External Exposure Analysis

---

## 1. Executive Summary

### 1.1 Engagement objective

Synchrohouse Limited operates in the smart-building industry, where the security of building management systems, operational infrastructure, administrative interfaces, and customer information is essential to business continuity and customer confidence.

Vanguard Security conducted an authorised reconnaissance assessment of three competing organisations:

- Cerebra Buildings, Toronto.
- Yume Building Systems, Tokyo.
- Verdant Systems, Milan.

The objective was to compare their observable external exposure, identify their most significant security weaknesses, and provide actionable recommendations for Synchrohouse's security investment and hardening strategy.

The assessment focused on information that could be collected without exploitation, authentication bypass, credential use, or modification of target systems.

### 1.2 Comparative results

A common weighted exposure metric was applied to the findings collected during Tasks 1 through 10.

| Rank | Estate | Exposure score | Primary concern |
|---|---|---:|---|
| 1 | Cerebra | 32 | Industrial control system exposure |
| 2 | Yume | 28 | Historical credential leakage and management interfaces |
| 3 | Verdant | 10 | Internal information disclosure |

Cerebra demonstrated the highest observed external exposure. Its publicly discoverable infrastructure, industrial control service, repository history, personnel information, historical breach records, and elevated IP reputation score create multiple opportunities for further hostile reconnaissance.

Yume presented a less immediately visible external footprint. However, targeted certificate analysis, virtual host discovery, service identification, and repository reconstruction revealed sensitive operational information and a historical API key.

Verdant received the lowest observed exposure score. Its weaknesses were primarily associated with document metadata, software identification, and an externally accessible internal status page.

The lower score does not establish that Verdant is secure, particularly because the assessment techniques were not distributed equally across all three estates.

### 1.3 Most critical asset

The highest-priority individual asset identified by the scoring methodology was:

`cerebra.lab:47808`

The service returned a banner identifying itself as ForgeBuilding Controller 4.8 with a BACnet-Management reference.

This asset was classified as ICS because of its apparent relationship with building automation and industrial control.

If the service provides operational functionality, unauthorised access could potentially affect building operations, service availability, and customer confidence.

However, no control commands were executed, and actual access to building equipment was not established.

### 1.4 Business implications

The assessment demonstrates that external exposure is not limited to conventional software vulnerabilities.

DNS records, certificates, document metadata, repository history, personnel information, and application comments can collectively reveal sensitive information about an organisation.

For Synchrohouse, the principal business risks are:

- Disruption of building management operations.
- Exposure of administrative and operational infrastructure.
- Compromise of application credentials.
- Disclosure of commercially sensitive relationships.
- Increased effectiveness of targeted social engineering.
- Reputational damage and reduced customer confidence.
- Potential contractual and regulatory consequences.

Synchrohouse should prioritise operational technology isolation, credential lifecycle management, external asset governance, and information publication controls.

---

## 2. Per-estate Profile

### 2.1 Cerebra Buildings — Toronto

**Primary domain:** `cerebra.lab`  
**Observed IP address:** `127.22.0.10`  
**Exposure score:** 32  
**Comparative rank:** 1

#### 2.1.1 Exposure surface

Cerebra presented the broadest observable footprint of the three estates.

Its external exposure included DNS infrastructure, public web content, downloadable documents, employee information, service banners, and an accessible Git repository.

The DNS assessment identified the following hostnames:

- `www.cerebra.lab`
- `mail.cerebra.lab`
- `ns1.cerebra.lab`
- `ns2.cerebra.lab`
- `vpn.cerebra.lab`
- `portal.cerebra.lab`
- `bms.cerebra.lab`
- `dev-bms.cerebra.lab`

The discovery of `dev-bms.cerebra.lab` is particularly relevant because its naming suggests a development environment associated with building management systems.

The hostname resolved to the same observed IP address as the primary domain.

The existence of the hostname was confirmed, but the presence of a separate development environment was not established.

#### 2.1.2 Industrial and management service exposure

Targeted TCP service identification revealed several accessible services.

| Port | Observed service or banner |
|---|---|
| 22/TCP | OpenSSH 8.9p1 |
| 25/TCP | Postfix SMTP |
| 80/TCP | nginx 1.18.0 |
| 8080/TCP | ForgeBuilding Dashboard (Grafana 9.1.5) |
| 47808/TCP | ForgeBuilding Controller 4.8 BACnet-Management |

The service on TCP port 47808 was classified as ICS.

Its identification was based on the returned banner and its apparent building automation function.

Although BACnet is commonly associated with UDP port 47808, the relevant service in this assessment was discovered on TCP.

The tested UDP port 47808 was closed. Additional UDP ports 47809 through 47815 were also closed during the assessment.

This distinction is important because conventional port assumptions alone would not have identified the observed controller service.

The dashboard banner on TCP port 8080 also suggests the presence of monitoring or management functionality.

However, the dashboard's actual capabilities, authentication requirements, and relationship with the controller were not established.

The controller represents the most significant individual exposure because of its potential operational impact.

#### 2.1.3 Document metadata exposure

Twelve publicly accessible PDF documents were collected and examined.

The dominant authoring software was ForgeOffice 5.2.

| Authoring software | Document count |
|---|---:|
| ForgeOffice 5.2 | 10 |
| LibreOffice 7.3 | 1 |
| Microsoft Word 2019 | 1 |
| Total | 12 |

ForgeOffice 5.2 appeared in approximately 83.3% of the examined documents.

The Creator and Producer metadata fields supported this observation.

Repeated software identification across multiple documents provides stronger evidence than a single metadata occurrence.

Nevertheless, document metadata does not prove that the software remains installed, that it is used throughout the organisation, or that it contains an exploitable vulnerability.

#### 2.1.4 Repository history exposure

Cerebra's Git repository was accessible through the public web server.

The repository was reconstructed locally, and its commit history was examined.

A historical commit removed a legacy partners page:

- Commit: `976570e`
- Date: 15 April 2024
- Message: Retire legacy partners page ahead of relaunch.

The deleted page contained references to:

- Northwind Integrators.
- Meridian Controls Ltd.
- Atlas Facilities.

The Meridian Controls Ltd reference described a joint BMS programme.

This demonstrates that removing information from the current website does not necessarily remove it from accessible version control history.

The historical relationship was confirmed as repository content. Its current commercial status remains unknown.

From a business perspective, historical repository exposure may reveal relationships, product plans, internal naming conventions, and commercially sensitive information.

#### 2.1.5 Personnel information exposure

The public team page identified:

| Name | Position |
|---|---|
| Marie Dubois | CEO |
| James Kowalski | VP Engineering |
| Aiko Sato | Head of Marketing |
| Daniel Mercer | Facilities Director |

The observed email naming convention was:

`firstname.lastname@cerebra.lab`

Public email addresses, document author metadata, and Git commit author information supported the personnel assessment.

All four employees appeared as authors in the examined document collection.

The naming convention increases the predictability of employee email addresses and may facilitate targeted social engineering.

No emails were sent, and no social engineering activity was performed.

#### 2.1.6 Historical breach and reputation findings

The supplied local breach intelligence corpus contained the following records associated with Cerebra personnel:

| Breach | Year | Associated employee |
|---|---:|---|
| ForumCrack | 2018 | Daniel Mercer |
| LinkScrape | 2019 | James Kowalski |
| MailDump | 2020 | Aiko Sato |
| CloudLeak | 2023 | Marie Dubois |

The most recent recorded breach was CloudLeak 2023.

The supplied reputation dataset also associated Cerebra's observed IP address with a reputation score of 9.

The dataset described scanning and command-and-control callbacks as observed activity.

These findings were confirmed as entries in the supplied simulated intelligence datasets.

The assessment did not independently observe malicious traffic, establish the validity of exposed credentials, or confirm an active compromise.

#### 2.1.7 Apparent security maturity

Cerebra demonstrates strong public visibility and provides substantial information about its products, personnel, and business activities.

Such transparency can support customer confidence and commercial communication.

However, the combination of operational service exposure, accessible repository history, predictable personnel information, and adverse intelligence records suggests weaknesses in external exposure governance.

The apparent weaknesses concern:

- Operational asset isolation.
- Repository publication controls.
- External asset inventory management.
- Information disclosure review.
- Threat intelligence monitoring.

Cerebra's internal security maturity cannot be determined from these findings alone.

---

### 2.2 Yume Building Systems — Tokyo

**Primary domain:** `yume.lab`  
**Observed IP address:** `127.22.0.20`  
**Exposure score:** 28  
**Comparative rank:** 2

#### 2.2.1 Exposure surface

Yume presented a less immediately visible footprint than Cerebra.

Its significant exposures were discovered through certificate analysis, targeted service identification, virtual host enumeration, personnel research, and repository history analysis.

The findings demonstrate that an asset does not need to appear in ordinary website navigation to remain externally discoverable.

#### 2.2.2 Certificate information disclosure

The HTTPS certificate presented by Yume contained the following Subject Alternative Names:

- `yume.lab`
- `www.yume.lab`
- `internal-bms.yume.lab`

Certificate details were:

| Field | Observed value |
|---|---|
| Subject organisation | Yume Building Systems |
| Common Name | yume.lab |
| Issuer organisation | Yume Building Systems |
| Valid from | 1 January 2024 |
| Expiry date | 1 January 2027 |

The certificate subject and issuer were identical, suggesting a self-signed certificate.

Its signature and complete trust chain were not independently validated.

The certificate had not expired at the assessment date.

The inclusion of `internal-bms.yume.lab` revealed an internal-looking hostname that was not visible through ordinary website navigation.

Certificate analysis provided an important lead for subsequent virtual host discovery.

#### 2.2.3 Management service exposure

Targeted service identification revealed:

| Port | Observed service or banner |
|---|---|
| 22/TCP | OpenSSH 8.9p1 |
| 80/TCP | nginx 1.18.0 |
| 443/TCP | HTTPS/nginx 1.18.0 |
| 9000/TCP | YumeOps Console 2.3 |

The service on TCP port 9000 was classified as MGMT.

The classification was based on the console identification in the returned service banner.

The use of a non-standard port may reduce casual visibility but does not provide effective access control.

The actual administrative capabilities and authentication requirements of the service were not tested.

#### 2.2.4 Internal virtual host exposure

Virtual host enumeration identified:

`internal-bms.yume.lab`

A request using the corresponding HTTP Host header returned a page titled:

`Yume Internal BMS Gateway`

The page described itself as a restricted operational interface and disclosed a controller node identifier.

The ordinary website returned a response size of 193 bytes.

The internal virtual host returned a different response of 245 bytes with HTTP status 200.

This confirmed that the server exposed distinct content based on the supplied Host header.

The certificate SAN and the virtual host response provided corroborating evidence for the internal-looking hostname.

The assessment established access to the returned page, not access to actual building management functionality.

#### 2.2.5 Personnel intelligence

The public team page identified:

- Haruto Suzuki — CEO.
- Kenji Tanaka — IT and Infrastructure Lead.
- Mei Lin — Sales Director.

Kenji Tanaka's individual profile confirmed his role and disclosed an internal staff reference.

Git repository history provided an additional source linking Kenji Tanaka to technical activities.

His recorded commits included deployment configuration and environment file management.

The public profile and repository history therefore supported the assessment that Kenji Tanaka was associated with infrastructure responsibilities.

The repository also contained the following email addresses:

- `k.tanaka@yume.lab`
- `m.lin@yume.lab`

These suggest a first-initial and surname naming convention.

The convention was observed in two examples and cannot be assumed to apply to every employee.

Git author information was not independently authenticated.

#### 2.2.6 Historical secret exposure

Yume's publicly accessible Git repository contained a historical deployment environment file named `deploy.env`.

The file was introduced on 18 February 2024 in commit `d98ea81`.

It was removed on 12 March 2024 in commit `1c64986`.

The historical file contained:

- A production environment designation.
- A variable named `YBS_API_KEY`.
- The region identifier `ap-northeast-1`.

The exposed secret was classified as APIKEY.

The complete secret value is retained in `9-flag.txt` and is deliberately not reproduced in this management report.

The removal commit stated:

`Stop tracking environment file; use secret manager`

This indicates an intention to improve secret management.

However, deleting a file from the current repository state does not remove its contents from historical commits.

The key remained recoverable from the reconstructed repository history.

The assessment did not determine whether the key was valid, revoked, rotated, or associated with privileged functionality.

No authentication attempt was made using the recovered value.

#### 2.2.7 Apparent security maturity

Yume appears to have attempted to reduce the visibility of operational infrastructure through virtual host routing and non-standard service ports.

Its repository history also indicates awareness of secret management practices.

These are potentially positive indicators, but they do not establish effective security implementation.

The observed weaknesses include:

- Reliance on limited visibility rather than demonstrated access control.
- Disclosure of internal hostnames through certificates.
- External exposure of management-related services.
- Accessible repository history.
- Historical credential leakage.

Yume illustrates the limitations of security through obscurity.

Its external footprint appears smaller during ordinary browsing, but deeper authorised reconnaissance reveals significant exposure.

---

### 2.3 Verdant Systems — Milan

**Primary domain:** `verdant.lab`  
**Observed IP address:** `127.22.0.30`  
**Exposure score:** 10  
**Comparative rank:** 3

#### 2.3.1 Exposure surface

Verdant's observed exposure was concentrated in public documents and web application content.

Its website provided corporate information, product information, downloadable documents, and contact information.

The assessment identified internal information through document metadata, HTTP headers, HTML source, robots.txt, and JavaScript comments.

#### 2.3.2 Internal document metadata

The document collection included:

- `verdant-brochure.pdf`
- `verdant-bms-template.pdf`
- `verdant-services.docx`

Metadata analysis of the BMS proposal template revealed the following internal folder path:

`C:\Users\m.rossi\Templates\BMS\`

The document identified Marco Rossi as its author and LibreOffice 7.4 as its authoring software.

The folder path suggests a Windows-based document preparation environment and a directory structure associated with BMS templates.

The brochure identified Giulia Bianchi as its author.

These observations demonstrate how published documents can reveal internal usernames, software information, and organisational processes.

The actual existence of the directory at the assessment date was not verified.

The DOCX file could not be fully decoded by ExifTool because the required Archive::Zip dependency was unavailable.

Consequently, the document metadata assessment was incomplete for that file.

#### 2.3.3 Technology stack identification

Verdant's content management system was identified as:

`VerdantCMS/3.4.1`

The identification was supported by multiple indicators:

- HTTP Server header.
- X-Powered-By header.
- HTML generator metadata.
- HTML source comment.
- JavaScript bundle comment.

The consistency of these indicators provides strong evidence for the advertised CMS identity and version.

However, the presence of a version identifier does not establish the existence of an exploitable vulnerability.

No vulnerability exploitation or external vulnerability validation was performed.

#### 2.3.4 Internal portal discovery

The public robots.txt file contained:

- `Disallow: /portal-internal/`
- `Disallow: /tmp/`

The public JavaScript bundle contained a developer comment referencing:

`/portal-internal/status`

The sitemap did not list this endpoint.

A direct request to the identified endpoint returned HTTP status 200 and displayed:

- Verdant Internal Portal — Status.
- Node status: OK.
- A portal build token.

This confirmed that an internal-looking status page was externally accessible within the assessment environment.

The complete token is retained in `7-flag.txt`.

Its purpose, sensitivity, and possible authentication capabilities were not established.

The findings demonstrate that robots.txt directives and unlinked URLs do not constitute access control.

#### 2.3.5 Reputation information

The supplied local reputation dataset associated Verdant's observed IP address with a score of 1.

This was substantially lower than Cerebra's recorded score of 9.

However, a low reputation score does not prove the absence of malicious activity, compromise, or vulnerabilities.

#### 2.3.6 Apparent security maturity

Verdant demonstrated the lowest observed exposure under the assessment methodology.

Its primary weaknesses were related to information publication and web application configuration.

The findings suggest opportunities to improve:

- Document metadata sanitisation.
- Developer comment review.
- Internal endpoint access control.
- Software information disclosure management.

Verdant may provide a useful benchmark for limiting visible external information.

However, the absence of equivalent service scanning prevents a reliable conclusion about its overall operational security maturity.

---

## 3. Comparative Analysis

### 3.1 Common exposure scoring methodology

The comparative exposure metric was implemented in `11-compare.sh`.

The script reads the ten finding files and assigns weighted points according to the type and potential impact of each exposure.

The same category weights are used for all estates.

The metric prioritises findings that could potentially affect operational continuity, privileged access, or sensitive information.

| Exposure category | Weight |
|---|---:|
| ICS service | 10 |
| APIKEY, TOKEN, PASSWORD or PRIVATEKEY exposure | 9 |
| MGMT service | 8 |
| DATA service | 7 |
| AUTH service | 7 |
| Elevated IP reputation score | 7 |
| IOT service | 6 |
| Internal BMS virtual host | 6 |
| Historical Git information disclosure | 5 |
| Internal portal exposure | 5 |
| Historical breach finding | 4 |
| CONFIG exposure | 4 |
| Certificate hostname disclosure | 3 |
| Internal document folder path | 3 |
| DNS information disclosure | 2 |
| Software or CMS identification | 2 |
| Personnel information exposure | 2 |

An IP reputation score of 7 or greater receives seven exposure points.

This threshold is an analytical choice made for this engagement, not an independently validated industry threshold.

ICS exposure receives the highest weight because building automation systems may have consequences beyond conventional information security.

Credential exposure receives nine points because a valid secret could provide access to protected services.

Management interfaces receive eight points because they may expose administrative functionality.

Information disclosure findings receive lower individual weights but remain relevant when combined with other evidence.

The scoring model measures observed exposure rather than confirmed exploitability.

It is not a CVSS score, a probability of compromise, or a formal security maturity certification.

### 3.2 Comparative exposure scores

| Finding | Cerebra | Yume | Verdant |
|---|---:|---:|---:|
| DNS exposure | 2 | 0 | 0 |
| Certificate disclosure | 0 | 3 | 0 |
| ICS service | 10 | 0 | 0 |
| MGMT service | 0 | 8 | 0 |
| Internal virtual host | 0 | 6 | 0 |
| Software or CMS identification | 2 | 0 | 2 |
| Internal document path | 0 | 0 | 3 |
| Historical Git disclosure | 5 | 0 | 0 |
| Internal portal | 0 | 0 | 5 |
| Personnel information | 2 | 2 | 0 |
| Historical secret exposure | 0 | 9 | 0 |
| Breach finding | 4 | 0 | 0 |
| Elevated IP reputation | 7 | 0 | 0 |
| **Total** | **32** | **28** | **10** |

Final ranking:

1. Cerebra — 32 points.
2. Yume — 28 points.
3. Verdant — 10 points.

The expected output of the comparison script is:

```text
Cerebra
cerebra.lab:47808
```

A zero in the scoring table indicates that no points were assigned for that category from the supplied findings.

It does not establish that the corresponding exposure is absent.

### 3.3 Differences between the three estates

| Dimension | Cerebra | Yume | Verdant |
|---|---|---|---|
| Dominant exposure | Broad infrastructure visibility | Hidden operational assets | Document and web disclosure |
| Primary concern | ICS controller | Historical API key and management console | Internal status page |
| Repository exposure | Deleted partner information | Historical credential | Not assessed equivalently |
| Operational exposure | ICS-related banner confirmed | Management-related banner confirmed | Not assessed equivalently |
| Personnel exposure | Predictable email convention | Infrastructure lead identified | Document author information |
| Reputation score | 9 | 1 | 1 |
| Exposure ranking | Highest | Second | Lowest |

Cerebra's exposure is characterised by breadth.

An analyst can combine DNS information, operational service banners, employee identities, historical repository content, and supplied threat intelligence to develop a detailed external profile.

Yume's exposure is characterised by depth.

Ordinary browsing reveals relatively limited information, but certificate inspection, Host header routing, and repository reconstruction expose more sensitive assets.

Verdant's exposure is characterised by information publication weaknesses.

Its public documents and application resources reveal internal details even when those details are not intended for ordinary visitors.

The three estates therefore demonstrate different failure modes:

- Cerebra: excessive external visibility.
- Yume: insufficient protection of less visible assets.
- Verdant: inadequate sanitisation and publication controls.

### 3.4 Strengths and weaknesses

#### Cerebra

Observed strengths:

- Accessible customer-facing product information.
- Clear corporate and personnel information.
- Extensive public documentation.

Observed weaknesses:

- Exposed ICS-related service.
- Accessible historical repository information.
- Predictable personnel email addresses.
- Historical breach associations.
- Elevated reputation score in the supplied intelligence corpus.

#### Yume

Observed strengths:

- Evidence of an intended transition to secret management.
- Less immediately visible operational infrastructure.
- Identifiable infrastructure responsibilities.

Observed weaknesses:

- Internal hostname disclosure through TLS certificates.
- Exposed management-related service.
- Externally accessible internal virtual host.
- Historical API key exposure.
- Accessible repository history.

#### Verdant

Observed strengths:

- Lowest observed exposure score.
- Lower reputation score in the supplied dataset.
- Public sitemap focused on ordinary corporate content.

Observed weaknesses:

- Internal document folder disclosure.
- Consistent disclosure of CMS version information.
- Developer comments revealing internal endpoints.
- Externally accessible internal status page.

These strengths are limited observations, not proof that the organisations operate effective security controls.

### 3.5 Most critical individual asset

The highest-priority individual asset is:

`cerebra.lab:47808`

The asset received ten points under the ICS classification.

Its prioritisation is justified by its apparent building automation role and the potential operational consequences associated with industrial control systems.

Yume's historical API key received nine points, and its management service received eight points.

Although the API key could potentially represent a severe risk, its current validity and privileges are unknown.

The Cerebra controller service was directly observed responding during the assessment.

This supports prioritising it for further authorised investigation.

The ranking does not establish that the controller is exploitable or that it can control physical equipment.

### 3.6 Scoring sensitivity and fairness

The four-point difference between Cerebra and Yume is relatively small.

If the elevated reputation contribution were removed from Cerebra's score, its total would decrease from 32 to 25.

Yume would then rank first with 28 points.

This demonstrates that the overall ranking is sensitive to the reliability and weighting of threat intelligence.

The certificate disclosure and virtual host exposure in Yume relate to the same hostname.

They are scored separately because they represent different disclosure mechanisms, although this introduces correlation between findings.

Yume's repository exposure is not awarded an additional five points because its principal historical disclosure is already represented by the nine-point secret exposure category.

Cerebra's dashboard banner is documented but not separately scored because Task 3 supplies one classified sensitive service per assessed estate.

Similarly, the four Cerebra breach records receive one four-point contribution rather than four separate contributions.

These decisions maintain consistency with the input structure of `11-compare.sh`.

The scoring methodology should therefore be treated as a transparent decision-support mechanism rather than an absolute measure of security.

---

## 4. Recommendations for Synchrohouse

### 4.1 Which competitor should Synchrohouse fear?

From an external security benchmarking perspective, Verdant should be treated as the competitor to watch most closely.

Its observed exposure score of 10 is substantially lower than the scores of Cerebra and Yume.

If further equivalent assessment confirms that its operational infrastructure is also well protected, Verdant could potentially offer a stronger security position to customers.

However, this is a conditional assessment.

The current engagement does not establish Verdant's overall security maturity, commercial competitiveness, market share, financial performance, or customer satisfaction.

Cerebra represents the clearest example of operational exposure that Synchrohouse should avoid.

Yume represents the clearest example of sensitive infrastructure and credential exposure remaining discoverable despite limited visibility.

Synchrohouse should therefore distinguish competitive security positioning from the immediate technical risks identified during reconnaissance.

### 4.2 Which competitor should Synchrohouse emulate?

Synchrohouse should selectively emulate useful practices rather than copying any competitor's complete security approach.

Cerebra's customer-facing transparency can support commercial trust.

Synchrohouse should preserve clear product information and useful public documentation while removing unnecessary technical and internal details.

Yume's stated intention to use a secret manager is a practice worth adopting.

Synchrohouse should implement centralised secret management, automated rotation, restricted access, and repository secret scanning.

Verdant's comparatively limited observed footprint provides a useful objective for external exposure reduction.

However, its internal status page and document metadata disclosures should not be reproduced.

The recommended model combines:

- Cerebra's customer-facing transparency.
- Yume's intended secret management approach.
- Verdant's comparatively limited observed exposure.

These practices must be supported by independently verified technical controls.

### 4.3 Priority 1 — Protect ICS and operational technology

**Recommended timeframe:** 0–30 days.

Synchrohouse should identify all building management and operational technology assets accessible from external networks.

Recommended actions:

- Maintain an inventory of ICS, OT, BMS, and management services.
- Remove unnecessary direct external access to operational controllers.
- Separate operational technology from public-facing IT infrastructure.
- Restrict administrative access through approved secure access mechanisms.
- Apply least privilege and strong authentication.
- Monitor connections to operational assets.
- Validate firewall rules and network segmentation.

Operational changes should be coordinated with engineering teams to avoid disrupting building services.

**Suggested owners:** CISO, OT Engineering, Network Security.

**Success criteria:**

- All externally accessible operational assets are inventoried.
- No unauthorised direct external access to ICS controllers remains.
- Approved operational access paths are documented and monitored.

### 4.4 Priority 2 — Strengthen secret management

**Recommended timeframe:** 0–30 days.

Yume's historical API key demonstrates that deleting a file does not eliminate credential exposure.

Recommended actions:

- Store application secrets in an approved secret management platform.
- Revoke and rotate credentials identified in exposed repositories.
- Scan current repositories and historical commits.
- Prevent secrets from being committed through automated checks.
- Restrict access to production credentials.
- Review credential privileges and expiration policies.
- Ensure that deployment processes do not publish Git metadata.

Repository history remediation should follow credential revocation and rotation rather than replace them.

**Suggested owners:** Application Security, DevSecOps, Infrastructure.

**Success criteria:**

- All identified exposed credentials are investigated and remediated.
- Production repositories are covered by secret scanning.
- New deployments retrieve secrets from approved storage.

### 4.5 Priority 3 — Govern the external attack surface

**Recommended timeframe:** 30–60 days.

Synchrohouse should continuously identify and review externally visible assets.

Recommended actions:

- Audit public DNS records.
- Review development and staging hostnames.
- Examine certificate Subject Alternative Names.
- Identify externally accessible management services.
- Review virtual host configurations.
- Remove obsolete DNS records and unused services.
- Ensure that internal applications enforce authentication and authorisation.
- Maintain an approved external asset inventory.

Non-standard ports, hidden hostnames, and unlinked URLs must not be treated as security controls.

**Suggested owners:** Network Security, Infrastructure, Security Operations.

**Success criteria:**

- Every approved external asset has an assigned owner.
- Unnecessary external services are removed.
- Internal interfaces are protected by verified access controls.

### 4.6 Priority 4 — Prevent information disclosure

**Recommended timeframe:** 30–60 days.

Synchrohouse should introduce publication controls covering corporate documents, websites, and application resources.

Recommended actions:

- Remove unnecessary document metadata before publication.
- Review documents for internal usernames and folder paths.
- Prevent public access to Git repository directories.
- Review JavaScript and HTML for sensitive developer comments.
- Remove unnecessary internal endpoint references.
- Restrict internal status and diagnostic pages.
- Review software version disclosures.
- Publish only necessary employee contact information.

Reducing unnecessary version disclosure should complement, not replace, vulnerability management and patching.

**Suggested owners:** Communications, Application Security, DevSecOps.

**Success criteria:**

- Public documents pass an approved sanitisation process.
- Production web servers do not expose Git metadata.
- Internal status endpoints require appropriate access controls.

### 4.7 Priority 5 — Establish continuous threat intelligence monitoring

**Recommended timeframe:** 60–90 days, followed by continuous monitoring.

Cerebra's breach and reputation records demonstrate the value of correlating external intelligence with asset inventories.

Recommended actions:

- Monitor approved sources for corporate credential exposure.
- Track the reputation of externally accessible IP addresses.
- Correlate intelligence with internal security telemetry.
- Investigate unexpected reputation changes.
- Maintain incident escalation procedures.
- Provide targeted security awareness training.
- Apply multifactor authentication to sensitive accounts.

Intelligence records should be independently validated before declaring an incident or compromise.

**Suggested owners:** SOC, Threat Intelligence, Incident Response.

**Success criteria:**

- External intelligence findings have documented investigation procedures.
- High-priority alerts are assigned to responsible teams.
- Confirmed incidents are escalated according to approved procedures.

### 4.8 Implementation roadmap

| Period | Priority | Expected outcome |
|---|---|---|
| Days 0–30 | ICS isolation and secret management | Reduce the highest-impact operational and credential risks |
| Days 30–60 | External asset governance | Establish visibility and ownership of public assets |
| Days 30–60 | Publication controls | Reduce accidental information disclosure |
| Days 60–90 | Threat intelligence monitoring | Improve detection and investigation of external threats |
| Ongoing | Exposure reassessment | Maintain and measure security improvements |

### 4.9 Recommended management indicators

Synchrohouse should track:

| Indicator | Proposed target |
|---|---|
| Externally accessible assets with assigned owners | 100% |
| Unauthorised externally accessible ICS services | 0 |
| Production repositories covered by secret scanning | 100% |
| Confirmed exposed credentials without remediation | 0 |
| Public documents reviewed before publication | 100% |
| Internal portals without approved access controls | 0 |
| External exposure reassessment | At least monthly |

These are proposed governance targets, not measurements of Synchrohouse's current security posture.

---

## 5. Methodology

### 5.1 Scope and rules of engagement

The assessment was conducted within the authorised laboratory environment.

The approved targets were:

- `cerebra.lab`
- `yume.lab`
- `verdant.lab`

The laboratory DNS resolver was `127.0.0.1`.

The assessment combined passive information analysis with limited active reconnaissance permitted by the engagement.

The following restrictions were respected:

- No exploitation of identified services.
- No authentication bypass.
- No credential testing.
- No SSH access to target systems.
- No modification of target data or configuration.
- No disruptive scanning.
- No unauthorised pivoting.
- No use of real external breach intelligence services.

Targeted port lists, bounded timeouts, limited wordlists, and moderate request rates were used.

Repository reconstruction and document analysis were performed locally after retrieving externally accessible material.

### 5.2 Task 1 — DNS reconnaissance

**Estate:** Cerebra  
**Tools:** dig, Gobuster  
**Evidence file:** `1-flag.txt`

DNS record queries:

```bash
dig @127.0.0.1 cerebra.lab A +short
dig @127.0.0.1 cerebra.lab NS +short
dig @127.0.0.1 cerebra.lab MX +short
dig @127.0.0.1 cerebra.lab TXT +short
```

Observed results included:

- Address: `127.22.0.10`.
- Nameservers: `ns1.cerebra.lab` and `ns2.cerebra.lab`.
- Mail server: `mail.cerebra.lab`.
- SPF and site verification TXT records.

Subdomain enumeration:

```bash
gobuster dns -d cerebra.lab \
-w /usr/share/wordlists/subdomains.txt \
-r 127.0.0.1:53 -t 2 --timeout 2s
```

Follow-up queries:

```bash
dig @127.0.0.1 dev-bms.cerebra.lab A +short
dig @127.0.0.1 dev-bms.cerebra.lab TXT +short
```

**Confirmed finding:** The development-related hostname existed in the laboratory DNS and returned a TXT record containing the task identifier.

**Inference:** The hostname may represent development-related BMS infrastructure.

### 5.3 Task 2 — TLS certificate analysis

**Estate:** Yume  
**Tools:** dig, OpenSSL  
**Evidence file:** `2-flag.txt`

```bash
dig @127.0.0.1 yume.lab A +short

timeout 10s openssl s_client \
-connect yume.lab:443 \
-servername yume.lab \
</dev/null 2>/dev/null |
openssl x509 -noout -subject -issuer -dates \
-ext subjectAltName
```

**Confirmed findings:**

- Address: `127.22.0.20`.
- Internal-looking hostname: `internal-bms.yume.lab`.
- Certificate expiry: 1 January 2027.
- Identical certificate subject and issuer.

**Inference:** The certificate appears to be self-signed and discloses an operationally relevant hostname.

### 5.4 Task 3 — Targeted service identification

**Estates:** Cerebra and Yume  
**Tools:** Nmap, Netcat, curl  
**Evidence file:** `3-flag.txt`

Initial targeted TCP scans:

```bash
nmap -sT -sV -T2 -Pn -n --version-light \
--host-timeout 120s \
-p 21,22,25,80,443,502,1883,2375,3306,4840,5432,6379,8000,8080,8443,8888,9000 \
cerebra.lab
```

```bash
nmap -sT -sV -T2 -Pn -n --version-light \
--host-timeout 120s \
-p 21,22,25,80,443,502,1883,2375,3306,4840,5432,6379,8000,8080,8443,8888,9000 \
yume.lab
```

Dashboard banner verification:

```bash
timeout 5s nc -nv 127.22.0.10 8080
curl -i --max-time 5 http://cerebra.lab:8080/
```

The Netcat connection returned the ForgeBuilding Dashboard banner.

The curl request reported an unsupported HTTP/0.9 response, so normal HTTP application functionality was not established.

Targeted UDP checks:

```bash
nmap --privileged -sU -sV -T2 -Pn -n \
--host-timeout 120s -p 47808 cerebra.lab
```

Additional UDP ports 47809 through 47815 were also checked and reported closed.

Follow-up TCP scan:

```bash
nmap -sT -sV -T2 -Pn -n --version-light \
--host-timeout 120s \
-p 102,2404,1911,1962,2222,4000,44818,47808,20000 \
cerebra.lab
```

**Confirmed findings:**

- Cerebra TCP 47808 returned a ForgeBuilding Controller 4.8 BACnet-Management banner.
- Cerebra TCP 8080 returned a ForgeBuilding Dashboard Grafana 9.1.5 banner.
- Yume TCP 9000 returned a YumeOps Console 2.3 banner.
- The tested Cerebra UDP BACnet port was closed.

**Classification:**

- Cerebra: ICS.
- Yume: MGMT.

The classifications were derived from the observed banners.

Actual protocol functionality and administrative capabilities were not verified.

### 5.5 Task 4 — Virtual host discovery

**Estate:** Yume  
**Tools:** curl, ffuf  
**Evidence file:** `4-flag.txt`

Baseline request:

```bash
curl -i --max-time 5 http://yume.lab/
```

Unknown Host header comparison:

```bash
curl -i --max-time 5 \
-H "Host: nonexistent-check.yume.lab" \
http://yume.lab/
```

Both responses returned HTTP status 200 with a response size of 193 bytes.

Virtual host enumeration:

```bash
ffuf -u http://yume.lab/ \
-w /usr/share/wordlists/vhosts.txt \
-H "Host: FUZZ.yume.lab" \
-mc all -fs 193 -t 2 -rate 5 \
-timeout 5 -maxtime 60
```

Verification:

```bash
curl -i --max-time 5 \
-H "Host: internal-bms.yume.lab" \
http://yume.lab/
```

**Confirmed finding:** The internal virtual host returned HTTP status 200, a distinct response size of 245 bytes, and an internal BMS gateway page.

The certificate SAN from Task 2 corroborated the hostname.

### 5.6 Task 5 — Document metadata analysis

**Estates:** Cerebra and Verdant  
**Tools:** curl, wget, ExifTool  
**Evidence file:** `5-flag.txt`

Cerebra document discovery:

```bash
curl -i --max-time 5 http://cerebra.lab/
curl -i --max-time 5 http://cerebra.lab/documents/
```

The document index listed twelve PDF files.

The collection procedure used bounded downloads of publicly listed documents.

A representative download command was:

```bash
wget -r -l 1 -np -nd -A '*.pdf' \
--timeout=5 --tries=1 --wait=1 \
-P ~/task5/cerebra/ \
http://cerebra.lab/documents/
```

Metadata extraction:

```bash
exiftool -FileName -Creator -CreatorTool -Producer \
~/task5/cerebra/*.pdf
```

Frequency analysis:

```bash
exiftool -s3 -Creator ~/task5/cerebra/*.pdf |
sort | uniq -c | sort -nr
```

```bash
exiftool -s3 -Producer ~/task5/cerebra/*.pdf |
sort | uniq -c | sort -nr
```

**Confirmed finding:** ForgeOffice 5.2 appeared in ten of the twelve examined documents.

Verdant document analysis:

```bash
curl -i --max-time 5 http://verdant.lab/
exiftool -r ~/task5/verdant/
```

**Confirmed finding:** The BMS proposal template contained the internal folder path:

`C:\Users\m.rossi\Templates\BMS\`

The local document collection and ExifTool output confirmed the availability of the examined files.

Complete download transcripts were not retained in the assessment notes.

The DOCX metadata analysis was incomplete because of the missing Archive::Zip dependency.

### 5.7 Task 6 — Repository history reconstruction

**Estate:** Cerebra  
**Tools:** curl, git-dumper, Git  
**Evidence file:** `6-flag.txt`

Repository discovery:

```bash
curl -i --max-time 5 http://cerebra.lab/.git/HEAD
```

Repository reconstruction:

```bash
timeout 120s git-dumper -j 2 -t 5 -r 1 \
http://cerebra.lab/.git/ ~/task6/cerebra
```

Historical analysis:

```bash
cd ~/task6/cerebra
git --no-pager log --all --oneline
git --no-pager log --all -p
```

**Confirmed finding:** Commit `976570e` removed a partners page containing a reference to Meridian Controls Ltd and a joint BMS programme.

The deleted content remained recoverable from Git history.

### 5.8 Task 7 — Web stack and endpoint discovery

**Estate:** Verdant  
**Tool:** curl  
**Evidence file:** `7-flag.txt`

```bash
curl -i --max-time 5 http://verdant.lab/
curl -i --max-time 5 http://verdant.lab/sitemap.xml
curl -i --max-time 5 http://verdant.lab/robots.txt
curl -i --max-time 5 http://verdant.lab/static/app.js
```

Endpoint verification:

```bash
curl -i --max-time 5 \
http://verdant.lab/portal-internal/status
```

**Confirmed findings:**

- CMS identification: VerdantCMS 3.4.1.
- Internal directory reference in robots.txt.
- Internal status endpoint reference in JavaScript.
- HTTP status 200 from the internal status page.
- Disclosure of a portal build token.

Multiple application indicators corroborated the CMS identification.

The token's privileges and intended use remain unknown.

### 5.9 Task 8 — Personnel intelligence

**Estates:** Cerebra and Yume  
**Tools:** curl, ExifTool, git-dumper, Git  
**Evidence file:** `8-flag.txt`

Cerebra personnel research:

```bash
curl -i --max-time 5 http://cerebra.lab/team.html

exiftool -FileName -Author \
~/task5/cerebra/*.pdf
```

The reconstructed Cerebra repository from Task 6 provided additional author information.

**Confirmed finding:** Public employee addresses supported the naming convention:

`firstname.lastname@cerebra.lab`

Yume personnel research:

```bash
curl -i --max-time 5 http://yume.lab/team.html

curl -i --max-time 5 \
http://yume.lab/team/kenji-tanaka.html

curl -i --max-time 5 http://yume.lab/.git/HEAD
```

Repository reconstruction:

```bash
timeout 120s git-dumper -j 2 -t 5 -r 1 \
http://yume.lab/.git/ ~/task8/yume
```

Commit author analysis:

```bash
cd ~/task8/yume
git --no-pager log --all \
--format='%h | %an | %ae | %s'
```

**Confirmed finding:** Kenji Tanaka was identified as IT and Infrastructure Lead on the public website.

Repository commit metadata independently linked the same name to deployment-related activity.

The sources supported the role assessment, although commit author identities were not independently authenticated.

### 5.10 Task 9 — Historical secret analysis

**Estate:** Yume  
**Tool:** Git  
**Evidence file:** `9-flag.txt`

The locally reconstructed repository from Task 8 was reused to avoid unnecessary network requests.

```bash
cd ~/task8/yume
git --no-pager log --all --name-status
git --no-pager log --all -p -- deploy.env
```

**Confirmed findings:**

- A deployment environment file was introduced in commit `d98ea81`.
- The file was removed in commit `1c64986`.
- Historical commits retained a value associated with `YBS_API_KEY`.

**Classification:** APIKEY.

The secret was not used or tested.

Its full value is retained separately in the task evidence file.

### 5.11 Task 10 — Breach and reputation intelligence

**Estates:** Cerebra, Yume and Verdant  
**Tools:** grep, dig  
**Evidence file:** `10-flag.txt`

Only the supplied local intelligence datasets were used.

Breach correlation:

```bash
grep -inF \
-e 'marie.dubois@cerebra.lab' \
-e 'james.kowalski@cerebra.lab' \
-e 'aiko.sato@cerebra.lab' \
-e 'daniel.mercer@cerebra.lab' \
/opt/intel/breaches.txt
```

**Confirmed dataset finding:** The latest matching breach was CloudLeak 2023.

Verdant address verification:

```bash
dig @127.0.0.1 verdant.lab A +short
```

Reputation correlation:

```bash
grep -nF \
-e '127.22.0.10' \
-e '127.22.0.20' \
-e '127.22.0.30' \
/opt/intel/reputation.csv
```

Observed dataset results:

| Estate | IP address | Reputation score |
|---|---|---:|
| Cerebra | 127.22.0.10 | 9 |
| Yume | 127.22.0.20 | 1 |
| Verdant | 127.22.0.30 | 1 |

**Confirmed dataset finding:** Cerebra had the highest recorded reputation score among the three observed addresses.

The dataset described scanning and C2 callbacks.

These activities were not independently observed during the engagement.

### 5.12 Task 11 — Automated comparative scoring

**Tool:** Bash  
**Evidence file:** `11-compare.sh`

The comparison script:

1. Reads `1-flag.txt` through `10-flag.txt`.
2. Checks that the required input files exist and are not empty.
3. Applies weighted exposure categories.
4. Parses the breach name and year.
5. Evaluates the recorded IP reputation score.
6. Calculates a total score for each estate.
7. Sorts estates by exposure score.
8. Selects the maximum score.
9. Tracks the highest-priority individual asset.
10. Prints exactly two output lines.

Reproduction command:

```bash
chmod +x 11-compare.sh
bash -n 11-compare.sh
./11-compare.sh
```

Expected result from the collected findings:

```text
Cerebra
cerebra.lab:47808
```

The asset ports and IP-to-estate mappings are based on observed reconnaissance evidence because the corresponding flag files do not contain all attribution details.

The script aggregates the supplied findings rather than independently rediscovering the assets.

### 5.13 Evidence traceability summary

| Evidence | Estate | Technique | Evidence file |
|---|---|---|---|
| DNS records and development hostname | Cerebra | DNS queries and enumeration | 1-flag.txt |
| Internal hostname and certificate details | Yume | TLS certificate inspection | 2-flag.txt |
| ICS controller and management console | Cerebra, Yume | Targeted service identification | 3-flag.txt |
| Internal BMS gateway | Yume | Virtual host enumeration | 4-flag.txt |
| Authoring software and internal folder path | Cerebra, Verdant | Metadata analysis | 5-flag.txt |
| Historical partner information | Cerebra | Git history reconstruction | 6-flag.txt |
| CMS version and internal portal | Verdant | Web resource analysis | 7-flag.txt |
| Email convention and infrastructure lead | Cerebra, Yume | Personnel intelligence | 8-flag.txt |
| Historical API key | Yume | Git history analysis | 9-flag.txt |
| Breach and reputation records | Cerebra, Yume, Verdant | Local intelligence correlation | 10-flag.txt |
| Comparative ranking | All estates | Weighted Bash aggregation | 11-compare.sh |

---

## 6. Limitations and Uncertainty

### 6.1 Confirmed findings versus inferences

The assessment distinguishes direct observations from analytical interpretations.

| Confirmed observation | Inference or unverified conclusion |
|---|---|
| Cerebra TCP 47808 returned a controller banner | The service can control physical building equipment |
| Cerebra TCP 8080 returned a dashboard banner | The dashboard provides privileged management access |
| Yume TCP 9000 returned a console banner | Administrative functions can be accessed |
| Yume's certificate contained an internal hostname | The hostname provides access to an internal network |
| The internal BMS gateway returned HTTP 200 | Building control functions are accessible |
| An API key appeared in Git history | The key remains valid or privileged |
| A deleted partners page was recoverable | The commercial relationship remains active |
| ForgeOffice 5.2 appeared in document metadata | The software is currently deployed |
| Verdant documents disclosed an internal folder path | The folder currently exists |
| Verdant's internal status page returned HTTP 200 | The build token grants authentication privileges |
| The reputation dataset recorded C2 callbacks | Cerebra is currently compromised |
| Verdant received the lowest exposure score | Verdant has the strongest overall security posture |

Only the observations in the first column were directly supported by the collected evidence.

### 6.2 Unequal assessment coverage

The assessment did not apply every reconnaissance technique equally to every estate.

For example:

- Targeted service identification focused on Cerebra and Yume.
- Detailed certificate analysis focused on Yume.
- Document metadata analysis focused on Cerebra and Verdant.
- Repository history analysis focused on Cerebra and Yume.
- Detailed breach correlation focused on Cerebra personnel.

Consequently, the comparative metric applies identical weights to equivalent findings but does not provide identical discovery coverage.

An unobserved exposure may exist outside the techniques applied to a particular estate.

Verdant's lower score must therefore be interpreted cautiously.

A future assessment should apply equivalent discovery techniques to all three estates under renewed authorisation.

### 6.3 Technical limitations

Footprinting alone cannot establish:

- Whether identified services contain exploitable vulnerabilities.
- Whether authentication and authorisation controls are effective.
- Whether operational controllers can influence physical equipment.
- Whether internal networks are properly segmented.
- Whether recovered credentials remain valid.
- Whether security monitoring detects hostile activity.
- Whether incident response procedures are effective.
- Whether backup and recovery capabilities are sufficient.
- Whether the organisations comply with applicable security requirements.

Service banners and software metadata may be outdated, incomplete, or deliberately configured.

The assessment therefore does not equate software identification with vulnerability confirmation.

### 6.4 Intelligence limitations

The breach and reputation datasets were supplied simulated intelligence sources.

Their entries were confirmed through local queries.

However, the underlying incidents, scoring methodology, data freshness, and collection accuracy were not independently validated.

The recorded reputation score of 9 supports additional investigation but does not prove compromise.

Likewise, a reputation score of 1 does not establish that an estate is free from malicious activity.

The historical breach associations do not prove that employee credentials remain exposed or usable.

### 6.5 Scoring limitations

The exposure metric is a custom weighted model developed for this engagement.

Its principal limitations include:

- Analyst-selected category weights.
- Correlation between some findings.
- Unequal assessment coverage.
- Limited representation of repeated findings.
- Dependence on the supplied intelligence data.
- No direct measurement of exploitation probability.
- No independent assessment of business impact.
- No normalisation by organisation size or asset count.

The model is useful for prioritising observed exposures, but it should not be interpreted as a complete enterprise risk assessment.

The ranking may change if additional evidence becomes available or if the weighting assumptions are modified.

### 6.6 Confidence assessment

| Assessment | Confidence |
|---|---|
| Observed DNS records | High |
| Returned certificate fields | High |
| Observed open ports and service banners | High |
| Returned virtual host and portal content | High |
| Extracted PDF metadata | High |
| Reconstructed Git history content | High |
| Personnel role attribution | High |
| Actual controller functionality | Unknown |
| Current API key validity | Unknown |
| Current commercial partnerships | Unknown |
| Current compromise status | Unknown |
| Overall enterprise security maturity | Limited |

High confidence in an observed artefact does not imply high confidence in every conclusion that could be drawn from it.

### 6.7 Recommended follow-up assessment

Subject to additional authorisation, a future engagement should:

- Apply equivalent reconnaissance coverage to all three estates.
- Validate the ownership and intended exposure of operational assets.
- Review authentication and authorisation controls.
- Confirm network segmentation through approved testing.
- Verify credential revocation through authorised asset owners.
- Correlate reputation findings with trusted security telemetry.
- Complete the missing document metadata analysis.
- Reassess the comparative scores using the expanded evidence.

These activities are proposed follow-up work and were not performed during the current engagement.

### 6.8 Final conclusion

The assessment identified three distinct external exposure patterns.

Cerebra demonstrated broad infrastructure and information exposure.

Yume demonstrated significant sensitive asset and credential exposure despite a less visible external footprint.

Verdant demonstrated document and application information disclosure with the lowest observed comparative score.

Under the defined scoring methodology, Cerebra ranked first with 32 points, followed by Yume with 28 points and Verdant with 10 points.

The highest-priority individual asset was `cerebra.lab:47808` because of its apparent industrial control function and potential operational consequences.

Synchrohouse should use these findings to strengthen its own operational technology protection, credential management, external asset governance, publication controls, and threat intelligence capabilities.

The central lesson is that information visibility must be governed rather than merely reduced.

An asset that is difficult to discover is not necessarily protected, and an exposed service is not necessarily exploitable.

Effective security requires verified access controls, continuous monitoring, and disciplined management of information throughout its lifecycle.

The conclusions in this report are limited to the authorised reconnaissance evidence collected during the engagement.

---

**End of Report**
