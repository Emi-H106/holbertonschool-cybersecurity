#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Disabling IP Forwarding ==="
echo

echo "Current state:"
echo "  $(sysctl net.ipv4.ip_forward)"
echo "  $(sysctl net.ipv6.conf.all.forwarding)"
echo

echo "Applying changes..."
sysctl -w net.ipv4.ip_forward=0 >/dev/null
sysctl -w net.ipv6.conf.all.forwarding=0 >/dev/null
echo "  $(sysctl net.ipv4.ip_forward)"
echo "  $(sysctl net.ipv6.conf.all.forwarding)"
echo

echo "Making persistent in $CONFIG_FILE..."

touch "$CONFIG_FILE"

sed -i '/^[[:space:]]*net\.ipv4\.ip_forward[[:space:]]*=/d' "$CONFIG_FILE"
sed -i '/^[[:space:]]*net\.ipv6\.conf\.all\.forwarding[[:space:]]*=/d' "$CONFIG_FILE"

cat >> "$CONFIG_FILE" <<EOF
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
EOF

echo
echo "Verification:"

if [ "$(sysctl -n net.ipv4.ip_forward)" = "0" ]; then
    echo "  IPv4 forwarding: DISABLED"
else
    echo "  IPv4 forwarding: ENABLED"
fi

if [ "$(sysctl -n net.ipv6.conf.all.forwarding)" = "0" ]; then
    echo "  IPv6 forwarding: DISABLED"
else
    echo "  IPv6 forwarding: ENABLED"
fi
