#!/bin/bash

DEV_COUNT=0
NET_COUNT=0
REMOTE_COUNT=0

check_package() {
    local package="$1"
    local description="$2"

    if dpkg -s "$package" 2>/dev/null | grep -q "^Status: install ok installed$"; then
        echo "  [FOUND] $package ($description)"
        return 0
    else
        return 1
    fi
}

echo "=== Package Security Audit ==="
echo

echo "Checking for development tools..."

check_package gcc "GNU C Compiler" && ((DEV_COUNT+=1))
check_package g++ "GNU C++ Compiler" && ((DEV_COUNT+=1))
check_package make "Build automation" && ((DEV_COUNT+=1))
check_package gdb "Debugger" && ((DEV_COUNT+=1))

echo
echo "Checking for network tools..."

check_package netcat-openbsd "Network Swiss Army Knife" && ((NET_COUNT+=1))
check_package nmap "Network scanner" && ((NET_COUNT+=1))
check_package tcpdump "Packet capture" && ((NET_COUNT+=1))

echo
echo "Checking for remote access tools..."

check_package telnet "Insecure remote access" && ((REMOTE_COUNT+=1))

echo
echo "Summary:"
echo "  Development tools: $DEV_COUNT found"
echo "  Network tools: $NET_COUNT found"
echo "  Remote access: $REMOTE_COUNT found"
echo
echo "Recommendation: Review and remove unnecessary packages."
