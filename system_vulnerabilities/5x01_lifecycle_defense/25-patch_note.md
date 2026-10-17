# NovaTech Patch Management Policy

**Document Owner:** Chief Information Security Officer (CISO)  
**Version:** 1.0  
**Status:** Draft for Approval  
**Review Frequency:** Annually and after major security incidents

## 1. Purpose and Scope

The purpose of this policy is to protect NovaTech's systems from known vulnerabilities by ensuring that security patches are assessed, tested, deployed, and monitored in a controlled manner.

This policy applies to all NovaTech-managed Linux servers, operating system packages, security updates, and related patch management configurations. It covers both automated and manual patching activities.

## 2. Roles and Responsibilities

- **CISO:** Approves the policy, oversees compliance, and reviews high-risk exceptions.
- **System Administrators:** Monitor available updates, maintain patch configurations, deploy patches, and verify system stability.
- **Security Team:** Assesses vulnerabilities, classifies patch severity, and identifies urgent security risks.
- **Application Owners:** Test critical applications after updates and report compatibility issues.
- **Management:** Provides resources and reviews compliance reports.

## 3. Patch Classification

Patches are classified according to severity and business impact.

| Severity | Description | Target Deployment Time |
|---|---|---|
| Critical | Actively exploited vulnerabilities or severe security risks | Within 24 hours |
| High | Serious vulnerabilities with significant potential impact | Within 7 days |
| Medium | Moderate security risks | Within 30 days |
| Low | Minor security issues or routine improvements | Within 90 days |

Critical and High patches must be prioritized according to exposure, exploitability, and business impact.

## 4. Update Schedule

NovaTech uses `unattended-upgrades` to automate approved security updates.

- **APT package list refresh:** Daily at 02:00 UTC, with up to 30 minutes of randomized delay.
- **Automatic upgrade execution:** Daily at 03:00 UTC, with up to 60 minutes of randomized delay.
- **Automatic reboot:** Scheduled for 04:00 UTC when a reboot is required.
- **Logged-in users:** Automatic reboot is disabled when users are logged in.
- **Security-only updates:** Automatic updates are restricted to approved security repositories.

These times refer to the server's UTC timezone. Updates may be delayed by system availability or timer behavior.

## 5. Protected Packages

The following packages are excluded from automatic upgrades:

| Package | Reason |
|---|---|
| `apache2` | Prevent unexpected web service disruption |
| `apache2-bin` | Protect Apache binary compatibility |
| `mysql-server` | Avoid untested database changes |
| `mysql-server-*` | Protect related MySQL server packages |
| `nginx` | Prevent unexpected reverse proxy changes |
| `docker-ce` | Avoid container runtime compatibility issues |

Protected packages must still receive security patches through a controlled manual update process, including testing, approval, deployment, and verification.

## 6. Exception Process

Temporary package holds and blacklist additions must be documented and approved.

Each exception must include:

- Package name and installed version
- Reason for the exception
- Date of implementation
- Responsible administrator
- Risk assessment and compensating controls
- Planned review or expiration date

Package holds are managed using `apt-mark hold` and tracked in `/var/log/package_holds.log`.

Holds must be reviewed within 14 days and must not remain active beyond 30 days without documented reapproval.

When the issue is resolved, the administrator must remove the hold using `apt-mark unhold` and verify that the package can receive approved updates.

## 7. Emergency Patching

Critical vulnerabilities requiring immediate action must follow the emergency patching procedure:

1. The Security Team identifies and evaluates the vulnerability.
2. The CISO or authorized incident manager approves emergency deployment.
3. Administrators create a backup or system snapshot when feasible.
4. The patch is tested in a staging environment when time permits.
5. The patch is deployed outside the normal maintenance window if necessary.
6. Administrators verify service availability, application functionality, and security status.
7. Any failures are addressed using an approved rollback or recovery procedure.
8. The incident, actions taken, and results are documented.

Emergency patching must prioritize risk reduction while minimizing service disruption.

## 8. Compliance and Auditing

NovaTech verifies patch management compliance through regular reviews and documented evidence.

Administrators must:

- Review automatic update logs and package installation history.
- Verify that `unattended-upgrades` is configured and functioning.
- Confirm that only approved security repositories are used for automatic updates.
- Review protected packages and active holds.
- Investigate failed updates and overdue critical patches.
- Maintain configuration backups and verify their integrity using SHA256.
- Retain patching records, exceptions, and incident documentation according to the organization's retention requirements.

The Security Team performs monthly compliance reviews and reports significant findings to the CISO.

Any policy violations must be documented, investigated, and remediated.

## 9. Policy Review and Approval

This policy must be reviewed at least annually and whenever significant infrastructure changes, security incidents, or regulatory requirements occur.

**Policy Owner:** CISO  
**Approval Status:** Pending formal approval  
**Next Review:** One year after approval
