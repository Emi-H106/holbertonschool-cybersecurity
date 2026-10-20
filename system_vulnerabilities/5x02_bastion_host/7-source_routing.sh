#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Blocking Source Routing ==="
echo

echo "Disabling source route acceptance..."

PARAMS=(
    net.ipv4.conf.all.accept_source_route
    net.ipv4.conf.default.accept_source_route
    net.ipv6.conf.all.accept_source_route
    net.ipv6.conf.default.accept_source_route
)

for param in "${PARAMS[@]}"; do
    sysctl -w "$param=0" >/dev/null
    echo "  $(sysctl "$param")"
done

touch "$CONFIG_FILE"

for param in "${PARAMS[@]}"; do
    sed -i "\|^[[:space:]]*${param//./\\.}[[:space:]]*=|d" "$CONFIG_FILE"
    echo "$param = 0" >> "$CONFIG_FILE"
done

echo
echo "Configuration saved to $CONFIG_FILE"
echo

ALL_BLOCKED=true

for param in "${PARAMS[@]}"; do
    if [ "$(sysctl -n "$param")" != "0" ]; then
        ALL_BLOCKED=false
    fi
done

if [ "$ALL_BLOCKED" = true ]; then
    echo "Source-routed packets: BLOCKED"
else
    echo "Source-routed packets: NOT FULLY BLOCKED"
    exit 1
fi
