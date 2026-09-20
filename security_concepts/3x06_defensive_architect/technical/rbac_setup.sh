#!/bin/bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Create the role groups if they do not already exist.
for GROUP in devs ops auditors; do
    if ! getent group "$GROUP" >/dev/null; then
        groupadd "$GROUP"
    fi
done

# Create test users if they do not already exist.
if ! id test_dev >/dev/null 2>&1; then
    useradd -m -s /bin/bash test_dev
fi

if ! id test_ops >/dev/null 2>&1; then
    useradd -m -s /bin/bash test_ops
fi

if ! id test_auditor >/dev/null 2>&1; then
    useradd -m -s /bin/bash test_auditor
fi

# Assign each test user to a role.
usermod -aG devs test_dev
usermod -aG ops test_ops
usermod -aG auditors test_auditor

# Restrict access to home directories.
chmod 700 /home/test_dev
chmod 700 /home/test_ops
chmod 700 /home/test_auditor

# Allow the ops group to restart Nginx.
cat > /etc/sudoers.d/nexus-rbac.tmp <<'EOF'
%ops ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx
EOF

chmod 440 /etc/sudoers.d/nexus-rbac.tmp
visudo -cf /etc/sudoers.d/nexus-rbac.tmp
mv /etc/sudoers.d/nexus-rbac.tmp /etc/sudoers.d/nexus-rbac

# Allow the auditors group to read existing Nginx logs.
if [ -d /var/log/nginx ]; then
    if ! command -v setfacl >/dev/null 2>&1; then
        echo "Install the acl package to grant read-only log access."
        exit 1
    fi

    setfacl -m g:auditors:rx /var/log/nginx

    for LOG in /var/log/nginx/*.log; do
        if [ -f "$LOG" ]; then
            setfacl -m g:auditors:r "$LOG"
        fi
    done
else
    echo "Nginx log directory does not exist yet; log access was skipped."
fi

echo "RBAC setup completed."