# Final Security Audit Report

## Purpose

This is a simulated audit of the Nexus Financial security controls.
"Pass (simulated)" means the expected result is shown as an example;
it does not mean the command was run on a production server.

## 1. SSH Hardening

| Verification Command | Expected Output | Self-Assessment |
|---|---|---|
| `sudo sshd -T \| grep permitrootlogin` | `permitrootlogin no` | Pass (simulated) |
| `sudo sshd -T \| grep passwordauthentication` | `passwordauthentication no` | Pass (simulated) |
| Test an individual SSH key and the old shared key | The individual key works; `nexus_master.pem` no longer works. | Pending — test both connections. |

## 2. Role-Based Access Control

| Verification Command | Expected Output | Self-Assessment |
|---|---|---|
| `id test_sarah` | `test_sarah` belongs to `ops`. | Pass (simulated) |
| `sudo -l -U test_sarah` | Only the approved Nginx restart command is allowed by the new rule. | Pass (simulated) |
| `id test_dave` | `test_dave` belongs to `auditors`. | Pass (simulated) |
| `ls -ld /home/test_dev /home/test_sarah /home/test_dave` | Each directory has permission `drwx------` (700). | Pass (simulated) |
| Check all group memberships and sudo rules for Dave | Dave has no other permission to edit configuration files. | Pending — review existing permissions. |

## 3. Network Defense

| Verification Command | Expected Output | Self-Assessment |
|---|---|---|
| `sudo ufw status verbose` | UFW is active. Incoming traffic is denied by default. TCP 5432 is allowed only from the web server IP, and TCP 22 only from the bastion IP. | Pass (simulated) |
| Test port 5432 from an unauthorized source | The connection is blocked. | Pending — test from another host. |

## 4. Centralized Logging

| Verification Command | Expected Output | Self-Assessment |
|---|---|---|
| `sudo rsyslogd -N1` | Configuration validation succeeds. | Pass (simulated) |
| `logger -p authpriv.warning "Nexus audit test"` | The message appears on the central log server. | Pending — check the receiving server. |

## 5. Audit Rules

| Verification Command | Expected Output | Self-Assessment |
|---|---|---|
| `sudo auditctl -l` | Rules for sensitive files and privileged command execution are listed. | Pass (simulated) |
| `sudo auditctl -s` | The output includes `enabled 2`. | Pass (simulated) |

## 6. Physical Security and Recovery

| Verification Method | Expected Result | Self-Assessment |
|---|---|---|
| Inspect the office and server room | Visitors are accompanied, and server access is controlled without overheating equipment. | Pending — on-site inspection required. |
| Review visitor and access-card records | Visitors and spare cards are recorded. | Pending — records must be checked. |
| Restore a backup in a test environment | The database can be restored and its important data passes validation. | Pending — restoration test required. |

## Overall Self-Assessment

The simulated checks show how the implemented controls could be
demonstrated to an auditor. The controls marked Pending still need
direct testing. Before the real audit, replace every simulated result
with the actual command output, test date, and evidence.