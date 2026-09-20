#!/bin/bash

set -e

LOG_SERVER="10.0.1.20"

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Install the required services if they are missing.
if ! command -v rsyslogd >/dev/null 2>&1 ||
   ! command -v auditctl >/dev/null 2>&1; then
    apt-get update
    apt-get install -y rsyslog auditd
fi

# Forward warning and more severe system logs, plus all
# authentication logs, to the central server over TCP.
cat > /etc/rsyslog.d/60-nexus-forward.conf <<EOF
*.warning;auth,authpriv.* @@${LOG_SERVER}:514
EOF

# Check the rsyslog configuration before restarting it.
rsyslogd -N1
systemctl enable --now rsyslog
systemctl restart rsyslog

# Audit changes to sensitive files and privileged command execution.
cat > /etc/audit/rules.d/99-nexus.rules <<'EOF'
-w /etc/passwd -p wa -k identity_changes
-w /etc/group -p wa -k identity_changes
-w /etc/shadow -p wa -k identity_changes
-w /etc/sudoers -p wa -k privilege_changes
-w /etc/sudoers.d/ -p wa -k privilege_changes
-w /etc/ssh/sshd_config -p wa -k ssh_changes

-a always,exit -F arch=b64 -S execve -F euid=0 -k privileged_commands

-e 2
EOF

systemctl enable --now auditd

# Once audit is immutable, rules cannot be reloaded until reboot.
if auditctl -s | grep -q "^enabled 2"; then
    echo "Audit rules are already immutable."
    echo "Any rule changes will take effect after reboot."
else
    augenrules --load
fi

echo "Logging setup completed."
auditctl -s