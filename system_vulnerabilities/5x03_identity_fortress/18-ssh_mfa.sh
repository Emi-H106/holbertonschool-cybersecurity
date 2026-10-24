#!/bin/bash
# NovaTech - SSH Multi-Factor Authentication
# Target: Ubuntu 20.04
# Require SSH public key + TOTP authentication.

set -Eeuo pipefail

PAM_CONFIG="/etc/pam.d/sshd"
SSHD_CONFIG="/etc/ssh/sshd_config"

PAM_BACKUP="/etc/pam.d/sshd.backup"
SSHD_BACKUP="/etc/ssh/sshd_config.backup"

echo "=== SSH Multi-Factor Authentication ==="
echo

# Require root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Check prerequisites
if [[ ! -f "$PAM_CONFIG" || ! -f "$SSHD_CONFIG" ]]; then
    echo "ERROR: SSH configuration files not found."
    exit 1
fi

if ! command -v sshd >/dev/null 2>&1; then
    echo "ERROR: OpenSSH server is not installed."
    exit 1
fi

if ! find /lib /usr/lib \
    -name pam_google_authenticator.so \
    -type f -print -quit 2>/dev/null | grep -q .; then
    echo "ERROR: Google Authenticator PAM module not found."
    echo "Complete Task 16 first."
    exit 1
fi

# Check TOTP setup for the intended user
TARGET_USER="${SUDO_USER:-}"

if [[ -z "$TARGET_USER" || "$TARGET_USER" == "root" ]]; then
    echo "ERROR: Run using sudo from a configured user account."
    exit 1
fi

USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [[ ! -s "$USER_HOME/.google_authenticator" ]]; then
    echo "ERROR: TOTP is not configured for $TARGET_USER."
    echo "Complete Task 17 first."
    exit 1
fi

echo "WARNING: SSH will require both a key and a TOTP code."
echo "Ensure you have tested key-based access and have VM console access."
echo

# Backup configurations
echo "Backing up configurations..."

cp /etc/pam.d/sshd /etc/pam.d/sshd.backup
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

echo "  /etc/pam.d/sshd.backup"
echo "  /etc/ssh/sshd_config.backup"
echo

# Backup any pre-existing MFA drop-in
DROPIN="/etc/ssh/sshd_config.d/00-novatech-mfa.conf"
DROPIN_BACKUP=""

if [[ -e "$DROPIN" ]]; then
    DROPIN_BACKUP=$(mktemp)
    cp -a "$DROPIN" "$DROPIN_BACKUP"
fi

rollback() {
    echo "ERROR: Restoring previous SSH and PAM settings."

    cp "$PAM_BACKUP" "$PAM_CONFIG"
    cp "$SSHD_BACKUP" "$SSHD_CONFIG"

    if [[ -n "$DROPIN_BACKUP" ]]; then
        cp -a "$DROPIN_BACKUP" "$DROPIN"
    else
        rm -f "$DROPIN"
    fi
}

# Configure PAM
echo "Configuring /etc/pam.d/sshd..."

if ! grep -Eq \
    '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_google_authenticator\.so([[:space:]]|$)' \
    "$PAM_CONFIG"; then

    sed -i '1i auth required pam_google_authenticator.so' \
        "$PAM_CONFIG"
fi

# Disable password-based PAM auth for SSH
sed -i \
    '/^[[:space:]]*@include[[:space:]]*common-auth[[:space:]]*$/s/^/# MFA disabled: /' \
    "$PAM_CONFIG"

echo "  Adding: auth required pam_google_authenticator.so"
echo "  Password-based PAM authentication: Disabled"
echo

# Configure SSH
echo "Configuring /etc/ssh/sshd_config..."

mkdir -p /etc/ssh/sshd_config.d

# Check whether the main config includes drop-ins
if ! grep -Eq \
    '^[[:space:]]*Include[[:space:]]+/etc/ssh/sshd_config\.d/\*' \
    "$SSHD_CONFIG"; then

    rollback
    echo "ERROR: SSH drop-in Include directive not found."
    exit 1
fi

cat > "$DROPIN" <<'EOF'
# NovaTech - SSH MFA
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication yes
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
UsePAM yes
EOF

chmod 644 "$DROPIN"

echo "  ChallengeResponseAuthentication: yes"
echo "  AuthenticationMethods: publickey,keyboard-interactive"
echo "  PasswordAuthentication: no"
echo "  PubkeyAuthentication: yes"
echo

# Validate SSH configuration
echo "Validating configuration..."

if sshd -t; then
    echo "  sshd -t: OK"
else
    rollback
    echo "ERROR: Invalid SSH configuration."
    exit 1
fi

# Verify effective SSH settings
EFFECTIVE=$(sshd -T \
    -C "user=$TARGET_USER,host=localhost,addr=127.0.0.1")

if ! grep -qx 'passwordauthentication no' <<< "$EFFECTIVE" ||
   ! grep -qx 'kbdinteractiveauthentication yes' <<< "$EFFECTIVE" ||
   ! grep -qx 'pubkeyauthentication yes' <<< "$EFFECTIVE" ||
   ! grep -qx 'authenticationmethods publickey,keyboard-interactive' \
       <<< "$EFFECTIVE" ||
   ! grep -qx 'usepam yes' <<< "$EFFECTIVE"; then

    rollback
    echo "ERROR: Effective SSH MFA settings are incorrect."
    echo "Check conflicting SSH configuration directives."
    exit 1
fi

# Basic PAM configuration check
if grep -Eq \
    '^[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_google_authenticator\.so([[:space:]]|$)' \
    "$PAM_CONFIG"; then

    echo "  PAM syntax: Basic module entry check OK"
else
    rollback
    echo "ERROR: PAM module entry missing."
    exit 1
fi

echo
echo "Reloading SSH..."

if systemctl reload ssh; then
    echo "  ssh.service: Reloaded"
else
    rollback
    systemctl reload ssh || true
    echo "ERROR: SSH reload failed."
    exit 1
fi

# Cleanup temporary backup
if [[ -n "$DROPIN_BACKUP" ]]; then
    rm -f "$DROPIN_BACKUP"
fi

echo
echo "SSH MFA Configuration:"
echo "  First factor: SSH Public Key"
echo "  Second factor: TOTP Code (Google Authenticator)"

echo
echo "Users must now provide BOTH key AND TOTP code to log in."
echo
echo "IMPORTANT: Test a NEW SSH connection before closing"
echo "your existing session or VM console."
