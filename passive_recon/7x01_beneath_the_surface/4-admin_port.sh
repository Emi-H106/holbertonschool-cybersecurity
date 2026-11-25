#!/bin/bash
timeout 1800s nmap -sT -T2 --max-rate 50 --max-retries 1 -p 49152-65535 --open admin.astralis-cloud.example 2>/dev/null | awk '/^[0-9]+\/tcp[[:space:]]+open[[:space:]]/ {split($1,p,"/"); print p[1]}'
