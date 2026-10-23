#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== SUID Neutralization ==="
echo

echo "Preserving essential SUID (DO NOT TOUCH):"
echo "  /usr/bin/sudo"
echo "  /usr/bin/passwd"
echo "  /usr/bin/su"
echo

echo "Removing SUID from non-essential binaries..."

FILES=(
    "/usr/bin/mount"
    "/usr/bin/umount"
    "/usr/bin/newgrp"
    "/usr/local/bin/backup"
)

REASONS=(
    "admin can use sudo"
    "admin can use sudo"
    "not needed"
    "CUSTOM - HIGH RISK"
)

before=$(find / -type f -perm -4000 2>/dev/null | wc -l)

for i in "${!FILES[@]}"; do
    file="${FILES[$i]}"
    reason="${REASONS[$i]}"

    if [ -f "$file" ] && [ -u "$file" ]; then
        if chmod u-s "$file"; then
            echo "  $file: SUID removed ($reason)"
        else
            echo "  $file: Failed to remove SUID"
        fi
    fi
done

echo
echo "Verification:"

for file in /usr/bin/mount /usr/bin/umount; do
    permissions=$(stat -c "%A" "$file")

    if [ -u "$file" ]; then
        echo "  $(basename "$file"): $permissions (SUID still present)"
    else
        echo "  $(basename "$file"): $permissions (no SUID)"
    fi
done

after=$(find / -type f -perm -4000 2>/dev/null | wc -l)

echo
echo "SUID binaries reduced from $before to $after."
