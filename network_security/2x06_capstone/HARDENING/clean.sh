#!/bin/bash

# Remove unnecessary Telnet services
apt remove -y telnet telnetd

# Backup SSH configuration
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Harden SSH
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config

# Disable anonymous FTP
sed -i 's/^anonymous_enable=YES/anonymous_enable=NO/' /etc/vsftpd.conf

# Check SSH configuration
if sshd -t; then
    echo "SSH configuration is valid."
    service ssh reload
else
    echo "SSH configuration is invalid. Restoring backup."
    cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    exit 1
fi