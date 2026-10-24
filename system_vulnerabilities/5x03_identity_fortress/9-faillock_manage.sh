#!/bin/bash
# NovaTech - Faillock Management

set -Eeuo pipefail

DENY=5
UNLOCK_TIME=900
CONF="/etc/security/faillock.conf"

usage() {
    echo "Usage:"
    echo "  $0 status"
    echo "  $0 show username"
    echo "  $0 reset username"
    exit 1
}

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if ! command -v faillock >/dev/null 2>&1; then
    echo "ERROR: faillock command not found."
    exit 1
fi

if [[ $# -lt 1 ]]; then
    usage
fi

# Read the active lockout policy.
if [[ -f "$CONF" ]]; then
    value=$(awk -F= '
        /^[[:space:]]*deny[[:space:]]*=/ {
            gsub(/[[:space:]]/, "", $2)
            print $2
        }' "$CONF" | tail -1)
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        DENY="$value"
    fi

    value=$(awk -F= '
        /^[[:space:]]*unlock_time[[:space:]]*=/ {
            gsub(/[[:space:]]/, "", $2)
            print $2
        }' "$CONF" | tail -1)
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        UNLOCK_TIME="$value"
    fi
fi

# Extract failure timestamps from faillock output.
get_failure_times() {
    local user="$1"

    faillock --user "$user" 2>/dev/null |
        awk '
            /^[[:space:]]*[0-9][0-9][0-9][0-9]-/ {
                print $1, $2
            }'
}

# Count failure records.
get_failure_count() {
    local user="$1"
    get_failure_times "$user" | wc -l
}

# Find the most recent failure timestamp.
get_last_failure() {
    local user="$1"
    get_failure_times "$user" | tail -1
}

# Check whether a user is currently locked.
is_locked() {
    local user="$1"
    local count last timestamp now

    count=$(get_failure_count "$user")

    if (( count < DENY )); then
        return 1
    fi

    last=$(get_last_failure "$user")

    if [[ -z "$last" ]]; then
        return 1
    fi

    timestamp=$(date -d "$last" +%s 2>/dev/null) || return 1
    now=$(date +%s)

    (( now < timestamp + UNLOCK_TIME ))
}

# Display estimated unlock time.
get_unlock_time() {
    local user="$1"
    local last timestamp

    last=$(get_last_failure "$user")
    timestamp=$(date -d "$last" +%s)

    date -d "@$((timestamp + UNLOCK_TIME))" +%H:%M:%S
}

case "$1" in

    status)
        if [[ $# -ne 1 ]]; then
            usage
        fi

        echo "=== Faillock Status ==="
        echo
        echo "Locked accounts:"

        found=0

        while IFS=: read -r user _; do
            if is_locked "$user"; then
                count=$(get_failure_count "$user")
                unlock=$(get_unlock_time "$user")

                echo "  $user: $count failures (locked until $unlock)"
                found=1
            fi
        done < /etc/passwd

        if [[ $found -eq 0 ]]; then
            echo "  No locked accounts found."
        fi
        ;;

    show)
        if [[ $# -ne 2 ]]; then
            usage
        fi

        user="$2"

        if ! id "$user" >/dev/null 2>&1; then
            echo "ERROR: User '$user' does not exist."
            exit 1
        fi

        echo "=== Faillock Details: $user ==="
        echo
        echo "Recent failures:"

        faillock --user "$user"

        echo

        if is_locked "$user"; then
            echo "Status: LOCKED"
            echo "Unlocks automatically at: $(get_unlock_time "$user")"
        else
            echo "Status: NOT LOCKED"
        fi
        ;;

    reset)
        if [[ $# -ne 2 ]]; then
            usage
        fi

        user="$2"

        if ! id "$user" >/dev/null 2>&1; then
            echo "ERROR: User '$user' does not exist."
            exit 1
        fi

        faillock --user "$user" --reset

        echo "Account $user: Lock cleared"
        ;;

    *)
        usage
        ;;
esac
