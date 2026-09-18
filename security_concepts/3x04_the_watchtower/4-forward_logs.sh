#!/bin/bash
set -e

config=/etc/rsyslog.d/50-default.conf
rule='if ($inputname != "imudp") then {
    *.* @127.0.0.1:514
}'

if ! sudo grep -Fq '*.* @127.0.0.1:514' "$config"; then
    printf '\n%s\n' "$rule" | sudo tee -a "$config" > /dev/null
fi

sudo rsyslogd -N1
sudo systemctl restart rsyslog
logger "Test Log Forwarding"