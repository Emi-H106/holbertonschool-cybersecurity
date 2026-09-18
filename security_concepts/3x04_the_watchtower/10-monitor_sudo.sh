#!/bin/bash
tail -f -n 0 /var/log/auth.log |
    grep --line-buffered 'sudo' |
    grep --line-buffered -E 'COMMAND|authentication failure' |
    while IFS= read -r line; do
        echo "ALERT: Sudo violation detected!"
    done