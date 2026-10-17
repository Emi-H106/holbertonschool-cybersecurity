#!/bin/bash

# Configure and enable basic unattended-upgrades functionality.

set -euo pipefail

echo "=== Unattended-Upgrades Setup ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

config="/etc/apt/apt.conf.d/20auto-upgrades"

if ! dpkg-query -W -f='${Status}' unattended-upgrades 2>/dev/null |
    grep -q "install ok installed"; then
    echo "ERROR: unattended-upgrades is not installed."
    exit 1
fi

echo "Configuring $config..."

if [ -f "$config" ]; then
    cp -p "$config" "${config}.backup.$(date +%Y%m%d%H%M%S)"
fi

cat > "$config" <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
EOF

cat "$config" | sed 's/^/  /'

echo
echo "Enabling systemd timers..."

systemctl enable --now apt-daily.timer
systemctl enable --now apt-daily-upgrade.timer

if systemctl is-enabled --quiet apt-daily.timer; then
    echo "  apt-daily.timer: Enabled"
else
    echo "  apt-daily.timer: FAILED"
    exit 1
fi

if systemctl is-enabled --quiet apt-daily-upgrade.timer; then
    echo "  apt-daily-upgrade.timer: Enabled"
else
    echo "  apt-daily-upgrade.timer: FAILED"
    exit 1
fi

echo
echo "Verification:"

update_setting=$(apt-config shell Value \
    APT::Periodic::Update-Package-Lists | awk -F"'" '{print $2}')

upgrade_setting=$(apt-config shell Value \
    APT::Periodic::Unattended-Upgrade | awk -F"'" '{print $2}')

if [ "$update_setting" = "1" ] &&
    [ "$upgrade_setting" = "1" ] &&
    systemctl is-active --quiet apt-daily.timer &&
    systemctl is-active --quiet apt-daily-upgrade.timer; then
    echo "  Unattended-upgrades: ACTIVE"
else
    echo "  Unattended-upgrades: INACTIVE"
    exit 1
fi

next_run=$(systemctl list-timers apt-daily-upgrade.timer \
    --no-pager --no-legend |
    awk 'NR==1 {print $1, $2, $3, $4}')

if [ -n "$next_run" ]; then
    echo "  Next scheduled run: $next_run"
else
    echo "  Next scheduled run: Not available"
fi

echo
echo "Basic setup complete."
