#!/bin/bash

set -euo pipefail

echo "=== Unattended-Upgrades Dry Run ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if ! command -v unattended-upgrade >/dev/null 2>&1; then
    echo "ERROR: unattended-upgrade is not installed."
    exit 1
fi

report=$(mktemp)
trap 'rm -f "$report"' EXIT

echo "Running simulation..."
echo

# Simulate updates without installing packages.
if ! unattended-upgrade --dry-run --debug >"$report" 2>&1; then
    echo "ERROR: Dry run failed."
    cat "$report"
    echo
    echo "Configuration validation: FAILED"
    exit 1
fi

# Extract packages selected for automatic upgrades.
mapfile -t upgrades < <(
    sed -n \
        -e 's/.*Packages that will be upgraded: //p' \
        -e 's/.*Packages that will be upgraded:$/ /p' \
        "$report" |
    tr ' ' '\n' |
    grep -E '^[a-zA-Z0-9][a-zA-Z0-9.+-]*$' |
    sort -u || true
)

echo "Packages that WOULD be upgraded:"

if [ "${#upgrades[@]}" -eq 0 ]; then
    echo "  None"
else
    for package in "${upgrades[@]}"; do
        echo "  $package (security)"
    done
fi

echo

# Show configured blacklist entries.
mapfile -t blacklist < <(
    apt-config dump |
    sed -n \
        's/^Unattended-Upgrade::Package-Blacklist:: "\(.*\)";$/\1/p'
)

echo "Packages PROTECTED by blacklist:"

if [ "${#blacklist[@]}" -eq 0 ]; then
    echo "  None"
else
    for package in "${blacklist[@]}"; do
        echo "  $package (blacklisted - manual review required)"
    done
fi

echo

# Report non-security packages identified in the dry-run log.
mapfile -t skipped < <(
    grep -Ei 'not allowed origin|not in allowed origins' "$report" |
    sort -u || true
)

echo "Packages NOT in security origin:"

if [ "${#skipped[@]}" -eq 0 ]; then
    echo "  None identified"
else
    for line in "${skipped[@]}"; do
        echo "  $line"
    done
fi

echo

# Check whether a kernel package is among planned upgrades.
reboot="NO"

for package in "${upgrades[@]}"; do
    if [[ "$package" == linux-image-* ||
          "$package" == linux-generic* ]]; then
        reboot="YES (kernel update)"
        break
    fi
done

if [ "$reboot" = "NO" ] &&
   [ -f /var/run/reboot-required ]; then
    reboot="ALREADY REQUIRED (current system)"
fi

echo "Simulation summary:"
echo "  Would upgrade: ${#upgrades[@]} packages"
echo "  Blacklist entries: ${#blacklist[@]}"
echo "  Non-security log entries: ${#skipped[@]}"
echo "  Reboot required: $reboot"
echo

echo "Configuration validation: PASSED"
