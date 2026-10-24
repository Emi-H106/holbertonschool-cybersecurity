#!/bin/bash
# NovaTech - Identity Security Audit
# Ubuntu 20.04; read-only configuration checks.
set -uo pipefail

PASS=0
TOTAL=12
FAILED=0
check() {
    local label="$1"; shift
    if "$@"; then
        printf '  %s: CONFIGURED\n' "$label"
        PASS=$((PASS + 1))
    else
        printf '  %s: NOT VERIFIED\n' "$label"
        FAILED=$((FAILED + 1))
    fi
}

pam_has() {
    grep -Eqs "$1" \
        /etc/pam.d/common-password \
        /etc/pam.d/common-auth \
        /etc/pam.d/sshd 2>/dev/null
}

minlen_12() {
    grep -Eqs '(^|[[:space:]])minlen[[:space:]]*=[[:space:]]*(1[2-9]|[2-9][0-9])([[:space:]]|$)' \
        /etc/security/pwquality.conf \
        /etc/security/pwquality.conf.d/*.conf \
        /etc/pam.d/common-password 2>/dev/null
}

history_5() {
    grep -Eq '^[[:space:]]*password[[:space:]]+.*pam_pwhistory\.so.*remember[[:space:]]*=[[:space:]]*([5-9]|[1-9][0-9]+)([[:space:]]|$)' \
        /etc/pam.d/common-password 2>/dev/null
}

aging_90() {
    grep -Eqs '^[[:space:]]*PASS_MAX_DAYS[[:space:]]+(90|[1-9]|[1-8][0-9])[[:space:]]*($|#)' \
        /etc/login.defs 2>/dev/null
}

faillock_active() {
    pam_has '^[[:space:]]*auth[[:space:]].*pam_faillock\.so'
}

faillock_5() {
    grep -Eqs '^[[:space:]]*deny[[:space:]]*=[[:space:]]*5([[:space:]]|$)' \
        /etc/security/faillock.conf 2>/dev/null ||
    grep -Eqs 'pam_faillock\.so.*deny=5([[:space:]]|$)' \
        /etc/pam.d/common-auth 2>/dev/null
}

fail2ban_active() {
    systemctl is-active --quiet fail2ban &&
    fail2ban-client status sshd >/dev/null 2>&1
}

sshd_value() {
    [[ "$(sshd -T 2>/dev/null |
        awk -v k="$1" '$1==k {print $2; exit}')" == "$2" ]]
}

mfa_enabled() {
    sshd -T 2>/dev/null |
        grep -Eq '^authenticationmethods publickey,keyboard-interactive(:pam)?([[:space:]]|$)' &&
    sshd_value kbdinteractiveauthentication yes &&
    sshd_value usepam yes &&
    grep -Eqs '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_google_authenticator\.so([[:space:]]|$)' \
        /etc/pam.d/sshd
}

if [[ $EUID -ne 0 ]]; then
    echo 'ERROR: Run as root: sudo ./22-identity_audit.sh' >&2
    exit 1
fi

printf '=== Identity Security Audit ===\n\n'
printf 'Password Policy:\n'
check 'Complexity enforcement' pam_has '^[[:space:]]*password[[:space:]].*pam_pwquality\.so'
check 'Minimum length 12' minlen_12
check 'History (5 passwords)' history_5
check 'Aging (90 days max)' aging_90

printf '\nAccount Protection:\n'
check 'pam_faillock' faillock_active
check 'Lockout after 5 attempts' faillock_5
check 'fail2ban for SSH' fail2ban_active

printf '\nSSH Security:\n'

# Verify PasswordAuthentication no
check 'Password authentication disabled' \
    sshd_value passwordauthentication no

# Verify PubkeyAuthentication yes
check 'Public key authentication enabled' \
    sshd_value pubkeyauthentication yes

# Verify AuthenticationMethods publickey,keyboard-interactive
check 'MFA required' mfa_enabled

printf '\nUser Compliance:\n'
# Audit local interactive accounts (UID >= 1000, excluding nobody).
# This is a conservative heuristic; review account roles manually.
mapfile -t USERS < <(awk -F: '$3 >= 1000 && $3 < 65534 && $7 !~ /(nologin|false)$/ {print $1":"$6}' /etc/passwd)
MISSING_TOTP=0
EXPIRED=0
for entry in "${USERS[@]}"; do
    user=${entry%%:*}
    home=${entry#*:}
    if [[ ! -s "$home/.google_authenticator" ]] || [[ "$(stat -c %a "$home/.google_authenticator" 2>/dev/null)" != 600 ]]; then
        MISSING_TOTP=$((MISSING_TOTP + 1))
    fi
    if chage -l "$user" 2>/dev/null | grep -Eq '^Password expires[[:space:]]*:[[:space:]]*password must be changed'; then
        EXPIRED=$((EXPIRED + 1))
    fi
done
printf '  Users with weak passwords: NOT MEASURABLE from password hashes\n'
printf '  Users without TOTP: %d (interactive local accounts only)\n' "$MISSING_TOTP"
printf '  Accounts flagged as expired: %d (limited check)\n' "$EXPIRED"
if (( MISSING_TOTP == 0 )); then PASS=$((PASS + 1)); else FAILED=$((FAILED + 1)); fi
if (( EXPIRED == 0 )); then PASS=$((PASS + 1)); else FAILED=$((FAILED + 1)); fi

printf '\nSummary:\n'
printf '  Identity controls: %d/%d PASSED\n' "$PASS" "$TOTAL"
if (( FAILED == 0 )); then
    echo '  Compliance level: CONFIGURATION CHECKS PASSED'
    echo 'Manual review and end-to-end authentication testing are still required.'
else
    echo '  Compliance level: REVIEW REQUIRED'
    echo 'Resolve failed checks before production deployment.'
    exit 1
fi
