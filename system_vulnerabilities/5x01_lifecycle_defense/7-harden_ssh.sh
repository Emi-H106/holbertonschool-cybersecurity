#!/bin/bash

# Harden SSH configuration with backup and validation.

set -euo pipefail

echo "=== SSH Hardening ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

config="/etc/ssh/sshd_config"
backup="${config}.backup.$(date +%Y%m%d%H%M%S)"

if [ ! -f "$config" ]; then
    echo "ERROR: SSH configuration file not found."
    exit 1
fi

cp -p "$config" "$backup"
echo "Backup created: $backup"
echo

echo "Applying hardening measures..."

set_ssh_option() {
    local key="$1"
    local value="$2"
    local old_value

    old_value=$(awk -v key="$key" '
        $1 == key || $1 == "#"key {
            print $2
            exit
        }
    ' "$config")

    if [ -z "$old_value" ]; then
        old_value="not set"
    fi

    sed -i -E "/^[[:space:]]*#?[[:space:]]*${key}[[:space:]]+/d" "$config"

    sed -i "1i ${key} ${value}" "$config"

    echo "  $key: $old_value -> $value"
}

set_ssh_option "PermitRootLogin" "no"
set_ssh_option "PasswordAuthentication" "no"
set_ssh_option "X11Forwarding" "no"
set_ssh_option "MaxAuthTries" "3"
set_ssh_option "ClientAliveInterval" "300"
set_ssh_option "ClientAliveCountMax" "2"

echo

if sshd -t -f "$config"; then
    echo "Configuration test: OK"
else
    echo "Configuration test: FAILED"
    cp -p "$backup" "$config"
    echo "Original configuration restored."
    exit 1
fi

echo
echo "Reloading SSH service..."

if systemctl is-active --quiet ssh; then
    systemctl reload ssh
    echo "  ssh.service: Reloaded"
elif systemctl is-active --quiet sshd; then
    systemctl reload sshd
    echo "  sshd.service: Reloaded"
else
    echo "  SSH service is not running."
    echo "  Configuration saved but not reloaded."
fi

echo
echo "SSH hardened successfully."
echo
echo "WARNING: Ensure key-based authentication is configured"
echo "         before closing this session."
