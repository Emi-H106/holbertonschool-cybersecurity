#!/usr/bin/env python3
"""Data models for IntelBroker."""


class TargetDossier:
    """Store intelligence data for a target IP."""

    ip = ""
    vt_data = {}
    abuse_data = {}
    nmap_ports = []

    def __init__(
        self,
        ip: str = "",
        vt_data=None,
        abuse_data=None,
        shodan_data=None,
        nmap_ports=None
    ):
        self.ip = ip
        self.shodan_data = (
            shodan_data if isinstance(shodan_data, dict) else {}
        )
        self.vt_data = vt_data if isinstance(vt_data, dict) else {}

        self.abuse_data = (
            abuse_data if isinstance(abuse_data, dict) else {}
        )
        self.nmap_ports = (
            list(nmap_ports) if nmap_ports is not None else []
        )
