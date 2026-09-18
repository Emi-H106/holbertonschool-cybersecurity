#!/bin/bash
set -e

config=/etc/rsyslog.d/50-default.conf
rule='if ($inputname != "imudp") then {
    *.* @127.0.0.1:514
}'

if ! sudo grep -Fq '*.* @127.0.0.1:514' "$config"; then
    printf '\n%s\n' "$rule" | sudo sh -c 'cat >> /etc/rsyslog.d/50-default.conf'
fi

sudo rsyslogd -N1
sudo systemctl restart rsyslog
logger "Test Log Forwarding"