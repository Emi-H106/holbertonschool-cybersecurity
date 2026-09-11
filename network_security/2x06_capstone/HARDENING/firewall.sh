#!/bin/bash

# Flush existing rules
nft flush ruleset

# Create filter table
nft add table inet filter

# Create chains
nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'
nft add chain inet filter forward '{ type filter hook forward priority 0; policy drop; }'
nft add chain inet filter output '{ type filter hook output priority 0; policy accept; }'

# Allow loopback traffic
nft add rule inet filter input iifname "lo" accept

# Allow established and related connections
nft add rule inet filter input ct state established,related accept
nft add rule inet filter forward ct state established,related accept

# Allow WireGuard
nft add rule inet filter input udp dport 51820 accept

# Allow SSH only for Remote Admin over VPN
nft add rule inet filter input ip saddr 10.200.0.2 tcp dport 22 accept

# Allow FTP only for Finance over VPN
nft add rule inet filter input ip saddr 10.200.0.3 tcp dport 21 accept

# Allow Remote Admin to access the database
nft add rule inet filter forward ip saddr 10.200.0.2 ip daddr 192.168.1.50 tcp dport 3306 accept

# Create NAT table
nft add table ip nat

# Create postrouting chain
nft add chain ip nat postrouting '{ type nat hook postrouting priority 100; policy accept; }'

# Enable masquerading for VPN clients
nft add rule ip nat postrouting ip saddr 10.200.0.0/24 oifname "eth1" masquerade

# Display the final ruleset
nft list ruleset