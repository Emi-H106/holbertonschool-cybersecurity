#!/bin/bash

check_binary() {
    local binary="$1"
    local warning="$2"

    path=$(command -v "$binary")

    if [ -n "$path" ]; then
        permissions=$(stat -c "%A" "$path")
        echo "  $path: $permissions ($warning)"
    else
        echo "  $binary: Not found"
    fi
}

echo "=== Living off the Land Binaries Audit ==="
echo
echo "Checking GTFOBins candidates..."
echo

echo "File Readers (can read sensitive files):"
check_binary cat "OK"
check_binary less "OK"
check_binary vim "WARNING: Can escape to shell"

echo
echo "Shell Escapes:"
check_binary python3 "WARNING: Can spawn shells"
check_binary perl "WARNING: Can spawn shells"
check_binary awk "OK"

echo
echo "Network Tools:"
check_binary wget "WARNING: Can download payloads"
check_binary curl "WARNING: Can download payloads"

echo
echo "Note: These binaries are legitimate but should be monitored."
echo "See https://gtfobins.github.io/ for abuse techniques."
