#!/bin/bash

# Analyze APT package versions, priorities, and repositories.

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

if ! [[ "$package" =~ ^[a-zA-Z0-9.+:-]+$ ]]; then
    echo "ERROR: Invalid package name."
    exit 1
fi

policy=$(apt-cache policy "$package")

if [ -z "$policy" ]; then
    echo "ERROR: Package '$package' not found."
    exit 1
fi

installed=$(echo "$policy" |
    awk '/Installed:/ {print $2; exit}')

candidate=$(echo "$policy" |
    awk '/Candidate:/ {print $2; exit}')

echo "=== Package Policy Analysis ==="
echo
echo "Package: $package"
echo "Installed: $installed"
echo "Candidate: $candidate"
echo

echo "Available versions:"
printf "  %-30s %-9s %s\n" \
    "Version" "Priority" "Repository"

apt-cache policy "$package" |
awk '
    /Version table:/ {
        in_table = 1
        next
    }

    in_table && /^[[:space:]]*(\*\*\*[[:space:]]*)?[^[:space:]]+[[:space:]]+[0-9]+$/ {
        line = $0
        gsub(/\*\*\*/, "", line)
        split(line, fields)
        version = fields[1]
        priority = fields[2]
        next
    }

    in_table && /focal-security|focal-updates|focal\// {
        repo = "unknown"

        if ($0 ~ /focal-security/) {
            repo = "focal-security"
        } else if ($0 ~ /focal-updates/) {
            repo = "focal-updates"
        } else if ($0 ~ /focal\//) {
            repo = "focal"
        }

        if (version != "") {
            printf "  %-30s %-9s %s\n", version, priority, repo
            version = ""
        }
    }
'

echo
echo "Analysis:"

if [ "$installed" = "(none)" ]; then
    echo "  Security update available: N/A"
    echo "  Version delta: Package not installed"
    echo "  Recommendation: Review package before installation"

elif [ "$candidate" = "(none)" ]; then
    echo "  Security update available: UNKNOWN"
    echo "  Version delta: No candidate available"
    echo "  Recommendation: Check APT repositories"

elif dpkg --compare-versions "$candidate" gt "$installed"; then

    if apt-cache policy "$package" |
        grep -q "focal-security"; then
        echo "  Security update available: YES"
    else
        echo "  Security update available: NO"
    fi

    echo "  Version delta: Installed version is outdated"
    echo "  Recommendation: Update to $candidate"

else
    echo "  Security update available: NO"
    echo "  Version delta: Up to date"
    echo "  Recommendation: No update required"
fi
