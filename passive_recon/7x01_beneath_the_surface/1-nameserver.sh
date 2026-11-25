#!/bin/bash
timeout 10s dig astralis-cloud.example SOA +short +time=3 +tries=1 | awk '{print $1}' | sed 's/\.$//'
