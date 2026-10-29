#!/bin/bash
# NovaTech Hardened Shield
# System Hardening Script
# Purpose: Apply and audit container security controls

set -Eeuo pipefail

umask 027

readonly BANNER="/etc/issue.net"
readonly AUDIT_DIR="/opt/security/audit"
readonly AUDIT_FILE="${AUDIT_DIR}/suid_sgid.txt"

log() {
    echo "[INFO] $*"
}

warn() {
    echo "[WARN] $*" >&2
}

fail() {
    echo "[ERROR] $*" >&2
    exit 1
}

trap 'echo "[ERROR] Failed at line $LINENO" >&2' ERR

require_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        fail "Run this script as root during image build."
    fi
}

configure_sysctl() {
    log "Checking kernel security parameters..."

    local key expected actual
    local -a settings=(
        "net.ipv4.ip_forward=0"
        "net.ipv4.conf.all.accept_redirects=0"
        "net.ipv4.conf.default.accept_redirects=0"
        "net.ipv4.tcp_syncookies=1"
    )

    for setting in "${settings[@]}"; do
        key="${setting%%=*}"
        expected="${setting#*=}"

        actual="$(sysctl -n "$key" 2>/dev/null)" || {
            warn "$key unavailable; configure through Docker/host."
            continue
        }

        if [[ "$actual" == "$expected" ]]; then
            log "$key is correctly configured."
        else
            warn "$key=$actual (expected $expected)."
            warn "Configure this setting at Docker runtime."
        fi
    done
}

secure_filesystem() {
    log "Applying filesystem permissions..."

    chmod 1777 /tmp

    if [[ -d /opt/security/scripts ]]; then
        find /opt/security/scripts -type f -name '*.sh' \
            -exec chmod 755 {} +
    fi

    if [[ -d /opt/security/config ]]; then
        find /opt/security/config -type f \
            -exec chmod 640 {} +
    fi

    log "Filesystem permissions configured."
    log "Use Docker read_only and tmpfs for mount security."
}

minimize_services() {
    log "Auditing installed services..."

    local service

    for service in telnetd ftpd vsftpd rsh-server; do
        if dpkg-query -W -f='${Status}' "$service" \
            2>/dev/null | grep -q "install ok installed"; then
            warn "Unnecessary service package installed: $service"
        fi
    done

    log "Service audit completed."
}

audit_suid_sgid() {
    log "Auditing SUID/SGID files..."

    mkdir -p "$AUDIT_DIR"

    find /usr /bin /sbin /opt \
        -xdev -type f \( -perm /4000 -o -perm /2000 \) \
        -print 2>/dev/null | sort > "$AUDIT_FILE"

    chmod 640 "$AUDIT_FILE"

    log "Audit saved to $AUDIT_FILE"
}

configure_banner() {
    log "Configuring legal banner..."

    cat > "$BANNER" <<'EOF'
**************************************************
*        NOVATECH SOLUTIONS - RESTRICTED         *
*                                                *
* Authorized users only.                        *
* Unauthorized access is prohibited.            *
* All activities may be monitored and logged.   *
**************************************************
EOF

    chmod 644 "$BANNER"

    log "Legal banner configured."
}

main() {
    log "Starting system hardening..."

    require_root
    configure_sysctl
    secure_filesystem
    minimize_services
    audit_suid_sgid
    configure_banner

    log "System hardening completed successfully."
}

main "$@"
exit 0
