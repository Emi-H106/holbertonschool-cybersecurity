#!/bin/bash
# NovaTech - SSH Key Deployment
# Install a public SSH key into authorized_keys.

set -Eeuo pipefail

echo "=== SSH Key Deployment ==="
echo

# Check arguments
if [[ $# -eq 0 ]]; then
    echo "ERROR: No public key provided."
    echo "Usage: $0 'ssh-ed25519 PUBLIC_KEY user@host'"
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "ERROR: Exactly one public key is required."
    exit 1
fi

PUBLIC_KEY="$1"

# Validate public key format and contents
if [[ "$PUBLIC_KEY" == *$'\n'* ||
      "$PUBLIC_KEY" == *$'\r'* ]]; then
    echo "ERROR: Public key must be a single line."
    exit 1
fi

if [[ ! "$PUBLIC_KEY" =~ ^ssh-ed25519[[:space:]]+ ]]; then
    echo "ERROR: Expected an ED25519 public key."
    exit 1
fi

if ! printf '%s\n' "$PUBLIC_KEY" |
    ssh-keygen -lf - >/dev/null 2>&1; then
    echo "ERROR: Invalid SSH public key."
    exit 1
fi

# Determine target user
TARGET_USER=$(whoami)
USER_HOME="$HOME"

SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

echo "Target user: $TARGET_USER"
echo

# Create SSH directory
echo "Creating .ssh directory if needed..."

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

echo "  $SSH_DIR: Ready"
echo "  Permissions: 700"
echo

# Create authorized_keys if necessary
touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

# Display public key fingerprint
FINGERPRINT=$(printf '%s\n' "$PUBLIC_KEY" |
    ssh-keygen -lf - -E sha256 |
    awk '{print $2}')

echo "Adding key to authorized_keys..."
echo "  Key fingerprint: $FINGERPRINT"

# Avoid duplicate keys by comparing key type and data
KEY_DATA=$(printf '%s\n' "$PUBLIC_KEY" | awk '{print $2}')

if awk -v key="$KEY_DATA" '
    $1 == "ssh-ed25519" && $2 == key {
        found = 1
    }
    END {
        exit !found
    }
' "$AUTHORIZED_KEYS"; then
    echo "  Key already exists"
else
    printf '%s\n' "$PUBLIC_KEY" >> "$AUTHORIZED_KEYS"
    echo "  Key added successfully"
fi

echo
echo "Setting permissions..."

chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"

echo "  authorized_keys: 600"
echo

# Verification
echo "Verification:"

KEY_COUNT=$(grep -cE \
    '^(ssh-ed25519|ssh-rsa|ecdsa-sha2-)' \
    "$AUTHORIZED_KEYS" || true)

DIR_PERMS=$(stat -c "%a" "$SSH_DIR")
FILE_PERMS=$(stat -c "%a" "$AUTHORIZED_KEYS")

echo "  Key count in authorized_keys: $KEY_COUNT"

if [[ "$DIR_PERMS" == "700" &&
      "$FILE_PERMS" == "600" ]]; then
    echo "  Permissions correct: YES"
else
    echo "  Permissions correct: NO"
    exit 1
fi

echo
echo "SSH key deployed."
echo "User can now authenticate with this key."
