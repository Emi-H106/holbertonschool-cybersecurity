#!/bin/bash
sudo tee -a /etc/rsyslog.conf > /dev/null <<'EOF'

$template json_fmt,"{\"time\":\"%timestamp%\", \"host\":\"%hostname%\", \"msg\":\"%msg%\"}\n"
EOF