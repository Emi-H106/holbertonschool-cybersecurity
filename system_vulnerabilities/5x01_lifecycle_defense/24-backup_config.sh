#!/bin/bash

set -euo pipefail

echo "=== Configuration Backup ==="
echo

# Require root privileges.
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

backup_dir="/var/backups"
timestamp=$(date +%Y%m%d-%H%M%S)
archive="$backup_dir/patch-config-$timestamp.tar.gz"

mkdir -p "$backup_dir"

echo "Collecting configuration files..."

# Configuration paths to back up.
config_paths=(
    "/etc/apt/apt.conf.d/20auto-upgrades"
    "/etc/apt/apt.conf.d/50unattended-upgrades"
    "/etc/apt/sources.list"
    "/etc/apt/sources.list.d"
    "/etc/systemd/system/apt-daily.timer.d"
    "/etc/systemd/system/apt-daily-upgrade.timer.d"
    "/var/log/package_holds.log"
)

existing_paths=()

for path in "${config_paths[@]}"; do
    if [ -e "$path" ]; then
        existing_paths+=("$path")
        echo "  $path"
    else
        echo "  [SKIPPED] $path (not found)"
    fi
done

if [ "${#existing_paths[@]}" -eq 0 ]; then
    echo "ERROR: No configuration files found."
    exit 1
fi

echo
echo "Creating archive..."

# Use relative paths inside the archive.
tar -czf "$archive" -C / "${existing_paths[@]/#\//}"

chmod 600 "$archive"

echo "  $archive"
echo

echo "Archive contents:"

file_count=$(tar -tzf "$archive" | grep -vc '/$' || true)
archive_size=$(du -h "$archive" | awk '{print $1}')

echo "  $file_count files, $archive_size total"
echo

checksum=$(sha256sum "$archive" | awk '{print $1}')

echo "SHA256: $checksum"
echo

# Verify archive integrity.
if tar -tzf "$archive" > /dev/null; then
    echo "Backup complete."
else
    echo "ERROR: Archive verification failed."
    exit 1
fi
