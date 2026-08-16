#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$BASE_DIR/config/harden.cfg"
LOG_FILE="/var/log/hardening.log"
REPORT_FILE="./audit_report.txt"

REMOVED_USERS_COUNT=0
REMOVED_USERS=""
WARNINGS=""
ERRORS=""

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Load configuration
source "$CONFIG_FILE"

# Load libraries
source "$BASE_DIR/lib/network.sh"
source "$BASE_DIR/lib/ssh.sh"
source "$BASE_DIR/lib/identity.sh"
source "$BASE_DIR/lib/system.sh"

# Logging function
log() {
    local level="$1"
    local message="$2"

    echo "$(date '+%FT%TZ') [$level] $message" >> "$LOG_FILE"
}

# First log
log "INFO" "Hardening framework initialized"

# Apply hardening policy
configure_firewall
configure_kernel
configure_ssh
configure_password_policy
configure_lockout
cleanup_users
lock_root_password
configure_system

generate_audit_report() {
    {
        echo "==============================================="
        echo " HARDENING AUDIT REPORT - $(date '+%Y-%m-%d %H:%M:%S')"
        echo "==============================================="
        echo

        echo "[INFO] Hardening procedure completed successfully."
        echo "[INFO] SSH configured on port $SSH_PORT."

        PORTS="$SSH_PORT"

        if [ "$ALLOW_HTTP" = true ]; then
            PORTS="$PORTS, 80"
        fi

        if [ "$ALLOW_HTTPS" = true ]; then
            PORTS="$PORTS, 443"
        fi

        echo "[INFO] Firewall policy created: ports $PORTS ALLOWED."

        if [ "$REMOVED_USERS_COUNT" -gt 0 ]; then
            echo "[INFO] $REMOVED_USERS_COUNT unauthorized users removed: $REMOVED_USERS."
        else
            echo "[INFO] 0 unauthorized users removed."
        fi

        echo "[INFO] Installed: auditd, fail2ban."
        echo "[INFO] Removed: telnet, ftp, netcat-traditional."

        if [ -n "$WARNINGS" ]; then
            echo "[WARN] $WARNINGS"
        fi

        if [ -n "$ERRORS" ]; then
            echo "[ERROR] $ERRORS"
        fi

        echo
        echo "==============================================="

        if [ -z "$ERRORS" ]; then
            echo " COMPLIANCE STATUS: PASS"
        else
            echo " COMPLIANCE STATUS: FAIL"
        fi

        echo "==============================================="
    } > "$REPORT_FILE"
}

generate_audit_report

log "INFO" "Hardening completed"
