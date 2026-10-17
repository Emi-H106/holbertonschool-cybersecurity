#!/bin/bash

# Verify remediation of vulnerabilities identified in the assessment.

set -uo pipefail

echo "=== Remediation Verification ==="
echo
echo "Checking vulnerabilities from assessment report..."
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

passed=0
total=8

report() {
    local result="$1"
    local message="$2"

    if [ "$result" = "pass" ]; then
        echo "  Status: REMEDIATED ($message)"
        passed=$((passed + 1))
    else
        echo "  Status: NOT REMEDIATED ($message)"
    fi

    echo
}

echo "[CRITICAL] CVE-2011-2523 vsftpd backdoor"

if ! dpkg-query -W -f='${Status}' vsftpd 2>/dev/null |
    grep -q "install ok installed" &&
    ! ss -ltnH '( sport = :21 )' | grep -q .; then
    report pass "service removed"
else
    report fail "vsftpd installed or port 21 open"
fi

echo "[HIGH] Apache outdated (CVE-2021-*)"

apache_version=$(dpkg-query -W -f='${Version}' apache2 \
    2>/dev/null || true)

if [ -n "$apache_version" ]; then
    candidate=$(apt-cache policy apache2 |
        awk '/Candidate:/ {print $2}')

    if [ "$apache_version" = "$candidate" ]; then
        report pass "version $apache_version"
    else
        report fail "installed $apache_version, candidate $candidate"
    fi
else
    report fail "Apache not installed"
fi

echo "[HIGH] SSH PermitRootLogin enabled"

ssh_root=$(sshd -T 2>/dev/null |
    awk '/^permitrootlogin / {print $2}')

if [ "$ssh_root" = "no" ]; then
    report pass "set to no"
else
    report fail "PermitRootLogin=$ssh_root"
fi

echo "[HIGH] MySQL root no password"

secret="/root/.mysql_secret"

if [ -s "$secret" ] &&
    mysql --defaults-extra-file="$secret" \
    --protocol=socket -Nse "SELECT 1" 2>/dev/null |
    grep -qx "1"; then
    report pass "password authentication works"
else
    report fail "root password authentication not verified"
fi

echo "[HIGH] MySQL exposed to network"

mysql_bind=$(mysql --defaults-extra-file="$secret" \
    --protocol=socket -Nse \
    "SHOW VARIABLES LIKE 'bind_address';" 2>/dev/null |
    awk '{print $2}')

if [ "$mysql_bind" = "127.0.0.1" ]; then
    report pass "localhost only"
else
    report fail "bind_address=$mysql_bind"
fi

echo "[MEDIUM] SUID binary /usr/local/bin/backup"

suid_file="/usr/local/bin/backup"

if [ ! -e "$suid_file" ]; then
    report pass "binary absent"
elif [ ! -u "$suid_file" ]; then
    report pass "SUID removed"
else
    report fail "SUID still enabled"
fi

echo "[MEDIUM] World-writable cron script"

cron_file="/etc/cron.daily/backup.sh"

if [ -f "$cron_file" ]; then
    permissions=$(stat -c '%a' "$cron_file")

    if [ ! -w "$cron_file" ] ||
        [ $((8#$permissions & 2)) -eq 0 ]; then
        report pass "permissions fixed"
    else
        report fail "world-writable permissions remain"
    fi
else
    report pass "cron script absent"
fi

echo "[MEDIUM] Exposed credentials in webroot"

env_file="/var/www/html/.env"
safe_file="/etc/novatech/app.env"

if [ -L "$env_file" ]; then
    if [ -f "$safe_file" ]; then
        report pass "moved to /etc"
    else
        report fail "symlink target missing"
    fi
elif [ ! -e "$env_file" ]; then
    report pass "credential file absent"
else
    report fail "credentials still in webroot"
fi

echo "Summary: $passed/$total vulnerabilities remediated"

if [ "$passed" -eq "$total" ]; then
    echo "System ready for patch automation."
else
    echo "WARNING: Some vulnerabilities still require remediation."
    exit 1
fi
