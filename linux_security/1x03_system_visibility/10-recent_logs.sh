#!/bin/bash
awk -v cutoff="$(date -d '30 minutes ago' +%s)" -v year="$(date +%Y)" '/sshd/ {cmd="date -d \"" $1 " " $2 " " $3 " " year "\" +%s"; cmd | getline t; close(cmd); if (t >= cutoff) print $0}' "$1"
