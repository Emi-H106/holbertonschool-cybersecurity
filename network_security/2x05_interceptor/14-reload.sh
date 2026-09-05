#!/bin/bash

if sudo squid -k parse; then
    sudo systemctl reload squid
else
    echo "Invalid Squid configuration"
    exit 1
fi