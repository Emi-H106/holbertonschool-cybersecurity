#!/bin/bash
# NovaTech - Password History Configuration

set -Eeuo pipefail

PAM_FILE="/etc/pam.d/common-password"
HISTORY_FILE="/etc/security/opasswd"

echo "=== Password History Configuration ==="
echo

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if [[ ! -f "$PAM_FILE" ]]; then
    echo "ERROR: $PAM_FILE not found."
    exit 1
fi

echo "Configuring pam_pwhistory..."
echo

if [[ ! -f /lib/x86_64-linux-gnu/security/pam_pwhistory.so ]] &&
   [[ ! -f /usr/lib/x86_64-linux-gnu/security/pam_pwhistory.so ]]; then
    echo "ERROR: pam_pwhistory.so not found."
    exit 1
fi

echo "Creating password history file..."

if [[ ! -f "$HISTORY_FILE" ]]; then
    touch "$HISTORY_FILE"
    echo "  $HISTORY_FILE: Created"
else
    echo "  $HISTORY_FILE: Already exists"
fi

chown root:root "$HISTORY_FILE"
chmod 600 "$HISTORY_FILE"

echo
echo "Updating $PAM_FILE..."

cp -a "$PAM_FILE" "${PAM_FILE}.backup"

# Remove existing active pam_pwhistory entries.
sed -i -E \
    '/^[[:space:]]*password[[:space:]]+.*pam_pwhistory\.so/d' \
    "$PAM_FILE"

# Insert pam_pwhistory before pam_unix.
awk '
    !inserted && /^[[:space:]]*password[[:space:]]+.*pam_unix\.so/ {
        print "password required pam_pwhistory.so remember=5 use_authtok"
        inserted=1
    }
    { print }
    END {
        if (!inserted) {
            exit 1
        }
    }
' "$PAM_FILE" > "${PAM_FILE}.tmp" || {
    rm -f "${PAM_FILE}.tmp"
    echo "ERROR: pam_unix.so not found."
    exit 1
}

cat "${PAM_FILE}.tmp" > "$PAM_FILE"
rm -f "${PAM_FILE}.tmp"

# Ensure pam_unix uses the password token from earlier PAM modules.
sed -i -E \
    '/^[[:space:]]*password[[:space:]]+.*pam_unix\.so/ {
        /use_authtok/! s/pam_unix\.so/pam_unix.so use_authtok/
    }' "$PAM_FILE"

echo "  pam_pwhistory.so remember=5: Added"

echo
echo "Configuration:"
echo "  Passwords remembered: 5"

if grep -Eq '^[[:space:]]*password[[:space:]]+.*pam_unix\.so.*sha512' \
    "$PAM_FILE"; then
    echo "  Hash algorithm: sha512"
else
    echo "  Hash algorithm: Check system configuration"
fi

echo
echo "Testing..."

if grep -Eq \
    '^[[:space:]]*password[[:space:]]+.*pam_pwhistory\.so.*remember=5' \
    "$PAM_FILE"; then
    echo "  Password history configuration: VERIFIED"
    echo
    echo "Password history enforcement: CONFIGURED"
    echo "Users cannot reuse their last 5 passwords when the policy is enforced."
else
    echo "  Password history configuration: FAILED"
    exit 1
fi
