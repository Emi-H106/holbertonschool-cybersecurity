#!/usr/bin/env python3
"""NovaTech Hardened Shield - Security Audit Tool."""

import os
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

REPORT = Path("audit_result.md")
AUDIT_RESULTS = {}
PASS_THRESHOLD = 80


def run(command):
    try:
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            timeout=5,
            check=False,
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (OSError, subprocess.TimeoutExpired):
        pass
    return ""


def read_file(path):
    try:
        return Path(path).read_text(
            encoding="utf-8", errors="replace"
        )
    except OSError:
        return ""


def add(category, name, passed, details):
    AUDIT_RESULTS.setdefault(category, []).append(
        (name, bool(passed), details)
    )


def config_value(content, key):
    pattern = rf"^\s*{re.escape(key)}\s*=\s*(\S+)"
    matches = re.findall(pattern, content, re.MULTILINE)
    return matches[-1] if matches else None


def audit_kernel():
    category = "Kernel Hardening"

    expected = {
        "net.ipv4.ip_forward": "0",
        "net.ipv4.tcp_syncookies": "1",
        "net.ipv4.conf.all.accept_redirects": "0",
        "net.ipv4.conf.default.accept_redirects": "0",
    }

    for key, value in expected.items():
        actual = run(["sysctl", "-n", key])
        add(
            category,
            key,
            actual == value,
            f"Expected: {value}, Actual: {actual or 'unavailable'}",
        )


def audit_filesystem():
    category = "Filesystem Security"

    tmp = Path("/tmp")
    tmp_mode = (tmp.stat().st_mode & 0o7777) if tmp.exists() else 0

    add(
        category,
        "Secure /tmp permissions",
        tmp_mode == 0o1777,
        f"Mode: {tmp_mode:04o}",
    )

    audit_file = Path("/opt/security/audit/suid_sgid.txt")

    add(
        category,
        "SUID/SGID audit exists",
        audit_file.is_file(),
        str(audit_file),
    )

    if audit_file.is_file():
        mode = audit_file.stat().st_mode & 0o777
        add(
            category,
            "SUID/SGID report permissions",
            mode == 0o640,
            f"Mode: {mode:03o}",
        )
    else:
        add(
            category,
            "SUID/SGID report permissions",
            False,
            "Audit file missing",
        )

    banner = read_file("/etc/issue.net")
    add(
        category,
        "Legal banner",
        "Authorized users only" in banner,
        "/etc/issue.net",
    )


def audit_identity():
    category = "Identity Security"

    quality = read_file(
        "/etc/security/pwquality.conf.d/90-novatech.conf"
    )

    expected_quality = {
        "minlen": "12",
        "ucredit": "-1",
        "lcredit": "-1",
        "dcredit": "-1",
        "ocredit": "-1",
        "enforcing": "1",
    }

    for key, value in expected_quality.items():
        actual = config_value(quality, key)
        add(
            category,
            f"Password policy: {key}",
            actual == value,
            f"Expected: {value}, Actual: {actual}",
        )

    faillock = read_file("/etc/security/faillock.conf")

    for key, value in {
        "deny": "5",
        "fail_interval": "900",
        "unlock_time": "600",
    }.items():
        actual = config_value(faillock, key)
        add(
            category,
            f"Account lockout: {key}",
            actual == value,
            f"Expected: {value}, Actual: {actual}",
        )

    root_status = run(["passwd", "-S", "root"])
    fields = root_status.split()

    locked = len(fields) > 1 and fields[1] in {"L", "LK"}

    add(
        category,
        "Root password locked",
        locked,
        root_status or "Unavailable",
    )


def audit_services():
    category = "Service Security"

    ssh_config = run(["/usr/sbin/sshd", "-T"])

    expected_ssh = {
        "permitrootlogin": "no",
        "passwordauthentication": "no",
        "kbdinteractiveauthentication": "no",
        "pubkeyauthentication": "yes",
        "port": "2222",
        "banner": "/etc/issue.net",
    }

    settings = {}

    for line in ssh_config.splitlines():
        parts = line.split(None, 1)
        if len(parts) == 2:
            settings[parts[0].lower()] = parts[1].strip()

    for key, value in expected_ssh.items():
        actual = settings.get(key)
        add(
            category,
            f"SSH: {key}",
            actual == value,
            f"Expected: {value}, Actual: {actual}",
        )

    nginx = run(["pgrep", "-x", "nginx"])
    sshd = run(["pgrep", "-x", "sshd"])

    add(
        category,
        "Nginx running",
        bool(nginx),
        "Process check",
    )

    add(
        category,
        "SSH running",
        bool(sshd),
        "Process check",
    )

    http = run([
        "curl", "-fsS", "--max-time", "3",
        "http://127.0.0.1:8080/",
    ])

    add(
        category,
        "HTTP health check",
        bool(http),
        "HTTP endpoint: 127.0.0.1:8080",
    )


def audit_container():
    category = "Container Security"

    uid = os.geteuid()

    add(
        category,
        "Non-root execution",
        uid != 0,
        f"Audit process UID: {uid}",
    )

    status = read_file("/proc/self/status")

    match = re.search(
        r"^CapEff:\s*([0-9a-fA-F]+)",
        status,
        re.MULTILINE,
    )

    caps = int(match.group(1), 16) if match else None

    add(
        category,
        "No effective Linux capabilities",
        caps == 0,
        f"CapEff: {match.group(1) if match else 'unavailable'}",
    )

    match = re.search(
        r"^NoNewPrivs:\s*(\d+)",
        status,
        re.MULTILINE,
    )

    nnp = match.group(1) if match else None

    add(
        category,
        "No new privileges",
        nnp == "1",
        f"NoNewPrivs: {nnp or 'unavailable'}",
    )

    match = re.search(
        r"^Seccomp:\s*(\d+)",
        status,
        re.MULTILINE,
    )

    seccomp = match.group(1) if match else None

    add(
        category,
        "Seccomp filtering",
        seccomp == "2",
        f"Seccomp mode: {seccomp or 'unavailable'}",
    )


def generate_report():
    lines = [
        "# NovaTech - Security Audit Report",
        "",
        f"**Date:** {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}",
        f"**Pass threshold:** {PASS_THRESHOLD}%",
        "",
        "## Category Results",
        "",
        "| Category | Passed | Total | Score |",
        "|---|---:|---:|---:|",
    ]

    total_passed = 0
    total_checks = 0

    for category, checks in AUDIT_RESULTS.items():
        passed = sum(1 for _, ok, _ in checks if ok)
        count = len(checks)
        score = (passed / count * 100) if count else 0

        total_passed += passed
        total_checks += count

        lines.append(
            f"| {category} | {passed} | {count} | {score:.1f}% |"
        )

    overall = (
        total_passed / total_checks * 100
        if total_checks else 0
    )

    passed_audit = overall >= PASS_THRESHOLD

    lines.extend([
        "",
        "## Overall Result",
        "",
        f"**Overall Score:** {overall:.1f}%",
        f"**Status:** {'PASS' if passed_audit else 'FAIL'}",
        "",
        "## Detailed Findings",
        "",
    ])

    for category, checks in AUDIT_RESULTS.items():
        lines.append(f"### {category}")
        lines.append("")
        lines.append("| Check | Status | Details |")
        lines.append("|---|---|---|")

        for name, ok, details in checks:
            status = "PASS" if ok else "FAIL"
            safe_details = details.replace("|", "\\|").replace("\n", " ")
            lines.append(
                f"| {name} | {status} | {safe_details} |"
            )

        lines.append("")

    REPORT.write_text(
        "\n".join(lines) + "\n",
        encoding="utf-8",
    )

    print("\n=== NovaTech Security Audit ===")

    for category, checks in AUDIT_RESULTS.items():
        passed = sum(1 for _, ok, _ in checks if ok)
        print(f"{category}: {passed}/{len(checks)}")

    print(f"\nOverall Score: {overall:.1f}%")
    print(f"Status: {'PASS' if passed_audit else 'FAIL'}")
    print(f"Report: {REPORT}")

    return passed_audit


def main():
    audit_kernel()
    audit_filesystem()
    audit_identity()
    audit_services()
    audit_container()

    if generate_report():
        return 0

    return 1


if __name__ == "__main__":
    raise SystemExit(main())
