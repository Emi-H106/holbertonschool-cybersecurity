# NovaTech Solutions — Bastion Host Hardening Report

**Document Owner:** Security Operations Team  
**System:** novatech-prod-02  
**Report Date:** 2026-10-23  
**Status:** Pending CISO Review  
**Scope:** Linux bastion host hardening for DMZ deployment

---

## 1. Executive Summary

This report documents the security hardening activities performed on the NovaTech Solutions Linux bastion host.

The objective was to reduce the system's attack surface, improve access controls, strengthen SSH security, and prepare the server for potential deployment in the DMZ.

Security assessments were performed using Lynis before and after the hardening activities.

The Hardening Index increased from **55 to 61**, representing an improvement of **6 points**.

The number of security suggestions decreased from **51 to 48**, while the number of warnings remained at **5**.

Although improvements were achieved, several security issues remain unresolved. Deployment should not proceed without reviewing these risks and obtaining CISO approval.

## 2. Baseline Assessment

An initial security assessment was performed before applying hardening measures.

**Baseline report:** `/var/log/hardening/baseline-20261020.txt`

| Metric | Baseline Result |
|---|---:|
| Hardening Index | 55/100 |
| Tests Performed | 231 |
| Warnings | 5 |
| Suggestions | 51 |

### Initial Security Findings

The baseline assessment identified several security concerns:

- A potentially risky SUID executable at `/usr/local/bin/backup`.
- IP forwarding enabled.
- `/tmp` without the `noexec` mount option.
- Missing protection for single-user mode.
- Insufficient DNS redundancy.
- Firewall configuration warnings.
- MySQL root password warning.
- An outdated Lynis version.

These findings provided the basis for the hardening activities.

## 3. Hardening Measures Applied

The hardening activities were organized into several security domains.

### 3.1 SSH Security

SSH configuration was reviewed and strengthened to reduce the risk of unauthorized remote access.

Measures included:

- Disabling direct SSH login for the root account.
- Configuring a legal warning banner for SSH connections.
- Validating SSH configuration before reloading the service.
- Verifying the effective SSH configuration.

**Verification:** SSH reported `PermitRootLogin no`, and the legal banner was successfully enabled.

### 3.2 Authentication and Privilege Management

Authentication and administrative access controls were reviewed.

Measures included:

- Locking the root account password.
- Verifying that authorized users could continue using `sudo`.
- Checking the validity of the sudo configuration.
- Reviewing privileged access settings.

**Verification:** The root password was locked, and sudo access remained functional.

### 3.3 Filesystem Security

Temporary filesystem locations were hardened to reduce the risk of executing malicious files.

Measures included:

- Applying `noexec`, `nosuid`, and `nodev` restrictions to `/tmp`.
- Applying equivalent restrictions to `/var/tmp`.
- Applying equivalent restrictions to `/dev/shm`.
- Testing that executable files could not run from these locations.

**Verification:** Execution tests were blocked in the protected temporary directories.

### 3.4 Service Minimization

Unnecessary services were reviewed to reduce the system's attack surface.

Measures included:

- Disabling unnecessary services such as CUPS, Avahi, and Bluetooth where present.
- Preserving essential SSH access.
- Preserving the Apache web service required for the lab environment.

**Verification:** Essential services remained available after service minimization.

### 3.5 Legal Access Warning

A legal banner was configured to warn users that access is restricted.

Measures included:

- Creating `/etc/issue.net`.
- Configuring SSH to display the legal banner.
- Validating the SSH configuration.
- Reloading SSH and verifying the banner setting.

**Verification:** The SSH legal banner was successfully configured.

### 3.6 Security Auditing

Lynis was used to assess the security posture of the host.

Measures included:

- Performing a baseline security audit.
- Performing a final security audit.
- Comparing hardening scores.
- Identifying remaining warnings and suggestions.

**Verification:** The final audit completed successfully and produced a report.

## 4. Final Assessment

The final Lynis assessment was performed after the hardening activities.

**Final report:** `/var/log/lynis-report.dat`

| Metric | Before | After | Change |
|---|---:|---:|---:|
| Hardening Index | 55 | 61 | +6 |
| Tests Performed | 231 | 228 | -3 |
| Warnings | 5 | 5 | 0 |
| Suggestions | 51 | 48 | -3 |

### Assessment Results

The Hardening Index improved by 6 points.

Three fewer suggestions were reported in the final assessment.

The number of warnings remained unchanged.

The number of tests performed also changed between assessments. Therefore, the score improvement should be interpreted together with the individual security findings rather than as a complete measure of system security.

The hardening activities improved several security controls, but the system is not yet free of security risks.

## 5. Remaining Recommendations

The final Lynis assessment identified five warnings and additional improvement opportunities.

### Outstanding Warnings

| Finding | Recommendation |
|---|---|
| Outdated Lynis version | Update Lynis to a supported version |
| Single-user mode protection | Review and strengthen recovery-mode authentication |
| DNS redundancy | Configure and verify appropriate backup DNS resolvers |
| Firewall configuration | Review active firewall rules and confirm the intended firewall backend |
| MySQL root authentication | Review and secure MySQL administrative authentication |

### Additional Security Recommendations

**High priority**

- Review firewall enforcement and network access restrictions.
- Verify MySQL administrative authentication.
- Review remaining SSH configuration weaknesses.
- Implement audit logging using auditd where appropriate.

**Medium priority**

- Consider deploying Fail2ban.
- Implement file integrity monitoring.
- Review password policy and authentication controls.
- Consider Apache security modules such as ModSecurity.
- Configure process accounting where required.

**Lower priority / Environment-dependent**

- Review DNS redundancy.
- Consider additional system monitoring utilities.
- Review compiler access restrictions.
- Evaluate malware scanning tools.

All recommendations should be assessed according to the system's operational requirements and deployment risks.

## 6. Sign-off Checklist

The following checklist must be reviewed before approving DMZ deployment.

- [x] Baseline security assessment completed.
- [x] Hardening activities documented.
- [x] SSH root login disabled.
- [x] Root account password locked.
- [x] Temporary filesystem restrictions verified.
- [x] Unnecessary services reviewed and disabled.
- [x] SSH legal banner configured.
- [x] Final Lynis audit completed.
- [x] Baseline and final results compared.
- [ ] Outstanding firewall warning reviewed and resolved or formally accepted.
- [ ] MySQL administrative authentication warning reviewed.
- [ ] Remaining security warnings assessed.
- [ ] Residual risks documented and accepted.
- [ ] CISO approval obtained.
- [ ] DMZ deployment authorized.

### Approval

**Prepared by:** Security Operations Team  
**Reviewed by:** __________________________  
**CISO Approval:** ________________________  
**Approval Date:** ________________________  

**Final Status:** Pending CISO Review

---

## Conclusion

The NovaTech Solutions bastion host has undergone several security hardening activities.

The final Lynis Hardening Index increased from 55 to 61, demonstrating measurable improvement.

However, five warnings and 48 suggestions remain. Additional security review and risk acceptance are necessary before production deployment.

**Recommendation:** Do not authorize DMZ deployment until the remaining critical security concerns have been reviewed and CISO approval has been obtained.
