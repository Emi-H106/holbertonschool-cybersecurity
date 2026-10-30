# NovaTech - Security Audit Report

**Date:** 2026-10-30 14:56 UTC
**Pass threshold:** 80%

## Category Results

| Category | Passed | Total | Score |
|---|---:|---:|---:|
| Kernel Hardening | 3 | 4 | 75.0% |
| Filesystem Security | 4 | 4 | 100.0% |
| Identity Security | 10 | 10 | 100.0% |
| Service Security | 9 | 9 | 100.0% |
| Container Security | 4 | 4 | 100.0% |

## Overall Result

**Overall Score:** 96.8%
**Status:** PASS

## Detailed Findings

### Kernel Hardening

| Check | Status | Details |
|---|---|---|
| net.ipv4.ip_forward | PASS | Expected: 0, Actual: 0 |
| net.ipv4.tcp_syncookies | PASS | Expected: 1, Actual: 1 |
| net.ipv4.conf.all.accept_redirects | FAIL | Expected: 0, Actual: 1 |
| net.ipv4.conf.default.accept_redirects | PASS | Expected: 0, Actual: 0 |

### Filesystem Security

| Check | Status | Details |
|---|---|---|
| Secure /tmp permissions | PASS | Mode: 1777 |
| SUID/SGID audit exists | PASS | /opt/security/audit/suid_sgid.txt |
| SUID/SGID report permissions | PASS | Mode: 640 |
| Legal banner | PASS | /etc/issue.net |

### Identity Security

| Check | Status | Details |
|---|---|---|
| Password policy: minlen | PASS | Expected: 12, Actual: 12 |
| Password policy: ucredit | PASS | Expected: -1, Actual: -1 |
| Password policy: lcredit | PASS | Expected: -1, Actual: -1 |
| Password policy: dcredit | PASS | Expected: -1, Actual: -1 |
| Password policy: ocredit | PASS | Expected: -1, Actual: -1 |
| Password policy: enforcing | PASS | Expected: 1, Actual: 1 |
| Account lockout: deny | PASS | Expected: 5, Actual: 5 |
| Account lockout: fail_interval | PASS | Expected: 900, Actual: 900 |
| Account lockout: unlock_time | PASS | Expected: 600, Actual: 600 |
| Root password locked | PASS | root L 2026-10-27 0 99999 7 -1 |

### Service Security

| Check | Status | Details |
|---|---|---|
| SSH: permitrootlogin | PASS | Expected: no, Actual: no |
| SSH: passwordauthentication | PASS | Expected: no, Actual: no |
| SSH: kbdinteractiveauthentication | PASS | Expected: no, Actual: no |
| SSH: pubkeyauthentication | PASS | Expected: yes, Actual: yes |
| SSH: port | PASS | Expected: 2222, Actual: 2222 |
| SSH: banner | PASS | Expected: /etc/issue.net, Actual: /etc/issue.net |
| Nginx running | PASS | Process check |
| SSH running | PASS | Process check |
| HTTP health check | PASS | HTTP endpoint: 127.0.0.1:8080 |

### Container Security

| Check | Status | Details |
|---|---|---|
| Non-root application workers | PASS | Nginx worker PIDs: [16, 17, 18, 19, 20, 22, 24, 25, 26, 27, 28, 30]; UIDs: ['10001', '10001', '10001', '10001', '10001', '10001', '10001', '10001', '10001', '10001', '10001', '10001'] |
| No effective capabilities on application workers | PASS | Nginx worker CapEff: ['0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000', '0000000000000000'] |
| No new privileges | PASS | NoNewPrivs: 1 |
| Seccomp filtering | PASS | Seccomp mode: 2 |

