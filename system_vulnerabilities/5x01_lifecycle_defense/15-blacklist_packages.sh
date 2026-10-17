#!/bin/bash

# Protect critical packages from unattended upgrades.

set -euo pipefail

echo "=== Package Blacklist Configuration ==="
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

packages=(
    "apache2"
    "apache2-bin"
    "mysql-server"
    "mysql-server-*"
    "nginx"
    "docker-ce"
)

# Remove any existing active blacklist block to avoid duplicates.
temp_file=$(mktemp)

awk '
    /^[[:space:]]*Unattended-Upgrade::Package-Blacklist[[:space:]]*\{/ {
        inside = 1
        next
    }

    inside {
        if ($0 ~ /^[[:space:]]*\};/) {
            inside = 0
        }
        next
    }

    { print }
' "$config" > "$temp_file"

cat >> "$temp_file" <<'EOF'

// Critical packages requiring manual review
Unattended-Upgrade::Package-Blacklist {
    "apache2";
    "apache2-bin";
    "mysql-server";
    "mysql-server-*";
    "nginx";
    "docker-ce";
};
EOF

cat "$temp_file" > "$config"
rm -f "$temp_file"

echo "Adding to Unattended-Upgrade::Package-Blacklist:"

for package in "${packages[@]}"; do
    echo "  + \"$package\""
done

echo
echo "Blacklist written to $config"
echo
echo "These packages will NOT be automatically upgraded."
echo "Manual review required for security updates."
