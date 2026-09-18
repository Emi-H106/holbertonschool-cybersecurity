#!/bin/bash
set -e

iptables -I INPUT 1 -s "$1" -j DROP
iptables -I OUTPUT 1 -d "$1" -j DROP
kill -STOP "$2"