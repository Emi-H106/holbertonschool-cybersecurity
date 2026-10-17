#!/bin/bash

# Validate Apache configuration, restore service, and check HTTP health.

set -euo pipefail

echo "=== Apache Recovery ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Configuration test..."

if apache2ctl configtest 2>&1 | grep -q "Syntax OK"; then
    echo "  Syntax: OK"
else
    echo "  Syntax: FAILED"
    apache2ctl configtest
    exit 1
fi

modules=$(apache2ctl -M 2>/dev/null |
    awk '$1 ~ /_module$/ {
        sub(/_module$/, "", $1)
        print $1
    }' |
    paste -sd ',' - |
    sed 's/,/, /g')

echo "  Modules loaded: $modules"
echo

echo "Starting Apache service..."

systemctl start apache2

if systemctl is-active --quiet apache2; then
    echo "  apache2.service: Started"
else
    echo "  apache2.service: FAILED"
    exit 1
fi

echo
echo "Health check..."

response=$(curl -sS -o /dev/null \
    -w '%{http_code} %{time_total}' \
    --max-time 10 \
    http://127.0.0.1/)

http_code=$(echo "$response" | awk '{print $1}')
response_time=$(echo "$response" | awk '{print $2}')

response_ms=$(awk -v t="$response_time" \
    'BEGIN {printf "%.0f", t * 1000}')

if [ "$http_code" = "200" ]; then
    echo "  HTTP GET /: 200 OK"
else
    echo "  HTTP GET /: $http_code"
    echo "  Apache health check failed."
    exit 1
fi

echo "  Response time: ${response_ms}ms"
echo

start_time=$(systemctl show apache2 \
    --property=ActiveEnterTimestampMonotonic \
    --value)

current_time=$(awk '{print int($1 * 1000000)}' /proc/uptime)

uptime_seconds=$(( (current_time - start_time) / 1000000 ))

if [ "$uptime_seconds" -lt 0 ]; then
    uptime_seconds=0
fi

days=$((uptime_seconds / 86400))
hours=$(((uptime_seconds % 86400) / 3600))
minutes=$(((uptime_seconds % 3600) / 60))

echo "Apache restored successfully."
echo "Service uptime: $days days, $hours hours, $minutes minutes"
