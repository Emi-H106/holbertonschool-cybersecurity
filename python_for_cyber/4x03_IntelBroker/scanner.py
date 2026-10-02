#!/usr/bin/env python3
"""Nmap scanner functions for IntelBroker."""

import asyncio
import xml.etree.ElementTree as ET


async def run_nmap(ip: str) -> str:
    """Run Nmap asynchronously and return the raw XML output."""
    process = await asyncio.create_subprocess_exec(
        "nmap",
        "-p",
        "22,80",
        ip,
        "-oX",
        "-",
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        raise RuntimeError("Nmap scan failed")

    return stdout.decode()


def parse_nmap_xml(xml_data: str) -> list:
    """Parse Nmap XML output and return a list of open ports."""
    root = ET.fromstring(xml_data)
    open_ports = []

    for port in root.findall("host/ports/port"):
        state = port.find("state")

        if state is not None and state.get("state") == "open":
            port_id = int(port.get("portid"))
            open_ports.append(port_id)

    return open_ports
