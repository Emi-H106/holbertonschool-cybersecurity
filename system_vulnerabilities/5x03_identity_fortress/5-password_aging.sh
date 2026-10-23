#!/bin/bash
# NovaTech - Password Aging Configuration

set -Eeuo pipefail

LOGIN_DEFS="/etc/login.defs"

echo "=== Password Aging Configuration ==="
echo

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if [[ ! -f "$LOGIN_DEFS" ]]; then
    echo "ERROR: /etc/login.defs not found."
    exit 1
fi

# Backup configuration
if [[ ! -f /etc/login.defs.bak ]]; then
    cp /etc/login.defs /etc/login.defs.bak
fi

echo "Configuring /etc/login.defs..."

update_setting() {
    local key="$1"
    local new_value="$2"
    local old_value

    old_value=$(awk -v key="$key" '
        $1 == key { print $2; exit }
    ' "$LOGIN_DEFS")

    if grep -Eq "^[[:space:]]*${key}[[:space:]]+" "$LOGIN_DEFS"; then
        sed -i -E \
            "s/^[[:space:]]*${key}[[:space:]]+.*/${key}   ${new_value}/" \
            "$LOGIN_DEFS"
    else
        echo "${key}   ${new_value}" >> "$LOGIN_DEFS"
    fi

    echo "  ${key}: ${old_value:-not set} -> ${new_value}"
}

# Password aging policy:
# PASS_MAX_DAYS 90
# PASS_MIN_DAYS 1
# PASS_WARN_AGE 14

update_setting "PASS_MAX_DAYS" "90"
update_setting "PASS_MIN_DAYS" "1"
update_setting "PASS_WARN_AGE" "14"

echo
echo "Note: These settings apply to NEW accounts only."
echo "Existing accounts must be updated with chage."
echo

echo "Applying to existing users..."

# UID_MIN identifies regular user accounts.
UID_MIN=$(awk '
    $1 == "UID_MIN" { print $2; exit }
' "$LOGIN_DEFS")

UID_MIN=${UID_MIN:-1000}

updated=0

while IFS=: read -r username _ uid gid gecos home shell; do

    # Skip system accounts.
    if (( uid < UID_MIN )); then
        continue
    fi

    # Skip disabled/non-login accounts.
    case "$shell" in
        */nologin|*/false)
            continue
            ;;
    esac

    # Only modify accounts with local shadow entries.
    if ! getent shadow "$username" >/dev/null; then
        continue
    fi

    user="$username"

    chage -M 90 $user
    chage -m 1 $user
    chage -W 14 $user

    echo "  ${username}: Max=90, Min=1, Warn=14"

    updated=$((updated + 1))

done < /etc/passwd

echo "  [Skipping system accounts]"

echo
echo "Verifying configuration..."

if grep -Eq '^PASS_MAX_DAYS[[:space:]]+90$' "$LOGIN_DEFS" &&
   grep -Eq '^PASS_MIN_DAYS[[:space:]]+1$' "$LOGIN_DEFS" &&
   grep -Eq '^PASS_WARN_AGE[[:space:]]+14$' "$LOGIN_DEFS"; then

    echo "  PASS_MAX_DAYS: OK"
    echo "  PASS_MIN_DAYS: OK"
    echo "  PASS_WARN_AGE: OK"

else
    echo "ERROR: Password aging configuration failed."
    exit 1
fi

echo
echo "Users updated: $updated"
echo
echo "Password aging: CONFIGURED"
