# ApexVault Security Design Document

## Executive Summary

ApexVault is designed to protect highly sensitive VIP client data using strong authentication, least-privilege authorization, client-side encryption, and tamper-resistant centralized logging. The architecture assumes that servers or administrator accounts may be compromised and ensures that a single compromise does not expose client data or destroy audit evidence.

## 1. Authentication Strategy

- **Selected Technology:** FIDO2 hardware security keys.

- **Justification:** FIDO2 uses public-key cryptography and does not rely on reusable passwords. The private key remains protected by the hardware authenticator, and authentication is bound to the legitimate service, providing strong resistance to phishing. Unlike passwords or SMS codes, there is no reusable shared secret that an attacker can easily steal through a phishing page.

## 2. Authorization Model

- **Model Selected:** Role-Based Access Control (RBAC).

- **Admin Restriction:** Roles separate client access from system administration. SysAdmins can manage the operating system, services, and infrastructure but are not authorized to access client data. Client files are encrypted on the client side before being uploaded to ApexVault. Decryption keys are never stored on the server, so even a SysAdmin with root privileges can only access encrypted data.

## 3. Accounting Architecture

- **Storage Location:** Security and audit logs are transmitted in real time to a dedicated centralized logging system located outside the ApexVault server.

- **Integrity Mechanism:** Logs are stored in immutable, append-only storage and protected with cryptographic integrity verification. Local administrators cannot modify or delete the centralized copies. This preserves audit evidence even if the ApexVault server or a privileged administrator account is compromised.