#!/bin/bash
# NovaTech - Force Password Change

set -Eeuo pipefail

echo "=== Force Password Change ==="
echo

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 username [username ...]"
    exit 1
fi

echo "Processing users with compromised passwords..."
echo

count=0
failed=0
first_user=""

for user in "$@"; do
    echo "$user:"

    # Check whether the user exists.
    if ! id "$user" >/dev/null 2>&1; then
        echo "  ERROR: User does not exist"
        echo
        failed=$((failed + 1))
        continue
    fi

    # Require a local shadow entry.
    if ! grep -Fq "${user}:" /etc/shadow; then
        echo "  ERROR: No local shadow entry"
        echo
        failed=$((failed + 1))
        continue
    fi

    # Force password change at next login.
    if chage -d 0 "$user"; then
        echo "  Password expired: FORCED"
        echo "  Must change at next login: YES"

        count=$((count + 1))

        if [[ -z "$first_user" ]]; then
            first_user="$user"
        fi
    else
        echo "  Password expired: FAILED"
        failed=$((failed + 1))
    fi

    echo
done

echo "Verification:"

if [[ -n "$first_user" ]]; then
    echo "  chage -l $first_user | grep 'Password expires'"
    chage -l "$first_user" | grep -E \
        '^(Last password change|Password expires)' || true
else
    echo "  No users were updated."
fi

echo
echo "$count users must change password at next login."

if [[ "$failed" -gt 0 ]]; then
    echo "Failed accounts: $failed"
    exit 1
fi
