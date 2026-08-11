#!/bin/bash
awk -v cutoff="$(date -d '30 minutes ago' +%s)" -v year="$(date +%Y)" '/sshd/ {cmd="date -d \"" year " " $1 " " $2 " " $3 "\" +%s"; cmd | getline t; close(cmd); if (t >= cutoff) print $0}' "$1"
