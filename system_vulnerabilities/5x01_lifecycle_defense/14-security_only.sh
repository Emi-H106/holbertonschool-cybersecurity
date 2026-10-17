#!/bin/bash

# Configure unattended-upgrades to allow security updates only.

set -euo pipefail

echo "=== Security-Only Configuration ==="
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

# Disable existing Allowed-Origins and Origins-Pattern blocks.
# Preserve all unrelated configuration settings.
temp_file=$(mktemp)

awk '
    /^[[:space:]]*Unattended-Upgrade::(Allowed-Origins|Origins-Pattern)[[:space:]]*\{/ {
        inside = 1
        print "// " $0
        next
    }

    inside {
        print "// " $0
        if ($0 ~ /^[[:space:]]*\};/) {
            inside = 0
        }
        next
    }

    { print }
' "$config" > "$temp_file"

cat >> "$temp_file" <<'EOF'

// Security-only allowed origins
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
EOF

cat "$temp_file" > "$config"
rm -f "$temp_file"

echo "Allowed-Origins:"
echo '  [ENABLED]  "${distro_id}:${distro_codename}-security"'
echo '  [ENABLED]  "${distro_id}ESMApps:${distro_codename}-apps-security"'
echo '  [ENABLED]  "${distro_id}ESM:${distro_codename}-infra-security"'
echo '  [DISABLED] "${distro_id}:${distro_codename}-updates"'
echo '  [DISABLED] "${distro_id}:${distro_codename}-backports"'

echo
echo "Security-only filter applied."
echo "Only security updates will be installed automatically."
