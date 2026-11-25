#!/bin/bash
curl -fsS --max-time 10 https://portal.astralis-cloud.example/robots.txt 2>/dev/null | tr -d '\r' | awk 'tolower($1)=="disallow:" && $2 ~ /^\// && tolower($2) ~ /(admin|manage|backend|console)/ {print $2; exit}'
