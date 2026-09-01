#!/bin/bash
tshark -r "$1" -Y "tcp.flags.syn == 1 && tcp.flags.ack == 0" -T fields -e frame.number | wc -l
