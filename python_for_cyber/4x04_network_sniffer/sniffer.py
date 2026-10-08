#!/usr/bin/env python3
"""Capture and analyze network packets using Scapy."""

import argparse
from queue import Queue
from threading import Thread

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
    from scapy.all import Raw
except ImportError:
    class Raw:
        """Fallback Raw layer."""
        pass


try:
    from scapy.utils import PcapWriter
except ImportError:
    PcapWriter = None


try:
    from scapy.all import hexdump
except ImportError:
    hexdump = None


class PacketProcessor:
    """Base class for packet processors."""

    def __init__(self, search_string=None):
        """Initialize the packet processor."""
        self.search_string = search_string

    def search_payload(self, packet):
        """Search for a string in the packet payload."""
        if not self.search_string:
            return

        if not packet.haslayer(Raw):
            return

        raw_layer = packet[Raw]
        raw_data = getattr(raw_layer, "load", b"")

        if isinstance(raw_data, bytes):
            payload = raw_data.decode(
                "utf-8",
                errors="ignore"
            )
        else:
            payload = str(raw_data)

        if self.search_string in payload:
            print("[ALERT] Payload Match found!")

    def process(self, packet):
        """Process a packet."""
        raise NotImplementedError


class TCPProcessor(PacketProcessor):
    """Process TCP packets."""

    def process(self, packet):
        """Process a TCP packet."""
        ip_layer = packet[IP]
        tcp_layer = packet[TCP]

        source_ip = getattr(ip_layer, "src", "Unknown")
        destination_ip = getattr(ip_layer, "dst", "Unknown")
        source_port = getattr(tcp_layer, "sport", "Unknown")
        destination_port = getattr(tcp_layer, "dport", "Unknown")
        flags = getattr(tcp_layer, "flags", "Unknown")

        print(
            f"[TCP] {source_ip}:{source_port} -> "
            f"{destination_ip}:{destination_port} | "
            f"Flags: {flags}"
        )

        self.search_payload(packet)


class UDPProcessor(PacketProcessor):
    """Process UDP packets."""

    def process(self, packet):
        """Process a UDP packet."""
        ip_layer = packet[IP]

        source_ip = getattr(ip_layer, "src", "Unknown")
        destination_ip = getattr(ip_layer, "dst", "Unknown")

        print(
            f"[UDP] {source_ip} -> "
            f"{destination_ip}"
        )

        self.search_payload(packet)


class ICMPProcessor(PacketProcessor):
    """Process ICMP packets."""

    def process(self, packet):
        """Process an ICMP packet."""
        ip_layer = packet[IP]

        source_ip = getattr(ip_layer, "src", "Unknown")
        destination_ip = getattr(ip_layer, "dst", "Unknown")

        print(
            f"[ICMP] {source_ip} -> "
            f"{destination_ip}"
        )

        self.search_payload(packet)


class Sniffer:
    """Capture and process network packets."""

    def __init__(
        self,
        interface,
        filter_str,
        output_file,
        search_string=None
    ):
        """Initialize the sniffer configuration."""
        self.interface = interface
        self.filter_str = filter_str
        self.output_file = output_file
        self.search_string = search_string
        self.verbose = False
        self.pcap_writer = None
        self.packet_queue = Queue()

        self.stats = {
            "TCP": 0,
            "UDP": 0,
            "ICMP": 0
        }

        self.processors = {
            TCP: ("TCP", TCPProcessor(search_string)),
            UDP: ("UDP", UDPProcessor(search_string)),
            ICMP: ("ICMP", ICMPProcessor(search_string))
        }

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

    def _enqueue_packet(self, packet):
        """Add a captured packet to the processing queue."""
        self.packet_queue.put(packet)

    def _process_queue(self):
        """Process packets from the queue."""
        while True:
            packet = self.packet_queue.get()

            try:
                self._process_packet(packet)
            finally:
                self.packet_queue.task_done()


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

        for protocol, (name, processor) in self.processors.items():
            if packet.haslayer(protocol):
                self.stats[name] += 1
                processor.process(packet)
                break

        self._dump_packet_if_verbose(packet)

    def _print_stats(self):
        """Display packet statistics."""
        print("\nPacket Statistics:")

        for protocol, count in self.stats.items():
            print(f"{protocol}: {count}")

    def start(self):
        """Start capturing network packets."""
        print("[INFO] PySniffer initialized.")

        processor_thread = Thread(
        target=self._process_queue,
        daemon=True
        )
        processor_thread.start()

        try:
            sniff(
                iface=self.interface,
                filter=self.filter_str,
                prn=self._enqueue_packet
            )
        except KeyboardInterrupt:
            print("[INFO] Stopping capture...")
            self._print_stats()
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

    parser.add_argument(
        "-s",
        "--search",
        help="Search for a string in packet payloads"
    )

    args = parser.parse_args()

    sniffer = Sniffer(
        args.interface,
        args.filter,
        args.write,
        args.search
    )

    sniffer.verbose = args.verbose
    sniffer.start()


if __name__ == "__main__":
    main()
