#!/bin/bash
set -e

WEB_IP="${1:-}"
BASTION_IP="${2:-}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

if [ -z "$WEB_IP" ] || [ -z "$BASTION_IP" ]; then
    echo "Usage: sudo bash network_defense.sh <web_private_ip> <bastion_ip>"
    exit 1
fi

if ! command -v ufw >/dev/null 2>&1; then
    echo "UFW is not installed."
    exit 1
fi

# Remove existing UFW rules, including public access to port 5432.
ufw --force reset

# Deny incoming traffic unless it is explicitly allowed.
ufw default deny incoming
ufw default allow outgoing

# Allow PostgreSQL only from the web server.
ufw allow from "$WEB_IP" to any port 5432 proto tcp

# Allow SSH only from the bastion host.
ufw allow from "$BASTION_IP" to any port 22 proto tcp

# Enable the firewall and display its rules.
ufw --force enable
ufw status verbose