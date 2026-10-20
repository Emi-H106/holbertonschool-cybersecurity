#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"
PARAM="net.ipv4.tcp_syncookies"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Enabling SYN Cookies ==="
echo

echo "Current state:"
echo "  $(sysctl "$PARAM")"
echo

echo "Enabling SYN cookies..."
sysctl -w "$PARAM=1" >/dev/null
echo "  $(sysctl "$PARAM")"
echo

touch "$CONFIG_FILE"

sed -i '/^[[:space:]]*net\.ipv4\.tcp_syncookies[[:space:]]*=/d' "$CONFIG_FILE"
echo "$PARAM = 1" >> "$CONFIG_FILE"

echo "Configuration saved to $CONFIG_FILE"
echo

if [ "$(sysctl -n "$PARAM")" = "1" ]; then
    echo "SYN flood protection: ENABLED"
else
    echo "SYN flood protection: DISABLED"
    exit 1
fi
