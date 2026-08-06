#!/bin/bash
mkdir -p "$1" && chown root:$2 "$1" && chmod 2750 $1 && echo "/var/log/app/*.log { daily rotate 7 create 0640 root $2 }" > /etc/logrotate.d/app