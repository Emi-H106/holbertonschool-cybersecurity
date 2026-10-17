#!/bin/bash

set -euo pipefail

echo "=== Update Regression Analysis ==="
echo

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 \"YYYY-MM-DD HH:MM\""
    exit 1
fi

error_time="$1"

if ! date -d "$error_time" >/dev/null 2>&1; then
    echo "ERROR: Invalid date format."
    exit 1
fi

error_epoch=$(date -d "$error_time" +%s)
start_epoch=$((error_epoch - 86400))

echo "Searching for updates before: $error_time"
echo

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

# Read current and rotated dpkg logs.
for logfile in /var/log/dpkg.log /var/log/dpkg.log.*; do
    [ -f "$logfile" ] || continue

    if [[ "$logfile" == *.gz ]]; then
        gzip -cd "$logfile" 2>/dev/null || true
    else
        cat "$logfile"
    fi
done | awk '$3 == "upgrade" {
    print $1, $2, $4, $5, $6
}' | while read -r log_date log_time package old_version new_version; do

    timestamp="$log_date $log_time"
    log_epoch=$(date -d "$timestamp" +%s 2>/dev/null) || continue

    if [ "$log_epoch" -ge "$start_epoch" ] &&
       [ "$log_epoch" -le "$error_epoch" ]; then

        package="${package%%:*}"

        printf '%s|%s|%s|%s|%s\n' \
            "$log_epoch" "$timestamp" "$package" \
            "$old_version" "$new_version"
    fi

done | sort -t '|' -k1,1n > "$temp_file"

echo "Updates in the last 24 hours:"

if [ ! -s "$temp_file" ]; then
    echo "  No package upgrades found."
    echo
    echo "Timeline analysis:"
    echo "  No updates found before the reported error."
    echo
    echo "Most likely culprit:"
    echo "  Unable to identify from available logs."
    exit 0
fi

while IFS='|' read -r epoch timestamp package old_version new_version; do
    printf '  %s  %s %s -> %s\n' \
        "${timestamp:0:16}" "$package" \
        "$old_version" "$new_version"
done < "$temp_file"

echo

# Find the most recent recorded package upgrade.
last_epoch=$(tail -n 1 "$temp_file" | cut -d '|' -f1)
last_time=$(date -d "@$last_epoch" '+%H:%M')

delta=$(( (error_epoch - last_epoch) / 60 ))

echo "Timeline analysis:"
echo "  Last recorded upgrade: $last_time"
echo "  Error first seen: $(date -d "$error_time" '+%H:%M')"
echo "  Delta: $delta minutes"
echo

# Prioritize packages related to SSL and certificates.
best_score=-1
best_epoch=0
best_package=""
best_old=""
best_new=""

while IFS='|' read -r epoch timestamp package old_version new_version; do

    score=0

    case "$package" in
        ca-certificates*)
            score=100
            ;;
        openssl|libssl*|libgnutls*)
            score=90
            ;;
        libcurl*|curl)
            score=80
            ;;
    esac

    if [ "$score" -gt "$best_score" ] ||
       { [ "$score" -eq "$best_score" ] &&
         [ "$epoch" -gt "$best_epoch" ]; }; then

        best_score=$score
        best_epoch=$epoch
        best_package=$package
        best_old=$old_version
        best_new=$new_version
    fi

done < "$temp_file"

echo "Most likely culprit:"
echo "  PACKAGE: $best_package"

if [ "$best_score" -gt 0 ]; then
    echo "  REASON: SSL-related package updated before error time"
else
    echo "  REASON: Most recent update; no SSL-specific package identified"
fi

echo "  PREVIOUS: $best_old"
echo "  CURRENT: $best_new"
