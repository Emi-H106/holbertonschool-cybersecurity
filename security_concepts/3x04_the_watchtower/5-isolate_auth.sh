#!/bin/bash
set -e
echo 'authpriv.info /var/log/secure_remote.log' | sudo tee /etc/rsyslog.d/60-auth.conf > /dev/null
sudo rsyslogd -N1
sudo systemctl restart rsyslog