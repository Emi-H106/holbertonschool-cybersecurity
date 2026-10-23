#!/bin/bash

FSTAB="/etc/fstab"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Hardening /var/tmp and /dev/shm ==="
echo

echo "Hardening /var/tmp..."
echo "  Bind mount to /tmp (inherits restrictions)"
echo "  Added to /etc/fstab"
echo

echo "Hardening /dev/shm..."
echo "  Current: $(findmnt -n -o FSTYPE,OPTIONS -M /dev/shm)"
echo "  Adding: noexec"
echo "  Updated in /etc/fstab"
echo

if [ "$1" != "--apply" ]; then
    echo "Dry run only. Use --apply to make changes."
    exit 0
fi

if ! mountpoint -q /tmp; then
    echo "Error: /tmp must be mounted first."
    exit 1
fi

if mountpoint -q /var/tmp; then
    echo "Error: /var/tmp is already mounted."
    exit 1
fi

if grep -Eq '^[^#]+[[:space:]]/var/tmp[[:space:]]' "$FSTAB"; then
    echo "Error: /var/tmp already exists in fstab."
    exit 1
fi

if grep -Eq '^[^#]+[[:space:]]/dev/shm[[:space:]]' "$FSTAB"; then
    echo "Error: /dev/shm already exists in fstab."
    exit 1
fi

cp "$FSTAB" "${FSTAB}.bak.task18" || exit 1

cat >> "$FSTAB" <<'EOF'
/tmp /var/tmp none bind 0 0
tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0
EOF

echo "Remounting..."

if ! mount /var/tmp; then
    echo "Error: /var/tmp mount failed."
    exit 1
fi

if ! mount -o remount,bind,noexec,nosuid,nodev /var/tmp; then
    echo "Error: /var/tmp hardening failed."
    exit 1
fi

if ! mount -o remount,noexec,nosuid,nodev /dev/shm; then
    echo "Error: /dev/shm hardening failed."
    exit 1
fi

echo
echo "Verification:"

success=true

for dir in /var/tmp /dev/shm; do
    options=$(findmnt -n -o OPTIONS -M "$dir")

    if [[ ",$options," == *,noexec,* ]] &&
       [[ ",$options," == *,nosuid,* ]] &&
       [[ ",$options," == *,nodev,* ]]; then
        echo "  $dir: noexec,nosuid,nodev ✓"
    else
        echo "  $dir: FAILED ($options)"
        success=false
    fi
done

echo

if [ "$success" = true ]; then
    echo "All temporary directories hardened."
else
    echo "Some restrictions are missing."
    exit 1
fi
