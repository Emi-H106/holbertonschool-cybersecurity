
#!/bin/bash
# NovaTech Solutions - Master Hardening Script
# Target: Ubuntu 20.04
# Purpose: Apply reusable and repeatable security controls.
#
# Usage:
#   sudo bash 25-master_harden.sh
#
# Optional software removal (review dependencies first):
#   sudo env REMOVE_DEV_TOOLS=yes bash 25-master_harden.sh
#
# WARNING:
# Test on a disposable VM before production deployment.
# Ensure console access and a VM snapshot are available.

set -Eeuo pipefail

LOG_DIR="/var/log/hardening"
LOG_FILE="$LOG_DIR/master-harden.log"
BACKUP_DIR="/var/backups/novatech-hardening"

SSH_CONFIG="/etc/ssh/sshd_config"
SYSCTL_CONFIG="/etc/sysctl.d/99-novatech-hardening.conf"
BANNER_FILE="/etc/issue.net"

REMOVE_DEV_TOOLS="${REMOVE_DEV_TOOLS:-no}"

# --------------------------------------------------
# Logging and initialization
# --------------------------------------------------

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

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

# --------------------------------------------------
# Configuration backup
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
# SSH configuration helpers
# --------------------------------------------------

set_sshd_option() {
    local key="$1"
    local value="$2"
    local file="$3"

    # Remove previous global copies of the option.
    # Do not edit settings inside Match blocks.
    local match_line

    match_line=$(grep -niE \
        '^[[:space:]]*Match[[:space:]]+' \
        "$file" | head -1 | cut -d: -f1 || true)

    if [ -n "$match_line" ]; then
        log "WARNING: SSH Match block detected; review overrides."
    fi

    # Insert an authoritative global setting at the top.
    # Remove existing occurrences before the first Match block.
    local temp_file
    temp_file=$(mktemp)

    awk -v key="$key" '
        BEGIN { in_match=0 }
        /^[[:space:]]*Match[[:space:]]+/ {
            in_match=1
        }
        {
            if (!in_match) {
                line=$0
                sub(/^[[:space:]]*#[[:space:]]*/, "", line)
                split(line, fields, /[[:space:]]+/)
                if (tolower(fields[1]) == tolower(key)) {
                    next
                }
            }
            print
        }
    ' "$file" > "$temp_file"

    {
        printf '%s %s\n' "$key" "$value"
        cat "$temp_file"
    } > "$file"

    rm -f "$temp_file"
}

# --------------------------------------------------
# SSH hardening
# --------------------------------------------------

harden_ssh() {
    log "Hardening SSH..."

    if [ ! -x /usr/sbin/sshd ]; then
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
# Kernel and network hardening
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
# Filesystem configuration helpers
# --------------------------------------------------

ensure_fstab_entry() {
    local mountpoint="$1"
    local entry="$2"

    if ! awk -v target="$mountpoint" '
        $1 !~ /^#/ && $2 == target {found=1}
        END {exit !found}
    ' /etc/fstab; then
        printf '%s\n' "$entry" >> /etc/fstab
        log "Added fstab entry for $mountpoint."
    else
        log "Existing fstab entry found for $mountpoint."
    fi
}

# --------------------------------------------------
# Filesystem hardening
# --------------------------------------------------

harden_filesystem() {
    log "Hardening temporary filesystems..."

    backup_file /etc/fstab

    # Protect /tmp without replacing an existing mount.
    if mountpoint -q /tmp; then
        log "/tmp already mounted; checking restrictions."

        if mount -o remount,nosuid,nodev,noexec /tmp; then
            log "/tmp restrictions applied."
        else
            log "WARNING: Could not remount /tmp."
        fi
    else
        ensure_fstab_entry \
            "/tmp" \
            "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,mode=1777 0 0"

        log "/tmp restrictions configured for next reboot."
    fi

    # Protect /dev/shm.
    if mountpoint -q /dev/shm; then
        if mount -o remount,nosuid,nodev,noexec /dev/shm; then
            log "/dev/shm restrictions applied."
        else
            log "WARNING: Could not remount /dev/shm."
        fi
    fi

    ensure_fstab_entry \
        "/dev/shm" \
        "tmpfs /dev/shm tmpfs defaults,nosuid,nodev,noexec 0 0"

    # Existing /var/tmp storage may need to persist across reboot.
    # Do not replace it automatically with a temporary filesystem.
    if mountpoint -q /var/tmp; then
        log "/var/tmp is mounted; review mount restrictions."
    else
        log "REVIEW: /var/tmp needs a compatible hardening policy."
    fi

    log "Filesystem hardening completed."
}

# --------------------------------------------------
# Service minimization
# --------------------------------------------------

minimize_services() {
    log "Reviewing unnecessary services..."

    local service

    for service in cups avahi-daemon bluetooth; do
        if systemctl list-unit-files \
            "${service}.service" --no-legend 2>/dev/null |
            grep -q "${service}.service"; then

            if systemctl disable --now "${service}.service"; then
                log "Disabled service: $service"
            else
                log "WARNING: Could not disable $service."
            fi
        else
            log "Service not installed: $service"
        fi
    done

    # Avahi can be restarted through socket activation.
    if systemctl list-unit-files \
        avahi-daemon.socket --no-legend 2>/dev/null |
        grep -q 'avahi-daemon.socket'; then

        if systemctl disable --now avahi-daemon.socket; then
            log "Disabled Avahi socket activation."
        else
            log "WARNING: Could not disable Avahi socket."
        fi
    fi

    log "SSH and Apache were not disabled."
    log "Service minimization completed."
}

# --------------------------------------------------
# Software minimization
# --------------------------------------------------

minimize_software() {
    log "Checking unnecessary software..."

    # Compilers and development tools increase the attack surface.
    # Removal is optional to avoid breaking applications.
    #
    # Enable with:
    # sudo env REMOVE_DEV_TOOLS=yes bash 25-master_harden.sh

    local package

    for package in gcc build-essential; do
        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null |
            grep -q "install ok installed"; then

            log "Installed development package: $package"

            if [ "$REMOVE_DEV_TOOLS" = "yes" ]; then
                log "Removing unnecessary package: $package"

                DEBIAN_FRONTEND=noninteractive \
                    apt-get remove -y "$package"

                log "Package removal completed: $package"
            else
                log "Keeping $package (removal not enabled)."
            fi
        else
            log "Package not installed: $package"
        fi
    done

    # Do not automatically remove diagnostic network tools.
    # They may be required for authorized troubleshooting.
    for package in nmap netcat-openbsd; do
        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null |
            grep -q "install ok installed"; then
            log "REVIEW: Network tool installed: $package"
        fi
    done

    log "Software minimization completed."
}

# --------------------------------------------------
# Legal SSH warning banner
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

    if [ ! -x /usr/sbin/sshd ] ||
       [ ! -f "$SSH_CONFIG" ]; then
        log "WARNING: SSH unavailable; banner file created only."
        return 0
    fi

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
        rm -f "$temp_config"
        log "ERROR: Banner configuration validation failed."
        return 1
    fi

    rm -f "$temp_config"
}

# --------------------------------------------------
# Final verification
# --------------------------------------------------

verify_hardening() {
    log "Verifying hardening controls..."

    if [ -x /usr/sbin/sshd ]; then
        /usr/sbin/sshd -t
        log "SSH configuration: valid."

        /usr/sbin/sshd -T |
            grep -Ei '^(permitrootlogin|maxauthtries|x11forwarding|banner) ' \
            || true
    fi

    log "Root account status: $(passwd -S root | awk '{print $2}')"

    log "IP forwarding: $(sysctl -n net.ipv4.ip_forward)"

    if command -v findmnt >/dev/null 2>&1; then
        log "/tmp options: $(findmnt -n -o OPTIONS /tmp || echo unavailable)"
        log "/dev/shm options: $(findmnt -n -o OPTIONS /dev/shm || echo unavailable)"
        log "/var/tmp options: $(findmnt -n -o OPTIONS /var/tmp || echo unavailable)"
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
    minimize_software
    configure_banner
    verify_hardening

    log "=== NovaTech Master Hardening Completed ==="
    log "Review warnings and reboot requirements before deployment."
}

main "$@"
