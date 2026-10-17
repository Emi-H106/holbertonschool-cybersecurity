#!/bin/bash

set -euo pipefail

echo "=== Notification Configuration ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

config="/etc/apt/apt.conf.d/50unattended-upgrades"
backup_dir="/root/apt-config-backups"
log_dir="/var/log/unattended-upgrades"

if [ ! -f "$config" ]; then
    echo "ERROR: Configuration file not found: $config"
    exit 1
fi

# Back up existing configuration.
mkdir -p "$backup_dir"
chmod 700 "$backup_dir"

cp -p "$config" \
    "$backup_dir/50unattended-upgrades.$(date +%Y%m%d%H%M%S).bak"

# Remove existing active notification settings.
sed -i -E \
    '/^[[:space:]]*Unattended-Upgrade::Mail[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::MailOnlyOnError[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::MailReport[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::SyslogEnable[[:space:]]/d;
     /^[[:space:]]*Unattended-Upgrade::SyslogFacility[[:space:]]/d' \
    "$config"

# Configure email notifications and syslog.
cat >> "$config" <<'EOF'

// Audit trail: email notifications
Unattended-Upgrade::Mail "root";
Unattended-Upgrade::MailOnlyOnError "false";
Unattended-Upgrade::MailReport "on-change";

// Audit trail: syslog
Unattended-Upgrade::SyslogEnable "true";
Unattended-Upgrade::SyslogFacility "daemon";
EOF

# Ensure the log directory exists.
mkdir -p "$log_dir"
chmod 755 "$log_dir"

echo "Email settings:"
echo '  Mail::OnlyOnError: "false"'
echo '  Mail::Report: "on-change"'
echo "  Recipient: root (local delivery)"
echo

echo "Logging settings:"
echo '  Syslog::Enable: "true"'
echo '  Syslog::Facility: "daemon"'
echo

echo "Log locations:"
echo "  $log_dir/unattended-upgrades.log"
echo "  $log_dir/unattended-upgrades-dpkg.log"
echo

echo "Notification system configured."
echo "All update activity will be logged and reported."
