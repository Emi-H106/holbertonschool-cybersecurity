#!/bin/bash
waf=$(timeout 30s wafw00f -r https://portal.astralis-cloud.example 2>/dev/null | sed -nE 's/.* is behind ([^(]+) \(.*/\1/p' | head -n 1); if [ -n "$waf" ]; then echo "$waf"; else curl -fsSI --max-time 10 https://portal.astralis-cloud.example 2>/dev/null | grep -qiE '^CF-(RAY|Cache-Status):' && echo "Cloudflare"; fi
