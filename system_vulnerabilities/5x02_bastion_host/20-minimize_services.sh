#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Service Minimization ==="
echo

echo "Checking for unnecessary services..."
echo

SERVICES=(
    "cups.service"
    "avahi-daemon.service"
    "bluetooth.service"
)

DESCRIPTIONS=(
    "Printing"
    "mDNS"
    "Bluetooth"
)

REASONS=(
    "Not needed on web server"
    "Not needed on web server"
    "Not needed on server"
)

echo "Unnecessary services found:"

for i in "${!SERVICES[@]}"; do
    service="${SERVICES[$i]}"
    description="${DESCRIPTIONS[$i]}"
    reason="${REASONS[$i]}"

    if systemctl list-unit-files --type=service --no-legend |
       grep -q "^${service} "; then
        echo "  $service ($description) - $reason"
    fi
done

echo
echo "Disabling services..."

for service in "${SERVICES[@]}"; do
    if systemctl list-unit-files --type=service --no-legend |
       grep -q "^${service} "; then

        if systemctl disable --now "$service" >/dev/null 2>&1; then
            echo "  $service: Disabled and stopped"
        else
            echo "  $service: Failed to disable"
        fi
    else
        echo "  $service: Not installed"
    fi
done

echo
echo "Essential services preserved:"

for service in ssh.service apache2.service; do
    if systemctl is-active --quiet "$service"; then
        echo "  $service: Running ✓"
    else
        echo "  $service: Not running"
    fi
done

echo
echo "Services reduced. Attack surface minimized."
