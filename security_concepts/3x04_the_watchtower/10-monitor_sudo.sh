#!/bin/bash
tail -f -n 0/var/log/auth.log | while IFS= read -r line; do
    if [[ "$line" == *sudo* && ( "$line" == *COMMAND* || "$line" == *"authentication failure"* ) ]]; then
        echo "ALERT: Sudo violation detected!"
    fi
done