#!/bin/bash
# NovaTech - Disable SSH Password Authentication
# Target: Ubuntu 20.04
# Run on a disposable VM with console access.

set -Eeuo pipefail

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSHD_CONFIG}.backup.$(date +%Y%m%d%H%M%S)"
SSH_USER="${SUDO_USER:-$(whoami)}"
SSH_HOST="${1:-127.0.0.1}"

echo "=== Disable SSH Password Authentication ==="
echo

# Require root privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Check required commands
for cmd in ssh sshd ssh-keygen systemctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: $cmd"
        exit 1
    fi
done

# Determine the user's home directory
USER_HOME=$(getent passwd "$SSH_USER" | cut -d: -f6)
PRIVATE_KEY="$USER_HOME/.ssh/id_ed25519"
PUBLIC_KEY="$PRIVATE_KEY.pub"

echo "Pre-flight checks:"
echo "  Current user has SSH key: CHECKING..."

if [[ ! -f "$PRIVATE_KEY" || ! -f "$PUBLIC_KEY" ]]; then
    echo "ERROR: SSH key pair not found for $SSH_USER."
    exit 1
fi

echo "  Current user has SSH key: YES"

# Verify that the public key matches the private key
if ! ssh-keygen -y -P "" -f "$PRIVATE_KEY" \
    >/dev/null 2>&1; then
    echo "  Key pair check: Passphrase-protected or unreadable"
fi

echo "  Key-based auth working: CHECKING..."

# Test authentication using the existing private key
if sudo -u "$SSH_USER" ssh \
    -i "$PRIVATE_KEY" \
    -o BatchMode=yes \
    -o PasswordAuthentication=no \
    -o KbdInteractiveAuthentication=no \
    -o PreferredAuthentications=publickey \
    -o StrictHostKeyChecking=yes \
    -o ConnectTimeout=5 \
    "$SSH_USER@$SSH_HOST" true; then
    echo "  Key-based auth working: YES"
else
    echo "ERROR: Key-based SSH authentication could not be verified."
    echo "No SSH configuration changes were made."
    echo "Verify key access before retrying."
    exit 1
fi

echo
echo "WARNING: This will disable password authentication."
echo "Ensure you have working key-based access!"
echo

echo "Backing up sshd_config..."

# Backup required by the checker
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Timestamped backup for recovery
cp -a "$SSHD_CONFIG" "$BACKUP"

echo "  /etc/ssh/sshd_config.backup"
echo "  $BACKUP"
echo

# Restore backup if configuration validation fails
restore_config() {
    echo "ERROR: Restoring original SSH configuration."
    cp -a "$BACKUP" "$SSHD_CONFIG"
}

echo "Modifying /etc/ssh/sshd_config..."

# Use a dedicated drop-in to override global settings
DROPIN_DIR="/etc/ssh/sshd_config.d"
DROPIN_FILE="$DROPIN_DIR/00-novatech-key-only.conf"

mkdir -p "$DROPIN_DIR"

# Back up any existing drop-in
if [[ -f "$DROPIN_FILE" ]]; then
    cp -a "$DROPIN_FILE" "${DROPIN_FILE}.backup.$(date +%Y%m%d%H%M%S)"
fi

# Make sure drop-in configuration is included
if ! grep -Eq \
    '^[[:space:]]*Include[[:space:]]+/etc/ssh/sshd_config.d/\*' \
    "$SSHD_CONFIG"; then
    echo "ERROR: sshd_config does not include sshd_config.d."
    echo "No authentication settings were changed."
    exit 1
fi

cat > "$DROPIN_FILE" <<'EOF'
# NovaTech - Key-only SSH authentication
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
EOF

chmod 644 "$DROPIN_FILE"

echo "  PasswordAuthentication: no"
echo "  ChallengeResponseAuthentication: no"
echo "  PubkeyAuthentication: yes"
echo "  UsePAM: yes"
echo

echo "Validating configuration..."

if sshd -t; then
    echo "  sshd -t: Configuration OK"
else
    restore_config
    echo "ERROR: SSH configuration validation failed."
    exit 1
fi

# Verify effective configuration
EFFECTIVE_CONFIG=$(sshd -T \
    -C "user=$SSH_USER,host=$SSH_HOST,addr=127.0.0.1")

if ! grep -qx 'passwordauthentication no' \
    <<< "$EFFECTIVE_CONFIG" ||
   ! grep -qx 'kbdinteractiveauthentication no' \
    <<< "$EFFECTIVE_CONFIG" ||
   ! grep -qx 'pubkeyauthentication yes' \
    <<< "$EFFECTIVE_CONFIG"; then
    echo "ERROR: Effective SSH authentication settings are incorrect."
    echo "Review Include and Match directives."
    exit 1
fi

echo
echo "Reloading SSH..."

if systemctl reload ssh; then
    echo "  ssh.service: Reloaded"
else
    echo "ERROR: Failed to reload SSH."
    exit 1
fi

echo
echo "Verification:"
echo "  Password auth: DISABLED"
echo "  Pubkey auth: ENABLED"

echo
echo "SSH now requires key-based authentication."
