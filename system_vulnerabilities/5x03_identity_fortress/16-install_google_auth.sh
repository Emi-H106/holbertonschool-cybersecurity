#!/bin/bash
# NovaTech - Install Google Authenticator PAM Module
# Target: Ubuntu 20.04

set -Eeuo pipefail

echo "=== Google Authenticator Installation ==="
echo

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Please run this script with sudo."
    exit 1
fi

# Install Google Authenticator PAM module
echo "Installing libpam-google-authenticator..."

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt install -y libpam-google-authenticator

# Verify package installation
if dpkg -s libpam-google-authenticator >/dev/null 2>&1; then
    echo "  Package: Installed"
else
    echo "ERROR: Package installation failed."
    exit 1
fi

echo

# Find PAM module
echo "Module location:"

MODULE_PATH=$(find /lib /usr/lib \
    -name "pam_google_authenticator.so" \
    -type f -print -quit 2>/dev/null)

if [[ -n "$MODULE_PATH" ]]; then
    echo "  $MODULE_PATH"
else
    echo "ERROR: PAM module not found."
    exit 1
fi

echo

# Check google-authenticator command
if ! command -v google-authenticator >/dev/null 2>&1; then
    echo "ERROR: google-authenticator command not found."
    exit 1
fi

# Display next steps
echo "Next steps:"
echo "  1. Run 'google-authenticator' as each user to generate secrets"
echo "  2. Configure /etc/pam.d/sshd to require the module"
echo "  3. Enable ChallengeResponseAuthentication in sshd_config"

echo
echo "Google Authenticator PAM module: INSTALLED"
