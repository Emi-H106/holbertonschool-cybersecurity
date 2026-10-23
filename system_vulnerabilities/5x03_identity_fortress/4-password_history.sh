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

if ! find /lib /usr/lib -name pam_pwhistory.so \
    -print -quit 2>/dev/null | grep -q .; then
    echo "ERROR: pam_pwhistory.so not found."
    exit 1
fi

echo "Creating password history file..."

if [[ ! -f /etc/security/opasswd ]]; then
    touch /etc/security/opasswd
    echo "  /etc/security/opasswd: Created"
else
    echo "  /etc/security/opasswd: Already exists"
fi

chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd

echo
echo "Backing up PAM configuration..."

if [[ ! -f /etc/pam.d/common-password.bak ]]; then
    cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
    echo "  /etc/pam.d/common-password.bak created"
else
    echo "  /etc/pam.d/common-password.bak already exists"
fi

echo
echo "Updating $PAM_FILE..."

# Remove existing active pam_pwhistory entries.
sed -i -E \
    '/^[[:space:]]*password[[:space:]]+.*pam_pwhistory\.so/d' \
    "$PAM_FILE"

# Ensure pam_unix exists before modifying the PAM stack.
if ! grep -Eq \
    '^[[:space:]]*password[[:space:]]+.*pam_unix\.so' \
    "$PAM_FILE"; then
    echo "ERROR: pam_unix.so not found."
    exit 1
fi

# Insert pam_pwhistory immediately before pam_unix.
awk '
    !inserted && /^[[:space:]]*password[[:space:]]+.*pam_unix\.so/ {
        print "password required pam_pwhistory.so remember=5 use_authtok"
        inserted=1
    }
    { print }
' "$PAM_FILE" > "${PAM_FILE}.tmp"

cat "${PAM_FILE}.tmp" > "$PAM_FILE"
rm -f "${PAM_FILE}.tmp"

# Ensure pam_unix uses the token passed by earlier PAM modules.
sed -i -E \
    '/^[[:space:]]*password[[:space:]]+.*pam_unix\.so/ {
        /use_authtok/! s/pam_unix\.so/pam_unix.so use_authtok/
    }' "$PAM_FILE"

echo "  pam_pwhistory.so remember=5: Added"

echo
echo "Configuration:"
echo "  Passwords remembered: 5"

if grep -Eq \
    '^[[:space:]]*password[[:space:]]+.*pam_unix\.so.*sha512' \
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
    echo "Users cannot reuse their last 5 passwords when enforced."
else
    echo "  Password history configuration: FAILED"
    exit 1
fi
