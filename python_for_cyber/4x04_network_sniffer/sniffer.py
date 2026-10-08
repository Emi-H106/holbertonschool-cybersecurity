#!/usr/bin/env python3
"""Capture and analyze network packets using Scapy."""

import argparse

from scapy.all import sniff

try:
    from scapy.all import IP
except ImportError:
    class IP:
        """Fallback IP layer."""
        pass


try:
    from scapy.all import TCP
except ImportError:
    class TCP:
        """Fallback TCP layer."""
        pass


try:
    from scapy.all import UDP
except ImportError:
    class UDP:
        """Fallback UDP layer."""
        pass


try:
    from scapy.all import ICMP
except ImportError:
    class ICMP:
        """Fallback ICMP layer."""
        pass


try:
    from scapy.utils import PcapWriter
except ImportError:
    PcapWriter = None


try:
    from scapy.all import hexdump
except ImportError:
    hexdump = None


class Sniffer:
    """Capture and process network packets."""

    def __init__(self, interface, filter_str, output_file):
        """Initialize the sniffer configuration."""
        self.interface = interface
        self.filter_str = filter_str
        self.output_file = output_file
        self.verbose = False
        self.pcap_writer = None

        if output_file:
            if PcapWriter is None:
                raise RuntimeError("PcapWriter is unavailable")

            self.pcap_writer = PcapWriter(
                output_file,
                append=True,
                sync=True
            )

    def _dump_packet_if_verbose(self, packet):
        """Display a packet hex dump when verbose mode is enabled."""
        if self.verbose and hexdump is not None:
            hexdump(packet)

    def _process_packet(self, packet):
        """Process, display, and optionally save a captured packet."""
        if self.pcap_writer is not None:
            self.pcap_writer.write(packet)

        if not hasattr(packet, "haslayer"):
            self._dump_packet_if_verbose(packet)
            return

        if not packet.haslayer(IP):
            self._dump_packet_if_verbose(packet)
            return

        ip_layer = packet[IP]

        if packet.haslayer(TCP):
            tcp_layer = packet[TCP]

            print(
                f"[TCP] {ip_layer.src}:{tcp_layer.sport} -> "
                f"{ip_layer.dst}:{tcp_layer.dport} | "
                f"Flags: {tcp_layer.flags}"
            )

        elif packet.haslayer(UDP):
            print(
                f"[UDP] {ip_layer.src} -> "
                f"{ip_layer.dst}"
            )

        elif packet.haslayer(ICMP):
            print(
                f"[ICMP] {ip_layer.src} -> "
                f"{ip_layer.dst}"
            )

        self._dump_packet_if_verbose(packet)

    def start(self):
        """Start capturing network packets."""
        print("[INFO] PySniffer initialized.")

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
                self.pcap_writer = None


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

    sniffer = Sniffer(
        args.interface,
        args.filter,
        args.write
    )

    sniffer.verbose = args.verbose
    sniffer.start()


if __name__ == "__main__":
    main()
