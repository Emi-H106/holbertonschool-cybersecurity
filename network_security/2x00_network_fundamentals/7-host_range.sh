#!/bin/bash
IFS=. read -r a b c d <<< "$1"; ip=$((a<<24|b<<16|c<<8|d)); mask=$((0xFFFFFFFF << (32-$2) & 0xFFFFFFFF)); net=$((ip & mask)); broad=$((net | (~mask & 0xFFFFFFFF))); first=$((net+1)); last=$((broad-1)); printf "%d.%d.%d.%d - %d.%d.%d.%d\n" $((first>>24&255)) $((first>>16&255)) $((first>>8&255)) $((first&255)) $((last>>24&255)) $((last>>16&255)) $((last>>8&255)) $((last&255))
