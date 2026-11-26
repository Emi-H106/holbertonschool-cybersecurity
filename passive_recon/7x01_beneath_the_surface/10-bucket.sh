#!/bin/bash
for suffix in prod prod-eu backup backups assets storage data logs public; do bucket="astralis-$suffix"; code=$(curl -sI --resolve s3.amazonaws.com:443:127.20.0.80 --max-time 5 -o /dev/null -w '%{http_code}' "https://s3.amazonaws.com/$bucket"); case "$code" in 2??|3??|403) echo "$bucket"; break;; esac; sleep 1; done
