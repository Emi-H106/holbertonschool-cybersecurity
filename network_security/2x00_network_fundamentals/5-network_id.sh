#!/bin/bash
IFS='.' read -ra ip <<< "$1"; IFS='.' read -ra mask <<< "$2"; for ((i=0; i<4; i++)); do network=$((ip[i] & mask[i])); ((i > 0)) && printf "."; printf "%d" "$network"; done