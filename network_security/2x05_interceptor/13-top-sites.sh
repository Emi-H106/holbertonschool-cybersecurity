#!/bin/bash

awk '{print $7}' /var/log/squid/access.log | sed -E 's#^[a-zA-Z]+://([^/]+).*#\1#' | sort | uniq -c | sort -nr | head -10