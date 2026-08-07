#!/bin/bash
while read -r username
do 
    if id "$username" &>/dev/null; then
        usermod -L "$username"
        echo "User $username locked"

    else
        echo "User "$username" not found"
    fi
done < "$1"
