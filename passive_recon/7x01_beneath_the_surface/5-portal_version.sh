#!/bin/bash
curl -sSI --max-time 10 https://portal.astralis-cloud.example 2>/dev/null | grep -i '^Server:' | awk '{print $2}' | tr -d '\r'
