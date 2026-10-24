#!/bin/bash
# NovaTech - Secure SSH Key Generation
# Generate an ED25519 SSH key pair.

set -Eeuo pipefail

SSH_DIR="$HOME/.ssh"
PRIVATE_KEY="$SSH_DIR/id_ed25519"
PUBLIC_KEY="$PRIVATE_KEY.pub"

echo "=== SSH Key Generation ==="
echo

# Check ssh-keygen availability.
if ! command -v ssh-keygen >/dev/null 2>&1; then
    echo "ERROR: ssh-keygen is not installed."
    exit 1
fi

# Create SSH directory with secure permissions.
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Prevent accidental overwrite of existing keys.
if [[ -e "$PRIVATE_KEY" || -e "$PUBLIC_KEY" ]]; then
    echo "ERROR: SSH key already exists."
    echo "Private key: $PRIVATE_KEY"
    echo "Public key: $PUBLIC_KEY"
    echo "Existing keys will not be overwritten."
    exit 1
fi

echo "Generating ED25519 key pair..."
echo "  Algorithm: ED25519 (recommended)"
echo "  Key file: ~/.ssh/id_ed25519"
echo

# Generate SSH key pair.
# ssh-keygen prompts for a passphrase interactively.
ssh-keygen -t ed25519 -a 100 -f $HOME/.ssh/id_ed25519

echo
echo "Key pair generated:"
echo "  Private key: $PRIVATE_KEY"
echo "  Public key: $PUBLIC_KEY"
echo

echo "Setting permissions..."

chmod 600 $HOME/.ssh/id_ed25519
chmod 644 "$PUBLIC_KEY"

echo "  Private key: 600 (owner read/write only)"
echo "  Public key: 644"
echo

echo "Public key fingerprint:"
ssh-keygen -lf $HOME/.ssh/id_ed25519.pub -E sha256

echo
echo "Your public key:"
cat "$PUBLIC_KEY"

echo
echo "Next step: Add this public key to target servers' authorized_keys"
