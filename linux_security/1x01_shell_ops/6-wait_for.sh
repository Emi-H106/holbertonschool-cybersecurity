#!/bin/bash
until nc -z "$1" 80 &> /dev/null
do
    echo "Waiting..."
    sleep 1
done
    echo "Service UP!"
