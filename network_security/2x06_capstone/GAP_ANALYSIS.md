# LogiCorp Gap Analysis Report

## 1. Executive Summary 
LogiCorp's current network has several serious security problems. All devices are on the same network, SSH is open to the Internet, FTP is not encrypted, and there is no active firewall. The main priority is to separate the network, secure remote access, and use a default-deny firewall while keeping important services like FTP for the Finance team. <br>

## 2. Current State Assessment

Based on the documentation provided by LogiCorp, the current state is as follows:

* **Network Architecture**

  * The infrastructure relies on a single Linux Gateway.
  * The internal network uses the `192.168.1.x` subnet.
  * The network is currently a flat network.
  * Office workstations, Finance systems, Guest WiFi devices, and the critical database appear to share the same network segment.
  * This may allow less trusted devices, such as Guest WiFi devices, to communicate directly with sensitive systems.

* **Remote Access**

  * Remote administration is performed through SSH.
  * SSH is exposed to the public Internet.
  * Root login is enabled.

* **Legacy FTP Service**

  * The Finance department uses a legacy FTP service to upload invoices remotely.
  * FTP currently operates without encryption.

* **Firewall**

  * No active firewall is documented on the gateway.
  * There is no default-deny policy controlling network traffic.

* **Redundancy**

  * The infrastructure depends on a single Linux Gateway.
  * This creates a single point of failure.
  * Redundancy improvements are outside the scope of this project.


## 3. Critical Gaps Identified & Risk Matrix

The following table summarizes the main security gaps identified from the provided documentation and their associated risk levels.

| Category                        | Gap                                   | Current State                                                                                                | Target State                                                                                     | Risk                                                                                     | Severity     |
| ------------------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------- | ------------ |
| **Network Architecture**        | **Flat Network**                      | Office, Finance, Guest WiFi, and the database are on the same network segment.                               | Separate the network into security zones such as LAN, Guest, Finance, DMZ, and critical servers. | A compromised device could move laterally across the network and reach critical systems. | **Critical** |
| **Network Architecture**        | **Database Isolation**                | The database appears to share network connectivity with internal and guest devices.                          | Only authorized systems and services should be able to reach the database.                       | Unauthorized or compromised devices could directly attack the database.                  | **Critical** |
| **Access Control**              | **Public SSH Exposure**               | SSH is exposed directly to the Internet.                                                                     | SSH should only be accessible to authorized personnel through a secure VPN.                      | The SSH service is exposed to attacks from the Internet.                                 | **Critical** |
| **Access Control**              | **Root SSH Login**                    | Remote root login is enabled.                                                                                | Direct root login should be disabled. Administrators should use individual accounts.             | Compromised root credentials could give an attacker full control of the gateway.         | **Critical** |
| **Access Control**              | **No Default-Deny Policy**            | No active firewall is documented.                                                                            | Traffic should be denied by default, and only required services should be allowed.               | Unnecessary services and traffic may be accessible without restriction.                  | **Critical** |
| **Encryption**                  | **Cleartext FTP**                     | Finance users upload invoices using unencrypted FTP.                                                         | Sensitive traffic should be protected by encryption.                                             | FTP credentials and transferred data could be intercepted.                               | **High**     |
| **Encryption / Access Control** | **Remote Administration Protection**  | SSH is accessible directly from the Internet.                                                                | Remote administration should first pass through an authenticated and encrypted VPN.              | Direct Internet exposure increases the public attack surface.                            | **High**     |
| **Monitoring**                  | **Lack of Security Monitoring**       | No centralized logging, firewall logging, network monitoring, or alerting is described in the documentation. | Security events should be logged and monitored.                                                  | Attacks and unauthorized access attempts may remain undetected.                          | **High**     |
| **Documentation**               | **Unvalidated Network Documentation** | The existing network diagram may not represent the real production environment.                              | Documentation should accurately reflect the real infrastructure.                                 | Incorrect documentation could cause configuration mistakes or unidentified attack paths. | **Medium**   |
| **Availability**                | **Single Point of Failure**           | The infrastructure depends on a single Linux Gateway.                                                        | Ideally, critical infrastructure should have redundancy.                                         | A gateway failure could affect the entire network. Redundancy is currently out of scope. | **Medium**   |

### Business Constraint

> **Legacy FTP :** The Finance application currently requires FTP and cannot be replaced immediately. A preliminary solution is to keep FTP but restrict its use to authenticated Finance users through an encrypted VPN tunnel.

## 4. Preliminary Recommendations

- Introduce network segmentation to separate Guest, Finance, internal users, public services, and critical systems.
- Isolate the central database and allow access only from explicitly authorized systems.
- Implement an nftables firewall using a default-deny policy and allow only business-required traffic.
- Deploy an encrypted VPN, such as WireGuard, for authorized remote users and administrators.
- Restrict SSH access to VPN-connected administrators and disable direct root login.
- Preserve the legacy FTP service temporarily but make it accessible only through the encrypted VPN and only to authorized Finance users.
- Enable appropriate security logging for firewall events, authentication attempts, VPN activity, and critical services.
- Validate the actual network topology, listening services, interfaces, routing, firewall state, and remote-access configuration during the live audit.
- Produce an updated network diagram based on verified technical findings.
- Document the single point of failure associated with the Linux Gateway. Redundancy remediation should be considered in a future project because it is currently outside the defined scope.

## 5. Assessment Limitation

This Gap Analysis is based exclusively on the client-provided briefing documents. No commands, scans, configuration reviews, or live-system checks have been performed at this stage.

All findings must therefore be confirmed or corrected during the technical audit of the LogiCorp Gateway.