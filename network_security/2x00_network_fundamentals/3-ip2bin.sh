#!/bin/bash
IFS='.' read -ra octets <<< "$1"; for ((i=0; i<4; i++)); do ((i > 0)) && printf "."; printf "%08d" "$(echo "obase=2; ${octets[i]}" | bc)"; done; printf "\n"
