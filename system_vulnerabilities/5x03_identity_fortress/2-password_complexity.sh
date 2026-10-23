#!/bin/bash
# NovaTech - Password Complexity Configuration
# Configure pam_pwquality for strong password enforcement.
#
# Package repair belongs to the separate 5x01 patch management task.
# That task uses dpkg --configure -a to finish interrupted installations.
# It uses apt-get install -f to repair broken package dependencies.
# This PAM script does not perform automatic package repairs.

set -Eeuo pipefail

PWQUALITY_CONF="/etc/security/pwquality.conf"
PAM_PASSWORD="/etc/pam.d/common-password"

echo "=== Password Complexity Configuration ==="
echo

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Installing libpam-pwquality..."

if dpkg -s libpam-pwquality >/dev/null 2>&1; then
    echo "  Already installed: libpam-pwquality"
else
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-pwquality
    echo "  Installed: libpam-pwquality"
fi

if [[ ! -f "$PAM_PASSWORD" ]]; then
    echo "ERROR: $PAM_PASSWORD not found."
    exit 1
fi

echo
echo "Backing up configuration..."

if [[ -f "$PWQUALITY_CONF" ]]; then
    cp -a "$PWQUALITY_CONF" "${PWQUALITY_CONF}.backup"
else
    touch "${PWQUALITY_CONF}.backup"
    chmod 600 "${PWQUALITY_CONF}.backup"
fi

cp -a "$PAM_PASSWORD" "${PAM_PASSWORD}.backup"

echo "  ${PWQUALITY_CONF}.backup created"
echo "  ${PAM_PASSWORD}.backup created"

echo
echo "Configuring $PWQUALITY_CONF:"

touch "$PWQUALITY_CONF"

set_option() {
    local key="$1"
    local value="$2"

    sed -i -E "/^[[:space:]]*#?[[:space:]]*${key}[[:space:]]*=/d" \
        "$PWQUALITY_CONF"

    echo "$key = $value" >> "$PWQUALITY_CONF"
}

set_option minlen 12
set_option dcredit -1
set_option ucredit -1
set_option lcredit -1
set_option ocredit -1
set_option usercheck 1
set_option difok 3

# Disable character-class length credits.
set_option minclass 4

echo "  minlen = 12"
echo "  dcredit = -1 (require digit)"
echo "  ucredit = -1 (require uppercase)"
echo "  lcredit = -1 (require lowercase)"
echo "  ocredit = -1 (require special)"
echo "  usercheck = 1 (reject username in password)"
echo "  difok = 3 (must differ from old password)"

echo
echo "Updating $PAM_PASSWORD..."

# Remove existing active pam_pwquality entries to avoid duplicates.
sed -i -E '/^[[:space:]]*password[[:space:]]+.*pam_pwquality\.so/d' \
    "$PAM_PASSWORD"

# Insert pwquality before the first active password module.
awk '
    !inserted && /^[[:space:]]*password[[:space:]]+/ {
        print "password requisite pam_pwquality.so retry=3"
        inserted=1
    }
    { print }
    END {
        if (!inserted) {
            print "password requisite pam_pwquality.so retry=3"
        }
    }
' "$PAM_PASSWORD" > "${PAM_PASSWORD}.tmp"

cat "${PAM_PASSWORD}.tmp" > "$PAM_PASSWORD"
rm -f "${PAM_PASSWORD}.tmp"

chmod 644 "$PWQUALITY_CONF"

echo "  pam_pwquality.so: Configured"

echo
echo "Testing enforcement..."

if command -v pwscore >/dev/null 2>&1; then
    if printf '%s\n' "weak" | pwscore >/dev/null 2>&1; then
        echo '  Attempt "weak": ACCEPTED (WARNING)'
        test1=0
    else
        echo '  Attempt "weak": REJECTED'
        test1=1
    fi

    if printf '%s\n' "Password123" | pwscore >/dev/null 2>&1; then
        echo '  Attempt "Password123": ACCEPTED (WARNING)'
        test2=0
    else
        echo '  Attempt "Password123": REJECTED'
        test2=1
    fi
else
    echo "  pwscore unavailable: tests skipped"
    test1=0
    test2=0
fi

echo

if grep -Eq '^[[:space:]]*password[[:space:]]+.*pam_pwquality\.so' \
    "$PAM_PASSWORD" && [[ "$test1" -eq 1 && "$test2" -eq 1 ]]; then
    echo "Password complexity enforcement: ACTIVE"
else
    echo "Password complexity enforcement: REQUIRES VERIFICATION"
fi
