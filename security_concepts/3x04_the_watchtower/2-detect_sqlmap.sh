#!/bin/bash
awk -F'"' 'tolower($6) ~ /sqlmap/ && $2 ~ /^(GET|POST) / {
    split($1, ip, " ")
    split($2, request_parts, " ")
    path = $2
    sub(/^(GET|POST) /, "", path)
    sub(/ HTTP\/[^ ]+$/, "", path)
    print ip[1] "," request_parts[1] "," path
}' "$1"