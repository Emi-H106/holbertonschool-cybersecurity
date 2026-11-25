#!/bin/bash
timeout 10s openssl s_client -connect portal.astralis-cloud.example:443 -servername portal.astralis-cloud.example </dev/null 2>/dev/null | openssl x509 -noout -ext subjectAltName 2>/dev/null | tr ',' '\n' | sed -n 's/^[[:space:]]*DNS://p' | grep -Ei 'internal|backend|admin|mgmt' | head -n 1
