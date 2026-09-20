#!/bin/bash

# Usage: sudo bash hardening.sh <admin_username>

set -e

ADMIN_USER="${1:-}"
SSH_CONFIG="/etc/ssh/sshd_config"
HARDENING_CONFIG="/etc/ssh/sshd_config.d/00-nexus-hardening.conf"

# Check root privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Check the administrator account.
if [ -z "$ADMIN_USER" ] || ! id "$ADMIN_USER" >/dev/null 2>&1; then
    echo "Usage: sudo bash hardening.sh <existing_admin_username>"
    exit 1
fi

# Check that the administrator can use SSH and sudo.
if ! id -nG "$ADMIN_USER" | grep -qw ssh_users; then
    echo "Add $ADMIN_USER to the ssh_users group first."
    exit 1
fi

if ! id -nG "$ADMIN_USER" | grep -qw sudo; then
    echo "Add $ADMIN_USER to the sudo group first."
    exit 1
fi

# Check that the administrator has an SSH public key.
ADMIN_HOME=$(getent passwd "$ADMIN_USER" | cut -d: -f6)

if [ ! -s "$ADMIN_HOME/.ssh/authorized_keys" ]; then
    echo "Add the administrator's SSH public key first."
    exit 1
fi

# Check that Ubuntu loads the additional SSH configuration files.
if ! grep -Fq 'Include /etc/ssh/sshd_config.d/*.conf' "$SSH_CONFIG"; then
    echo "SSH does not load files from sshd_config.d."
    exit 1
fi

# Write the security settings. Re-running overwrites the same file.
cat > "$HARDENING_CONFIG" <<'EOF'
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
AllowGroups ssh_users
EOF

chown root:root "$HARDENING_CONFIG"
chmod 600 "$HARDENING_CONFIG"

# Validate before applying the configuration.
if /usr/sbin/sshd -t; then
    systemctl reload ssh
    echo "SSH hardening completed."
    echo "Keep this session open and test a new SSH login."
else
    echo "SSH configuration is invalid. SSH was not reloaded."
    exit 1
fi