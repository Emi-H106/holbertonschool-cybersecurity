#!/bin/bash

# Repair interrupted packages and broken dependencies.

set -e

echo "=== Package Repair ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

echo "Configuring interrupted packages..."

dpkg --configure -a

echo
echo "Fixing broken dependencies..."

DEBIAN_FRONTEND=noninteractive apt-get install -f -y

echo
echo "Verification:"

half_configured=$(dpkg-query -W \
    -f='${db:Status-Abbrev}\n' 2>/dev/null |
    awk 'substr($1,2,1)=="F" {count++}
         END {print count+0}')

audit_output=$(dpkg --audit 2>&1)

if [ -z "$audit_output" ]; then
    broken_dependencies=0
else
    broken_dependencies=1
fi

echo "  Half-configured packages: $half_configured"
echo "  Broken dependencies: $broken_dependencies"

echo

if [ "$half_configured" -eq 0 ] &&
   [ "$broken_dependencies" -eq 0 ]; then
    echo "Package database: CONSISTENT"
else
    echo "Package database: INCONSISTENT"
    exit 1
fi
