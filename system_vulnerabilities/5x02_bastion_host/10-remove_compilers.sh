#!/bin/bash
set -e

PACKAGES=("gcc" "g++" "make")

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Development Tools Removal ==="
echo

echo "Checking dependencies before removal..."

# Simulate removal before making changes
simulation=$(apt-get -s remove "${PACKAGES[@]}")

# Stop if other installed packages would also be removed
extra=$(echo "$simulation" | awk '
    $1 == "Rem" && $2 != "gcc" && $2 != "g++" && $2 != "make" {
        print $2
    }
')

if [ -n "$extra" ]; then
    echo "Removal would affect other packages:"
    echo "$extra"
    echo "Aborting removal. Review dependencies first."
    exit 1
fi

for package in "${PACKAGES[@]}"; do
    echo "  $package: Can be safely removed"
done

echo
echo "Removing packages..."

apt-get remove -y "${PACKAGES[@]}" >/dev/null

for package in "${PACKAGES[@]}"; do
    echo "  $package: Removed"
done

echo
echo "Cleanup..."
echo "  Removing orphaned dependencies..."

# Count packages scheduled for automatic removal
count=$(apt-get -s autoremove | awk '$1 == "Rem" {count++} END {print count+0}')

apt-get autoremove -y >/dev/null

echo "  $count packages auto-removed"

echo
echo "Verification:"

failed=0

for package in "${PACKAGES[@]}"; do
    if dpkg -s "$package" 2>/dev/null | grep -q "Status: install ok installed"; then
        echo "  $package: Still installed"
        failed=1
    else
        echo "  $package: Not found"
    fi
done

echo

if [ "$failed" -eq 0 ]; then
    echo "Compilers removed successfully."
else
    echo "Some compilers are still installed."
    exit 1
fi
