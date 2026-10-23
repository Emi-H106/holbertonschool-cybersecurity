#!/bin/bash

echo "=== Root Account Lockdown ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

ADMIN_USER="${SUDO_USER:-}"

if [ -z "$ADMIN_USER" ] || [ "$ADMIN_USER" = "root" ]; then
    echo "Error: Run this script with sudo from a normal user."
    exit 1
fi

echo "Pre-flight checks:"

if sudo -n -l -U "$ADMIN_USER" >/dev/null 2>&1 &&
   command -v runuser >/dev/null 2>&1 &&
   runuser -u "$ADMIN_USER" -- sudo -n id -u 2>/dev/null |
       grep -qx "0"; then
    echo "  Current user has sudo: YES ✓"
else
    echo "  Current user has sudo: NO"
    echo "Aborting to avoid losing administrative access."
    exit 1
fi

if visudo -c >/dev/null 2>&1; then
    echo "  Sudo configuration valid: YES ✓"
else
    echo "  Sudo configuration valid: NO"
    exit 1
fi

echo
echo "Locking root account..."

if passwd -l root >/dev/null 2>&1; then
    echo "  passwd -l root: Done"
else
    echo "  passwd -l root: FAILED"
    exit 1
fi

echo
echo "Verification:"

root_status=$(passwd -S root | awk '{print $2}')

if [ "$root_status" = "L" ]; then
    echo "  Root password: LOCKED (!)"
else
    echo "  Root password: NOT LOCKED"
fi

sshd_path=$(command -v sshd || true)

if [ -z "$sshd_path" ] && [ -x /usr/sbin/sshd ]; then
    sshd_path="/usr/sbin/sshd"
fi

if [ -n "$sshd_path" ]; then
    ssh_setting=$("$sshd_path" -T 2>/dev/null |
        awk '$1 == "permitrootlogin" {print $2; exit}')

    if [ "$ssh_setting" = "no" ]; then
        echo "  Root SSH login: Already disabled (PermitRootLogin no)"
    else
        echo "  Root SSH login: CHECK ($ssh_setting)"
    fi
else
    echo "  Root SSH login: SSH server not found"
fi

if runuser -u "$ADMIN_USER" -- sudo -n id -u 2>/dev/null |
   grep -qx "0"; then
    echo "  Sudo to root: WORKING ✓"
else
    echo "  Sudo to root: FAILED"
    exit 1
fi

echo
echo "WARNING: Direct root password login is now disabled."
echo "All administrative tasks must use sudo."
