#!/bin/bash

REPORT="/var/log/hardening/suid_audit.txt"
SUID_COUNT=0
SGID_COUNT=0
UNKNOWN_COUNT=0

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

mkdir -p /var/log/hardening

# Save output to both terminal and report file
exec > >(tee "$REPORT") 2>&1

echo "=== SUID/SGID Binary Audit ==="
echo

echo "SUID binaries (run as owner):"

while IFS= read -r file; do
    owner=$(stat -c "%U" "$file")

    case "$file" in
        /usr/bin/sudo|/usr/bin/passwd|/usr/bin/chsh)
            status="KNOWN SAFE"
            ;;
        /usr/bin/newgrp|/usr/bin/mount|/usr/bin/umount)
            status="REVIEW NEEDED"
            ;;
        *)
            status="UNKNOWN - HIGH RISK"
            UNKNOWN_COUNT=$((UNKNOWN_COUNT + 1))
            ;;
    esac

    printf "  %-30s %-8s %s\n" "$file" "$owner" "$status"
    SUID_COUNT=$((SUID_COUNT + 1))

done < <(find / -type f -perm -4000 -perm /111 2>/dev/null | sort)

echo
echo "SGID binaries (run as group):"

while IFS= read -r file; do
    group=$(stat -c "%G" "$file")

    case "$file" in
        /usr/bin/ssh-agent)
            status="KNOWN SAFE"
            ;;
        *)
            status="REVIEW NEEDED"
            ;;
    esac

    printf "  %-30s %-8s %s\n" "$file" "$group" "$status"
    SGID_COUNT=$((SGID_COUNT + 1))

done < <(find / -type f -perm -2000 -perm /111 2>/dev/null | sort)

echo
echo "Summary:"
echo "  Total SUID: $SUID_COUNT"
echo "  Total SGID: $SGID_COUNT"
echo "  Unknown/Custom: $UNKNOWN_COUNT (requires investigation)"
echo
echo "Full report saved to: $REPORT"
