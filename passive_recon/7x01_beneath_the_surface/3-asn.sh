#!/bin/bash
ip=$(dig astralis-cloud.example A +short +time=3 +tries=1 | head -n 1); curl -fsS --max-time 10 "https://api.bgpview.io/ip/$ip" 2>/dev/null | jq -er '.data.prefixes[0].asn.asn | numbers | "AS\(.)"'
