#!/bin/bash

CONFIG_FILE="/etc/sysctl.d/99-hardening.conf"

PASSED=0
TOTAL=0

check_param() {
    local param="$1"
    local expected="$2"
    local actual

    TOTAL=$((TOTAL + 1))

    actual=$(sysctl -n "$param" 2>/dev/null)

    if [ "$actual" = "$expected" ]; then
        echo "  [PASS] $param = $actual"
        PASSED=$((PASSED + 1))
    else
        echo "  [FAIL] $param = ${actual:-unavailable} (expected: $expected)"
    fi
}

echo "=== Kernel Hardening Verification ==="
echo

echo "IP Forwarding:"
check_param net.ipv4.ip_forward 0
check_param net.ipv6.conf.all.forwarding 0
echo

echo "ICMP Redirects:"
check_param net.ipv4.conf.all.accept_redirects 0
check_param net.ipv4.conf.all.send_redirects 0
check_param net.ipv4.conf.default.accept_redirects 0
echo

echo "Reverse Path Filtering:"
check_param net.ipv4.conf.all.rp_filter 1
check_param net.ipv4.conf.default.rp_filter 1
echo

echo "SYN Cookies:"
check_param net.ipv4.tcp_syncookies 1
echo

echo "Source Routing:"
check_param net.ipv4.conf.all.accept_source_route 0
echo

echo "ICMP Configuration:"
check_param net.ipv4.icmp_echo_ignore_broadcasts 1
echo

echo "Persistence Check:"
TOTAL=$((TOTAL + 1))

if [ -f "$CONFIG_FILE" ]; then
    echo "  [PASS] $CONFIG_FILE exists"
    PASSED=$((PASSED + 1))
else
    echo "  [FAIL] $CONFIG_FILE does not exist"
fi

echo
echo "Summary: $PASSED/$TOTAL checks passed"

if [ "$PASSED" -eq "$TOTAL" ]; then
    echo "Kernel hardening: COMPLETE"
else
    echo "Kernel hardening: INCOMPLETE"
    exit 1
fi
