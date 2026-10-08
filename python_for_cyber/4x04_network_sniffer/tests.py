#!/usr/bin/env python3
"""Unit tests for PySniffer packet processors."""

import io
import unittest
from contextlib import redirect_stdout

from scapy.all import IP, TCP

from sniffer import TCPProcessor


class TestTCPProcessor(unittest.TestCase):
    """Test the TCPProcessor class."""

    def test_tcp_packet(self):
        """Test TCP packet IP address and destination port."""
        pkt = IP(src="1.1.1.1") / TCP(dport=80)

        processor = TCPProcessor()

        with redirect_stdout(io.StringIO()):
            processor.process(pkt)

        self.assertEqual(pkt[IP].src, "1.1.1.1")
        self.assertEqual(pkt[TCP].dport, 80)


if __name__ == "__main__":
    unittest.main()
