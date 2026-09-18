#!/bin/bash
# Usage: sudo bash hardening.sh <admin_username>

set -e

ADMIN_USER="${1:-}"
CONFIG="/etc/ssh/sshd_config"
POLICY="/etc/ssh/nexus_hardening.conf"
BACKUP="/etc/ssh/sshd_config.before_nexus"

# 1. Check root privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: run this script with sudo."
    exit 1
fi

# 2. Check the administrator account.
if [ -z "$ADMIN_USER" ] || [ "$ADMIN_USER" = "root" ]; then
    echo "Usage: sudo bash hardening.sh <non-root_admin_username>"
    exit 1
fi

if ! id "$ADMIN_USER" >/dev/null 2>&1; then
    echo "Error: this user does not exist."
    exit 1
fi

for GROUP in ssh_users sudo; do
    if ! id -nG "$ADMIN_USER" | tr ' ' '\n' | grep -qx "$GROUP"; then
        echo "Error: $ADMIN_USER must belong to $GROUP."
        exit 1
    fi
done

# 3. Check that an SSH public key is installed.
ADMIN_HOME=$(getent passwd "$ADMIN_USER" | cut -d: -f6)

if [ ! -s "$ADMIN_HOME/.ssh/authorized_keys" ]; then
    echo "Error: install the administrator's SSH public key first."
    exit 1
fi

# 4. Validate and back up the existing configuration.
/usr/sbin/sshd -t
cp -p "$CONFIG" "$BACKUP"

# 5. Write the SSH security policy.
cat > "$POLICY" <<'EOF'
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin no
AllowGroups ssh_users
EOF

chown root:root "$POLICY"
chmod 600 "$POLICY"

# 6. Read this policy before the other global SSH settings.
# Remove the previous reference to avoid duplicates.
sed -i '\|^Include /etc/ssh/nexus_hardening.conf$|d' "$CONFIG"
sed -i '1i Include /etc/ssh/nexus_hardening.conf' "$CONFIG"

# 7. Validate the new configuration.
if ! /usr/sbin/sshd -t; then
    cp -p "$BACKUP" "$CONFIG"
    echo "Error: invalid configuration. SSH was not reloaded."
    exit 1
fi

# 8. Apply the configuration.
systemctl reload ssh

echo "SSH hardening completed."
echo "Keep this session open and test a new SSH connection."