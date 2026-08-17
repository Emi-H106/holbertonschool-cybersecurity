#!/bin/bash

decimal=$1
binary=""

for ((i=0; i<8; i++)); do
    bit=$((decimal % 2))
    binary="${bit}${binary}"
    decimal=$((decimal / 2))
done

echo "$binary"
