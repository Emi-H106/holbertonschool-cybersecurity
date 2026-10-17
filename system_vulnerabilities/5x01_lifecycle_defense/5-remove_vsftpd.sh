#!/bin/bash

# Remove the vulnerable vsftpd FTP service and its configuration.

set -euo pipefail

echo "=== Vulnerable Service Removal ==="
echo
echo "Target: vsftpd (CVE-2011-2523 - Backdoor)"
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Stopping service..."

if systemctl list-unit-files vsftpd.service --no-legend 2>/dev/null |
    grep -q '^vsftpd.service'; then
    systemctl stop vsftpd
    systemctl disable vsftpd >/dev/null 2>&1 || true
    echo "  vsftpd.service: Stopped"
else
    echo "  vsftpd.service: Not present"
fi

echo
echo "Removing package..."

if dpkg-query -W -f='${Status}' vsftpd 2>/dev/null |
    grep -q 'install ok installed'; then
    DEBIAN_FRONTEND=noninteractive apt-get purge -y vsftpd
    echo "  vsftpd: Purged (including config files)"
else
    echo "  vsftpd: Already removed"
fi

echo
echo "Cleanup..."

config_files=(
    /etc/vsftpd.conf
    /etc/vsftpd.user_list
)

for file in "${config_files[@]}"; do
    if [ -e "$file" ]; then
        rm -f -- "$file"
        echo "  $file: Removed"
    else
        echo "  $file: Already absent"
    fi
done

echo
echo "Verification:"

if dpkg-query -W -f='${Status}' vsftpd 2>/dev/null |
    grep -q 'install ok installed'; then
    echo "  Package status: Still installed"
    exit 1
else
    echo "  Package status: Not installed"
fi

if ss -ltnH '( sport = :21 )' | grep -q .; then
    echo "  Port 21: LISTENING"
    exit 1
else
    echo "  Port 21: Not listening"
fi

echo
echo "vsftpd removed successfully."
echo "Vulnerability CVE-2011-2523: REMEDIATED"
