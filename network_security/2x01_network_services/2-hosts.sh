#!/bin/bash
awk '$1 ~ /^[0-9]+\./ && $2 == "localhost" {printf "%s", $1; exit}' /etc/hosts
