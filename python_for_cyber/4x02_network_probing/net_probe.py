#!/usr/bin/env python3
"""NetProbe network scanning tool."""

import argparse
import json
import random
import socket
import time

from concurrent.futures import ThreadPoolExecutor, as_completed


def check_port(ip: str, port: int, local_ip: str = None) -> bool:
    """Check whether a TCP port is open on the target."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)

    try:
        if local_ip:
            sock.bind((local_ip, 0))

        sock.connect((ip, port))
        return True
    except (ConnectionRefusedError, socket.timeout, socket.gaierror):
        return False
    finally:
        sock.close()


def ping_sweep(subnet: str) -> list:
    """Scan port 80 on all hosts in a /24 subnet."""
    live_ips = []

    for host in range(1, 255):
        ip = f"{subnet}.{host}"

        if check_port(ip, 80):
            live_ips.append(ip)

    return live_ips


def get_banner(ip: str, port: int, local_ip: str = None) -> str:
    """Retrieve a service banner from an open TCP port."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)

    try:
        if local_ip:
            sock.bind((local_ip, 0))

        sock.connect((ip, port))

        if port != 22:
            sock.sendall(b"HEAD / HTTP/1.0\r\n\r\n")

        data = sock.recv(1024)

        if not data:
            return "Unknown"

        return data.decode(errors="ignore").strip()

    except (OSError, socket.timeout):
        return "Unknown"
    finally:
        sock.close()


def scan_single_port(
    ip: str,
    port: int,
    delay: float = 0.0,
    local_ip: str = None
):
    """Scan a single TCP port and return its information."""
    if delay > 0:
        print(
            f"[DEBUG] Sleeping {delay}s before next packet..."
        )
        time.sleep(delay)

    if check_port(ip, port):
        banner = get_banner(ip, port)
        status = check_vulnerability(banner)

        return {
            "port": port,
            "state": "open",
            "service": banner,
            "vulnerability": "YES" if status else "NO"
        }

    return None


def scan_ports(
    ip: str,
    start_port: int,
    end_port: int,
    delay: float = 0.0,
    randomize: bool = False
) -> list:
    """Scan a range of TCP ports using multiple threads."""
    results = []

    ports = list(range(start_port, end_port + 1))

    if randomize:
        print("Scanning ports randomly...")
        random.shuffle(ports)
    else:
        print(f"Scanning {ip} from {start_port} to {end_port}...")

    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = []

        for port in ports:
            future = executor.submit(scan_single_port, ip, port, delay, local_ip)
            futures.append(future)

        for future in as_completed(futures):
            result = future.result()

            if result:
                results.append(result)
                print(
                    f"[+] Port {result['port']} Open: "
                    f"{result['service']}"
                )

    return results


def guess_service(port: int) -> str:
    """Guess the service name based on the port number."""
    services = {
        21: "FTP",
        22: "SSH",
        80: "HTTP",
        443: "HTTPS",
        3306: "MySQL"
    }

    service = services.get(port, "Unknown")

    if service != "Unknown":
        return f"{service} (Guessed)"

    return "Unknown"


def check_vulnerability(banner: str) -> str:
    """Check a banner for known vulnerable service versions."""
    bad_signatures = [
        "vsftpd 2.3.4",
        "Apache 2.2.8"
    ]

    for signature in bad_signatures:
        if signature.lower() in banner.lower():
            return "[VULNERABLE]"

    return ""


def scan_udp(ip: str, port: int, local_ip: str = None) -> bool:
    """Check whether a UDP port is open or filtered."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(1)

    try:
        if local_ip:
            sock.bind((local_ip, 0))

        sock.sendto(b"", (ip, port))
        sock.recvfrom(1024)
        return True
    except socket.timeout:
        return True
    except OSError:
        return False
    finally:
        sock.close()


def resolve_hostname(ip: str) -> str:
    """Resolve a hostname from an IP address."""
    try:
        hostname = socket.gethostbyaddr(ip)[0]
        return hostname
    except socket.herror:
        return "Unknown"


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
        with open(args.output, "w", encoding="utf-8") as file:
            json.dump(results, file, indent=2)


if __name__ == "__main__":
    main()
