#!/bin/bash

set -euo pipefail

echo "=== Package Rollback ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run with sudo."
    exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <package> <version>"
    exit 1
fi

package="$1"
target_version="$2"

# Validate arguments.
if [[ ! "$package" =~ ^[a-zA-Z0-9][a-zA-Z0-9.+-]*$ ]] ||
   [[ ! "$target_version" =~ ^[a-zA-Z0-9][a-zA-Z0-9.+:~_-]*$ ]]; then
    echo "ERROR: Invalid package name or version."
    exit 1
fi

current_version=$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null) || {
    echo "ERROR: Package is not installed."
    exit 1
}

echo "Target: $package"
echo "Current: $current_version"
echo "Rollback to: $target_version"
echo

if [ "$current_version" = "$target_version" ]; then
    echo "Package is already at the requested version."
    exit 0
fi

if ! dpkg --compare-versions "$current_version" gt "$target_version"; then
    echo "ERROR: Target version is not older than installed version."
    exit 1
fi

echo "Checking version availability..."

if ! apt-cache madison "$package" |
    awk '{print $3}' |
    grep -Fxq "$target_version"; then
    echo "  Version $target_version not found in apt cache."
    echo "Rollback cannot continue."
    exit 1
fi

echo "  Version $target_version found in apt cache."
echo

echo "Creating rollback backup..."

backup_dir="/root/package-rollbacks"
snapshot_id="pre-rollback-$(date +%Y%m%d-%H%M%S)"
backup_path="$backup_dir/$snapshot_id"

mkdir -p "$backup_path"
chmod 700 "$backup_path"

dpkg --get-selections > "$backup_path/package-selections.txt"
dpkg-query -W > "$backup_path/installed-versions.txt"

printf '%s\n' \
    "Package: $package" \
    "Previous version: $current_version" \
    "Target version: $target_version" \
    > "$backup_path/rollback-info.txt"

echo "  Backup ID: $snapshot_id"
echo "  Backup location: $backup_path"
echo "  Note: This is not a full system snapshot."
echo

echo "Simulating downgrade..."

if ! apt-get -s install --allow-downgrades \
    "$package=$target_version"; then
    echo "ERROR: Downgrade simulation failed."
    exit 1
fi

echo
read -r -p "Proceed with actual downgrade? [y/N]: " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Rollback cancelled."
    exit 0
fi

echo
echo "Performing downgrade..."

apt-get install -y --allow-downgrades \
    "$package=$target_version"

echo
echo "Verification:"

installed_version=$(dpkg-query -W -f='${Version}' "$package")

echo "  Installed version: $installed_version"

if [ "$installed_version" = "$target_version" ]; then
    echo "  Downgrade: SUCCESSFUL"
else
    echo "  Downgrade: FAILED"
    exit 1
fi

echo
echo "Application testing:"
echo "  Manual application verification required."
echo
echo "Rollback complete."
