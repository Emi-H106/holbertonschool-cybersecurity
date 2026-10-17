#!/bin/bash

set -euo pipefail

echo "=== Maintenance Window Configuration ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Configuring systemd timer overrides..."
echo

# Configure apt-daily.timer
mkdir -p /etc/systemd/system/apt-daily.timer.d

cat > /etc/systemd/system/apt-daily.timer.d/override.conf <<'EOF'
[Timer]
OnCalendar=
OnCalendar=*-*-* 02:00
RandomizedDelaySec=30min
EOF

echo "apt-daily.timer:"
echo "  OnCalendar: *-*-* 02:00"
echo "  RandomizedDelaySec: 30min"
echo

# Configure apt-daily-upgrade.timer
mkdir -p /etc/systemd/system/apt-daily-upgrade.timer.d

cat > /etc/systemd/system/apt-daily-upgrade.timer.d/override.conf <<'EOF'
[Timer]
OnCalendar=
OnCalendar=*-*-* 03:00
RandomizedDelaySec=60min
EOF

echo "apt-daily-upgrade.timer:"
echo "  OnCalendar: *-*-* 03:00"
echo "  RandomizedDelaySec: 60min"
echo

echo "Timer configuration:"
echo "  Package list update: 02:00-02:30"
echo "  Package installation: 03:00-04:00"
echo

echo "Reloading systemd..."

systemctl daemon-reload
systemctl restart apt-daily.timer
systemctl restart apt-daily-upgrade.timer

echo "Maintenance window configured."
