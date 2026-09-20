#!/bin/bash

set -e

# Run as root.
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Check that UFW is installed.
if ! command -v ufw >/dev/null 2>&1; then
    echo "UFW is not installed."
    exit 1
fi

# Remove old UFW rules, including public access to PostgreSQL.
ufw --force reset

# Deny incoming connections by default.
ufw default deny incoming
ufw default allow outgoing

# Allow PostgreSQL only from the web server's private IP.
ufw allow from 10.0.1.10 to any port 5432 proto tcp

# Allow SSH only from the bastion host.
ufw allow from 10.0.1.5 to any port 22 proto tcp

# Enable UFW and show the applied rules.
ufw --force enable
ufw status verbose