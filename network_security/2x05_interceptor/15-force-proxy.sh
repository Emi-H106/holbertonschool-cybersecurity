#!/bin/bash

InterF=$(ip route show default | awk '{print $5; exit}')

sudo nft add rule inet filter forward ip saddr 10.200.0.0/24 oifname "$InterF" tcp dport 80 drop
sudo nft add rule inet filter forward ip saddr 10.200.0.0/24 oifname "$InterF" tcp dport 443 drop

sudo nft add rule inet filter output oifname "$InterF" tcp dport 80 accept
sudo nft add rule inet filter output oifname "$InterF" tcp dport 443 accept