#!/bin/bash

# Install WireGuard
apt update
apt install -y wireguard

# Create WireGuard directory
mkdir -p /etc/wireguard
chmod 700 /etc/wireguard

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key

# Generate Admin client keys
wg genkey | tee /etc/wireguard/admin_private.key | wg pubkey > /etc/wireguard/admin_public.key

# Generate Finance client keys
wg genkey | tee /etc/wireguard/finance_private.key | wg pubkey > /etc/wireguard/finance_public.key

# Protect private keys
chmod 600 /etc/wireguard/*_private.key

# Read keys
SERVER_PRIVATE=$(cat /etc/wireguard/server_private.key)
SERVER_PUBLIC=$(cat /etc/wireguard/server_public.key)

ADMIN_PRIVATE=$(cat /etc/wireguard/admin_private.key)
ADMIN_PUBLIC=$(cat /etc/wireguard/admin_public.key)

FINANCE_PRIVATE=$(cat /etc/wireguard/finance_private.key)
FINANCE_PUBLIC=$(cat /etc/wireguard/finance_public.key)

# Get server IP address
SERVER_ENDPOINT=$(ip -4 addr show eth1 | awk '/inet / {print $2}' | cut -d/ -f1)

# Create server configuration
cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = 10.200.0.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE

[Peer]
PublicKey = $ADMIN_PUBLIC
AllowedIPs = 10.200.0.2/32

[Peer]
PublicKey = $FINANCE_PUBLIC
AllowedIPs = 10.200.0.3/32
EOF

# Protect server configuration
chmod 600 /etc/wireguard/wg0.conf

# Create Admin client configuration
cat > /etc/wireguard/admin.conf <<EOF
[Interface]
Address = 10.200.0.2/32
PrivateKey = $ADMIN_PRIVATE

[Peer]
PublicKey = $SERVER_PUBLIC
Endpoint = $SERVER_ENDPOINT:51820
AllowedIPs = 10.200.0.0/24, 192.168.1.50/32
PersistentKeepalive = 25
EOF

# Create Finance client configuration
cat > /etc/wireguard/finance.conf <<EOF
[Interface]
Address = 10.200.0.3/32
PrivateKey = $FINANCE_PRIVATE

[Peer]
PublicKey = $SERVER_PUBLIC
Endpoint = $SERVER_ENDPOINT:51820
AllowedIPs = 10.200.0.1/32
PersistentKeepalive = 25
EOF

# Start WireGuard
wg-quick up wg0

# Display WireGuard status
wg show