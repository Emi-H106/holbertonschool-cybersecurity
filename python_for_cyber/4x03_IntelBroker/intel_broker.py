#!/usr/bin/env python3
"""Entry point for IntelBroker."""

import argparse
import asyncio
import json
from datetime import datetime

from api_client import gather_intel
from models import TargetDossier
from scanner import parse_nmap_xml, run_nmap


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
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Display progress messages"
    )

    args = parser.parse_args()

    dossier = TargetDossier(args.ip)

    if args.verbose:
        print("[+] Querying VirusTotal...")
        print("[+] Querying Shodan...")
        print("[+] Querying AbuseIPDB...")

    vt_data, shodan_data, abuse_data = await gather_intel(args.ip)

    dossier.vt_data = vt_data
    dossier.shodan_data = shodan_data
    dossier.abuse_data = abuse_data

    if args.verbose:
        print("[+] Running Nmap...")

    xml_data = await run_nmap(args.ip)
    dossier.nmap_ports = parse_nmap_xml(xml_data)

    if args.verbose:
        print("[+] Nmap finished.")

    print(f"Target: {dossier.ip}")
    print(f"VirusTotal: {dossier.vt_data}")
    print(f"Shodan: {dossier.shodan_data}")
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

    if args.verbose:
        print("[SUCCESS] Report generated.")

if __name__ == "__main__":
    asyncio.run(main())
