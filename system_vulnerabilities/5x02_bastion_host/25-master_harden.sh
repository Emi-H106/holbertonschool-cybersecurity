#!/bin/bash
# NovaTech Solutions - Master Hardening Script
# Target: Ubuntu 20.04
# Purpose: Apply repeatable security hardening controls.
# Run as: sudo bash 25-master_harden.sh
#
# WARNING:
# Test on a disposable VM before production deployment.
# Review network and SSH access before applying changes.

set -Eeuo pipefail

LOG_DIR="/var/log/hardening"
LOG_FILE="$LOG_DIR/master-harden.log"
BACKUP_DIR="/var/backups/novatech-hardening"
SSH_CONFIG="/etc/ssh/sshd_config"
SYSCTL_CONFIG="/etc/sysctl.d/99-novatech-hardening.conf"
BANNER_FILE="/etc/issue.net"

# --------------------------------------------------
# Initialization and logging
# --------------------------------------------------

initialize() {
    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: Run this script with sudo."
        exit 1
    fi

    mkdir -p "$LOG_DIR" "$BACKUP_DIR"
    chmod 700 "$LOG_DIR" "$BACKUP_DIR"

    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"

    exec > >(tee -a "$LOG_FILE") 2>&1

    trap 'log "ERROR at line $LINENO: $BASH_COMMAND"' ERR

    log "=== NovaTech Master Hardening Started ==="

    if [ ! -f /etc/os-release ]; then
        log "ERROR: Cannot identify operating system."
        exit 1
    fi

    # shellcheck disable=SC1091
    source /etc/os-release

    if [ "$ID" != "ubuntu" ]; then
        log "ERROR: This script supports Ubuntu only."
        exit 1
    fi

    if [ "$VERSION_ID" != "20.04" ]; then
        log "WARNING: Designed for Ubuntu 20.04; found $VERSION_ID."
    fi
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# --------------------------------------------------
# Backup management
# --------------------------------------------------

backup_file() {
    local file="$1"
    local destination

    [ -f "$file" ] || return 0

    destination="$BACKUP_DIR${file}"

    mkdir -p "$(dirname "$destination")"

    if [ ! -f "$destination" ]; then
        cp -a "$file" "$destination"
        log "BACKUP: $file"
    else
        log "BACKUP EXISTS: $file"
    fi
}

# --------------------------------------------------
# SSH configuration
# --------------------------------------------------

set_sshd_option() {
    local key="$1"
    local value="$2"
    local file="$3"

    # Remove active or commented copies of this option.
    # Add one authoritative setting at the top.
    sed -i -E \
        "/^[[:space:]]*#?[[:space:]]*${key}[[:space:]]+/Id" \
        "$file"

    sed -i "1i ${key} ${value}" "$file"
}

harden_ssh() {
    log "Hardening SSH..."

    if ! command -v sshd >/dev/null 2>&1 &&
       [ ! -x /usr/sbin/sshd ]; then
        log "WARNING: SSH server not installed; skipping."
        return 0
    fi

    if [ ! -f "$SSH_CONFIG" ]; then
        log "WARNING: SSH configuration missing; skipping."
        return 0
    fi

    backup_file "$SSH_CONFIG"

    local temp_config
    temp_config=$(mktemp)

    cp -a "$SSH_CONFIG" "$temp_config"

    set_sshd_option "PermitRootLogin" "no" "$temp_config"
    set_sshd_option "MaxAuthTries" "3" "$temp_config"
    set_sshd_option "X11Forwarding" "no" "$temp_config"

    # Validate before replacing the active configuration.
    if /usr/sbin/sshd -t -f "$temp_config"; then
        cp "$temp_config" "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG"
        log "SSH configuration validated."
    else
        rm -f "$temp_config"
        log "ERROR: SSH validation failed; changes not applied."
        return 1
    fi

    rm -f "$temp_config"

    if systemctl is-active --quiet ssh; then
        systemctl reload ssh
        log "SSH service reloaded."
    fi

    log "SSH hardening completed."
}

# --------------------------------------------------
# Root account protection
# --------------------------------------------------

harden_root() {
    log "Checking root account..."

    local root_status
    root_status=$(passwd -S root | awk '{print $2}')

    if [ "$root_status" = "L" ]; then
        log "Root password already locked."
    else
        passwd -l root
        log "Root password locked."
    fi
}

# --------------------------------------------------
# Kernel and network security
# --------------------------------------------------

harden_sysctl() {
    log "Applying kernel and network hardening..."

    backup_file "$SYSCTL_CONFIG"

    cat > "$SYSCTL_CONFIG" <<'EOF'
# NovaTech Solutions security baseline
# Disable IP forwarding.
net.ipv4.ip_forward = 0

# Disable IPv4 source routing.
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Disable ICMP redirects.
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Enable SYN flood protection.
net.ipv4.tcp_syncookies = 1

# Log suspicious packets.
net.ipv4.conf.all.log_martians = 1
EOF

    chmod 644 "$SYSCTL_CONFIG"

    sysctl -p "$SYSCTL_CONFIG"

    log "Kernel and network hardening completed."
}

# --------------------------------------------------
# Filesystem hardening
# --------------------------------------------------

ensure_fstab_entry() {
    local mountpoint="$1"
    local entry="$2"

    if ! grep -Eq \
        "^[^#][^[:space:]]+[[:space:]]+${mountpoint}[[:space:]]" \
        /etc/fstab; then
        echo "$entry" >> /etc/fstab
        log "Added fstab entry for $mountpoint."
    else
        log "Existing fstab entry found for $mountpoint."
    fi
}

harden_filesystem() {
    log "Hardening temporary filesystems..."

    backup_file /etc/fstab

    # Preserve an existing /tmp mount rather than
    # automatically replacing its filesystem.
    if mountpoint -q /tmp; then
        log "WARNING: /tmp already mounted; review its options."
    else
        ensure_fstab_entry \
            "/tmp" \
            "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,mode=1777 0 0"

        log "/tmp hardening configured for next reboot."
    fi

    # Protect /dev/shm if it is mounted.
    if mountpoint -q /dev/shm; then
        if mount -o remount,nosuid,nodev,noexec /dev/shm; then
            log "/dev/shm mount restrictions applied."
        else
            log "WARNING: Could not remount /dev/shm."
        fi
    fi

    # Configure /dev/shm persistence.
    if ! grep -Eq '^[^#].*[[:space:]]/dev/shm[[:space:]]' /etc/fstab; then
        echo "tmpfs /dev/shm tmpfs defaults,nosuid,nodev,noexec 0 0" \
            >> /etc/fstab
        log "Added persistent /dev/shm restrictions."
    fi

    # /var/tmp requires an explicit storage and persistence
    # decision; do not automatically bind it to /tmp.
    log "REVIEW: /var/tmp restrictions require service compatibility checks."

    log "Filesystem hardening completed."
}

# --------------------------------------------------
# Unnecessary service minimization
# --------------------------------------------------

minimize_services() {
    log "Reviewing unnecessary services..."

    local service

    for service in cups avahi-daemon bluetooth; do
        if systemctl list-unit-files \
            "${service}.service" --no-legend 2>/dev/null |
            grep -q "${service}.service"; then

            systemctl disable --now "${service}.service" || \
                log "WARNING: Could not disable $service."

            log "Reviewed service: $service"
        else
            log "Service not installed: $service"
        fi
    done

    log "Essential SSH and Apache services were not disabled."
}

# --------------------------------------------------
# Legal warning banner
# --------------------------------------------------

configure_banner() {
    log "Configuring legal SSH banner..."

    backup_file "$BANNER_FILE"

    cat > "$BANNER_FILE" <<'EOF'
=====================================
AUTHORIZED ACCESS ONLY

This system is the property of NovaTech Solutions.
Unauthorized access is prohibited and will be prosecuted.
All activities are monitored and logged.
=====================================
EOF

    chmod 644 "$BANNER_FILE"

    if [ -f "$SSH_CONFIG" ]; then
        backup_file "$SSH_CONFIG"

        local temp_config
        temp_config=$(mktemp)

        cp -a "$SSH_CONFIG" "$temp_config"

        set_sshd_option "Banner" "$BANNER_FILE" "$temp_config"

        if /usr/sbin/sshd -t -f "$temp_config"; then
            cp "$temp_config" "$SSH_CONFIG"
            chmod 600 "$SSH_CONFIG"

            if systemctl is-active --quiet ssh; then
                systemctl reload ssh
            fi

            log "SSH legal banner enabled."
        else
            log "ERROR: Banner configuration validation failed."
            rm -f "$temp_config"
            return 1
        fi

        rm -f "$temp_config"
    fi
}

# --------------------------------------------------
# Final verification
# --------------------------------------------------

verify_hardening() {
    log "Verifying hardening controls..."

    if [ -x /usr/sbin/sshd ]; then
        /usr/sbin/sshd -t
        log "SSH configuration: valid."
    fi

    log "Root account status: $(passwd -S root | awk '{print $2}')"
    log "IP forwarding: $(sysctl -n net.ipv4.ip_forward)"

    if command -v findmnt >/dev/null 2>&1; then
        log "/tmp options: $(findmnt -n -o OPTIONS /tmp || echo unavailable)"
        log "/dev/shm options: $(findmnt -n -o OPTIONS /dev/shm || echo unavailable)"
    fi

    log "Verification completed."
}

# --------------------------------------------------
# Main workflow
# --------------------------------------------------

main() {
    initialize

    backup_file /etc/fstab

    harden_root
    harden_sysctl
    harden_ssh
    harden_filesystem
    minimize_services
    configure_banner
    verify_hardening

    log "=== NovaTech Master Hardening Completed ==="
    log "Review warnings and reboot requirements before deployment."
}

main "$@"
