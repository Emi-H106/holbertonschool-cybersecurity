#!/usr/bin/env python3
"""Query the mock VirusTotal API for IP reputation information."""

import argparse
import asyncio
import json
import subprocess
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta

import aiohttp
import requests


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
        nmap_ports=None
    ):
        self.ip = ip
        self.vt_data = vt_data if isinstance(vt_data, dict) else {}
        self.abuse_data = (
            abuse_data if isinstance(abuse_data, dict) else {}
        )
        self.nmap_ports = (
            list(nmap_ports) if nmap_ports is not None else []
        )


def load_cache():
    """Load cached intelligence from the JSON cache file."""
    try:
        with open("cache.json", "r", encoding="utf-8") as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def save_cache(cache):
    """Save intelligence data to the JSON cache file."""
    with open("cache.json", "w", encoding="utf-8") as file:
        json.dump(cache, file, indent=4)


def get_cached_data(ip, cache):
    """Return cached data if it is less than one hour old."""
    if ip not in cache:
        return None

    timestamp = datetime.fromisoformat(cache[ip]["timestamp"])

    if datetime.now() - timestamp < timedelta(hours=1):
        return cache[ip]["data"]

    return None


async def fetch_api(session, url):
    """Fetch JSON data asynchronously from an API."""
    try:
        async with session.get(url) as response:
            if response.status == 200:
                return await response.json()

            return {"error": "Unavailable"}

    except aiohttp.ClientError:
        return {"error": "Unavailable"}


async def gather_intel(ip):
    """Gather intelligence using cache when possible."""
    cache = load_cache()
    cached_data = get_cached_data(ip, cache)

    if cached_data is not None:
        return (
            cached_data["virustotal"],
            cached_data["shodan"],
            cached_data["abuseipdb"]
        )

    vt_url = f"http://localhost:5000/virustotal/{ip}"
    shodan_url = f"http://localhost:5000/shodan/{ip}"
    abuse_url = f"http://localhost:5000/abuseipdb/{ip}"

    semaphore = asyncio.Semaphore(5)

    async with aiohttp.ClientSession() as session:

        async def limited_fetch(url):
            async with semaphore:
                return await fetch_api(session, url)

        vt_data, shodan_data, abuse_data = await asyncio.gather(
            limited_fetch(vt_url),
            limited_fetch(shodan_url),
            limited_fetch(abuse_url)
        )

    cache[ip] = {
        "timestamp": datetime.now().isoformat(),
        "data": {
            "virustotal": vt_data,
            "shodan": shodan_data,
            "abuseipdb": abuse_data
        }
    }

    save_cache(cache)

    return vt_data, shodan_data, abuse_data


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


async def main():
    """Run IntelBroker from the command line."""
    parser = argparse.ArgumentParser(
        description="Collect intelligence about a target IP."
    )
    parser.add_argument("ip", help="Target IP address")
    parser.add_argument(
        "-o",
        "--output",
        help="Save the intelligence report to a JSON file"
    )

    args = parser.parse_args()

    dossier = TargetDossier(args.ip)

    vt_data, shodan_data, abuse_data = await gather_intel(args.ip)

    xml_data = await run_nmap(args.ip)
    dossier.nmap_ports = parse_nmap_xml(xml_data)

    print(f"Target: {dossier.ip}")
    print(f"VirusTotal: {dossier.vt_data}")
    print(f"AbuseIPDB: {dossier.abuse_data}")
    print(f"Open ports: {dossier.nmap_ports}")

    if args.output:
        report = {
            "target": dossier.ip,
            "timestamp": datetime.now().isoformat(),
            "intelligence": {
                "virustotal": dossier.vt_data,
                "shodan": shodan_data,
                "abuseipdb": dossier.abuse_data,
                "nmap_ports": dossier.nmap_ports
            }
        }

        with open(args.output, "w", encoding="utf-8") as file:
            json.dump(report, file, indent=4)


if __name__ == "__main__":
    asyncio.run(main())
