#!/bin/bash
# NovaTech - Account Lockout Configuration
# Target: Ubuntu 20.04 lab VM

set -Eeuo pipefail

AUTH="/etc/pam.d/common-auth"
ACCOUNT="/etc/pam.d/common-account"
CONF="/etc/security/faillock.conf"

echo "=== Account Lockout Configuration ==="
echo

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run with sudo."
    exit 1
fi

if [[ ! -f "$AUTH" || ! -f "$ACCOUNT" ]]; then
    echo "ERROR: PAM configuration files missing."
    exit 1
fi

if ! find /lib /usr/lib -name pam_faillock.so \
    -print -quit 2>/dev/null | grep -q .; then
    echo "ERROR: pam_faillock.so is not installed."
    exit 1
fi

echo "Configuring pam_faillock..."
echo

# Back up original PAM files once.
for file in "$AUTH" "$ACCOUNT"; do
    if [[ ! -f "${file}.bak" ]]; then
        cp -a "$file" "${file}.bak"
    fi
done

echo "Creating /etc/security/faillock.conf..."

mkdir -p /etc/security

if [[ -f "$CONF" && ! -f "${CONF}.bak" ]]; then
    cp -a "$CONF" "${CONF}.bak"
fi

# Remove existing policy keys, preserving unrelated settings.
touch "$CONF"

sed -i -E \
    '/^[[:space:]]*(deny|unlock_time|fail_interval)[[:space:]]*=/d' \
    "$CONF"

cat >> "$CONF" <<'EOF'

# NovaTech account lockout policy
deny = 5
unlock_time = 900
fail_interval = 900
EOF

echo "  Configuration written"
echo

echo "Updating /etc/pam.d/common-auth..."

# Remove old faillock entries to prevent duplicates.
sed -i '/pam_faillock\.so/d' "$AUTH"

# The standard Ubuntu PAM stack uses success=N jumps.
# Require a supported baseline before modifying it.
if ! grep -Eq \
    '^[[:space:]]*auth[[:space:]]+\[success=1[[:space:]]+default=ignore\][[:space:]]+pam_unix\.so' \
    "$AUTH"; then
    echo "ERROR: Unexpected PAM stack layout."
    echo "Review $AUTH manually before continuing."
    exit 1
fi

# Insert preauth before pam_unix.
sed -i \
    '/^[[:space:]]*auth.*pam_unix\.so/i auth required pam_faillock.so preauth silent' \
    "$AUTH"

# Insert authfail after pam_unix.
sed -i \
    '/^[[:space:]]*auth.*pam_unix\.so/a auth [default=die] pam_faillock.so authfail' \
    "$AUTH"

# Successful pam_unix authentication skips authfail.
# authsucc clears previous failed attempts.
sed -i \
    '/^[[:space:]]*auth.*pam_deny\.so/i auth sufficient pam_faillock.so authsucc' \
    "$AUTH"

# Update pam_unix success jump to skip authfail.
sed -i -E \
    '/pam_unix\.so/s/\[success=1[[:space:]]+default=ignore\]/[success=1 default=ignore]/' \
    "$AUTH"

echo "  pam_faillock.so preauth: Added"
echo "  pam_faillock.so authfail: Added"
echo "  pam_faillock.so authsucc: Added"
echo

echo "Updating /etc/pam.d/common-account..."

sed -i '/pam_faillock\.so/d' "$ACCOUNT"
echo "account required pam_faillock.so" >> "$ACCOUNT"

echo "  pam_faillock.so: Added"
echo

echo "Configuration:"
echo "  deny = 5 (lock after 5 failures)"
echo "  unlock_time = 900 (15 minutes)"
echo "  fail_interval = 900 (count failures within 15 min)"
echo

echo "Testing..."

grep -Eq '^[[:space:]]*deny[[:space:]]*=[[:space:]]*5$' "$CONF"
grep -Eq '^[[:space:]]*unlock_time[[:space:]]*=[[:space:]]*900$' "$CONF"
grep -Eq '^[[:space:]]*fail_interval[[:space:]]*=[[:space:]]*900$' "$CONF"

grep -q 'pam_faillock.so preauth' "$AUTH"
grep -q 'pam_faillock.so authfail' "$AUTH"
grep -q 'pam_faillock.so authsucc' "$AUTH"
grep -q 'pam_faillock.so' "$ACCOUNT"

echo "  Configuration: VERIFIED"
echo "  Live login simulation: NOT RUN"
echo
echo "Account lockout: CONFIGURED"
