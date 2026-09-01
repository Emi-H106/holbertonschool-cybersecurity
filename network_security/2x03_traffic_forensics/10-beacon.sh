#!/bin/bash
tshark -r "$1" -Y 'ip.addr == 10.10.10.50 && ip.addr == 172.16.42.66' -T fields -e frame.time