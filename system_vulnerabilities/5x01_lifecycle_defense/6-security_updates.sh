#!/bin/bash

# Apply security updates without performing a general upgrade.

set -euo pipefail

echo "=== Security Updates ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Fetching security update list..."
echo "Source: focal-security"
echo

security_source="/etc/apt/sources.list.d/security-only-temp.list"
preferences_file="/etc/apt/preferences.d/security-only-temp"

cleanup() {
    rm -f "$security_source" "$preferences_file"
}
trap cleanup EXIT

cat > "$security_source" <<'EOF'
deb http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse
EOF

cat > "$preferences_file" <<'EOF'
Package: *
Pin: release a=focal-security
Pin-Priority: 990

Package: *
Pin: release a=focal-updates
Pin-Priority: 100
EOF

apt-get update -qq

mapfile -t packages < <(
    apt list --upgradable 2>/dev/null |
    awk -F/ '/focal-security/ {print $1}' |
    sort -u
)

count=${#packages[@]}

echo "Available security updates: $count packages"

for package in "${packages[@]}"; do
    installed=$(dpkg-query -W \
        -f='${Version}' "$package" 2>/dev/null || true)

    candidate=$(apt-cache policy "$package" |
        awk '/Candidate:/ {print $2}')

    echo "  $package ($installed -> $candidate)"
done

echo

if [ "$count" -gt 0 ]; then
    echo "Applying security updates..."

    DEBIAN_FRONTEND=noninteractive apt-get install \
        --only-upgrade -y "${packages[@]}"

    echo "  Security update operation completed."
else
    echo "No security updates available."
fi

echo
echo "Verification:"

if dpkg-query -W -f='${Version}' apache2 \
    >/dev/null 2>&1; then
    apache_version=$(dpkg-query -W \
        -f='${Version}' apache2)
    echo "  apache2: $apache_version (installed)"
fi

apt-get update -qq

pending=$(apt list --upgradable 2>/dev/null |
    awk -F/ '/focal-security/ {count++}
             END {print count+0}')

echo "  Pending security updates: $pending"
echo

if [ "$pending" -eq 0 ]; then
    echo "Security updates applied successfully."
else
    echo "WARNING: Some security updates are still pending."
    exit 1
fi
