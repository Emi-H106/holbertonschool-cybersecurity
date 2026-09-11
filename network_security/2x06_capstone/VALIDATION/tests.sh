#!/bin/bash

PASS=0
TOTAL=0

# Check function
check() {
    TOTAL=$((TOTAL + 1))

    if eval "$1"; then
        echo "[PASS] $2"
        PASS=$((PASS + 1))
    else
        echo "[FAIL] $2"
    fi
}

# Firewall checks
check "nft list chain inet filter input | grep -q 'policy drop'" \
"Firewall default INPUT policy is DROP"

check "nft list chain inet filter forward | grep -q 'policy drop'" \
"Firewall default FORWARD policy is DROP"

check "nft list ruleset | grep -q 'udp dport 51820 accept'" \
"WireGuard UDP 51820 is allowed"

check "nft list ruleset | grep -q '10.200.0.2.*tcp dport 22.*accept'" \
"SSH is allowed for Remote Admin"

check "nft list ruleset | grep -q '10.200.0.3.*tcp dport 21.*accept'" \
"FTP is allowed for Finance"

# SSH checks
check "pgrep -x sshd > /dev/null" \
"SSH service is running"

check "grep -Eq '^PermitRootLogin[[:space:]]+no' /etc/ssh/sshd_config" \
"SSH root login disabled"

check "grep -Eq '^PasswordAuthentication[[:space:]]+no' /etc/ssh/sshd_config" \
"SSH password authentication disabled"

check "grep -Eq '^PubkeyAuthentication[[:space:]]+yes' /etc/ssh/sshd_config" \
"SSH public key authentication enabled"

# VPN checks
check "ip link show wg0 > /dev/null 2>&1" \
"VPN interface wg0 exists"

check "ip link show wg0 | grep -q 'UP'" \
"VPN interface wg0 is UP"

check "wg show wg0 > /dev/null 2>&1" \
"WireGuard is running"

# Unnecessary service checks
check "! pgrep -x telnetd > /dev/null" \
"Telnet service is stopped"

# FTP check
check "pgrep -x vsftpd > /dev/null" \
"FTP service is running"

check "grep -Eq '^anonymous_enable=NO' /etc/vsftpd.conf" \
"Anonymous FTP is disabled"

# Network checks
check "ip addr show wg0 | grep -q '10.200.0.1/24'" \
"WireGuard interface has address 10.200.0.1/24"

check "sysctl -n net.ipv4.ip_forward | grep -q '^1$'" \
"IP forwarding is enabled"

# Result
echo
echo "RESULT: $PASS/$TOTAL checks passed"