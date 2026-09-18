# Nexus Financial — Threat Model

## 1. Purpose and Scope

This threat model identifies the main threats to Nexus Financial
based on the provided field notes.

The scope includes people, physical premises, workstations,
network infrastructure, production access, the database,
backups, and logging.

The objective is to prioritize risks during the five-day
security improvement period while maintaining business operations.

## 2. Assets to Protect

- Confidential customer and financial data.
- Integrity and availability of production services.
- Database credentials, SSH private keys, and administrative accounts.
- Employee workstations and server hardware.
- Backups required for recovery.
- Audit logs and evidence of administrative actions.

## 3. STRIDE Categories

| Letter | Category | Security concern |
|---|---|---|
| S | Spoofing | Impersonating a legitimate user or trusted party. |
| T | Tampering | Unauthorized modification of data, software, or equipment. |
| R | Repudiation | Denying an action when reliable evidence is unavailable. |
| I | Information Disclosure | Exposing information to unauthorized parties. |
| D | Denial of Service | Making systems or data unavailable. |
| E | Elevation of Privilege | Gaining privileges beyond the initial level of access. |

## 4. Component Analysis

Each row identifies one top threat and the most likely threat
actor for that scenario. Actors are reasoned estimates, not
confirmed attackers.

| Component / Asset | Observed Weakness | Top Threat | STRIDE | Most Likely Threat Actor |
|---|---|---|---|---|
| Office entrance | No receptionist and a broken visitor check-in system. | An intruder poses as a legitimate visitor and enters the workspace without verification. | S — Spoofing | An opportunistic external intruder posing as a visitor. |
| Server room and hardware | The biometric door is propped open, and an unescorted delivery person reached the rack. | An unauthorized person modifies server equipment or cabling, compromising system integrity. | T — Tampering | A malicious visitor with physical access to the rack. |
| Internal network ports | Several unused switch ports remain active. | An intruder connects an unauthorized device and obtains information from insufficiently protected internal services. | I — Information Disclosure | A malicious visitor with access to an active network port. |
| Whiteboard credentials | Guest Wi-Fi, staging database, and personal credentials are visible in a shared workspace. | An unauthorized person reads or photographs exposed credentials. | I — Information Disclosure | An opportunistic visitor or coworking-space occupant. |
| Employee workstations | Most laptops are left unlocked during breaks. | Another person uses an employee's authenticated session to impersonate that employee. | S — Spoofing | A malicious person present in the shared office. |
| Building access cards | Generic cards are shared, and spare cards are stored unsecured. | An unauthorized person obtains a spare card and enters as an authorized cardholder. | S — Spoofing | An opportunistic person who can access the spare cards. |
| Production SSH access | A shared private key, nexus_master.pem, is pinned in Slack. | An attacker obtains the shared key and authenticates as a trusted production operator. | S — Spoofing | An external attacker who compromises an employee's Slack account. |
| PostgreSQL database | Port 5432 accepts connections from any internet source. | An attacker exploits weak authentication or a database vulnerability to extract confidential records. | I — Information Disclosure | A financially motivated external attacker scanning public services. |
| Backups and recovery | The backup process has not been checked since its maintainer left three months ago. | An attacker destroys or encrypts production data, and unavailable or unusable backups cause a prolonged outage. | D — Denial of Service | A ransomware operator who gains production access. |
| Developer privileges | Developers have unrestricted root access across systems. | An attacker compromises a developer account and uses its excessive privileges to obtain root-level control. | E — Elevation of Privilege | An external attacker targeting developer accounts. |
| Logging and accountability | The lead developer reports that logs are unavailable, and production access uses a shared SSH key. | A malicious user denies performing a harmful action because reliable, individually attributable records are missing. | R — Repudiation | A malicious insider with production access. |
| Administrative panel | The CEO demands a predictable PIN based on his birth year. | An attacker guesses the PIN and impersonates the CEO if this weak authentication is in use. | S — Spoofing | An attacker who knows or discovers the CEO's birth year. |

## 5. Immediate Risk Priorities

The first priorities are to:

1. Restrict public database access while preserving authorized
   application and remote-team connectivity.
2. Replace shared production access with individual access,
   then revoke the exposed SSH key and rotate exposed credentials.
3. Verify backup availability and perform an isolated restore test.
4. Remove unnecessary root privileges and enforce strong
   administrative authentication.
5. Restrict physical access to the office and server rack,
   while resolving the cooling problem.
6. Enable centralized logging and protect collected logs
   from modification or deletion by source systems.

These priorities reflect the potential impact on customer data,
production availability, and the ability to detect and investigate
an incident.

## Assumptions and Limitations

This analysis is based on the provided field notes, not a verified technical audit.
Threat actors and attack scenarios are estimates, not evidence of confirmed incidents.