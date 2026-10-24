#!/bin/bash
# NovaTech - Configure User TOTP
# Generate Google Authenticator secrets for the current user.

set -Eeuo pipefail

echo "=== TOTP Setup for Current User ==="
echo

# Do not run as root
if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Run this script as a normal user, without sudo."
    exit 1
fi

# Check if Google Authenticator is installed
if ! command -v google-authenticator >/dev/null 2>&1; then
    echo "ERROR: google-authenticator is not installed."
    echo "Install it first:"
    echo "  sudo apt install -y libpam-google-authenticator"
    exit 1
fi

TOTP_FILE="$HOME/.google_authenticator"

# Avoid overwriting existing TOTP configuration
if [[ -e "$TOTP_FILE" ]]; then
    echo "WARNING: TOTP configuration already exists."
    echo "  $TOTP_FILE"
    echo
    echo "Existing configuration will not be overwritten."
    exit 1
fi

echo "Running google-authenticator with secure defaults..."
echo

# Generate time-based TOTP secrets
# -t: Time-based tokens
# -d: Disallow token reuse
# -f: Write configuration without confirmation
# -r 3 -R 30: Limit to 3 attempts per 30 seconds
# -w 3: Allow a 3-step verification window

google-authenticator \
    -t \
    -d \
    -f \
    -r 3 \
    -R 30 \
    -w 3

# Verify configuration file
if [[ ! -f "$TOTP_FILE" ]]; then
    echo "ERROR: TOTP configuration was not created."
    exit 1
fi

# Protect secret file
chmod 600 "$TOTP_FILE"

echo
echo "Configuration saved to ~/.google_authenticator"
echo

echo "Settings applied:"
echo "  Time-based tokens: YES"
echo "  Rate limiting: 3 attempts per 30 seconds"
echo "  Token reuse: DISALLOWED"
echo "  Window size: 3 (allows clock skew)"
echo

echo "IMPORTANT: Save your emergency codes securely!"
echo "Scan the QR code with your authenticator app."
echo
echo "TOTP setup completed successfully."
