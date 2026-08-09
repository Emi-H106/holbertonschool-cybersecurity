#!/bin/bash
awk -F: '$3 >= 1000 {print $1}' "$1" | while read user; do
    for group in disk docker shadow; do
        if id -nG "$user" | tr ' ' '\n' | grep -qx "$group"; then
            echo "$user:$group"
        fi
    done
done
