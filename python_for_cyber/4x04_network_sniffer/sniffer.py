#!/usr/bin/env python3
"""Capture and display network packet summaries using Scapy."""

import argparse

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
    """Parse arguments and start packet capture."""
    parser = argparse.ArgumentParser(
        description="Capture and analyze network packets."
    )
    parser.add_argument(
        "-i",
        "--interface",
        help="Network interface to sniff on"
    )
    parser.add_argument(
        "-f",
        "--filter",
        help="BPF filter for packet capture"
    )
    args = parser.parse_args()

    print("[INFO] PySniffer initialized.")

    try:
        sniff(
            iface=args.interface,
            filter=args.filter,
            prn=packet_handler
        )
    except KeyboardInterrupt:
        print("[INFO] Stopping capture...")


if __name__ == "__main__":
    main()
