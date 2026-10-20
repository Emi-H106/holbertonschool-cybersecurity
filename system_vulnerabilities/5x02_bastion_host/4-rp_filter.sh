#!/bin/bash
set -e

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Enabling Reverse Path Filtering ==="
echo

echo "Setting strict mode (1) for all interfaces..."

PARAMS=(
    net.ipv4.conf.all.rp_filter
    net.ipv4.conf.default.rp_filter
)

for param in "${PARAMS[@]}"; do
    sysctl -w "$param=1" >/dev/null
    echo "  $(sysctl "$param")"
done

touch "$CONFIG_FILE"

for param in "${PARAMS[@]}"; do
    sed -i "\|^[[:space:]]*${param//./\\.}[[:space:]]*=|d" "$CONFIG_FILE"
    echo "$param = 1" >> "$CONFIG_FILE"
done

echo
echo "Configuration saved to $CONFIG_FILE"
echo

ALL_STRICT=true

for param in "${PARAMS[@]}"; do
    if [ "$(sysctl -n "$param")" != "1" ]; then
        ALL_STRICT=false
    fi
done

if [ "$ALL_STRICT" = true ]; then
    echo "Reverse path filtering: STRICT MODE"
    echo "Spoofed packets will be dropped."
else
    echo "Reverse path filtering: NOT FULLY ENABLED"
    exit 1
fi
