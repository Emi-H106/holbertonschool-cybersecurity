#!/bin/bash
# NovaTech Hardened Shield
# Identity and Access Hardening Script

set -Eeuo pipefail
umask 027

log() {
    echo "[INFO] $*"
}

fail() {
    echo "[ERROR] $*" >&2
    exit 1
}

trap 'echo "[ERROR] Failed at line $LINENO" >&2' ERR

require_root() {
    [[ "$(id -u)" -eq 0 ]] || fail "Root privileges required."
}

configure_password_policy() {
    log "Configuring password policies..."

    local conf="/etc/security/pwquality.conf.d/90-novatech.conf"

    mkdir -p /etc/security/pwquality.conf.d

    cat > "$conf" <<'EOF'
minlen = 12
ucredit = -1
lcredit = -1
dcredit = -1
ocredit = -1
difok = 3
usercheck = 1
enforcing = 1
EOF

    chmod 644 "$conf"

    # Ensure PAM password stack uses pam_pwquality.
    if ! grep -Eq '^[[:space:]]*password[[:space:]].*pam_pwquality\.so' \
        /etc/pam.d/common-password; then

        sed -i '/^password[[:space:]].*pam_unix\.so/i\
password requisite pam_pwquality.so retry=3' \
            /etc/pam.d/common-password
    fi

    log "Password policy configured."
}

configure_account_lockout() {
    log "Configuring account lockout..."

    cat > /etc/security/faillock.conf <<'EOF'
deny = 5
fail_interval = 900
unlock_time = 600
silent
EOF

    chmod 644 /etc/security/faillock.conf

    local pam="/etc/pam.d/common-auth"

    # Insert preauth before the authentication stack.
    if ! grep -q 'pam_faillock.so preauth' "$pam"; then
        sed -i '1i auth required pam_faillock.so preauth' "$pam"
    fi

    # Insert authfail before pam_deny, preserving existing jumps.
    if ! grep -q 'pam_faillock.so authfail' "$pam"; then
        sed -i '/^auth[[:space:]]*requisite[[:space:]]*pam_deny.so/i\
auth [default=die] pam_faillock.so authfail' "$pam"
    fi

    # Check locked accounts during account management.
    if ! grep -q 'pam_faillock.so' /etc/pam.d/common-account; then
        printf '\naccount required pam_faillock.so\n' \
            >> /etc/pam.d/common-account
    fi

    log "Account lockout policy configured."
}

configure_ssh() {
    log "Hardening SSH configuration..."

    mkdir -p /etc/ssh/sshd_config.d

    cat > /etc/ssh/sshd_config.d/00-novatech.conf <<'EOF'
Port 2222
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
X11Forwarding no
AllowTcpForwarding no
PermitUserEnvironment no
Banner /etc/issue.net
EOF

    chmod 644 /etc/ssh/sshd_config.d/00-novatech.conf

    /usr/sbin/sshd -t

    log "SSH configuration validated."
}

lock_root() {
    log "Locking root password..."

    passwd -l root >/dev/null

    log "Root password locked."
}

main() {
    log "Starting identity hardening..."

    require_root
    configure_password_policy
    configure_account_lockout
    configure_ssh
    lock_root

    log "Identity hardening completed successfully."
}

main "$@"
exit 0
