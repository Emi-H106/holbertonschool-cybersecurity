#!/bin/bash
timeout 10s dig astralis-cloud.example NS +short +time=3 +tries=1 | head -n 1 | sed 's/\.$//'
