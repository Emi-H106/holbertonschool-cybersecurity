#!/usr/bin/env python3
"""Capture and display network packet summaries using Scapy."""

from scapy.all import sniff


def packet_handler(packet) -> None:
    """Identify and display protocol details of a captured packet."""
    if packet.haslayer(IP):
        source_ip = packet[IP].src
        destination_ip = packet[IP].dst

        if packet.haslayer(TCP):
            source_port = packet[TCP].sport
            destination_port = packet[TCP].dport
            flags = packet[TCP].flags

            print(
                f"[TCP] {source_ip}:{source_port} -> "
                f"{destination_ip}:{destination_port} | Flags: {flags}"
            )
        elif packet.haslayer(UDP):
            print(f"[UDP] {source_ip} -> {destination_ip}")
        elif packet.haslayer(ICMP):
            print(f"[ICMP] {source_ip} -> {destination_ip}")


def main() -> None:
    """Start PySniffer and capture five network packets."""
    print("[INFO] PySniffer initialized.")

    try:
        sniff(prn=packet_handler)
    except KeyboardInterrupt:
        print("[INFO] Stopping capture...")


if __name__ == "__main__":
    main()
