#!/bin/bash
# NovaTech - fail2ban SSH Protection
# Target: Ubuntu 20.04

set -Eeuo pipefail

JAIL_FILE="/etc/fail2ban/jail.local"

echo "=== fail2ban Configuration ==="
echo

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Installing fail2ban..."

export DEBIAN_FRONTEND=noninteractive

if ! command -v fail2ban-client >/dev/null 2>&1; then
    apt update
    apt install -y fail2ban
fi

echo "  fail2ban: Installed"
echo

echo "Creating /etc/fail2ban/jail.local..."

# Back up existing configuration
if [[ -f "$JAIL_FILE" ]]; then
    cp -a "$JAIL_FILE" \
        "${JAIL_FILE}.bak.$(date +%Y%m%d%H%M%S)"
fi

# Create SSH jail configuration
cat > "$JAIL_FILE" <<'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
findtime = 600
bantime = 3600
EOF

echo
echo "[sshd] configuration:"
echo "  enabled = true"
echo "  port = ssh"
echo "  filter = sshd"
echo "  logpath = /var/log/auth.log"
echo "  maxretry = 5"
echo "  findtime = 600 (10 minutes)"
echo "  bantime = 3600 (1 hour)"
echo

# Check configuration
echo "Validating configuration..."

fail2ban-client -t

echo
echo "Starting fail2ban..."

systemctl enable --now fail2ban
systemctl restart fail2ban

if systemctl is-active --quiet fail2ban; then
    echo "  fail2ban.service: Active"
else
    echo "ERROR: fail2ban service is not active."
    exit 1
fi

echo
echo "Current status:"

# Wait briefly for the SSH jail to initialize
for attempt in 1 2 3 4 5; do
    if fail2ban-client status sshd >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

fail2ban-client status sshd

echo
echo "fail2ban: ACTIVE"
echo "IP addresses with 5+ failures in 10 min will be banned for 1 hour."
