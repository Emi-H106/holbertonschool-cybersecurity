#!/bin/bash
timeout 10s dig _dmarc.astralis-cloud.example TXT +short +time=3 +tries=1 2>/dev/null | tr -d '"' | tr ';' '\n' | grep -E '^[[:space:]]*p=(none|quarantine|reject)[[:space:]]*$' | sed -E 's/^[[:space:]]*p=//; s/[[:space:]]*$//' | head -n 1
