#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Blocking ICMP Redirects ==="
echo

echo "Disabling redirect acceptance..."

ACCEPT_PARAMS=(
    net.ipv4.conf.all.accept_redirects
    net.ipv4.conf.default.accept_redirects
    net.ipv6.conf.all.accept_redirects
    net.ipv6.conf.default.accept_redirects
)

for param in "${ACCEPT_PARAMS[@]}"; do
    sysctl -w "$param=0" >/dev/null
    echo "  $(sysctl "$param")"
done

echo
echo "Disabling redirect sending..."

SEND_PARAMS=(
    net.ipv4.conf.all.send_redirects
    net.ipv4.conf.default.send_redirects
)

for param in "${SEND_PARAMS[@]}"; do
    sysctl -w "$param=0" >/dev/null
    echo "  $(sysctl "$param")"
done

touch "$CONFIG_FILE"

for param in "${ACCEPT_PARAMS[@]}" "${SEND_PARAMS[@]}"; do
    sed -i "\|^[[:space:]]*$param[[:space:]]*=|d" "$CONFIG_FILE"
    echo "$param = 0" >> "$CONFIG_FILE"
done

echo
echo "Configuration saved to $CONFIG_FILE"
echo

ALL_DISABLED=true

for param in "${ACCEPT_PARAMS[@]}" "${SEND_PARAMS[@]}"; do
    if [ "$(sysctl -n "$param")" != "0" ]; then
        ALL_DISABLED=false
    fi
done

if [ "$ALL_DISABLED" = true ]; then
    echo "ICMP redirects: BLOCKED"
else
    echo "ICMP redirects: NOT FULLY BLOCKED"
    exit 1
fi
