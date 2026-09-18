#!/bin/bash
awk -F'"' '{
    split($1, client, " ")
    split($3, response, " ")
    if (response[1] ~ /^4[0-9][0-9]$/)
        print client[1]
}' "$1" | sort | uniq -c | awk '{
    count = $1
    ip = $2
    if (count > 5)
        print "ALERT: IP " ip " is scanning us!"
}'