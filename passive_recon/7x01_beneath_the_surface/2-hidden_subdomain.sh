#!/bin/bash
timeout 60s gobuster -m dns -u astralis-cloud.example -w /usr/share/wordlists/astralis-subdomains.txt -t 2 -q -np 2>/dev/null | awk '/^Found:/ && $2 ~ /(internal|backend|admin)/ {print $2}' | head -n 1
