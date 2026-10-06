#!/usr/bin/env python3
"""Capture and display network packet summaries using Scapy."""

from scapy.all import ICMP, IP, TCP, UDP, sniff


def packet_handler(packet) -> None:
    """Identify and display the protocol and IP addresses of a packet."""
    if packet.haslayer(IP):
        source_ip = packet[IP].src
        destination_ip = packet[IP].dst

        if packet.haslayer(TCP):
            print(f"[TCP] {source_ip} -> {destination_ip}")
        elif packet.haslayer(UDP):
            print(f"[UDP] {source_ip} -> {destination_ip}")
        elif packet.haslayer(ICMP):
            print(f"[ICMP] {source_ip} -> {destination_ip}")


def main() -> None:
    """Start PySniffer and capture five network packets."""
    print("[INFO] PySniffer initialized.")
    sniff(count=5, prn=packet_handler)


if __name__ == "__main__":
    main()
