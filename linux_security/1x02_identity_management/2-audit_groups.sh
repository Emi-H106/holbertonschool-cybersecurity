#!/bin/bash
for user in $(awk -F: '$3 >= 1000 {print $1}' "$1"); do
    for group in disk docker shadow; do
        if id -nG "$user" | tr ' ' '\n' | grep -qx "$group"; then
            echo "$user:$group"
        fi
    done
done
