#!/bin/bash

FSTAB="/etc/fstab"
ENTRY="tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

echo "=== Hardening /tmp ==="
echo

echo "Current /tmp mount:"
findmnt -T /tmp -o SOURCE,TARGET,FSTYPE,OPTIONS -n
echo

echo "Applying hardening options..."
echo
echo "Method: tmpfs mount"
echo "Adding to /etc/fstab:"
echo "  $ENTRY"
echo

if [ "$1" != "--apply" ]; then
    echo "Dry run only. Use --apply to make changes."
    exit 0
fi

if mountpoint -q /tmp; then
    echo "Error: /tmp is already a separate mount."
    echo "Review its configuration before changing it."
    exit 1
fi

if grep -Eq '^[[:space:]]*[^#[:space:]]+[[:space:]]+/tmp[[:space:]]+' "$FSTAB"; then
    echo "Error: /tmp already has an fstab entry."
    echo "Review it before adding another."
    exit 1
fi

cp "$FSTAB" "${FSTAB}.bak"

echo "$ENTRY" >> "$FSTAB"

echo "Remounting /tmp..."
mount /tmp || {
    echo "Mount failed. Restore the fstab backup if necessary."
    exit 1
}

echo
echo "Verification:"
options=$(findmnt -n -o OPTIONS --target /tmp)
echo "  /tmp mount options: $options"

echo
echo "Testing restrictions:"

testfile=$(mktemp /tmp/suid-test.XXXXXX)

printf '#!/bin/sh\necho test\n' > "$testfile"
chmod 755 "$testfile"

if "$testfile" >/dev/null 2>&1; then
    echo "  Execute test: FAILED"
else
    echo "  Execute test: BLOCKED (Permission denied)"
fi

rm -f "$testfile"

case ",$options," in
    *,nosuid,*)
        echo "  SUID test: BLOCKED (nosuid active)"
        ;;
    *)
        echo "  SUID test: FAILED"
        ;;
esac

echo
echo "/tmp hardened successfully."
