#!/bin/bash
sudo tcpdump -i tun0 -w 21-capture.pcap '((icmp and host 10.8.0.1) or (tcp port 80 and host 10.42.173.140))'
