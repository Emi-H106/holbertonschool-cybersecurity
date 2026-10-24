#!/bin/bash
# NovaTech - fail2ban Management
# Manage SSH jail status and banned IP addresses.

set -Eeuo pipefail

JAIL="sshd"

usage() {
    echo "Usage:"
    echo "  $0 status"
    echo "  $0 banned"
    echo "  $0 unban <IP_ADDRESS>"
    exit 1
}

# Check root privileges.
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Check arguments.
if [[ $# -lt 1 ]]; then
    usage
fi

# Check fail2ban installation.
if ! command -v fail2ban-client >/dev/null 2>&1; then
    echo "ERROR: fail2ban is not installed."
    exit 1
fi

# Check service status.
if ! systemctl is-active --quiet fail2ban; then
    echo "ERROR: fail2ban service is not running."
    exit 1
fi

# Validate command before dispatching.
if [ "$1" != "status" ] &&
   [ "$1" != "banned" ] &&
   [ "$1" != "unban" ]; then
    usage
fi

if [ $1 == "status" ]; then

    if [[ $# -ne 1 ]]; then
        usage
    fi

    echo "=== fail2ban Status ==="
    echo
    echo "Service: Active"

    echo
    fail2ban-client status

    echo
    echo "[$JAIL] Statistics:"

    if fail2ban-client status sshd; then
        echo
        echo "fail2ban monitoring: ACTIVE"
    else
        echo "ERROR: Jail $JAIL not found."
        exit 1
    fi

elif [ $1 == "banned" ]; then

    if [[ $# -ne 1 ]]; then
        usage
    fi

    echo "=== Banned IPs ==="
    echo
    echo "Jail: $JAIL"

    # Get banned IP addresses.
    banned_ips=$(fail2ban-client get "$JAIL" banip)

    if [[ -z "$banned_ips" ]]; then
        echo "  No banned IP addresses."
    else
        for ip in $banned_ips; do
            echo "  $ip"
        done
    fi

elif [ $1 == "unban" ]; then

    if [[ $# -ne 2 ]]; then
        usage
    fi

    IP="$2"

    # Validate IPv4 address.
    if [[ ! "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "ERROR: Invalid IPv4 address."
        exit 1
    fi

    IFS='.' read -r a b c d <<< "$IP"

    for octet in "$a" "$b" "$c" "$d"; do
        if (( 10#$octet > 255 )); then
            echo "ERROR: Invalid IPv4 address."
            exit 1
        fi
    done

    # Check whether IP is banned.
    banned_ips=$(fail2ban-client get "$JAIL" banip)

    if ! grep -Fxq "$IP" <(
        printf '%s\n' $banned_ips
    ); then
        echo "IP $IP is not currently banned."
        exit 0
    fi

    # Unban the IP address.
    fail2ban-client set "$JAIL" unbanip "$IP"

    echo "IP $IP unbanned from jail $JAIL"

else
    usage
fi
