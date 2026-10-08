#!/usr/bin/env python3
"""Capture and analyze network packets using Scapy."""

import argparse

from scapy.all import hexdump, sniff


class Sniffer:
    """Capture and process network packets."""

    def __init__(self, interface, filter_str, output_file):
        """Initialize the sniffer configuration."""
        self.interface = interface
        self.filter_str = filter_str
        self.output_file = output_file
        self.pcap_writer = None
        self.verbose = False

    def start(self):
        """Start capturing network packets."""
        if self.output_file:
            try:
                from scapy.utils import PcapWriter

                self.pcap_writer = PcapWriter(
                    self.output_file,
                    append=True,
                    sync=True
                )
            except (ImportError, ModuleNotFoundError):
                self.pcap_writer = None

        try:
            sniff(
                iface=self.interface,
                filter=self.filter_str,
                prn=self._process_packet
            )
        except KeyboardInterrupt:
            print("[INFO] Stopping capture...")
        finally:
            if self.pcap_writer is not None:
                self.pcap_writer.close()

    def _process_packet(self, packet):
        """Process, display, and optionally save a captured packet."""
        if self.pcap_writer is not None:
            self.pcap_writer.write(packet)

        if hasattr(packet, "haslayer"):
            if packet.haslayer("IP"):
                source_ip = packet["IP"].src
                destination_ip = packet["IP"].dst

                if packet.haslayer("TCP"):
                    source_port = packet["TCP"].sport
                    destination_port = packet["TCP"].dport
                    flags = packet["TCP"].flags

                    print(
                        f"[TCP] {source_ip}:{source_port} -> "
                        f"{destination_ip}:{destination_port} | "
                        f"Flags: {flags}"
                    )
                elif packet.haslayer("UDP"):
                    print(
                        f"[UDP] {source_ip} -> "
                        f"{destination_ip}"
                    )
                elif packet.haslayer("ICMP"):
                    print(
                        f"[ICMP] {source_ip} -> "
                        f"{destination_ip}"
                    )

        if self.verbose:
            hexdump(packet)


def main():
    """Parse command-line arguments and start the sniffer."""
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

    print("[INFO] PySniffer initialized.")

    sniffer = Sniffer(
        args.interface,
        args.filter,
        args.write
    )

    sniffer.verbose = args.verbose
    sniffer.start()


if __name__ == "__main__":
    main()
    