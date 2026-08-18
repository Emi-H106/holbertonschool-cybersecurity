#!/bin/bash
IFS='.' read -ra ip <<< "$1"; IFS='.' read -ra mask <<< "$2"; for ((i=0; i<4; i++)); do network=$((ip[i] & mask[i])); inverse=$((255-mask[i])); broadcast=$((network | inverse)); ((i>0)) && printf "."; printf "%d" "$broadcast"; done
