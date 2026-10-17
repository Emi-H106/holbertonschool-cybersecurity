#!/bin/bash

# Remediate known file permission and credential exposure issues.

set -euo pipefail

echo "=== Permission Remediation ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

get_mode() {
    stat -c '%a' "$1"
}

format_mode() {
    printf '%04d' "$1"
}

echo "SUID/SGID issues:"

file="/usr/local/bin/backup"

if [ -f "$file" ]; then
    old_mode=$(get_mode "$file")
    chmod u-s,g-s "$file"
    new_mode=$(get_mode "$file")

    echo "  $file: SUID/SGID removed (was $old_mode, now $new_mode)"
else
    echo "  $file: Not found"
fi

echo
echo "World-writable files:"

for file in \
    /etc/cron.daily/backup.sh \
    /opt/scripts/cleanup.sh
do
    if [ -f "$file" ]; then
        old_mode=$(get_mode "$file")
        chmod o-w,g-w "$file"
        new_mode=$(get_mode "$file")

        echo "  $file: $old_mode -> $new_mode"
    else
        echo "  $file: Not found"
    fi
done

echo
echo "Sensitive file permissions:"

file="/var/www/html/config.php"

if [ -f "$file" ]; then
    old_mode=$(get_mode "$file")
    chown www-data:www-data "$file"
    chmod 640 "$file"

    echo "  $file: $old_mode -> 0640 (owner www-data)"
else
    echo "  $file: Not found"
fi

file="/home/devops/.ssh/id_rsa"

if [ -f "$file" ]; then
    old_mode=$(get_mode "$file")
    chown devops:devops "$file"
    chmod 600 "$file"

    echo "  $file: $old_mode -> 0600"
else
    echo "  $file: Not found"
fi

echo
echo "Credential exposure:"

source_file="/var/www/html/.env"
target_dir="/etc/novatech"
target_file="$target_dir/app.env"

if [ -f "$source_file" ] && [ ! -L "$source_file" ]; then
    mkdir -p "$target_dir"
    chmod 750 "$target_dir"

    if [ -e "$target_file" ]; then
        echo "ERROR: $target_file already exists."
        exit 1
    fi

    mv "$source_file" "$target_file"
    chown root:www-data "$target_file"
    chmod 640 "$target_file"

    ln -s "$target_file" "$source_file"

    echo "  $source_file: Moved to $target_file"
    echo "  Symlink created for application compatibility"

elif [ -L "$source_file" ]; then
    echo "  $source_file: Already a symlink"

else
    echo "  $source_file: Not found"
fi

echo
echo "All permission issues remediated."
