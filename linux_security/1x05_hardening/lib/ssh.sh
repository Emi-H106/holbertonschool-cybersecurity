#!/bin/bash

configure_ssh() {
    SSHD_CONFIG="/etc/ssh/sshd_config"

    sed -i '/^PasswordAuthentication/d' "$SSHD_CONFIG"
    sed -i '/^PubkeyAuthentication/d' "$SSHD_CONFIG"
    sed -i '/^PermitRootLogin/d' "$SSHD_CONFIG"
    sed -i '/^Port /d' "$SSHD_CONFIG"

    echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
    echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
    echo "PermitRootLogin no" >> "$SSHD_CONFIG"
    echo "Port $SSH_PORT" >> "$SSHD_CONFIG"

    log "SSH configuration hardened"
}
