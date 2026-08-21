#!/bin/bash
awk '$1 ~ /^[0-9]+\./ && $2 == "localhost" {print $1; exit}' /etc/hosts
