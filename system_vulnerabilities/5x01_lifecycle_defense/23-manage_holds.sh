#!/bin/bash

set -euo pipefail

log_file="/var/log/package_holds.log"

usage() {
    echo "Usage: $0 {list|release <package>}"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

action="$1"

if [ "$1" = "list" ]; then

    echo "=== Package Hold Registry ==="
    echo

    printf '%-22s %-22s %-12s %-6s %s\n' \
        "Package" "Version" "Held Since" "Days" "Reason"

    total=0
    old_holds=0
    today=$(date +%s)

    if [ -f "$log_file" ]; then

        while IFS= read -r line; do

            package=$(echo "$line" |
                sed -n 's/.*Package: \([^|]*\).*/\1/p' |
                xargs)

            version=$(echo "$line" |
                sed -n 's/.*Version: \([^|]*\).*/\1/p' |
                xargs)

            reason=$(echo "$line" |
                sed -n 's/.*Reason: \([^|]*\).*/\1/p' |
                xargs)

            held_since="${line:0:10}"

            [ -n "$package" ] || continue

            # Only show packages currently on hold.
            if ! apt-mark showhold | grep -Fxq "$package"; then
                continue
            fi

            held_epoch=$(date -d "$held_since" +%s 2>/dev/null) ||
                continue

            days=$(( (today - held_epoch) / 86400 ))

            if [ "$days" -lt 0 ]; then
                days=0
            fi

            printf '%-22s %-22s %-12s %-6s %s\n' \
                "$package" "$version" "$held_since" "$days" "$reason"

            total=$((total + 1))

            if [ "$days" -gt 14 ]; then
                old_holds=$((old_holds + 1))
            fi

        done < "$log_file"

    fi

    echo
    echo "Total holds: $total"
    echo "Holds older than 14 days: $old_holds"

elif [ "$1" = "release" ]; then

    if [ "$#" -ne 2 ]; then
        usage
    fi

    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: Run release with sudo."
        exit 1
    fi

    package="$2"

    if [[ ! "$package" =~ ^[a-zA-Z0-9][a-zA-Z0-9.+-]*$ ]]; then
        echo "ERROR: Invalid package name."
        exit 1
    fi

    echo "Releasing hold on $package..."

    apt-mark unhold "$package"

    echo "  apt-mark unhold $package: Done"

    if [ -f "$log_file" ]; then

        temp_file=$(mktemp)

        awk -v pkg="$package" '
            index($0, "Package: " pkg " |") == 0 {
                print
            }
        ' "$log_file" > "$temp_file"

        cat "$temp_file" > "$log_file"
        rm -f "$temp_file"

        echo "  Removed from $log_file"
    fi

    echo
    echo "Package will be upgraded on next automatic cycle."

else
    usage
fi
