#!/bin/bash
grep -i "sqlmap" "$1" | sed -E 's/^([^ ]+)[^"]*"([^ ]+) (.*) HTTP\/[^"]+".*$/\1,\2,\3/'