#!/bin/bash

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$1"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$1"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$1"

if sshd -t; then
    service ssh reload
fi
