#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== ICMP Configuration ==="
echo

echo "Disabling broadcast ping response (Smurf prevention)..."
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 >/dev/null
echo "  $(sysctl net.ipv4.icmp_echo_ignore_broadcasts)"
echo

echo "Keeping unicast ping enabled for diagnostics."
sysctl -w net.ipv4.icmp_echo_ignore_all=0 >/dev/null
echo "  $(sysctl net.ipv4.icmp_echo_ignore_all)"
echo

echo "Ignoring bogus ICMP error responses..."
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1 >/dev/null
echo "  $(sysctl net.ipv4.icmp_ignore_bogus_error_responses)"
echo

touch "$CONFIG_FILE"

PARAMS=(
    net.ipv4.icmp_echo_ignore_broadcasts
    net.ipv4.icmp_echo_ignore_all
    net.ipv4.icmp_ignore_bogus_error_responses
)

for param in "${PARAMS[@]}"; do
    sed -i "\|^[[:space:]]*${param//./\\.}[[:space:]]*=|d" "$CONFIG_FILE"
done

# Security decision:
# Block broadcast ping responses to reduce Smurf attack risk.
# Keep unicast ping available for network diagnostics.
# Ignore bogus ICMP error responses.

cat >> "$CONFIG_FILE" <<EOF
# ICMP hardening: block broadcast ping, allow unicast diagnostics
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
EOF

echo "Configuration saved to $CONFIG_FILE"
echo

if [ "$(sysctl -n net.ipv4.icmp_echo_ignore_broadcasts)" = "1" ] &&
   [ "$(sysctl -n net.ipv4.icmp_echo_ignore_all)" = "0" ] &&
   [ "$(sysctl -n net.ipv4.icmp_ignore_bogus_error_responses)" = "1" ]; then
    echo "Broadcast ping: DISABLED"
    echo "Unicast ping: ENABLED"
else
    echo "ICMP configuration: FAILED"
    exit 1
fi
