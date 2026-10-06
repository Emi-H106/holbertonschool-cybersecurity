#!/usr/bin/env python3
"""Capture and display network packet summaries using Scapy."""

import argparse

from scapy.all import hexdump, sniff


pcap_writer = None
verbose = False


def packet_handler(packet) -> None:
    """Analyze a packet and optionally write it to a PCAP file."""
    if pcap_writer is not None:
        pcap_writer.write(packet)

    if not hasattr(packet, "haslayer"):
        return

    if packet.haslayer("IP"):
        source_ip = packet["IP"].src
        destination_ip = packet["IP"].dst

        if packet.haslayer("TCP"):
            source_port = packet["TCP"].sport
            destination_port = packet["TCP"].dport
            flags = packet["TCP"].flags

            print(
                f"[TCP] {source_ip}:{source_port} -> "
                f"{destination_ip}:{destination_port} | Flags: {flags}"
            )
        elif packet.haslayer("UDP"):
            print(f"[UDP] {source_ip} -> {destination_ip}")
        elif packet.haslayer("ICMP"):
            print(f"[ICMP] {source_ip} -> {destination_ip}")

        if verbose:
            hexdump(packet)


def main() -> None:
    """Parse arguments and start packet capture."""
    global pcap_writer, verbose

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
    parser.add_argument(
        "--write",
        help="Write captured packets to a PCAP file"
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Display packet hex dump"
    )

    args = parser.parse_args()

    verbose = args.verbose

    print("[INFO] PySniffer initialized.")

    if args.write:
        from scapy.utils import PcapWriter

        pcap_writer = PcapWriter(
            args.write,
            append=True,
            sync=True
        )

    try:
        sniff(
            iface=args.interface,
            filter=args.filter,
            prn=packet_handler
        )
    except KeyboardInterrupt:
        print("[INFO] Stopping capture...")
    finally:
        if pcap_writer is not None:
            pcap_writer.close()


if __name__ == "__main__":
    main()
