#!/usr/bin/env python3
"""Query the mock VirusTotal API for IP reputation information."""

import xml.etree.ElementTree as ET

import requests
import subprocess


def query_virustotal(ip: str) -> dict:
    """Query VirusTotal mock API and return IP reputation data."""
    url = f"http://localhost:5000/virustotal/{ip}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code == 200:
            return response.json()

        return {}

    except requests.exceptions.ConnectionError:
        print("[ERROR] Could not connect to VirusTotal API.")
        return {}

    except requests.exceptions.Timeout:
        print("[ERROR] VirusTotal API request timed out.")
        return {}


def query_abuseipdb(ip: str) -> dict:
    """Query AbuseIPDB mock API and return IP reputation data."""
    url = f"http://localhost:5000/abuseipdb/{ip}"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code == 200:
            return response.json()

        return {}

    except requests.exceptions.ConnectionError:
        print("[ERROR] Could not connect to AbuseIPDB API.")
        return {}

    except requests.exceptions.Timeout:
        print("[ERROR] AbuseIPDB API request timed out.")
        return {}


def run_nmap(ip: str) -> str:
    """Run Nmap against an IP and return the raw XML output."""
    command = ["nmap", "-p", "22,80", ip, "-oX", "-"]

    result = subprocess.run(
        command,
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        raise RuntimeError("Nmap scan failed")

    return result.stdout


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


if __name__ == "__main__":
    print(query_virustotal("1.2.3.4"))
    print(query_abuseipdb("1.2.3.4"))
    print(run_nmap("127.0.0.1"))
