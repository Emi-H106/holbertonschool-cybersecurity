#!/bin/bash

set -e

echo "=== Legal Banner Configuration ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
BANNER_FILE="/etc/issue.net"

echo "Creating banner in $BANNER_FILE..."

cat > "$BANNER_FILE" <<'EOF'
=====================================
AUTHORIZED ACCESS ONLY

This system is the property of NovaTech Solutions.
Unauthorized access is prohibited and will be prosecuted.
All activities are monitored and logged.
=====================================
EOF

chmod 644 "$BANNER_FILE"

echo
echo "Banner content:"
cat "$BANNER_FILE"
echo

echo "Configuring SSH to display banner..."

cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak.task22"

# Remove existing active Banner directives in the main config.
sed -i '/^[[:space:]]*Banner[[:space:]]/Id' "$SSHD_CONFIG"

# Place Banner before Include directives so it takes precedence.
sed -i '1i Banner /etc/issue.net' "$SSHD_CONFIG"

if /usr/sbin/sshd -t; then
    echo "  Banner /etc/issue.net: Enabled"
else
    echo "SSH configuration is invalid."
    cp "${SSHD_CONFIG}.bak.task22" "$SSHD_CONFIG"
    exit 1
fi

echo
echo "Reloading SSH..."

systemctl reload ssh.service

echo
echo "Verification:"

if [ -f "$BANNER_FILE" ]; then
    echo "  /etc/issue.net: EXISTS ✓"
else
    echo "  /etc/issue.net: MISSING"
    exit 1
fi

ACTIVE_BANNER=$(/usr/sbin/sshd -T |
    awk '$1 == "banner" {print $2}')

if [ "$ACTIVE_BANNER" = "/etc/issue.net" ]; then
    echo "  SSH Banner config: ENABLED ✓"
else
    echo "  SSH Banner config: FAILED"
    exit 1
fi

echo
echo "Legal banner configured."
