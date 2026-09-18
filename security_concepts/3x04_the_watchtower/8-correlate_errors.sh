#!/bin/bash
awk -F'"' '{
    split($1, client, " ")
    split($3, response, " ")
    if (response[1] ~ /^4[0-9][0-9]$/)
        errors[client[1]]++
}
END {
    for (ip in errors)
        if (errors[ip] > 5)
            print "ALERT: IP " ip " is scanning us!"
}' "$1"