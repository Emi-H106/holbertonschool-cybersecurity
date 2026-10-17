#!/bin/bash

set -euo pipefail

echo "=== Package Hold ==="
echo

# Check root privileges.
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Check arguments: $1 = package, $2 = reason
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <package> <reason>"
    exit 1
fi

package="$1"
reason="$2"
log_file="/var/log/package_holds.log"

# Validate package name.
if [[ ! "$package" =~ ^[a-zA-Z0-9][a-zA-Z0-9.+-]*$ ]]; then
    echo "ERROR: Invalid package name."
    exit 1
fi

if [ -z "$reason" ]; then
    echo "ERROR: Hold reason cannot be empty."
    exit 1
fi

# Check installed package version.
current_version=$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null) || {
    echo "ERROR: Package is not installed."
    exit 1
}

echo "Package: $package"
echo "Current version: $current_version"
echo

echo "Placing hold..."

apt-mark hold "$package"

echo "  apt-mark hold $package: Done"
echo

echo "Logging hold reason..."

# Protect the log file.
touch "$log_file"
chmod 600 "$log_file"

timestamp=$(date '+%Y-%m-%d %H:%M:%S')
review_date=$(date -d '+30 days' '+%Y-%m-%d')

printf '%s | Package: %s | Version: %s | Reason: %s | Review by: %s\n' \
    "$timestamp" "$package" "$current_version" "$reason" "$review_date" \
    >> "$log_file"

echo "  $log_file updated"
echo

echo "Hold verification:"

if apt-mark showhold | grep -Fxq "$package"; then
    echo "  $package set on hold."
else
    echo "ERROR: Package hold verification failed."
    exit 1
fi

echo

echo "WARNING: This package will NOT receive automatic updates."
echo "         Including security updates."
echo "         Review required within 30 days."
echo

echo "Hold applied successfully."
