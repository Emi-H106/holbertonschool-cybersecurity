#!/bin/bash
set -euo pipefail

REPORT_DIR="/var/log/hardening"
REPORT_FILE="$REPORT_DIR/baseline-$(date +%Y%m%d).txt"
LYNIS_REPORT="/var/log/lynis-report.dat"

if [ "$EUID" -ne 0 ]; then
    exec sudo bash "$0" "$@"
fi

if ! command -v lynis >/dev/null 2>&1; then
    echo "Error: Lynis is not installed."
    exit 1
fi

mkdir -p "$REPORT_DIR"

echo "Running Lynis audit..."

# Run a fresh security audit
lynis audit system --quick --no-colors > /tmp/lynis-baseline-output.txt 2>&1

if [ ! -f "$LYNIS_REPORT" ]; then
    echo "Error: Lynis report not found."
    exit 1
fi

# Extract actual values from Lynis report
INDEX=$(awk -F= '/^hardening_index=/{print $2; exit}' "$LYNIS_REPORT")
TESTS=$(awk -F= '/^tests_executed=/{n=split($2,a,"|"); print n-(a[n]==""); exit}' "$LYNIS_REPORT")
WARNINGS=$(grep -c '^warning\[\]=' "$LYNIS_REPORT" || true)
SUGGESTIONS=$(grep -c '^suggestion\[\]=' "$LYNIS_REPORT" || true)

INDEX=${INDEX:-0}
TESTS=${TESTS:-0}

# Build a 20-character progress bar
FILLED=$((INDEX * 20 / 100))
EMPTY=$((20 - FILLED))

printf -v BAR '%*s' "$FILLED" ''
BAR=${BAR// /#}
printf -v SPACE '%*s' "$EMPTY" ''
BAR="${BAR}${SPACE// /.}"

{
    echo "Hardening Index: $INDEX [$BAR]"
    echo "Tests Performed: $TESTS"
    echo "Warnings: $WARNINGS"
    echo "Suggestions: $SUGGESTIONS"
    echo "Critical Findings:"

    # Findings from Lynis
    grep '^warning\[\]=' "$LYNIS_REPORT" |
        sed 's/^warning\[\]=/  [WARNING] /' || true

    # Additional checks required by the lab
    if [ -f /usr/local/bin/backup ] &&
       [ -u /usr/local/bin/backup ]; then
        echo "  [WARNING] Found SUID file: /usr/local/bin/backup"
    fi

    if [ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ]; then
        echo "  [WARNING] IP forwarding is enabled"
    fi

    if ! findmnt -no OPTIONS -T /tmp |
         tr ',' '\n' | grep -qx noexec; then
        echo "  [WARNING] /tmp is not mounted with noexec option"
    fi
} | tee "$REPORT_FILE"

echo "Baseline saved to: $REPORT_FILE"
