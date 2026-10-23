#!/bin/bash

TOOLS=("nc" "ncat" "nmap" "tcpdump")

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Network Tools Restriction ==="
echo
echo "Restricting access (root only)..."

for tool in "${TOOLS[@]}"; do
    binary=$(command -v "$tool")

    if [ -n "$binary" ]; then
        binary=$(readlink -f "$binary")
        old_perm=$(stat -c "%a" "$binary")

        chown root:root "$binary"
        chmod 750 "$binary"

        new_perm=$(stat -c "%a" "$binary")

        echo "  $binary: 0$new_perm (was 0$old_perm)"
    fi
done

echo
echo "Verification:"

for tool in nc nmap tcpdump; do
    binary=$(command -v "$tool")

    if [ -n "$binary" ]; then
        binary=$(readlink -f "$binary")
        permissions=$(stat -c "%A %U %G" "$binary")
        echo "  $tool: $permissions"
    else
        echo "  $tool: Not found"
    fi
done

echo
echo "Network tools restricted to root."
echo "Regular users can no longer execute these binaries."
