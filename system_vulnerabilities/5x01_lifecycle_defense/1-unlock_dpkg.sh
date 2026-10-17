#!/bin/bash

# Safely remove stale APT/DPKG lock files.

echo "=== DPKG Unlock Procedure ==="
echo

locks=(
    /var/lib/dpkg/lock-frontend
    /var/lib/dpkg/lock
    /var/lib/apt/lists/lock
    /var/cache/apt/archives/lock
)

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Checking for active package operations..."

apt_processes=$(pgrep -a -x apt 2>/dev/null)
dpkg_processes=$(pgrep -a -x dpkg 2>/dev/null)

if [ -n "$apt_processes" ]; then
    echo "  apt processes: Active"
    printf '%s\n' "$apt_processes"
else
    echo "  apt processes: None"
fi

if [ -n "$dpkg_processes" ]; then
    echo "  dpkg processes: Active"
    printf '%s\n' "$dpkg_processes"
else
    echo "  dpkg processes: None"
fi

if [ -n "$apt_processes" ] || [ -n "$dpkg_processes" ]; then
    echo "ERROR: Package operations are running."
    echo "Lock files will not be removed."
    exit 1
fi

if ! command -v fuser >/dev/null 2>&1; then
    echo "ERROR: fuser is required to verify lock ownership."
    exit 1
fi

for lock in "${locks[@]}"; do
    if [ -e "$lock" ] && fuser "$lock" >/dev/null 2>&1; then
        echo "ERROR: Lock is currently in use: $lock"
        echo "No lock files will be removed."
        exit 1
    fi
done

echo
echo "Removing stale lock files..."

for lock in "${locks[@]}"; do
    if [ -e "$lock" ]; then
        if rm -- "$lock"; then
            echo "  $lock: Removed"
        else
            echo "  $lock: Failed to remove"
            exit 1
        fi
    else
        echo "  $lock: Already absent"
    fi
done

echo
echo "Verification:"

for lock in "${locks[@]}"; do
    if [ -e "$lock" ]; then
        echo "  Package operations: LOCKED"
        exit 1
    fi
done

echo "  Package operations: UNLOCKED"
echo
echo "DPKG unlocked successfully."
