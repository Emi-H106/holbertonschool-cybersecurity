#!/usr/bin/env python3
"""Capture and display network packet summaries using Scapy."""

from scapy.all import sniff


def packet_handler(packet) -> None:
    """Print a one-line summary of a captured packet."""
    print(packet.summary())


def main() -> None:
    """Start PySniffer and capture five network packets."""
    print("[INFO] PySniffer initialized.")
    sniff(count=5, prn=packet_handler)


if __name__ == "__main__":
    main()
