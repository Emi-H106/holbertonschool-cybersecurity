#!/bin/bash

set -euo pipefail

echo "=== Automatic Reboot Policy ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

config="/etc/apt/apt.conf.d/50unattended-upgrades"
backup_dir="/root/apt-config-backups"

if [ ! -f "$config" ]; then
    echo "ERROR: Configuration file not found: $config"
    exit 1
fi

mkdir -p "$backup_dir"
chmod 700 "$backup_dir"

cp -p "$config" \
    "$backup_dir/50unattended-upgrades.$(date +%Y%m%d%H%M%S).bak"

echo "Configuring $config..."
echo

# Remove existing active reboot settings to avoid duplicates.
sed -i -E \
    '/^[[:space:]]*Unattended-Upgrade::Automatic-Reboot[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::Automatic-Reboot-Time[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::Automatic-Reboot-WithUsers[[:space:]]/d' \
    "$config"

# Add the required reboot policy.
cat >> "$config" <<'EOF'

// Automatic reboot policy
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
EOF

echo "Reboot settings:"
echo '  Automatic-Reboot: "true"'
echo '  Automatic-Reboot-Time: "04:00"'
echo '  Automatic-Reboot-WithUsers: "false"'
echo

echo "Additional safeguards:"
echo "  Reboot only when required (kernel/libc updates)"
echo "  Skip reboot if users are logged in"
echo

echo "Reboot policy configured."
echo "System will auto-reboot at 04:00 when required."
