#!/usr/bin/env python3
"""NetProbe network scanning tool."""

import argparse

from concurrent.futures import ThreadPoolExecutor, as_completed
from reporter import save_json_report


def main() -> None:
    """Run NetProbe from the command line."""
    parser = argparse.ArgumentParser(
        description="Scan TCP ports on a target."
    )

    parser.add_argument(
        "-t",
        "--target",
        required=True,
        help="Target IP address"
    )

    parser.add_argument(
        "-p",
        "--ports",
        required=True,
        help="Port range, for example 1-1000"
    )

    parser.add_argument(
        "-o",
        "--output",
        help="Output JSON file"
    )

    parser.add_argument(
        "-d",
        "--delay",
        type=float,
        default=0,
        help="Delay between scan attempts"
    )

    parser.add_argument(
        "-r",
        "--random",
        action="store_true",
        help="Scan ports in random order"
    )

    parser.add_argument(
        "-i",
        "--interface",
        help="Local IP address to use as source"
    )

    args = parser.parse_args()

    start_port, end_port = map(int, args.ports.split("-"))

    hostname = resolve_hostname(args.target)
    print(f"Target: {args.target} ({hostname})")

    if args.interface:
        print(f"[INFO] Scanning from source IP: {args.interface}")

    results = scan_ports(
        args.target,
        start_port,
        end_port,
        delay=args.delay,
        randomize=args.random,
        local_ip=args.interface
    )

    if args.output:
        save_json_report(results, args.output)


if __name__ == "__main__":
    main()
