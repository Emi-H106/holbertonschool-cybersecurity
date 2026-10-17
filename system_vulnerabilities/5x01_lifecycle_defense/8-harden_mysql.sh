#!/bin/bash

# Harden MySQL authentication and network configuration.

set -euo pipefail

echo "=== MySQL Hardening ==="
echo

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

config="/etc/mysql/mysql.conf.d/mysqld.cnf"
secret="/root/.mysql_secret"
backup="${config}.backup.$(date +%Y%m%d%H%M%S)"

if [ ! -f "$config" ]; then
    echo "ERROR: MySQL configuration not found."
    exit 1
fi

if ! command -v mysql >/dev/null 2>&1; then
    echo "ERROR: MySQL client is not installed."
    exit 1
fi

# Obtain current root access before changing authentication.
if mysql --protocol=socket -u root -Nse "SELECT 1" \
    >/dev/null 2>&1; then
    mysql_auth=(mysql --protocol=socket -u root)
elif [ -s "$secret" ]; then
    mysql_auth=(mysql --protocol=socket -u root \
        --defaults-extra-file="$secret")
    # MySQL requires --defaults-extra-file as the first option.
    mysql_auth=(mysql --defaults-extra-file="$secret" \
        --protocol=socket -u root)
    if ! "${mysql_auth[@]}" -Nse "SELECT 1" \
        >/dev/null 2>&1; then
        echo "ERROR: Cannot authenticate as MySQL root."
        exit 1
    fi
else
    echo "ERROR: Cannot authenticate as MySQL root."
    exit 1
fi

cp -p "$config" "$backup"
echo "Backup created: $backup"
echo

echo "Securing MySQL..."

# Create a random password and protect the credentials file.
umask 077
if [ ! -s "$secret" ]; then
    password=$(openssl rand -hex 24)
    printf '[client]\nuser=root\npassword=%s\n' \
        "$password" > "$secret"
    chmod 600 "$secret"
else
    password=$(sed -n 's/^password=//p' "$secret" | head -n 1)
    if [ -z "$password" ]; then
        echo "ERROR: Existing secret file is invalid."
        exit 1
    fi
fi

# Hexadecimal encoding avoids SQL quoting problems.
password_hex=$(printf '%s' "$password" | od -An -tx1 |
    tr -d ' \n')

"${mysql_auth[@]}" <<SQL
ALTER USER 'root'@'localhost'
IDENTIFIED WITH caching_sha2_password BY '$password';

DELETE FROM mysql.user WHERE User = '';

DELETE FROM mysql.user
WHERE User = 'root' AND Host <> 'localhost';

DROP DATABASE IF EXISTS test;

DELETE FROM mysql.db
WHERE Db = 'test' OR Db LIKE 'test\\_%';

FLUSH PRIVILEGES;
SQL

echo "  Root password: Set (stored in $secret)"
echo "  Anonymous users: Removed"
echo "  Remote root login: Disabled"
echo "  Test database: Removed"

# Set bind-address in the [mysqld] section.
old_bind=$(awk '
    /^[[:space:]]*bind-address[[:space:]]*=/ {
        split($0, a, "=")
        gsub(/[[:space:]]/, "", a[2])
        print a[2]
        exit
    }
' "$config")

if [ -z "$old_bind" ]; then
    old_bind="not set"
fi

# Remove existing bind-address entries.
sed -i -E \
    '/^[[:space:]]*#?[[:space:]]*bind-address[[:space:]]*=/d' \
    "$config"

# Insert the setting immediately after [mysqld].
sed -i '/^\[mysqld\]/a bind-address = 127.0.0.1' "$config"

echo "  Bind address: $old_bind -> 127.0.0.1"

echo
echo "Restarting MySQL..."

if ! systemctl restart mysql; then
    echo "ERROR: MySQL restart failed."
    cp -p "$backup" "$config"
    systemctl restart mysql || true
    exit 1
fi

echo "  mysql.service: Restarted"

echo
echo "Verification:"

if mysql --defaults-extra-file="$secret" \
    --protocol=socket -Nse "SELECT 1" |
    grep -qx "1"; then
    echo "  Local root access: OK (with password)"
else
    echo "  Local root access: FAILED"
    exit 1
fi

actual_bind=$(mysql --defaults-extra-file="$secret" \
    --protocol=socket -Nse \
    "SHOW VARIABLES LIKE 'bind_address';" |
    awk '{print $2}')

if [ "$actual_bind" = "127.0.0.1" ]; then
    echo "  Remote connections: REFUSED (bind localhost only)"
else
    echo "  Remote connections: CHECK REQUIRED ($actual_bind)"
    exit 1
fi

echo
echo "MySQL hardened successfully."
